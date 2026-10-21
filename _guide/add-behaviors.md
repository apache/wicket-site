---
title: Add behavior to a component with a Behavior
type: howto
topic: components
summary: Write a Behavior that changes a component's tag, adds markup around it or contributes CSS and JavaScript, and reuse it on any kind of component.
since: 10
apis: [Behavior, ComponentTag, IHeaderResponse]
keywords: [mixin, decorator, onComponentTag, beforeRender, afterRender, renderHead, reusable logic, cross-cutting, add behavior, remove behavior, isTemporary]
order: 110
source: [advanced/advanced_1.adoc]
---

Use a behavior when the same addition applies to components of different kinds: a CSS class on every required field, a tooltip, a JavaScript widget, a confirmation prompt. Subclassing each component type would mean one subclass per type; a behavior is written once and added to any component with `add`.

## Write a behavior

Extend `Behavior` and override the methods for the moments you need. Every method gets the component the behavior is attached to. This one marks required form components: it adds a CSS class to the tag and writes an asterisk after it.

*RequiredMarker.java*

```java
public class RequiredMarker extends Behavior {

    @Override
    public void onComponentTag(Component component, ComponentTag tag) {
        if (isRequired(component)) {
            tag.append("class", "is-required", " ");
        }
    }

    @Override
    public void afterRender(Component component) {
        if (isRequired(component)) {
            component.getResponse().write("<span class=\"required-mark\" aria-hidden=\"true\">*</span>");
        }
    }

    private boolean isRequired(Component component) {
        return component instanceof FormComponent<?> field && field.isRequired();
    }
}
```

`beforeRender` and `afterRender` write to the response just before and after the component's markup. `onComponentTag` changes the component's own tag.

## Add and remove a behavior

```java
TextField<String> name = new TextField<>("name", nameModel);
name.setRequired(true);
name.add(new RequiredMarker());
```

`add` takes several behaviors at once. `remove(behavior)` takes one off again; keep a reference to the instance if you need that. `getBehaviors(RequiredMarker.class)` finds the behaviors of a type on a component.

## Add a behavior to many components

Behaviors combine with visitors and with your own base classes. To mark every form component in a form:

```java
form.visitChildren(FormComponent.class, (component, visit) -> component.add(new RequiredMarker()));
```

Run this in `onInitialize` of the page or form, after the fields have been added.

## Contribute CSS and JavaScript

Override `renderHead` to add resources to the page when the component is on it. Wicket renders each header item once per page, however many components carry the behavior.

```java
private static final CssResourceReference CSS =
    new CssResourceReference(RequiredMarker.class, "required-marker.css");

@Override
public void renderHead(Component component, IHeaderResponse response) {
    response.render(CssHeaderItem.forReference(CSS));
}
```

For JavaScript that needs the component's element, call `component.setOutputMarkupId(true)` in `bind` and use `component.getMarkupId()` in `renderHead`. See [Wrap a JavaScript widget in a component]({{ site.baseurl }}/docs/integrate-javascript.html).

## Write a small behavior as a lambda

For a one-off change to a tag, the factory methods on `Behavior` save a class:

```java
name.add(Behavior.onTag((component, tag) -> tag.put("autocomplete", "name")));
name.add(Behavior.onAttribute("class", current -> current == null ? "wide" : current + " wide"));
```

To set or append an attribute value from a model, use `AttributeModifier`; see [Change a tag's attributes]({{ site.baseurl }}/docs/modify-attributes.html).

## Choose the right method to override

| Method | Called |
|---|---|
| `bind(Component)` | when the behavior is added to a component |
| `unbind(Component)` | when the behavior is removed |
| `onConfigure(Component)` | after the component's own `onConfigure`, once per request |
| `beforeRender(Component)` | just before the component renders |
| `onComponentTag(Component, ComponentTag)` | while the component's tag is written |
| `afterRender(Component)` | just after the component rendered |
| `renderHead(Component, IHeaderResponse)` | while Wicket collects the page's header contributions |
| `onEvent(Component, IEvent<?>)` | when the component receives an event |
| `detach(Component)` | at the end of every request; release models and caches here |
| `onRemove(Component)` | when the component is removed from its parent |
| `onException(Component, RuntimeException)` | when an exception occurs in one of the other methods |
| `isEnabled(Component)` | before each of the above; return `false` to skip the behavior |
| `isTemporary(Component)` | return `true` to have the behavior removed at the end of the request |
| `getStatelessHint(Component)` | return `false` if the behavior makes the page stateful |
| `canCallListener(Component)` | for behaviors with a callback URL: whether a request to it is accepted |

A behavior that holds no state can be shared: add one instance to many components. Ajax behaviors are bound to a single component and throw an exception when you add them to a second one. For Ajax behaviors, see [Ajax behaviors]({{ site.baseurl }}/docs/ajax-behaviors.html).
