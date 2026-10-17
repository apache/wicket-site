---
title: React to Ajax requests in JavaScript
type: howto
topic: ajax
summary: Run your own JavaScript before, during and after Ajax requests, for one component with a call listener or for the whole page with global events.
since: 10
apis: [IAjaxCallListener, AjaxCallListener, AjaxRequestAttributes, IComponentAwareHeaderContributor]
keywords: [confirm dialog, are you sure, precondition, beforeSend, success handler, failure handler, Wicket.Event.subscribe, /ajax/call/complete, /dom/node/removing, jqXHR]
order: 50
source: [ajax/ajax_5.adoc, ajax/ajax_6.adoc]
---

Use this when the browser has to do something around an Ajax request: ask for confirmation first, mark a part of the page as busy, or clean up a JavaScript widget before its markup is replaced. A call listener does this for the requests of one component; global events do it for every request on the page.

## Ask for confirmation before the request

Add an `AjaxCallListener` in `updateAjaxAttributes`. A precondition that returns `false` cancels the request:

```java
add(new AjaxLink<Void>("delete") {
    @Override
    protected void updateAjaxAttributes(AjaxRequestAttributes attributes) {
        super.updateAjaxAttributes(attributes);
        attributes.getAjaxCallListeners().add(new AjaxCallListener()
            .onPrecondition("return confirm('Delete this order?');"));
    }

    @Override
    public void onClick(AjaxRequestTarget target) {
        orders.delete(orderId);
        target.add(orderList);
    }
});
```

Each `on...` method takes the body of a JavaScript function. Wicket wraps it in a function with the arguments listed below and calls it at that stage of the request.

## The stages of a request

| Stage | `AjaxCallListener` method | Function arguments | Runs |
|---|---|---|---|
| init | `onInit` | `attrs` | Right after the event, before anything else. |
| before | `onBefore` | `attrs` | Before the preconditions. |
| precondition | `onPrecondition` | `attrs` | Returning `false` cancels the request and the handlers after it. |
| beforeSend | `onBeforeSend` | `attrs`, `jqXHR`, `settings` | Just before the request is sent, when all preconditions passed. |
| after | `onAfter` | `attrs` | Right after the request is sent, before the response arrives. |
| success | `onSuccess` | `attrs`, `jqXHR`, `data`, `textStatus` | When the response has been processed. |
| failure | `onFailure` | `attrs`, `jqXHR`, `errorMessage`, `textStatus` | When the request failed or timed out. |
| complete | `onComplete` | `attrs`, `jqXHR`, `textStatus` | After success or failure. |
| done | `onDone` | `attrs` | At the very end, also when a precondition cancelled the request. |

`attrs` is the attributes object of the request, the same JSON that is passed to `Wicket.Ajax.ajax`; `attrs.c` is the markup id of the component. `jqXHR` is the request object.

> Since Wicket 11, `jqXHR` is a plain `XMLHttpRequest` and `settings` a plain object when the application uses the jQuery-free Ajax implementation; with the default implementation they are the jQuery objects. See [Run Ajax without jQuery]({{ site.baseurl }}/docs/ajax-without-jquery.html).
{: .since}

## Write a reusable listener

For a listener you use in several places, extend `AjaxCallListener` and override the getters. `AjaxCallListener` also implements `IComponentAwareHeaderContributor`, so the listener can bring its own script:

*BusyListener.java*

```java
public class BusyListener extends AjaxCallListener {
    private static final ResourceReference SCRIPT =
        new JavaScriptResourceReference(BusyListener.class, "busy.js");

    private final Component region;

    public BusyListener(Component region) {
        this.region = region;
        region.setOutputMarkupId(true);
    }

    @Override
    public CharSequence getBeforeHandler(Component component) {
        return "Busy.start('" + region.getMarkupId() + "');";
    }

    @Override
    public CharSequence getCompleteHandler(Component component) {
        return "Busy.stop('" + region.getMarkupId() + "');";
    }

    @Override
    public void renderHead(Component component, IHeaderResponse response) {
        response.render(JavaScriptHeaderItem.forReference(SCRIPT));
    }
}
```

*busy.js*

```javascript
var Busy = {
    start: function (id) {
        document.getElementById(id).classList.add('busy');
    },
    stop: function (id) {
        document.getElementById(id).classList.remove('busy');
    }
};
```

Add it with `attributes.getAjaxCallListeners().add(new BusyListener(form))`. `AjaxDisableComponentListener` in wicket-extensions is a ready-made listener of this kind, and for blocking the page there are veils; see [Block the page while a request runs]({{ site.baseurl }}/docs/ajax-veils.html).

## Listen to every Ajax request on the page

Global events fire for all Ajax requests. Subscribe to them in JavaScript with `Wicket.Event.subscribe`:

```javascript
Wicket.Event.subscribe('/ajax/call/failure', function (event, attrs, jqXHR, errorMessage, textStatus) {
    console.warn('Ajax request failed', attrs.u, textStatus);
});
```

The first argument is a small event object; the others are the arguments of the matching stage in the table above.

| Event | Fires |
|---|---|
| `/ajax/call/init` | At the init stage. |
| `/ajax/call/before` | At the before stage. |
| `/ajax/call/precondition` | At the precondition stage. |
| `/ajax/call/beforeSend` | Just before the request is sent. |
| `/ajax/call/after` | After the request is sent. |
| `/ajax/call/success` | When the response has been processed. |
| `/ajax/call/failure` | When the request failed. |
| `/ajax/call/complete` | After success or failure. |
| `/ajax/call/done` | At the end of every request. |
| `/dom/node/removing` | Before an element is replaced or removed by an Ajax update. Argument: the element. |
| `/dom/node/added` | After an element was inserted by an Ajax update. Argument: the new element. |

Render the subscription with the component or page that needs it, for example from `renderHead` with an `OnDomReadyHeaderItem` or in a script file, so it runs once per page. `Wicket.Event.unsubscribe(topic, handler)` removes a subscriber.

## Clean up a widget before its markup is replaced

When a component that a JavaScript library has decorated is refreshed through Ajax, its old element is thrown away and the library is not told. Use `/dom/node/removing` to tear the widget down. The event fires for the replaced element only, so also look inside it:

```javascript
Wicket.Event.subscribe('/dom/node/removing', function (event, element) {
    var pickers = element.matches('.datepicker') ? [element] : [];
    element.querySelectorAll('.datepicker').forEach(function (e) { pickers.push(e); });
    pickers.forEach(function (picker) {
        if (picker._flatpickr) {
            picker._flatpickr.destroy();
        }
    });
});
```

[Wrap a JavaScript widget in a component]({{ site.baseurl }}/docs/integrate-javascript.html) shows the component side of this.
