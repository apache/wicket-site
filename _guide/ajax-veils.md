---
title: Block the page while a request runs
type: howto
topic: ajax
summary: Cover the page or one component with a veil during Ajax requests, so a second click cannot send the same request twice.
since: 11
apis: [PageVeilBehavior, LocalVeilBehavior, AbstractVeilBehavior]
keywords: [veil, overlay, block ui, modal overlay, double click, double submit, spinner, busy, loading mask]
order: 30
source: [ajax/ajax_12.adoc]
---

Use this when a second click during a slow Ajax request does harm: it sends the same request twice, or acts on a part of the page that the pending response is about to replace. A veil covers the page, or one component, for as long as the request runs.

The veil appears as soon as the request is sent. It is transparent and swallows mouse clicks, so a quick request does not make the page flash. When the request is still running after 300 ms, the veil dims its area and shows a spinner, which then stays for at least 500 ms so it does not flicker. The veil does not block the keyboard. Both behaviors are in wicket-extensions, package `org.apache.wicket.extensions.ajax.veil`, and work with the jQuery and the plain JavaScript Ajax implementation.

## Veil the whole page

Add a `PageVeilBehavior` to the page, usually to the base page all your pages extend:

```java
public abstract class BasePage extends WebPage {
    public BasePage() {
        add(new PageVeilBehavior());
    }
}
```

Every Ajax request fired from the page is now veiled. `PageVeilBehavior` only works on a page; adding it to another component throws an `IllegalArgumentException`.

## Veil a single component

When the rest of the page should stay usable, add a `LocalVeilBehavior` to the component that does the slow work:

```java
WebMarkupContainer search = new WebMarkupContainer("search");
search.add(new LocalVeilBehavior());
add(search);
```

Requests fired by the component or by anything inside it veil only that component, even when the page has a `PageVeilBehavior`. When local veils are nested, the innermost one around the clicked element takes the request.

The behavior gives the component a markup id and adds the veil as a `div` inside the component's element, so the component must render an element that can contain a `div`, such as a `div` or a `section`, not an `input`. While veiled, the element gets `position: relative` if it is not positioned already. When the element is replaced by an Ajax update while veiled, the veil moves to the new element. A `LocalVeilBehavior` instance belongs to one component; create a new one for each.

## Leave a request unveiled

All Ajax requests are veiled, also those the user did not start, such as an `AbstractAjaxTimerBehavior` or an `AjaxLazyLoadPanel` loading its content. Exempt such a request by calling `PageVeilBehavior.noVeil` from `updateAjaxAttributes`:

```java
label.add(new AjaxSelfUpdatingTimerBehavior(Duration.ofSeconds(10)) {
    @Override
    protected void updateAjaxAttributes(AjaxRequestAttributes attributes) {
        super.updateAjaxAttributes(attributes);
        PageVeilBehavior.noVeil(attributes);
    }
});
```

`noVeil` adds the request parameter `wicket_nb` (`PageVeilBehavior.NO_VEIL_PARAMETER`). No veil, page or local, covers a request that carries it. The parameter also reaches the server.

## Change the timings

Set the spinner delay and the minimum spinner time on each behavior:

```java
WebMarkupContainer report = new WebMarkupContainer("report");
report.add(new LocalVeilBehavior()
    .setSpinnerDelay(Duration.ofMillis(100))
    .setMinimumSpinnerTime(Duration.ofSeconds(1)));
```

`Duration.ZERO` as delay shows the spinner at once. Nested local veils keep their own timings, so a part of the page that is known to be slow can show its spinner sooner. Subclasses can override `getSpinnerDelay()` and `getMinimumSpinnerTime()` instead.

## Style the veil

The behaviors contribute `wicket-veil.css`. Override these classes in your own stylesheet:

| CSS class | Set on |
|---|---|
| `wicket-veil` | The veil `div`: `position: fixed` over the page, `position: absolute` over a component. |
| `wicket-veil-busy` | The veil, once the spinner delay has passed. Gives the background; its `::after` pseudo-element draws the spinner. |
| `wicket-veil-host` | The element of a component with a local veil, while veiled. Sets `isolation: isolate`, so the veil does not paint over a sticky header or a dialog in front of it. |
| `wicket-veil-host-static` | Added with `wicket-veil-host` when the element was not positioned. Sets `position: relative`. |

## Veil a component during a WebSocket push

An update pushed over a WebSocket has no Ajax request the browser could notice, so the server raises and lowers the veil itself. `getVeilMessage()` returns a text message that raises the local veil when you send it over the page's WebSocket connection; `unveil(handler)` lowers it once the pushed update is applied:

```java
LocalVeilBehavior veil = new LocalVeilBehavior();
counterPanel.add(veil);

// while handling a request, for example the click that starts the work
String veilMessage = veil.getVeilMessage();

// in the background thread
connection.sendMessage(veilMessage);
// ... compute, then push the result as an IWebSocketPushMessage

// in onEvent(), for the WebSocketPushPayload with the result
handler.add(counterPanel);
veil.unveil(handler);
```

`getVeilMessage()` reads the component's markup id, so call it during a request; the message is a plain string you can send from any thread. When the work fails and no update follows, send `getUnveilMessage()` instead. Pushing updates is covered in [Push updates over a WebSocket]({{ site.baseurl }}/docs/use-websockets.html).
