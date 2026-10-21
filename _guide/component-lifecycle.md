---
title: Component lifecycle
type: reference
topic: lifecycle
summary: The stages a component goes through and every hook method Wicket calls on it, in order, with who calls it and when.
since: 10
apis: [Component, MarkupContainer, Behavior, IComponentInstantiationListener, IComponentInitializationListener, IComponentOnConfigureListener, IComponentOnBeforeRenderListener, IComponentOnAfterRenderListener, IOnComponentTagListener]
keywords: [hook method, callback, onInitialize, onConfigure, onBeforeRender, onComponentTag, onComponentTagBody, onRender, onAfterRender, onRemove, onReAdd, onDetach, renderHead, detachModels, has not called super, post constructor]
order: 10
source: [componentLifecycle/componentLifecycle_1.adoc, componentLifecycle/componentLifecycle_2.adoc, componentLifecycle/componentLifecycle_3.adoc, componentLifecycle/componentLifecycle_4.adoc, componentLifecycle/componentLifecycle_5.adoc, componentLifecycle/componentLifecycle_6.adoc, componentLifecycle/componentLifecycle_7.adoc]
---

A component is created once with `new`, then takes part in any number of requests until it is garbage collected with its page. In each request it may be rendered, and at the end of each request it is detached. Why the lifecycle looks like this is explained in [What happens during a request]({{ site.baseurl }}/docs/request-cycle.html).

## Stages

| Stage | When | Hook methods |
|---|---|---|
| Construction | Application code calls `new`; for bookmarkable pages Wicket calls the page constructor. Once per component. | constructor |
| Initialization | The first time the component is part of a tree rooted in a page. Once per component. | `onInitialize()` |
| Re-adding | The component was removed from its parent and is added to a page again. | `onReAdd()` |
| Configuration | Every request in which the component, or a container around it, is about to render. | `onConfigure()` |
| Preparing to render | Every request in which the component will render and is visible. | `onBeforeRender()` |
| Rendering | The component writes its markup. Happens for a full page render and for an Ajax update of the component or a parent. | `renderHead()`, `onRender()`, `onComponentTag()`, `onComponentTagBody()`, `onAfterRender()` |
| Removal | The parent calls `remove()` or `replace()`. Optional, and never happens to a page. | `onRemove()` |
| Detaching | The end of every request in which the component's page was used. | `onDetach()`, `detachModels()` |

A component that is not visible goes through configuration but not through preparing to render or rendering.

## Hook methods in call order

The table lists every hook of `Component` in the order Wicket calls it during a request that renders a page. "Super" says where an override must call the super implementation. Wicket checks the ones marked "checked" and throws an `IllegalStateException` when the call is missing, with a message like `onInitialize() in the hierarchy of com.example.HomePage has not called super.onInitialize()`.

| Method | Called by | When | Super | Typical use |
|---|---|---|---|---|
| constructor | your code, or the page factory for bookmarkable pages | once | first line, by Java | Add child components, set models. |
| `onInitialize()` | `MarkupContainer.add()` on a page that is already initialized; otherwise the page when it initializes itself before its first render | once, parents before children | first, checked | Code that needs the page, the parent or the markup, such as `getPage()` or `getMarkup()`. |
| `onReAdd()` | `MarkupContainer.add()` | each time a removed component is added again | checked | Restore what `onRemove()` released. |
| `onConfigure()` | `Component.configure()`, from the parent's `beforeRender()` | once per request, before rendering, also when the component is invisible | checked | Decide visibility and enabled state with `setVisible()` and `setEnabled()`. |
| `onBeforeRender()` | `Component.beforeRender()` | once per request, after `onConfigure()`, only when visible | last, checked | Add, replace or remove children. The super call cascades to the children, so changes must come before it. |
| `renderHead(IHeaderResponse)` | the page's `<head>` section, or the Ajax response for the updated components | when the head is rendered, children before their parents | not needed | Contribute CSS and JavaScript. See [Header items]({{ site.baseurl }}/docs/header-items.html). |
| `onRender()` | `Component.render()` | when the component renders | depends on the class | Writes the component to the response. Abstract; rarely overridden. |
| `onComponentTag(ComponentTag)` | `onRender()` of `WebComponent` and `MarkupContainer` | while writing the component's open tag | yes, usually first | Change the tag name or its attributes. |
| `onComponentTagBody(MarkupStream, ComponentTag)` | the component's markup sourcing strategy | after the open tag, for tags with a body | call it to keep the default body | Replace the body, for example with `replaceComponentTagBody()`. In a `MarkupContainer`, the super call renders the children. |
| `onAfterRender()` | `Component.render()` | after the component and all its children are rendered, also when rendering threw an exception | checked | Clean up after rendering. |
| `onRemove()` | `MarkupContainer.remove()` and `replace()` | when removed from the hierarchy, before its children | last, checked | Release resources held for rendering. |
| `onDetach()` | `Component.detach()` | at the end of every request that used the page, also for components that did not render | last, checked | Release request-scoped state. |
| `detachModels()` | `Component.detach()`, after `onDetach()` | at the end of every request | yes | Detach models other than the default model. |

Two more hooks run outside this order:

