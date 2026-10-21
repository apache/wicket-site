---
title: Hide surrounding markup with wicket:enclosure
type: howto
topic: components
summary: Hide a caption, label or table row together with the component it describes, without a container component in Java.
since: 10
apis: [Enclosure, InlineEnclosure, EnclosureContainer]
keywords: [wicket:enclosure, hide label, hide caption, enclosure child attribute, inline enclosure, optional field, empty value]
order: 80
source: [keepControl/keepControl_9.adoc, componentQueueing/componentQueueing_2.adoc]
---

Use this when a value comes with markup that describes it, such as a caption, a `<dt>` or a table row, and that markup should disappear when the value's component is hidden. Without an enclosure you would need a `WebMarkupContainer` around both and keep its visibility in sync.

## Wrap the markup in wicket:enclosure

Put the caption and the component inside `<wicket:enclosure>`. When the component is invisible, Wicket leaves out everything inside the tag.

*CustomerPanel.html*

```html
<dl>
  <dt>Name</dt>
  <dd wicket:id="name"></dd>
  <wicket:enclosure>
    <dt>Phone</dt>
    <dd wicket:id="phone"></dd>
  </wicket:enclosure>
</dl>
```

*CustomerPanel.java*

```java
add(new Label("name", () -> customer.getName()));
add(new Label("phone", () -> customer.getPhone()) {
    @Override
    protected void onConfigure() {
        super.onConfigure();
        setVisible(customer.getPhone() != null);
    }
});
```

The components stay children of the panel in Java. Only the markup has the extra level.

## Choose the controlling component

With one component inside the enclosure, that component decides. With more, name the one that decides in the `child` attribute; otherwise Wicket stops with `Use <wicket:enclosure child='xxx'> to name the child component`.

```html
<wicket:enclosure child="phone">
  <dt>Phone</dt>
  <dd><span wicket:id="phone"></span> (<span wicket:id="phoneType"></span>)</dd>
</wicket:enclosure>
```

When the controlling component sits inside a container, give its path with `:` between the ids:

```html
<wicket:enclosure child="contact:phone">
  <div wicket:id="contact">
    <dt>Phone</dt>
    <dd wicket:id="phone"></dd>
  </div>
</wicket:enclosure>
```

## Use the enclosure as an attribute

When the markup to hide is a single element, put `wicket:enclosure` on that element instead of adding a tag around it. Leave the value empty to let the first component inside decide, or give the id of the controlling component.

```html
<table>
  <tr wicket:enclosure="">
    <th>Phone</th>
    <td wicket:id="phone"></td>
  </tr>
</table>
```

This form also works with Ajax. The element gets a markup id and a placeholder of its own, and when you add the controlling component to an `AjaxRequestTarget`, Wicket repaints the whole element instead, so the row appears or disappears together with the value. With the `<wicket:enclosure>` tag, only the component itself is repainted.

## Use enclosures around form components

An enclosure does not become the parent of the components inside it: in Java they stay children of the page or panel. When the enclosure is hidden because one field is invisible, the other fields in it are still part of the form. They are validated on submit, and a required field raises an error the user cannot see.

Two ways around this:

- Add the components with `queue()` instead of `add()`. Wicket then builds the hierarchy from the markup, and the enclosure becomes the real parent of the fields. Hidden enclosure, skipped fields. See [Add components without repeating the markup hierarchy]({{ site.baseurl }}/docs/queue-components.html).
- Replace the tag with an `EnclosureContainer`: a container you add yourself, attached to an ordinary tag or a `<wicket:container>`, that takes its visibility from one child. Add the fields to it.

```java
TextField<String> phone = new TextField<>("phone", phoneModel);
EnclosureContainer phoneGroup = new EnclosureContainer("phoneGroup", phone);
phoneGroup.add(phone, new TextField<>("phoneType", phoneTypeModel));
add(phoneGroup);
```

```html
<wicket:container wicket:id="phoneGroup">
  <label>Phone <input wicket:id="phone"></label>
  <label>Type <input wicket:id="phoneType"></label>
</wicket:container>
```

`EnclosureContainer` renders without its own tag, so it cannot be repainted with Ajax; repaint its parent instead. For why enclosures behave this way, see [How markup becomes components]({{ site.baseurl }}/docs/auto-components.html).
