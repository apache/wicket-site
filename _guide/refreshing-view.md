---
title: Control how items are reused with RefreshingView
type: howto
topic: repeaters
summary: Build repeater items from models you supply, and keep an item's components across renders as long as its model stays in the list.
since: 10
apis: [RefreshingView, Item, IItemReuseStrategy, ReuseIfModelsEqualStrategy, DefaultItemReuseStrategy, ModelIteratorAdapter]
keywords: [item reuse, keep state in rows, getItemModels, equals, hashCode, setItemReuseStrategy, form in repeater, editable rows]
order: 30
source: [repeaters/repeaters_3.adoc]
---

Use a `RefreshingView` when you want to decide which model each item gets, and whether an item survives a re-render. Unlike a [ListView]({{ site.baseurl }}/docs/list-items.html), it does not tie an item to an index: you hand it a model per element, and with the right strategy it keeps the item for as long as that model is in the list. That keeps the user's input and other state in the right row even when rows are added, removed or reordered.

## Supply a model per item

Implement `getItemModels()` to return an iterator of models, and `populateItem(Item)` to fill each item:

*PersonsPage.java*
```java
add(new RefreshingView<Person>("persons") {
    @Override
    protected Iterator<IModel<Person>> getItemModels() {
        return new ModelIteratorAdapter<>(personService.findAll()) {
            @Override
            protected IModel<Person> model(Person person) {
                return new PersonModel(person);
            }
        };
    }

    @Override
    protected void populateItem(Item<Person> item) {
        item.add(new Label("name", item.getModel().map(Person::getFullName)));
    }
});
```

*PersonsPage.html*
```html
<ul>
    <li wicket:id="persons"><span wicket:id="name"></span></li>
</ul>
```

Wicket calls `getItemModels()` every time the view renders. `ModelIteratorAdapter` turns an iterable of objects into an iterator of models, using the `model` method you implement. `PersonModel` is a [detachable model]({{ site.baseurl }}/docs/detachable-models.html) that keeps the person's id.

## Keep items whose model is still in the list

By default a `RefreshingView` uses `DefaultItemReuseStrategy`: on each render it throws all items away and creates new ones. Switch to `ReuseIfModelsEqualStrategy` to keep an item when a model equal to its model comes back from `getItemModels()`:

```java
RefreshingView<Person> persons = new RefreshingView<>("persons") { ... };
persons.setItemReuseStrategy(ReuseIfModelsEqualStrategy.getInstance());
```

Items whose model is no longer returned are removed. New models get new items, and `populateItem` is called only for those. Kept items stay in the order of the new models.

## Make the models comparable

The strategy compares the models, not the objects in them, so the model class needs `equals` and `hashCode`. Compare on what identifies the object, usually the id, so the comparison does not have to load anything:

*PersonModel.java*
```java
public class PersonModel extends LoadableDetachableModel<Person> {
    private final long id;

    // constructor and load() as usual

    @Override
    public boolean equals(Object other) {
        return other instanceof PersonModel that && this.id == that.id;
    }

    @Override
    public int hashCode() {
        return Long.hashCode(id);
    }
}
```

Without these methods every model is different from every other, and the strategy behaves like the default one.

## Put form fields in the rows

With `ReuseIfModelsEqualStrategy`, form components in the items keep their input and error messages after a failed submit, because the same components render again. This is what `setReuseItems(true)` does for a `ListView`, but tied to the element instead of the index.

`DataView`, `GridView` and `DataTable` are refreshing views too and accept the same strategy, through `setItemReuseStrategy` on the view or on the `DataTable`. The models then come from `IDataProvider.model(T)`, so that is where equal models have to be created.

## Write your own strategy

Implement `IItemReuseStrategy` for other rules. Its one method, `getItems(factory, newModels, existingItems)`, returns the items to render: existing items it keeps, and new ones made with `factory.newItem(index, model)`. The view calls `populateItem` for the items the factory creates.
