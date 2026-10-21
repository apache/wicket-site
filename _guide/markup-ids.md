---
title: Give a component a markup id
type: howto
topic: components
summary: Render the HTML id attribute of a component so JavaScript, CSS, labels and Ajax can find it, and choose or generate the id yourself.
since: 10
apis: [Component, IMarkupIdGenerator, DefaultMarkupIdGenerator, MarkupSettings]
keywords: [id attribute, DOM id, setOutputMarkupId, getMarkupId, setMarkupId, unique id, getElementById, Markup id set on a component that renders its body only]
order: 30
source: [keepControl/keepControl_3.adoc]
---

Use this when something in the browser needs to find a component's element by its `id`: your JavaScript, a `<label for>`, an ARIA attribute, or Wicket Ajax repainting the component. By default Wicket does not write an `id` attribute on component tags.

## Render the id attribute

Call `setOutputMarkupId(true)`. Wicket then writes an `id` that is unique within the page.

```java
Label total = new Label("total", totalModel);
total.setOutputMarkupId(true);
add(total);
```

Components you repaint with Ajax need it as well: the browser finds the element to replace by this id, so it must be in the page before the Ajax request.

## Use the id in Java

`getMarkupId()` returns the id. Use it to build JavaScript or to point other attributes at the component:

```java
TextField<String> search = new TextField<>("search", queryModel);
search.setOutputMarkupId(true);
add(search);

add(new WebMarkupContainer("hint")
    .add(AttributeModifier.replace("aria-describedby", search::getMarkupId)));
```

Call `getMarkupId()` once the component is on a page, for instance from `onInitialize`, `onConfigure`, a model or `renderHead`, not in a constructor where the component has no parent yet.

For `<label>` tags there is a shortcut that needs no Java: `<label wicket:for="search">` writes the `for` attribute and turns on the markup id. See [`wicket:for`]({{ site.baseurl }}/docs/wicket-tags.html#wicketfor).

## Choose the id yourself

Wicket picks the id from, in this order:

1. a value you set with `setMarkupId(String)`;
2. an `id` attribute on the tag in the markup;
3. a generated id.

```java
search.setMarkupId("site-search");
```

A fixed id is your responsibility: if the component appears twice on a page, for instance in a list or in two panels, the page ends up with duplicate ids. Generated ids do not have that problem, so prefer them unless something outside Wicket needs a known id.

## Know what generated ids look like

The default generator, `DefaultMarkupIdGenerator`, combines a prefix with a counter kept in the session, written in hexadecimal. In development mode the prefix is the component id, such as `total1f`, so you can recognise the element. In deployment mode the prefix is `id`, such as `id1f`. Do not rely on a generated id in CSS or tests: it changes with the order in which components get their ids.

## Generate ids your own way

Implement `IMarkupIdGenerator`, a single method interface, and register it in your application's `init()`:

```java
@Override
protected void init() {
    super.init();
    getMarkupSettings().setMarkupIdGenerator((component, createIfDoesNotExist) -> {
        Object stored = component.getMarkupIdImpl();
        if (stored instanceof String id) {
            return id;
        }
        if (stored == null && !createIfDoesNotExist) {
            return null;
        }
        int sequence = stored instanceof Integer number ? number : component.getSession().nextSequenceValue();
        component.setMarkupIdImpl(sequence);
        return "w" + Integer.toString(sequence, 36);
    });
}
```

The generator must return the same id every time it is asked about the same component, which is why it stores the sequence number on the component with `setMarkupIdImpl`.

## Keep the tag when you need the id

A component with `setRenderBodyOnly(true)` has no tag to carry the id. Wicket logs `Markup id set on a component that renders its body only`, and the component cannot be updated with Ajax. Keep the tag on components that need an id; see [Render a component without its tag]({{ site.baseurl }}/docs/render-body-only.html).
