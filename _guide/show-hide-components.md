---
title: Show, hide or disable a component
type: howto
topic: components
summary: Hide a component or make it read-only depending on the state of your application, and decide that state once per request in onConfigure.
since: 10
apis: [Component, WebMarkupContainer]
keywords: [visibility, setVisible, isVisible, setEnabled, isEnabled, disabled, hidden, conditional rendering, onConfigure, isVisibleInHierarchy, setOutputMarkupPlaceholderTag]
order: 10
source: [keepControl/keepControl_1.adoc]
---

Use this when part of a page should only appear, or only be usable, under some condition: a link for administrators, a warning when a list is empty, a field that cannot be changed after an order is placed.

## Hide a component

Call `setVisible(false)`. An invisible component renders nothing, not even its tag, and neither do its children.

```java
Label warning = new Label("warning", "Your trial ends tomorrow.");
warning.setVisible(account.isTrialEndingSoon());
add(warning);
```

This decides the visibility once, when the page is built. If the page stays on screen and the condition changes, the component keeps its old state.

## Decide visibility on every request with onConfigure

Override `onConfigure` and set the visibility there. Wicket calls `onConfigure` once per request, before it renders the component, so the condition is always current.

```java
add(new Label("warning", "Your trial ends tomorrow.") {
    @Override
    protected void onConfigure() {
        super.onConfigure();
        setVisible(account.isTrialEndingSoon());
    }
});
```

Always call `super.onConfigure()`; Wicket checks that you do.

Prefer this to overriding `isVisible()`. Wicket calls `isVisible()` many times while it processes a request, so any work in it, such as a database query, runs many times. An overridden `isVisible()` can also return different answers within one request, which makes `isVisibleInHierarchy()` unreliable.

## Hide a group of components at once

Hiding a container hides all of its children. Put the components in a `WebMarkupContainer` and set the visibility on the container. See [Group components with WebMarkupContainer]({{ site.baseurl }}/docs/group-components.html).

To hide the text around a single component together with it, without a container in Java, use [`wicket:enclosure`]({{ site.baseurl }}/docs/use-enclosures.html).

## Disable a component

Call `setEnabled(false)`, in `onConfigure` when the condition can change:

```java
add(new TextField<>("customerNumber", customerNumberModel) {
    @Override
    protected void onConfigure() {
        super.onConfigure();
        setEnabled(!order.isPlaced());
    }
});
```

A disabled component is still rendered, but:

- form components get the `disabled` attribute, and Wicket ignores their input;
- links lose their `href`, and buttons get the `disabled` attribute;
- Wicket refuses requests to the component's listeners, so its Ajax behaviors do nothing, even when someone calls their URL by hand.

Disabling a container disables everything inside it. `isEnabledInHierarchy()` tells you whether a component and all its parents are enabled.

## Show a hidden component with Ajax

An invisible component leaves no tag in the page, so an Ajax response has nowhere to put it when it becomes visible. Call `setOutputMarkupPlaceholderTag(true)` on it: Wicket then renders an empty, hidden placeholder tag with the component's markup id in its place.

```java
Label details = new Label("details", detailsModel);
details.setVisible(false);
details.setOutputMarkupPlaceholderTag(true);
add(details);

add(new AjaxLink<Void>("toggle") {
    @Override
    public void onClick(AjaxRequestTarget target) {
        details.setVisible(!details.isVisible());
        target.add(details);
    }
});
```

See [Update components with Ajax]({{ site.baseurl }}/docs/update-components.html) for more on repainting components.
