---
title: Let the user pick from a list
type: howto
topic: forms
summary: Show a drop-down list with DropDownChoice, render objects and enums as options, and control the empty "Choose One" option.
since: 10
apis: [DropDownChoice, IChoiceRenderer, ChoiceRenderer, LambdaChoiceRenderer, EnumChoiceRenderer, GroupedDropDownChoice]
keywords: [select, drop-down, dropdown, combo box, option, Choose One, choice renderer, enum, setNullValid]
order: 40
source: [modelsforms/modelsforms_5.adoc]
---

You need this when the user picks one value out of a known set: a country, a category, a person. A `DropDownChoice` renders a `<select>` with an option per choice, and puts the chosen object, not a string, into its model.

## Show a list of strings

Pass the component a model for the selection and a list of choices, and bind it to a `<select>` tag.

*OrderPage.java*

```java
List<String> sizes = List.of("Small", "Medium", "Large");
form.add(new DropDownChoice<>("size",
    LambdaModel.of(order, Order::getSize, Order::setSize), sizes));
```

*OrderPage.html*

```html
<select wicket:id="size"></select>
```

Wicket renders the options itself; anything you put between the `<select>` tags is replaced.

## Show objects with a choice renderer

For objects other than strings, tell the component what to show and what to use as option value with an `IChoiceRenderer`. `LambdaChoiceRenderer` takes a function for the text and one for the id:

```java
IModel<List<Country>> countries = LoadableDetachableModel.of(countryService::findAll);

form.add(new DropDownChoice<>("country",
    LambdaModel.of(address, Address::getCountry, Address::setCountry),
    countries,
    new LambdaChoiceRenderer<>(Country::getName, Country::getIsoCode)));
```

`ChoiceRenderer` does the same with property expressions: `new ChoiceRenderer<>("name", "isoCode")`.

Give the renderer an id whenever the list can change between rendering and submitting, such as a list loaded from a database. Without an id, the option value is the position in the list, and a changed list maps the submitted position to a different object. Without an id, the current model object must also be `equals()` to one of the choices for the option to show as selected.

The choices can be a `List` or a model of a list, as above. A `LoadableDetachableModel` loads them once per request and keeps them out of the session.

## Show enum values

Use `EnumChoiceRenderer`. It uses the constant name as option value and looks the text up in your resources under `<EnumName>.<CONSTANT>`:

```java
form.add(new DropDownChoice<>("priority",
    LambdaModel.of(ticket, Ticket::getPriority, Ticket::setPriority),
    List.of(Priority.values()),
    new EnumChoiceRenderer<>(this)));
```

*TicketPage.properties*

```properties
Priority.LOW=Low
Priority.HIGH=High
```

Passing the component (`this`) makes the renderer look in the resources of that component and its parents, such as the page's properties file. [Translate the options of a choice]({{ site.baseurl }}/docs/localize-choices.html) has more on translating options.

## Control the empty option

While the model is `null`, the list starts with an option "Choose One". Once the user has picked a value and the form is saved, that option disappears and the user cannot go back to no value.

To let the user clear the selection, call `setNullValid(true)`. The empty option is then always there, with an empty text.

Neither setting makes a choice mandatory. Call `setRequired(true)` for that.

Change the texts in your properties file. Wicket tries the key prefixed with the component id first:

```properties
country.null=Pick a country
country.nullValid=No country
```

The keys without prefix, `null` and `nullValid`, change the text for every drop-down that uses the file.

## React when the user picks an option

Add an `AjaxFormComponentUpdatingBehavior` on the `change` event to update other parts of the page as soon as the selection changes, for example to fill a second list with the cities of the chosen country:

```java
country.add(AjaxFormComponentUpdatingBehavior.onUpdate("change", target -> target.add(city)));
```

The behavior validates the drop-down and updates its model before your code runs. See [Ajax behaviors]({{ site.baseurl }}/docs/ajax-behaviors.html). Without Ajax, `FormComponentUpdatingBehavior` does the same with a full page request.

## Group the options

`GroupedDropDownChoice` renders `<optgroup>` elements. Sort the choices by group and implement `isNewGroup`, `hasNoGroup` and `getGroupLabel` to tell where each group starts and what it is called.

To let the user pick more than one value, see [Select several values]({{ site.baseurl }}/docs/select-multiple.html). For a few options shown at once, a [`RadioChoice`]({{ site.baseurl }}/docs/checkboxes-radios.html) works the same way as a `DropDownChoice`.
