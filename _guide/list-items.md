---
title: Show a list with ListView
type: howto
topic: repeaters
summary: Render markup for every element of a java.util.List, keep form input in the rows, and avoid the pitfalls of index-based items.
since: 10
apis: [ListView, ListItem, PropertyListView, Loop]
keywords: [for each, iterate, table rows, list of objects, populateItem, setReuseItems, form in list, validation lost, feedback lost, removeAll]
order: 20
source: [repeaters/repeaters_2.adoc]
---

Use a `ListView` to render a fragment of markup for each element of a `java.util.List`, such as a row per person in a table. For large or paged data use a [DataView]({{ site.baseurl }}/docs/paginate-data.html) instead; a `ListView` always works with the whole list.

## Render a row per element

Attach the `ListView` to the tag to repeat. Wicket calls `populateItem` once per element, with a `ListItem` whose model holds that element:

*PersonsPage.html*
```html
<table>
    <tr wicket:id="persons">
        <td wicket:id="name"></td>
        <td wicket:id="email"></td>
    </tr>
</table>
```

*PersonsPage.java*
```java
IModel<List<Person>> persons = LoadableDetachableModel.of(() -> personService.findAll());

add(new ListView<>("persons", persons) {
    @Override
    protected void populateItem(ListItem<Person> item) {
        item.add(new Label("name", item.getModel().map(Person::getFullName)));
        item.add(new Label("email", item.getModel().map(Person::getEmail)));
    }
});
```

Add the components to `item`, not to the list view. The `ListItem` is what renders the `<tr>`, so behaviors and attributes for the row go on the item as well, for example `item.add(AttributeModifier.append("class", "inactive"))`.

The list view also accepts a plain `List`, which it wraps in a model. Pass a model, as above, when the list comes from a database, so the list is [loaded per request]({{ site.baseurl }}/docs/detachable-models.html) and not stored with the page.

## Bind the row components by id

`PropertyListView` gives each item a `CompoundPropertyModel`, so components without a model bind to the property named by their id:

```java
add(new PropertyListView<>("persons", persons) {
    @Override
    protected void populateItem(ListItem<Person> item) {
        item.add(new Label("fullName"));
        item.add(new Label("email"));
    }
});
```

[Bind components to a JavaBean]({{ site.baseurl }}/docs/property-models.html) describes the property expressions.

## Put form fields in the rows

By default a `ListView` throws its items away and creates new ones every time it renders. Inside a form that breaks validation: when a submit fails, the new fields have lost the user's input, and the error messages belonged to the old fields, so they are not shown either. Tell the list view to keep its items:

```java
ListView<Person> rows = new ListView<>("persons", persons) {
    @Override
    protected void populateItem(ListItem<Person> item) {
        item.add(new TextField<>("name", LambdaModel.of(item.getModel(),
                Person::getName, Person::setName)).setRequired(true));
    }
};
rows.setReuseItems(true);
form.add(rows);
```

With `setReuseItems(true)` the list view creates an item only for an index it has no item for yet, and removes items whose index is past the end of the list. To rebuild all items after you change the list, for instance after adding or deleting an element, call `removeAll()` on the list view.

## Mind that items are identified by index

The model of a `ListItem` is a `ListItemModel`: it reads element number *n* from the list view's model, not a particular object. When the list changes between two requests, item *n* refers to a different element than before. A link in row 3 that deletes "its" person deletes whatever is at index 3 when the click arrives.

Two ways to avoid this:

- Override `getListItemModel(listModel, index)` and return a model that keeps the element's id, such as a [detachable model]({{ site.baseurl }}/docs/detachable-models.html) loaded by id.
- Use a `RefreshingView` or `DataView`, which build each item from a model you provide. [Control how items are reused]({{ site.baseurl }}/docs/refreshing-view.html) shows how.

## Move and remove elements

`ListView` has factory methods for links that change the list: `moveUpLink(id, item)`, `moveDownLink(id, item)` and `removeLink(id, item)`. They change the list in the list view's model, so that model must hold a modifiable list that lives with the page, such as a `Model` or `ListModel`.

## Repeat a fixed number of times

To repeat markup *n* times without a list, use `Loop`. Its `populateItem(LoopItem)` gets the iteration number from `item.getIndex()`:

```java
IModel<Integer> stars = productModel.map(Product::getRating);

add(new Loop("stars", stars) {
    @Override
    protected void populateItem(LoopItem item) {
        item.add(new WebMarkupContainer("star"));
    }
});
```

`Loop` rebuilds its items on every render.
