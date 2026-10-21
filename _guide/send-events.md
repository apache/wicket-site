---
title: Send events between components
type: howto
topic: lifecycle
summary: Let a component notify others on the page without holding references to them, with send(), onEvent() and a payload class.
since: 10
apis: [IEvent, IEventSink, IEventSource, Broadcast, IEventDispatcher]
keywords: [event bus, publish subscribe, observer, notify, onEvent, payload, inter-component communication, decouple components, Ajax update other panel]
order: 60
source: [advanced/advanced_3.adoc]
---

Use events when an action in one component must update components it does not know about, for example when adding a product in one panel must refresh the cart summary in another. The sender sends a payload object; every component that cares checks for that payload in `onEvent()`.

## Define a payload

The payload is any object. Give each kind of event its own type, so receivers can recognize it:

```java
public record CartChanged(AjaxRequestTarget target, Product product) {}
```

Carrying the `AjaxRequestTarget` in the payload lets receivers add themselves to the Ajax response.

## Send the event

Every component can send an event with `send(sink, broadcast, payload)`. To reach every component on the page, send it to the page with `Broadcast.BREADTH`:

```java
add(new AjaxLink<Void>("addToCart") {
    @Override
    public void onClick(AjaxRequestTarget target) {
        cart.add(product);
        send(getPage(), Broadcast.BREADTH, new CartChanged(target, product));
    }
});
```

`send()` delivers the event right away, before it returns.

## Receive the event

Override `onEvent()` and check the payload type:

```java
public class CartSummaryPanel extends Panel {

    public CartSummaryPanel(String id, IModel<Cart> cart) {
        super(id, cart);
        setOutputMarkupId(true);
        add(new Label("count", cart.map(Cart::size)));
    }

    @Override
    public void onEvent(IEvent<?> event) {
        super.onEvent(event);
        if (event.getPayload() instanceof CartChanged changed) {
            changed.target().add(this);
        }
    }
}
```

Behaviors receive events too, in `onEvent(Component component, IEvent<?> event)`, right after the component they belong to.

## Choose how the event travels

The second argument of `send()` decides which sinks receive the event, starting at the sink you pass:

| `Broadcast` | Receivers, in order |
|---|---|
| `BREADTH` | The sink, then its children, then their children, and so on. Sent to the application, it reaches the application, the session, the request cycle, the page and all its components. |
| `DEPTH` | The children first, deepest first, then the sink. Sent to the application, it reaches the components, the page, the request cycle, the session and the application last. |
| `BUBBLE` | The sink, then its parents up to the page, then the request cycle, the session and the application. |
| `EXACT` | Only the sink. |

Use `BUBBLE` to notify the containers around a component, for example to tell the panel that holds a form that the form was saved:

```java
send(this, Broadcast.BUBBLE, new Saved(target));
```

Components, the page, the session, the request cycle and the application can all receive events: they implement `IEventSink`. Only components can send them.

## Stop an event

`IEvent` lets a receiver control the rest of the delivery:

| Method | Effect |
|---|---|
| `stop()` | No further sink receives the event. |
| `dontBroadcastDeeper()` | With `BREADTH`, the children of the current component do not receive it. |
| `getSource()` | The component that sent the event. |
| `getType()` | The `Broadcast` used. |
| `getPayload()` | The payload. |

## React to every Ajax request

Wicket itself sends an event during every Ajax request: before it writes the response, it broadcasts the `AjaxRequestTarget` with `BREADTH` from the application to the whole page. A component that must refresh after any Ajax request can listen for it:

```java
@Override
public void onEvent(IEvent<?> event) {
    super.onEvent(event);
    if (event.getPayload() instanceof AjaxRequestTarget target) {
        target.add(this);
    }
}
```

Put this in a subclass of `FeedbackPanel`, for example, and it stays up to date without every Ajax handler adding it. Use it sparingly: the check runs for every component on every Ajax request of the page.

## Change how events are delivered

Wicket calls `onEvent()` through an `IEventDispatcher`. To deliver events another way, for example to methods marked with an annotation, add your own dispatcher in `init()` with `getFrameworkSettings().add(dispatcher)`.