| Method | When |
|---|---|
| `onModelChanging()` and `onModelChanged()` | Before and after `setDefaultModelObject()` changes the model object. |
| `onEvent(IEvent<?>)` | When an event sent with `send()` reaches the component. See [Send events between components]({{ site.baseurl }}/docs/send-events.html). |

## Order within the component tree

- `onInitialize()` runs on a container before its children.
- `onConfigure()` and `onBeforeRender()` run on a container before its children, because `super.onBeforeRender()` cascades to the children.
- Feedback components such as `FeedbackPanel` are prepared after all other components of the page, so they see the messages that `onConfigure()` and `onBeforeRender()` of other components report.
- `renderHead()` runs child first: children contribute before their parents, and the page contributes last, so a parent can override what a child contributed.
- `onComponentTag()` and `onComponentTagBody()` run in markup order. A container writes its open tag, then renders its children inside `onComponentTagBody()`, then writes its close tag.
- `onAfterRender()` runs on the children before their container.
- `onDetach()` runs on a container before its children.

Once rendering has started, a component cannot change: adding or replacing children throws an exception. Make such changes in `onBeforeRender()` before calling super, or in `onConfigure()`.

## When a request invokes a listener

When the request clicks a link or submits a form, Wicket loads the page and calls the listener (`onClick()`, `onSubmit()`, the `onEvent()` of an Ajax behavior) before any of the rendering hooks of that request. The listener sees the visibility and enabled state set during the previous render. After the listener, the page or the updated components go through configuration and rendering as above, and every touched component is detached at the end.

## Hooks of a behavior

A [behavior]({{ site.baseurl }}/docs/add-behaviors.html) is called from the matching hook of the component it is added to:

| Behavior method | Called |
|---|---|
| `bind(Component)` | When the behavior is added to the component. |
| `onConfigure(Component)` | Right after the component's `onConfigure()`. |
| `beforeRender(Component)` | Just before the component's `onRender()`. |
| `renderHead(Component, IHeaderResponse)` | With the component's `renderHead()`, when the behavior is enabled. |
| `onComponentTag(Component, ComponentTag)` | After the component's `onComponentTag()`, when the open tag is written. |
| `afterRender(Component)` | Right after the component's `onRender()`. |
| `onException(Component, RuntimeException)` | When rendering the component throws. |
| `onEvent(Component, IEvent<?>)` | After the component's `onEvent()`. |
| `onRemove(Component)` | When the component is removed from the hierarchy. |
| `detach(Component)` | When the component detaches. |
| `unbind(Component)` | When the behavior is removed from the component. |

## Application-wide listeners

These listeners run for every component of the application. Register them in `Application.init()`.

| Listener | Registered with | Called |
|---|---|---|
| `IComponentInstantiationListener` | `getComponentInstantiationListeners()` | In the `Component` constructor, before the constructor of your subclass runs. Dependency injection uses it. |
| `IComponentInitializationListener` | `getComponentInitializationListeners()` | After `onInitialize()`. |
| `IComponentOnConfigureListener` | `getComponentOnConfigureListeners()` | After `onConfigure()` and the behaviors' `onConfigure()`. |
| `IComponentOnBeforeRenderListener` | `getComponentPreOnBeforeRenderListeners()` | Before `onBeforeRender()`. |
| `IComponentOnBeforeRenderListener` | `getComponentPostOnBeforeRenderListeners()` | After `onBeforeRender()`. |
| `IOnComponentTagListener` | `getOnComponentTagListeners()` | Before `onComponentTag()`. |
| `IComponentOnAfterRenderListener` | `getComponentOnAfterRenderListeners()` | After `onAfterRender()`. |

```java
@Override
protected void init() {
    super.init();
    getComponentInitializationListeners().add(component ->
        log.debug("initialized {}", component.getPageRelativePath()));
}
```

## Which hook to override

Set visibility in `onConfigure()`, not by overriding `isVisible()`, which Wicket calls many times per request:

```java
add(new WebMarkupContainer("adminTools") {
    @Override
    protected void onConfigure() {
        super.onConfigure();
        setVisible(currentUser().isAdmin());
    }
});
```

Change the tag in `onComponentTag()`:

```java
add(new Label("title", titleModel) {
    @Override
    protected void onComponentTag(ComponentTag tag) {
        super.onComponentTag(tag);
        tag.setName("span");
        tag.put("class", "title");
    }
});
```

To reuse such a change on several components, use an `AttributeModifier` or a behavior instead; see [Change a tag's attributes]({{ site.baseurl }}/docs/modify-attributes.html).

Replace the body in `onComponentTagBody()`:

```java
add(new Label("status", statusModel) {
    @Override
    public void onComponentTagBody(MarkupStream markupStream, ComponentTag openTag) {
        if (isEnabledInHierarchy()) {
            super.onComponentTagBody(markupStream, openTag);
        } else {
            replaceComponentTagBody(markupStream, openTag, "(not available)");
        }
    }
});
```

Swap a child in `onBeforeRender()`, before the super call:

```java
@Override
protected void onBeforeRender() {
    addOrReplace(showDetails ? new DetailsPanel("content") : new SummaryPanel("content"));
    super.onBeforeRender();
}
```
