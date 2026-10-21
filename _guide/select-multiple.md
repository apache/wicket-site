---
title: Select several values
type: howto
topic: forms
summary: Let the user select several values from a list with ListMultipleChoice, or move them between two lists with Palette.
since: 10
apis: [ListMultipleChoice, ListChoice, Palette, Select, SelectOptions]
keywords: [multi-select, multiple selection, select multiple, list box, transfer list, dual list, shuttle, palette]
order: 60
source: [forms2/forms2_12.adoc]
---

You need this when the user picks any number of values from a list that is too long for checkboxes. For a short list, [checkboxes]({{ site.baseurl }}/docs/checkboxes-radios.html#let-the-user-tick-several-options) are easier to use.

## Select several values from a list

A `ListMultipleChoice` renders a `<select multiple>`. The user holds Ctrl (or Command on a Mac) to select more than one option. Its model holds the collection of selected choices.

*TeamPage.java*

```java
IModel<List<Person>> people = LoadableDetachableModel.of(personService::findAll);

ListMultipleChoice<Person> members = new ListMultipleChoice<>("members",
    LambdaModel.of(team, Team::getMembers, Team::setMembers),
    people,
    new LambdaChoiceRenderer<>(Person::getFullName, Person::getId));
members.setMaxRows(8);
form.add(members);
```

*TeamPage.html*

```html
<select wicket:id="members"></select>
```

Wicket adds the `multiple` attribute, and a `size` attribute from `setMaxRows()` unless the markup has one. Give the renderer an id, so that the selection survives a change in the list.

A `ListChoice` looks the same but lets the user pick only one value. It works like a [`DropDownChoice`]({{ site.baseurl }}/docs/dropdown-choice.html) that shows several rows.

## Move values between two lists

A `Palette` from wicket-extensions shows the available choices on the left and the selected ones on the right, with buttons to move them across. Users find it easier than Ctrl-clicking, and the selection stays visible.

```java
Palette<Person> palette = new Palette<>("members",
    LambdaModel.of(team, Team::getMembers, Team::setMembers),
    people,
    new LambdaChoiceRenderer<>(Person::getFullName, Person::getId),
    10,      // visible rows
    true);   // show buttons to change the order
palette.add(new DefaultTheme());
form.add(palette);
```

```html
<div wicket:id="members"></div>
```

The choice renderer of a `Palette` must return a real id, not the position in the list. With ordering turned on, the user can move selected values up and down, and the model gets them in that order. A constructor with one more `boolean` adds buttons to move all choices at once.

`DefaultTheme` adds a stylesheet that places the two lists side by side. Without it, you style the CSS classes of the palette yourself: `palette-choices`, `palette-buttons`, `palette-selected` and `palette-header`.

Change the headers with the keys `palette.available` and `palette.selected` in your properties file:

```properties
palette.available=Everyone
palette.selected=In this team
```

## Write the options yourself

When you need control over each `<option>`, for example to add `<optgroup>` elements to a multiple select, use `Select` with `SelectOptions` from wicket-extensions. For several values, the model object of the `Select` must be a collection; Wicket clears it and adds the selected values. Each option is a component, so this uses more memory than a `ListMultipleChoice`.

```html
<select wicket:id="members" multiple>
    <optgroup label="Developers">
        <wicket:container wicket:id="developers">
            <option wicket:id="option">name</option>
        </wicket:container>
    </optgroup>
</select>
```

```java
Select<List<Person>> select = new Select<>("members",
    LambdaModel.of(team, Team::getMembers, Team::setMembers));
form.add(select);
select.add(new SelectOptions<>("developers", developers,
    new IOptionRenderer<Person>() {
        @Override
        public String getDisplayValue(Person person) {
            return person.getFullName();
        }

        @Override
        public IModel<Person> getModel(Person person) {
            return Model.of(person);
        }
    }));
```
