---
title: Change how an Ajax request is sent
type: howto
topic: ajax
summary: Override updateAjaxAttributes to throttle requests, send them as POST, pass extra parameters, drop outdated ones or stop the browser's default action.
since: 10
apis: [AjaxRequestAttributes, ThrottlingSettings, AjaxChannel, AjaxRequestTarget.IListener, AbstractDefaultAjaxBehavior]
keywords: [updateAjaxAttributes, debounce, throttle, keyup, POST, extra parameters, preventDefault, stopPropagation, event delegation, channel, timeout, attrs]
order: 40
source: [ajax/ajax_5.adoc]
---

Use this when the default request of an Ajax component or behavior does not fit: it fires too often, should carry more data, or lets the browser do something you want to stop. Every Ajax component and behavior describes its request with an `AjaxRequestAttributes` object, which you change by overriding `updateAjaxAttributes`. Always call `super` first, it sets the event names and the form to submit:

```java
field.add(new AjaxFormComponentUpdatingBehavior("input") {
    @Override
    protected void updateAjaxAttributes(AjaxRequestAttributes attributes) {
        super.updateAjaxAttributes(attributes);
        attributes.setThrottlingSettings(new ThrottlingSettings(Duration.ofMillis(400)));
    }

    @Override
    protected void onUpdate(AjaxRequestTarget target) {
        target.add(results);
    }
});
```

Ajax components such as `AjaxLink` and `AjaxButton` have the same `updateAjaxAttributes` method.

## Wait until the user stops typing

The throttling settings above send at most one request per 400 ms, however fast the user types. `new ThrottlingSettings(delay, true)` restarts the delay at every event, so the request goes out only once the user has paused for the whole delay.

## Drop requests that are outdated

Ajax requests wait in a queue per channel, and all requests share one channel by default. For a search field, an older search is useless once a newer one is waiting. Give the behavior its own channel that keeps only the last request:

```java
attributes.setChannel(new AjaxChannel("search", AjaxChannel.Type.DROP));
```

`AjaxChannel.Type.ACTIVE` discards a new request while one on the channel is still running, which suits a button that must not be pressed twice.

## Stop the browser's default action

```java
attributes.setPreventDefault(true);
attributes.setEventPropagation(AjaxRequestAttributes.EventPropagation.STOP);
```

`setPreventDefault(true)` stops a link from being followed or a form from being submitted by the browser. You need it for an `AjaxFormSubmitBehavior` on a submit button, or the form is submitted twice. `EventPropagation.STOP` keeps the event from reaching the parent elements; the default is `BUBBLE`.

## Send extra parameters

Static values go into `getExtraParameters()`. Values that the browser has to compute go into `getDynamicExtraParameters()`, as the body of a JavaScript function that returns an object:

```java
attributes.getExtraParameters().put("source", "toolbar");
attributes.getDynamicExtraParameters().add("return {'width': window.innerWidth};");
```

Read them on the server from the request parameters:

```java
int width = getRequest().getRequestParameters().getParameterValue("width").toInt(0);
```

## Send the request as POST

Ajax requests are GET requests unless they submit a form. Switch to POST when the parameters are large or the request changes data:

```java
attributes.setMethod(AjaxRequestAttributes.Method.POST);
```

## Listen to several events, or to child elements

`AjaxEventBehavior` takes several event names separated by spaces, such as `new AjaxEventBehavior("click keydown")`. To handle clicks on many children with one behavior on their container, set a CSS selector; the event then only triggers when it comes from a matching element:

```java
attributes.setChildSelector("li");
```

## Give up after a timeout

```java
attributes.setRequestTimeout(Duration.ofSeconds(10));
```

A request that has no response by then fails, and the failure handlers of its call listeners run.

## Change every Ajax request in the application

An `AjaxRequestTarget.IListener` registered with the application sees the attributes of every Ajax behavior before the behavior's own `updateAjaxAttributes`:

```java
@Override
protected void init() {
    super.init();
    getAjaxRequestTargetListeners().add(new AjaxRequestTarget.IListener() {
        @Override
        public void updateAjaxAttributes(AbstractDefaultAjaxBehavior behavior,
                AjaxRequestAttributes attributes) {
            attributes.setRequestTimeout(Duration.ofSeconds(30));
        }
    });
}
```

## Read the attributes in the page source

The attributes are rendered as a JSON object in the call to `Wicket.Ajax.ajax`, with short names. Only values that differ from the default are written.

| Short name | Attribute | Set with |
|---|---|---|
| `u` | Callback URL | (generated) |
| `c` | Markup id of the component | (generated) |
| `e` | Event names | `setEventNames` |
| `m` | HTTP method, `GET` by default | `setMethod` |
| `f`, `sc`, `mp` | Form to submit, submitting component, multipart | `setFormId`, `setSubmittingComponentName`, `setMultipart` |
| `tr` | Throttling | `setThrottlingSettings` |
| `ch` | Channel | `setChannel` |
| `pd`, `sp` | Prevent default, event propagation | `setPreventDefault`, `setEventPropagation` |
| `ep`, `dep` | Extra and dynamic extra parameters | `getExtraParameters`, `getDynamicExtraParameters` |
| `sel` | Child selector | `setChildSelector` |
| `rt` | Request timeout | `setRequestTimeout` |
| `async` | Asynchronous request, `true` by default | `setAsynchronous` |
| `dt`, `wr` | Response data type, whether the response is an `<ajax-response>` | `setDataType`, `setWicketAjaxResponse` |
| `sr` | Serialize all form fields inside the element | `setSerializeRecursively` |
| `i` | Markup id of the busy indicator | `IAjaxIndicatorAware` |
| `ih`, `bh`, `pre`, `bsh`, `ah`, `sh`, `fh`, `coh`, `dh` | Call listener handlers | `getAjaxCallListeners` |

The handlers are covered in [React to Ajax requests in JavaScript]({{ site.baseurl }}/docs/ajax-call-listeners.html).
