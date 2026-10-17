---
title: Change a tag's attributes
type: howto
topic: components
summary: Set, append to or remove an attribute of a component's tag from Java, with a fixed value or one that follows a model.
since: 10
apis: [AttributeModifier, AttributeAppender, ClassAttributeModifier, StyleAttributeModifier, Behavior]
keywords: [class attribute, css class, style, add class, remove attribute, dynamic attribute, onComponentTag, ComponentTag, VALUELESS_ATTRIBUTE_ADD, aria, data attribute]
order: 20
source: [keepControl/keepControl_2.adoc]
---

Use this when an attribute of a component's tag depends on Java state: a CSS class for the current status, a `title` from the model, an `aria-expanded` that follows a toggle. Wicket changes attributes through behaviors that you add to the component; the markup keeps its static attributes.

## Replace an attribute value

`AttributeModifier.replace` sets the attribute, overwriting a value from the markup. If the attribute is not in the markup, it is added.

*OrderPanel.html*

```html
<span wicket:id="status" class="badge">Status</span>
```

*OrderPanel.java*

```java
Label status = new Label("status", order.getStatus());
status.add(AttributeModifier.replace("title", "Order status"));
add(status);
```

## Make the value follow a model

Pass a model instead of a value. Wicket reads the model each time it renders the tag, so the attribute stays current.

```java
status.add(AttributeModifier.replace("data-status", () -> order.getStatus().name()));
```

When the model returns `null`, the attribute keeps the value it has in the markup.

## Append or prepend to an attribute

`AttributeModifier.append` adds the value after the existing one, separated by a space. `prepend` puts it in front. Both add the attribute if it is missing.

```java
status.add(AttributeModifier.append("class", () -> order.isLate() ? "badge-late" : null));
```

With the markup above, a late order renders `class="badge badge-late"`. When the model returns `null`, nothing is appended. For another separator, use `new AttributeAppender(attribute, model, separator)`, for example `";"` for a `style` attribute.

## Add or remove CSS classes as a set

`ClassAttributeModifier` gives you the current classes as a set and writes back the set you return. Use it when you need to remove a class from the markup, or add several depending on state. When the set ends up empty, the `class` attribute is removed.

```java
status.add(new ClassAttributeModifier() {
    @Override
    protected Set<String> update(Set<String> classes) {
        classes.remove("badge");
        if (order.isLate()) {
            classes.add("badge-late");
        }
        return classes;
    }
});
```

`StyleAttributeModifier` does the same for the declarations in a `style` attribute, as a map from property to value.

## Remove an attribute

```java
link.add(AttributeModifier.remove("target"));
```

## Add or remove a boolean attribute

Attributes such as `hidden`, `open` or `required` have no value. Pass `AttributeModifier.VALUELESS_ATTRIBUTE_ADD` to write the attribute without a value, or `VALUELESS_ATTRIBUTE_REMOVE` to leave it out:

```java
details.add(AttributeModifier.replace("open",
    () -> expanded ? AttributeModifier.VALUELESS_ATTRIBUTE_ADD
                   : AttributeModifier.VALUELESS_ATTRIBUTE_REMOVE));
```

## Change attributes with a lambda

`Behavior.onAttribute` gets the current value and returns the new one. `Behavior.onTag` gives you the whole `ComponentTag`.

```java
status.add(Behavior.onAttribute("title", current -> current == null ? "Status" : current.toUpperCase()));
status.add(Behavior.onTag((component, tag) -> tag.put("aria-live", "polite")));
```

## Set attributes in your own component

In a component class you write yourself, override `onComponentTag` instead of adding a behavior:

```java
public class StatusLabel extends Label {
    private final IModel<Status> status;

    public StatusLabel(String id, IModel<Status> status) {
        super(id, status);
        this.status = status;
    }

    @Override
    protected void onComponentTag(ComponentTag tag) {
        super.onComponentTag(tag);
        tag.put("data-status", status.getObject().name());
    }
}
```

Wicket escapes attribute values when it writes the tag, so a value with quotes or `<` cannot break out of the attribute. Attribute changes need a tag: on a component with `setRenderBodyOnly(true)` they have no effect. For more on behaviors, see [Add behavior to a component with a Behavior]({{ site.baseurl }}/docs/add-behaviors.html).
