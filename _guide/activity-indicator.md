---
title: Show that a request is running
type: howto
topic: ajax
summary: Show a busy indicator while an Ajax request runs, with the indicating components, your own component or your own spinner element.
since: 10
apis: [IndicatingAjaxLink, IndicatingAjaxButton, IndicatingAjaxFallbackLink, IAjaxIndicatorAware, AjaxIndicatorAppender, AjaxDisableComponentListener]
keywords: [spinner, loading indicator, busy indicator, throbber, progress, disable button while submitting, double submit]
order: 20
source: [ajax/ajax_4.adoc]
---

Use this when an Ajax request can take long enough for the user to wonder whether the click registered. Wicket shows an element while the request runs and hides it when the response is in.{% if site.wicket.version_11 %} To also stop the user from clicking again, see [Block the page while a request runs]({{ site.baseurl }}/docs/ajax-veils.html).{% endif %}

## Use an indicating link or button

wicket-extensions has variants of the Ajax link and button that render a small animated image after themselves:

```java
add(new IndicatingAjaxButton("save") {
    @Override
    protected void onSubmit(AjaxRequestTarget target) {
        reportService.generate(form.getModelObject());
        target.add(result);
    }
});
```

`IndicatingAjaxLink`, `IndicatingAjaxFallbackLink` and `IndicatingAjaxButton` have the same callbacks as `AjaxLink`, `AjaxFallbackLink` and `AjaxButton`. The image sits in a `span` with the CSS class `wicket-ajax-indicator`, which you can style.

## Add the indicator to your own component

Any component with an Ajax behavior gets an indicator when it implements `IAjaxIndicatorAware` and returns the markup id of the indicator element. `AjaxIndicatorAppender` renders the default image and gives you that id:

```java
public class RefreshPanel extends Panel implements IAjaxIndicatorAware {
    private final AjaxIndicatorAppender indicator = new AjaxIndicatorAppender();

    public RefreshPanel(String id) {
        super(id);
        add(indicator);
        add(new AjaxLink<Void>("refresh") {
            @Override
            public void onClick(AjaxRequestTarget target) {
                // ...
            }
        });
    }

    @Override
    public String getAjaxIndicatorMarkupId() {
        return indicator.getMarkupId();
    }
}
```

Wicket looks for an `IAjaxIndicatorAware` on the component that has the Ajax behavior, then on the behavior itself, then on each parent up to the page. That is why the link inside `RefreshPanel` shows the panel's indicator: one implementation covers every Ajax component in the panel.

For a different image, pass a `ResourceReference` to the `AjaxIndicatorAppender` constructor, or override its `getIndicatorUrl()`.

## Use your own spinner element

`getAjaxIndicatorMarkupId()` can return the id of any element on the page. Wicket removes its `hidden` attribute when the request starts and sets it again when the request ends, so start with the element hidden:

*OrderPage.html*

```html
<div id="order-spinner" class="spinner" hidden>Saving your order...</div>
```

*OrderPage.java*

```java
public class OrderPage extends WebPage implements IAjaxIndicatorAware {
    @Override
    public String getAjaxIndicatorMarkupId() {
        return "order-spinner";
    }
}
```

Because the page is the last parent Wicket checks, every Ajax component on the page without an indicator of its own uses this one. Wicket counts the running requests, so the element stays visible until the last one is done.

## Disable the button while the request runs

`AjaxDisableComponentListener` from wicket-extensions sets the `disabled` attribute on the component during the request and removes it afterwards:

```java
add(new AjaxButton("save") {
    @Override
    protected void updateAjaxAttributes(AjaxRequestAttributes attributes) {
        super.updateAjaxAttributes(attributes);
        attributes.getAjaxCallListeners().add(new AjaxDisableComponentListener());
    }

    @Override
    protected void onSubmit(AjaxRequestTarget target) {
        // ...
    }
});
```

This works for elements that have a `disabled` attribute, such as buttons and inputs. How call listeners work is described in [React to Ajax requests in JavaScript]({{ site.baseurl }}/docs/ajax-call-listeners.html).
