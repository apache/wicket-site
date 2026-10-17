---
title: How native WebSockets work
type: explanation
topic: websockets
summary: How Wicket connects a page to a WebSocket, routes messages to components, pushes updates from other threads, and what that means for sessions and locking.
since: 10
apis: [WebSocketBehavior, WebSocketResource, WebSocketRequestHandler, IWebSocketConnectionRegistry, WebSocketPushBroadcaster, IWebSocketPushMessage, JavaxWebSocketFilter]
keywords: [server push, real-time, full duplex, jakarta websocket, JSR 356, connection registry, page lock, request scoped beans, session scoped beans]
order: 10
source: [nativewebsockets.adoc, nativewebsockets/nativewebsockets_1.adoc, nativewebsockets/nativewebsockets_5.adoc]
---

With Ajax the browser always asks first: the server can only answer. A WebSocket is a connection that stays open after the page has loaded, over which both sides send messages whenever they like. Wicket's native WebSocket support uses it to let the server update components on a page that nobody clicked on: a progress bar of a background job, a new chat message, a price that changed.

## Built on the servlet container's WebSocket support

Wicket does not implement the WebSocket protocol. The module `wicket-native-websocket-javax` plugs into the Jakarta WebSocket API that every current servlet container provides, such as Tomcat, Jetty and WildFly. The module and its filter still carry `javax` in their names, from the time the API lived in that namespace, but they work with `jakarta.websocket`.

The module registers a WebSocket endpoint at `/wicket/websocket` with the container, which finds it on start-up. `JavaxWebSocketFilter` takes the place of `WicketFilter`: it handles normal requests the same way and leaves that path to the endpoint. A browser that opens a WebSocket connection to that path goes through an HTTP upgrade request, and from then on the connection belongs to the container's WebSocket implementation, not to the servlet filter chain.

## A connection per page, kept in a registry

You switch WebSockets on for a page by adding a `WebSocketBehavior` to the page or to any component on it. The behavior renders a small script that opens the connection when the page is loaded, passing the page id and the application name in the URL. One connection serves the whole page, however many WebSocket behaviors it has.

On the server, each open connection is stored in the application's `IWebSocketConnectionRegistry`, under three keys: the application, the HTTP session id, and a key for the page. The page key is a `PageIdKey` holding the page id and the page class name. This registry is what makes pushing possible: code that wants to reach a page later looks the connection up by these keys, and code that wants to reach everyone asks for all connections of the application.

A `WebSocketResource` is the alternative to the behavior: a shared resource that receives messages for connections opened under its resource name, keyed with a `ResourceNameKey`. It has no page, so it can push text and binary data but cannot re-render components.

## How a message reaches a component

Messages from the browser are text or binary frames. When one arrives, Wicket finds the page instance by the id the connection was opened with, takes the lock on that page, and sends the message as an event through the page: every component and behavior can see it in `onEvent`. `WebSocketBehavior` unpacks the event and calls the matching method, such as `onMessage` with a `TextMessage`, `onConnect` or `onClose`.

The handler these methods receive, a `WebSocketRequestHandler`, works like an `AjaxRequestTarget`. You can add components to it, and their new markup goes back over the connection as an `<ajax-response>`, which the client script applies exactly like an Ajax response. You can also push plain text with `push(String)`, which the browser receives as a message event for your own JavaScript to handle.

## Pushing from another thread

The interesting case is a message that does not come from the browser. A background job, a message queue listener or another user's request wants to update a page. That code holds no page and runs outside any Wicket request.

It describes what happened in an object implementing `IWebSocketPushMessage` and hands it to a `WebSocketPushBroadcaster`, for one connection or for all of them. The broadcaster finds the connections in the registry and, for each, processes the message as if it had come in over the connection: page lookup, page lock, event through the page. Components receive a `WebSocketPushPayload` in `onEvent`, or `WebSocketBehavior.onPush` is called, with a handler to add components to. The push message is a plain Java object, so the background code never touches a component.

Because every message takes the page lock, WebSocket traffic and Ajax requests for the same page are processed one at a time, in the same way two Ajax requests are. This keeps component code free of threading concerns, at the cost of throughput: a page that receives many messages per second keeps its lock busy. A `WebSocketResource` takes no page lock, which is why it suits high-volume streams that the browser renders itself.

## What a WebSocket request does not have

A WebSocket message is not an HTTP request. It is not processed by servlet filters or listeners, so anything that relies on them is missing: request-scoped and session-scoped beans of Spring or CDI do not work, and a security filter does not see the messages. Wicket gives the handler a copy of the HTTP request and session as they were when the connection was opened.

The upgrade request is the only point where the usual web defences apply. Browsers send an `Origin` header with it, and `WebSocketConnectionOriginFilter` can reject connections from other origins. Frames sent after that carry no such headers; if the application uses a `ResourceIsolationRequestCycleListener` against cross-site requests, it uses `WebSocketAwareResourceIsolationRequestCycleListener`, which lets WebSocket messages through. See [Protect against cross-site request forgery]({{ site.baseurl }}/docs/csrf.html).

The connection also lives only as long as the page in the browser. A reload opens a new connection for the new page instance, and a push to a connection that has closed is silently dropped. Code that pushes has to cope with nobody listening.
