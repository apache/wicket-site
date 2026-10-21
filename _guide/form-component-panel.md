---
title: Combine fields into one form component
type: howto
topic: forms
summary: Build a FormComponentPanel that shows several inputs but converts, validates and stores them as one value.
since: 10
apis: [FormComponentPanel, FormComponent, AjaxFormComponentUpdatingBehavior]
keywords: [compound field, composite input, custom form component, convertInput, setConvertedInput, reusable input]
order: 100
source: [forms2/forms2_9.adoc]
---

You need this when one value in your model takes more than one input to enter, such as an amount with a currency, or a date split into day, month and year. A plain `Panel` can hold those inputs, but it is not a form component: it cannot be required, have validators, or write one combined value to its model. A `FormComponentPanel` is a panel with its own markup that is also a `FormComponent`.

## Build the panel

Take a field for an amount of money in a currency. The model holds one `Money` value; the panel shows a number input and a currency list.

*Money.java*

```java
public record Money(BigDecimal amount, Currency currency) implements Serializable {
}
```

*MoneyField.java*

```java
public class MoneyField extends FormComponentPanel<Money> {
    private final NumberTextField<BigDecimal> amount;
    private final DropDownChoice<Currency> currency;

    public MoneyField(String id, IModel<Money> model) {
        super(id, model);

        amount = new NumberTextField<>("amount", Model.of(), BigDecimal.class);
        amount.setStep(new BigDecimal("0.01"));
        add(amount);

        List<Currency> currencies = List.of(
            Currency.getInstance("EUR"), Currency.getInstance("USD"), Currency.getInstance("GBP"));
        currency = new DropDownChoice<>("currency", Model.of(), currencies,
            new LambdaChoiceRenderer<>(Currency::getCurrencyCode, Currency::getCurrencyCode));
        add(currency);
    }
```

*MoneyField.html*

```html
<wicket:panel>
    <input type="number" wicket:id="amount">
    <select wicket:id="currency"></select>
</wicket:panel>
```

The inner fields get models of their own. The panel copies values between those models and its own model in two methods.

## Combine the input in convertInput

When the form is processed, Wicket converts the inner fields before the panel. In `convertInput()`, read their converted input and set the combined value with `setConvertedInput()`:

```java
    @Override
    public void convertInput() {
        BigDecimal value = amount.getConvertedInput();
        Currency unit = currency.getConvertedInput();
        setConvertedInput(value == null || unit == null ? null : new Money(value, unit));
    }
```

The panel's validators then run on that `Money` value, and if the whole form is valid, Wicket writes it to the panel's model. If the panel is required and `convertInput()` produces `null`, the panel fails with the `Required` message.

## Split the value in onBeforeRender

Before the panel renders, copy the parts of the model value into the inner fields:

```java
    @Override
    protected void onBeforeRender() {
        Money money = getModelObject();
        amount.setModelObject(money == null ? null : money.amount());
        currency.setModelObject(money == null ? null : money.currency());
        super.onBeforeRender();
    }
}
```

When the form has errors, the inner fields show what the user typed rather than their models, so this does not overwrite the user's input.

## Use the panel in a form

Bind the panel to any tag; Wicket renders the panel's markup inside it.

```java
form.add(new MoneyField("price",
    LambdaModel.of(product, Product::getPrice, Product::setPrice)).setRequired(true));
```

```html
<div wicket:id="price"></div>
```

Messages about the inner fields, such as an amount that is not a number, are reported on the inner fields and use their labels. Give them a label with `setLabel()` or a resource keyed by their id.

## Update the panel with Ajax

{% if site.wicket.version_11 %}
Attach an `AjaxFormComponentUpdatingBehavior` to the panel to react when any of its inputs changes:

```java
MoneyField price = new MoneyField("price", priceModel);
price.add(AjaxFormComponentUpdatingBehavior.onUpdate("change", target -> target.add(total)));
```

The `change` event of an inner input bubbles up to the panel's tag. The behavior sends the inputs inside the panel, checks the inner fields and the panel, and updates their models before `onUpdate()` runs.

> Since Wicket 11, `AjaxFormComponentUpdatingBehavior` processes the inner components of a `FormComponentPanel`. In Wicket 10 it only processes the panel itself, so attach the behavior to the inner fields instead and call `processInput()` on the panel in `onUpdate()`. To get the Wicket 10 behavior back in Wicket 11, override `updateInnerComponents()` to return `false`.
{: .since}
{% else %}
An `AjaxFormComponentUpdatingBehavior` on the panel processes only the panel itself, not the inner fields. To react when any of its inputs changes, attach the behavior to the inner fields instead, and call `processInput()` on the panel in `onUpdate()`. `processInput()` runs the required check, conversion, validation and model update of the panel.
{% endif %}
