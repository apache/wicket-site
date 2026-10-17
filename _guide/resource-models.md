---
title: Put model values into translated texts
type: howto
topic: i18n
summary: Show translated texts through ResourceModel and StringResourceModel, fill in property values and MessageFormat parameters, and choose the key from the data.
since: 10
apis: [ResourceModel, StringResourceModel]
keywords: [localized model, translated label, message parameters, MessageFormat, placeholder in translation, plural, property expression, dynamic key, default text]
order: 20
source: [i18n/i18n_5.adoc]
---

Use these models when a label, a link text or an attribute must show a translated text, possibly with values from your data in it. Both look up the text when the component renders, through the same search as `<wicket:message>`, so they follow a change of language. Where the texts live is covered in [Translate component texts]({{ site.baseurl }}/docs/localize-components.html).

## Show a translated text

`ResourceModel` returns the text for a key:

```java
add(new Label("title", new ResourceModel("orders.title")));
```

Give a default for when no bundle has the key:

```java
add(new Label("title", new ResourceModel("orders.title", "Your orders")));
```

The model uses the component it is assigned to for the lookup, so the bundles of that component and its parents are searched.

## Insert properties of an object

`StringResourceModel` takes a model of an object as well. `${...}` expressions in the text are property expressions on that object, as in a `PropertyModel`:

*Order.java*

```java
public class Order implements Serializable {
    private String number;
    private LocalDate orderDate;
    private Status status;
    // getters and setters
}
```

*OrderPanel.properties*

```properties
order.summary=Order ${number} of ${orderDate}
```

*OrderPanel.java*

```java
add(new Label("summary", new StringResourceModel("order.summary", this, orderModel)));
```

Values are converted to text with the converters of the component and its locale, so `${orderDate}` shows as a date in the user's format.

The second argument is the component whose bundles are searched. Pass `null`, or use the constructor without it, to use the component the model is assigned to.

## Choose the key from the data

The key may contain property expressions too. This picks one text per status of the order:

```java
add(new Label("status",
    new StringResourceModel("order.status.${status}", this, orderModel)));
```

```properties
order.status.ACCEPTED=Your payment for order ${number} was accepted.
order.status.SHIPPED=Order ${number} is on its way.
order.status.DELIVERED=Order ${number} was delivered.
```

## Pass parameters with MessageFormat

`setParameters` passes values for `{0}`, `{1}` and so on, formatted by `java.text.MessageFormat` in the locale of the component. A parameter that is a model is replaced by its object each time the text is rendered. Here `delayModel` is an `IModel<Integer>` with the number of days:

```java
add(new Label("delay", new StringResourceModel("order.delay", this)
    .setParameters(orderModel.map(Order::getNumber), delayModel)));
```

```properties
order.delay=Order {0} is delayed by {1,choice,1#one day|1<{1,number,integer} days}.
```

The `choice` format picks a text by number, which handles singular and plural. You do not need to double single quotes in these texts: Wicket escapes quotes outside `{...}` before it calls `MessageFormat`, so `Don't worry` stays as it is.

Property expressions and parameters can be combined. Wicket applies the parameters first, then the `${...}` expressions on the model object.

## Use a default text

`setDefaultValue` takes a string or a model, used when no bundle has the key:

```java
new StringResourceModel("order.note", this, orderModel)
    .setDefaultValue("No note for order ${number}");
```

## Use the text as an attribute

Both models fit everywhere a model of a string fits, such as an attribute:

```java
link.add(AttributeModifier.replace("title", new ResourceModel("order.details.tooltip")));
```
