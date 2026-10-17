---
title: WebSocket JavaScript API
type: reference
topic: websockets
summary: The Wicket.WebSocket functions and the events your JavaScript can subscribe to on a page with a WebSocket behavior.
since: 10
apis: [BaseWebSocketBehavior, WebSocketBehavior, WicketWebSocketJQueryResourceReference, WebSocketSettings]
keywords: [Wicket.WebSocket, Wicket.WebSocket.send, /websocket/message, /websocket/open, /websocket/closed, /websocket/error, Wicket.Event.subscribe, wicket-websocket-jquery.js, client side]
order: 10
source: [nativewebsockets/nativewebsockets_3.adoc]
---

A page with a `WebSocketBehavior` or `BaseWebSocketBehavior` loads `wicket-websocket-jquery.js` and opens one connection when the DOM is ready. The script is a thin layer over the browser's `WebSocket`: it builds the connection URL, applies `<ajax-response>` messages from the server and publishes everything else as events.

## Functions

| Function | What it does |
|---|---|
| `Wicket.WebSocket.send(text)` | Sends a text message over the page's default connection. The server receives it in `onMessage(WebSocketRequestHandler, TextMessage)`. Empty text is not sent. |
| `Wicket.WebSocket.close()` | Closes the default connection and forgets it. |
| `Wicket.WebSocket.createDefaultConnection()` | Opens the default connection if there is none. The behavior's setup script calls it. |
| `new Wicket.WebSocket()` | Opens an additional connection with the same settings. The object has `send(text)` and `close()`. |

```javascript
Wicket.WebSocket.send(JSON.stringify({ action: 'like', id: 42 }));
```

## Events

Subscribe with `Wicket.Event.subscribe(topic, function (event, ...) { })`. The first argument is Wicket's event object; the other arguments are listed below.

| Topic | Arguments after the event | Published when |
|---|---|---|
| `/websocket/open` | the browser's `open` event | The connection is open. |
| `/websocket/message` | the message data | A message arrives that is not an `<ajax-response>`, such as text sent with `WebSocketRequestHandler.push(String)` or `IWebSocketConnection.sendMessage(String)`. |
| `/websocket/closed` | the browser's `close` event | The connection is closed. |
| `/websocket/error` | the browser's `error` event | A communication error occurred. The connection is closed. |
| `/websocket/notsupported` | an error message | The browser has no WebSocket support. |

```javascript
Wicket.Event.subscribe('/websocket/message', function (event, message) {
    var data = JSON.parse(message);
    updateChart(data);
});
```

The topic names are also available as `Wicket.Event.Topic.WebSocket.Opened`, `Message`, `Closed`, `Error` and `NotSupported`.

## Messages the script handles itself

A message that contains `<ajax-response>` is applied like an Ajax response: components are replaced and scripts run. This is what `WebSocketRequestHandler.add(...)`, `appendJavaScript` and `prependJavaScript` produce. These messages are processed one after the other on their own channel, `Wicket.WebSocket.MESSAGE_CHANNEL`, and are not published as `/websocket/message`.

## Connection URL

The connection goes to `/wicket/websocket` under the context path and the filter prefix, with `ws:` or `wss:` matching the page's protocol. The query string carries the page id or the resource name of a `WebSocketResource`, the page class as context, the application name and the base URL. The session id is added to the path when the session is tracked in the URL or no session cookie is available.

The parts can be changed in `WebSocketSettings`:

| Setting | Default |
|---|---|
| `setPort(int)` | The port of the page. |
| `setSecurePort(int)` | The port of the page, for `wss:`. |
| `setContextPath(CharSequence)` | The servlet context path. |
| `setFilterPrefix(CharSequence)` | Empty. Set it to the filter path when the filter is not mapped to `/*`, for example `/app`. |
| `setBaseUrl(CharSequence)` | The base URL of the page. |

```java
WebSocketSettings.Holder.get(this).setPort(8000);
```

Behind a proxy that serves WebSockets on another port, set the ports. Subclasses of `BaseWebSocketBehavior` can override `getPort`, `getSecurePort`, `getContextPath`, `getFilterPrefix` and `getBaseUrl` to compute them per page.
