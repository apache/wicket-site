---
title: Handle a callback URL with IRequestListener
type: howto
topic: lifecycle
summary: Let a component or behavior answer requests to a URL of its own, read parameters from the request, and respond with the page or anything else.
since: 10
apis: [IRequestListener, Component, Behavior, ListenerRequestHandler, TextRequestHandler]
keywords: [callback url, urlForListener, onRequest, rendersPage, custom listener, request parameter, link without Link]
order: 50
source: [advanced/advanced_2.adoc]
---

Use `IRequestListener` when a component or behavior needs a URL that calls back into it on the server, and none of the built-in links, forms or Ajax behaviors fits. `Link` itself works this way: its `onClick()` is called from the listener method `onRequest()`. For callbacks from JavaScript without a page reload, use an Ajax behavior such as `AbstractDefaultAjaxBehavior` instead; see [Ajax behaviors]({{ site.baseurl }}/docs/ajax-behaviors.html).

The interface has two methods:

| Method | Purpose |
|---|---|
| `void onRequest()` | Runs when the callback URL is requested. |
| `boolean rendersPage()` | Whether Wicket renders the page after `onRequest()`. Default `true`. |

## Give a component a callback URL

Implement `IRequestListener` on the component and put the URL from `urlForListener()` in its markup:

*LikeButton.java*

```java
public class LikeButton extends WebComponent implements IRequestListener {

    public LikeButton(String id, IModel<Integer> likes) {
        super(id, likes);
    }

    @Override
    protected void onComponentTag(ComponentTag tag) {
        super.onComponentTag(tag);
        tag.put("href", urlForListener(new PageParameters()));
    }

    @Override
    public void onRequest() {
        int likes = (Integer) getDefaultModelObject();
        setDefaultModelObject(likes + 1);
    }
}
```

*HomePage.html*

```html
<a wicket:id="like">Like</a>
```

When the user follows the link, Wicket finds the page and the component, calls `onRequest()`, and renders the page again.

## Give a behavior a callback URL

A behavior gets its URL from the component it is bound to, with `urlForListener(behavior, parameters)`. This behavior sends the selected value of a `<select>` to the server when it changes, by adding a request parameter to the callback URL:

*ChoiceCallbackBehavior.java*

```java
public abstract class ChoiceCallbackBehavior extends Behavior implements IRequestListener {

    private Component component;

    @Override
    public void bind(Component component) {
        this.component = component;
        component.setOutputMarkupId(true);
    }

    @Override
    public void renderHead(Component component, IHeaderResponse response) {
        String url = component.urlForListener(this, new PageParameters()).toString();
        response.render(OnDomReadyHeaderItem.forScript(
            "document.getElementById('" + component.getMarkupId() + "').addEventListener('change', e => {"
            + " const url = new URL('" + url + "', location.href);"
            + " url.searchParams.set('choice', e.target.value);"
            + " location.href = url; });"));
    }

    @Override
    public void onRequest() {
        StringValue choice = component.getRequest()
            .getRequestParameters()
            .getParameterValue("choice");
        onChoice(choice.toOptionalString());
    }

    protected abstract void onChoice(String choice);
}
```

Read request parameters with `getRequestParameters()`, which covers both the query string and posted form data. Values arrive as `StringValue`; convert them yourself and never trust them, since anyone can send any value to the URL.

## Respond with something other than the page

Return `false` from `rendersPage()` and schedule your own request handler in `onRequest()`. This listener answers with JSON:

```java
@Override
public boolean rendersPage() {
    return false;
}

@Override
public void onRequest() {
    String json = "{\"likes\": " + getDefaultModelObject() + "}";
    RequestCycle.get().scheduleRequestHandlerAfterCurrent(
        new TextRequestHandler("application/json", "UTF-8", json));
}
```

The handlers you can schedule are listed in [Request processing]({{ site.baseurl }}/docs/request-processing.html#request-handlers).

## Things to know

- A behavior that implements `IRequestListener` makes its page stateful, because the URL points to one component instance on one page instance. A component that implements it decides with `getStatelessHint()`; `Link` returns `false`. On a stateless page, Wicket creates the page again for the callback. See [Keep a page stateless]({{ site.baseurl }}/docs/keep-stateless.html).
- Wicket calls the listener only when the component is visible and enabled, and the behavior enabled. Otherwise it throws a `ListenerInvocationNotAllowedException` and shows the access denied page. Override `canCallListener()` to change this.
- `onRequest()` runs before the rendering hooks of the request. Change state there and let `onConfigure()` act on it; see [Component lifecycle]({{ site.baseurl }}/docs/component-lifecycle.html#when-a-request-invokes-a-listener).
