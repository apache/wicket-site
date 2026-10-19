---
title: Push updates over a WebSocket
type: howto
topic: websockets
summary: Set up wicket-native-websocket, handle messages from the browser and push component updates to a page from a background thread.
since: 10
apis: [WebSocketBehavior, WebSocketRequestHandler, WebSocketPushBroadcaster, IWebSocketPushMessage, WebSocketPushPayload, JavaxWebSocketFilter, WebSocketSettings, ConnectedMessage, WebSocketResource]
keywords: [server push, real-time, live update, broadcast, notification, background job progress, wicket-native-websocket-javax, Spring Boot websocket]
order: 10
source: [nativewebsockets/nativewebsockets_2.adoc]
---

Use this when the server has to update a page without the user doing anything: a job that reports progress, a chat, a dashboard that follows live data. [How native WebSockets work]({{ site.baseurl }}/docs/how-websockets-work.html) explains what happens underneath.

## Add the dependency and the filter

Add the module to your build:

*pom.xml*

```xml
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-native-websocket-javax</artifactId>
    <version>${wicket.version}</version>
</dependency>
```

Replace `WicketFilter` with `JavaxWebSocketFilter`. In `web.xml`, only the filter class changes:

*web.xml*

```xml
<filter>
    <filter-name>wicket</filter-name>
    <filter-class>org.apache.wicket.protocol.ws.javax.JavaxWebSocketFilter</filter-class>
    <init-param>
        <param-name>applicationClassName</param-name>
        <param-value>com.example.WicketApplication</param-value>
    </init-param>
</filter>
```

The servlet container has to support Jakarta WebSocket, as Tomcat, Jetty and WildFly do.

### With Spring Boot

Add `spring-boot-starter-websocket`, register the filter, and export Wicket's endpoint:

```java
@Bean
public FilterRegistrationBean<JavaxWebSocketFilter> wicketFilter() {
    var registration = new FilterRegistrationBean<>(new JavaxWebSocketFilter());
    registration.setDispatcherTypes(DispatcherType.REQUEST, DispatcherType.ERROR,
        DispatcherType.FORWARD, DispatcherType.ASYNC);
    registration.setAsyncSupported(true);
    registration.addInitParameter(WicketFilter.APP_FACT_PARAM,
        SpringWebApplicationFactory.class.getName());
    registration.addInitParameter(WicketFilter.FILTER_MAPPING_PARAM, "/*");
    registration.addUrlPatterns("/*");
    return registration;
}

@Bean
public ServerEndpointExporter serverEndpointExporter() {
    return new ServerEndpointExporter();
}

@Bean
public WicketServerEndpointConfig wicketServerEndpointConfig() {
    return new WicketServerEndpointConfig();
}
```

## Answer messages from the browser

Add a `WebSocketBehavior` to the page, or to a component on it. The browser opens the connection when the page loads. Override the callbacks you need:

```java
add(new WebSocketBehavior() {
    @Override
    protected void onMessage(WebSocketRequestHandler handler, TextMessage message) {
        chat.add(message.getText());
        handler.add(messages);
    }
});
```

`handler.add(...)` re-renders components in the browser, exactly as with an `AjaxRequestTarget`; the components need a markup id. `handler.push(String)` sends a plain text message instead, which your JavaScript receives; see [WebSocket JavaScript API]({{ site.baseurl }}/docs/websocket-client-api.html). `appendJavaScript` and `prependJavaScript` work as well.

## Push an update from a background thread

Code outside a request cannot touch components. It sends a message object, and the page's components turn it into an update.

1. Define the message as a class implementing `IWebSocketPushMessage`:

   ```java
   public record JobProgress(int percent) implements IWebSocketPushMessage {
   }
   ```

2. Remember where to send it. The connection is identified by the application name, the session id and a key for the page. `onConnect` gives you all three:

   ```java
   add(new WebSocketBehavior() {
       @Override
       protected void onConnect(ConnectedMessage message) {
           jobs.start(new ProgressReporter(message.getApplication().getName(),
               message.getSessionId(), message.getKey()));
       }
   });
   ```

3. In the background thread, broadcast the message to that connection:

   ```java
   public record ProgressReporter(String applicationName, String sessionId, IKey key)
           implements Serializable {

       public void report(int percent) {
           Application application = Application.get(applicationName);
           var registry = WebSocketSettings.Holder.get(application).getConnectionRegistry();
           new WebSocketPushBroadcaster(registry).broadcast(
               new ConnectedMessage(application, sessionId, key), new JobProgress(percent));
       }
   }
   ```

4. Receive it in the page or a component and update the components:

   ```java
   @Override
   public void onEvent(IEvent<?> event) {
       super.onEvent(event);
       if (event.getPayload() instanceof WebSocketPushPayload payload
               && payload.getMessage() instanceof JobProgress progress) {
           percent = progress.percent();
           payload.getHandler().add(progressBar);
       }
   }
   ```

   `WebSocketBehavior.onPush(handler, message)` receives the same messages, if you prefer to handle them in the behavior.

A connection that has closed in the meantime is skipped without an error.{% if site.wicket.version_11 %} To show that a component is being recomputed while the server works, see [Block the page while a request runs]({{ site.baseurl }}/docs/ajax-veils.html#veil-a-component-during-a-websocket-push).{% endif %}

## Push to many pages at once

`WebSocketPushBroadcaster` also has `broadcastAll(application, message)` for every connection of the application, `broadcastAllInSession(application, sessionId, message)` for one user's pages, and `broadcastAllMatchingFilter(application, filter, message)` with a lambda that selects connections by session id and key:

```java
broadcaster.broadcastAllMatchingFilter(application,
    (sessionId, key) -> key instanceof PageIdKey, new PriceChanged(product));
```

By default the broadcast runs in the calling thread, one page after the other. `WebSocketSettings.setWebSocketPushMessageExecutor` moves it to other threads.

## Send raw text without a page

When the browser renders the data itself, for example a chart that receives a stream of numbers, send text straight to the connection and skip the page:

```java
IWebSocketConnection connection = registry.getConnection(application, sessionId, key);
if (connection != null && connection.isOpen()) {
    connection.sendMessageAsync(json);
}
```

For many messages from the browser, a `WebSocketResource` handles them without taking the page lock. Register it with `getSharedResources().add("prices", new PriceResource())` in `init()` and add `new BaseWebSocketBehavior("prices")` to the page. It has the same callbacks as `WebSocketBehavior`, but cannot re-render components.
