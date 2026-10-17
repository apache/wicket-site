---
title: Use checkboxes and radio buttons
type: howto
topic: forms
summary: Bind a checkbox to a boolean, let the user tick several options or pick one with radio buttons, and add a "select all" checkbox.
since: 10
apis: [CheckBox, CheckBoxMultipleChoice, RadioChoice, RadioGroup, Radio, CheckGroup, Check, CheckBoxSelector, CheckboxMultipleChoiceSelector, CheckGroupSelector]
keywords: [checkbox, check box, radio button, option group, select all, toggle, boolean field, tick]
order: 50
source: [forms2/forms2_11.adoc]
---

You need this when a form asks yes or no, offers a handful of options to tick, or asks the user to pick exactly one of a few options that should all be visible.

## Bind a checkbox to a boolean

A `CheckBox` writes `true` or `false` to its model. Bind it to `<input type="checkbox">`.

*RegistrationPage.java*

```java
form.add(new CheckBox("newsletter",
    LambdaModel.of(registration, Registration::isNewsletter, Registration::setNewsletter)));
```

*RegistrationPage.html*

```html
<label><input type="checkbox" wicket:id="newsletter"> Send me the newsletter</label>
```

The box is ticked when the model is `true` at render time.

## Let the user tick several options

A `CheckBoxMultipleChoice` renders a checkbox with a label for each choice. Its model holds the collection of ticked choices. Bind it to a container tag such as `<div>`; Wicket replaces the content.

```java
List<String> toppings = List.of("Cheese", "Mushrooms", "Olives", "Peppers");
form.add(new CheckBoxMultipleChoice<>("toppings",
    LambdaModel.of(pizza, Pizza::getToppings, Pizza::setToppings), toppings));
```

```html
<div wicket:id="toppings"></div>
```

For objects, pass an `IChoiceRenderer` as fourth argument, as for a [`DropDownChoice`]({{ site.baseurl }}/docs/dropdown-choice.html#show-objects-with-a-choice-renderer).

## Let the user pick one option

A `RadioChoice` renders a radio button with a label for each choice, and puts the chosen one in its model. It takes the same arguments as a `DropDownChoice`:

```java
List<Delivery> options = List.of(Delivery.values());
form.add(new RadioChoice<>("delivery",
    LambdaModel.of(order, Order::getDelivery, Order::setDelivery),
    options, new EnumChoiceRenderer<>(this)));
```

```html
<div wicket:id="delivery"></div>
```

Call `setRequired(true)` if the user must pick one.

## Lay out the options

Both components write each option as an `<input>` followed by its `<label>`. Change that with:

- `setLabelPosition(LabelPosition)`: `BEFORE` or `AFTER` the input, or `WRAP_BEFORE` and `WRAP_AFTER` to put the input inside the label.
- `setPrefix(String)` and `setSuffix(String)`: markup before and after each option, such as `"<li>"` and `"</li>"`.

The prefix and suffix are written as they are, without escaping. Do not build them from user input.

## Place each radio button or checkbox yourself

When the options must sit in your own markup, for example one per table row, use a `RadioGroup` with a `Radio` per option, or a `CheckGroup` with a `Check` per option. The group holds the model; each `Radio` or `Check` holds the value it stands for.

```java
RadioGroup<Plan> plan = new RadioGroup<>("plan",
    LambdaModel.of(subscription, Subscription::getPlan, Subscription::setPlan));
form.add(plan);
plan.add(new ListView<>("plans", plans) {
    @Override
    protected void populateItem(ListItem<Plan> item) {
        item.add(new Radio<>("radio", item.getModel()));
        item.add(new Label("name", item.getModel().map(Plan::getName)));
        item.add(new Label("price", item.getModel().map(Plan::getPrice)));
    }
});
```

```html
<table wicket:id="plan">
    <tr wicket:id="plans">
        <td><input type="radio" wicket:id="radio"></td>
        <td wicket:id="name"></td>
        <td wicket:id="price"></td>
    </tr>
</table>
```

The `Radio` and `Check` components must be inside their group in the component tree.

## Add a "select all" checkbox

Add a selector bound to an extra `<input type="checkbox">`. It ticks or clears all boxes of a group in the browser:

| Selector | Works with |
|---|---|
| `CheckboxMultipleChoiceSelector` | a `CheckBoxMultipleChoice` |
| `CheckGroupSelector` | a `CheckGroup` |
| `CheckBoxSelector` | a list of single `CheckBox` components |

```java
CheckBoxMultipleChoice<String> toppingsChoice = new CheckBoxMultipleChoice<>("toppings", ...);
form.add(toppingsChoice);
form.add(new CheckboxMultipleChoiceSelector("allToppings", toppingsChoice));
```

```html
<label><input type="checkbox" wicket:id="allToppings"> All toppings</label>
<div wicket:id="toppings"></div>
```

The selector also ticks itself when the user has ticked every box.

## React to a click with Ajax

For `RadioChoice`, `CheckBoxMultipleChoice`, `RadioGroup` and `CheckGroup`, use `AjaxFormChoiceComponentUpdatingBehavior`; it updates the model of the whole group:

```java
deliveryChoice.add(AjaxFormChoiceComponentUpdatingBehavior.onUpdateChoice(
    target -> target.add(totalPrice)));
```

For a single `CheckBox`, use `AjaxFormComponentUpdatingBehavior` on the `change` event, or an `AjaxCheckBox`. See [Ajax behaviors]({{ site.baseurl }}/docs/ajax-behaviors.html).
