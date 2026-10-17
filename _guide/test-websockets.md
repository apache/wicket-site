---
title: Test WebSocket behaviors
type: howto
topic: websockets
summary: Send messages to a page's WebSocket behavior and check what it pushes back with WebSocketTester, without a servlet container.
since: 10
apis: [WebSocketTester, WicketTester, PageIdKey, IWebSocketPushMessage]
keywords: [unit test, junit, websocket test, onOutMessage, sendMessage, broadcast, wicket-native-websocket-tester]
order: 20
source: [nativewebsockets/nativewebsockets_4.adoc]
---

Use this to test the `WebSocketBehavior` of a page, or a `WebSocketResource`, in a unit test. `WebSocketTester` opens an emulated connection on top of a `WicketTester`, sends messages as the browser would, and hands you every message the server sends back.

## Add the test dependency

*pom.xml*

```xml
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-native-websocket-tester</artifactId>
    <version>${wicket.version}</version>
    <scope>test</scope>
</dependency>
```

The class is `org.apache.wicket.protocol.ws.tester.WebSocketTester`. It works with the `WicketTester` you already use; see [Test pages and components]({{ site.baseurl }}/docs/test-pages.html).

## Send a message and check the answer

Start the page, create a `WebSocketTester` for it, and override `onOutMessage` to collect what the server pushes:

*ChatPageTest.java*

```java
class ChatPageTest {
    private WicketTester tester;

    @BeforeEach
    void setUp() {
        tester = new WicketTester(new WicketApplication());
    }

    @AfterEach
    void tearDown() {
        tester.destroy();
    }

    @Test
    void echoesMessageInUpperCase() {
        ChatPage page = tester.startPage(ChatPage.class);
        List<String> received = new ArrayList<>();

        WebSocketTester webSocket = new WebSocketTester(tester, page) {
            @Override
            protected void onOutMessage(String message) {
                received.add(message);
            }
        };

        webSocket.sendMessage("hello");
        webSocket.destroy();

        assertEquals(List.of("HELLO"), received);
    }
}
```

`sendMessage` calls the behavior's `onMessage` in the test thread, so by the time it returns the answers are in. Binary messages work the same way with `sendMessage(byte[], offset, length)` and the matching `onOutMessage(byte[], int, int)`. `destroy()` closes the connection, which calls the behavior's `onClose`.

When the behavior re-renders components with `handler.add(...)`, the message you receive is the `<ajax-response>` XML. Check that it contains the markup you expect.

## Test a push from the server

Push messages do not come from the browser. Broadcast one to the page's connection, identified by the application, the session id and the page key:

```java
webSocket.broadcast(tester.getApplication(), tester.getHttpSession().getId(),
    new PageIdKey(page.getPageId(), page.getClass().getName()), new JobProgress(50));
```

The `PageIdKey` takes the page class name as second argument, because the connection is registered with it. `broadcastAll(application, message)` reaches every connection. The page's `onEvent` or the behavior's `onPush` runs in the test thread, and its answer arrives in `onOutMessage`. `WebSocketTester` sets a same-thread executor for push messages, so nothing has to be awaited.

## Test a WebSocketResource

For a shared `WebSocketResource`, pass its name instead of a page:

```java
WebSocketTester webSocket = new WebSocketTester(tester, "prices") {
    @Override
    protected void onOutMessage(String message) {
        received.add(message);
    }
};
```

The resource must be registered in the application's `init()` as in production. [Push updates over a WebSocket]({{ site.baseurl }}/docs/use-websockets.html) shows the behavior and resource side.
