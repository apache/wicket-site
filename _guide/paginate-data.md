---
title: Page through data
type: howto
topic: repeaters
summary: Load one page of rows at a time with an IDataProvider, show them in a DataView or DataTable, and let users move between pages.
since: 10
apis: [IDataProvider, DataView, PagingNavigator, AjaxPagingNavigator, ListDataProvider, SortableDataProvider, DefaultDataTable, AjaxFallbackDefaultDataTable, LambdaColumn]
keywords: [pagination, paging, pager, page size, items per page, offset, limit, large result set, sortable table, sort column]
order: 40
source: [repeaters/repeaters_4.adoc]
---

Use a data provider and a pageable repeater when a list is too long to show at once, such as the result of a database query. The repeater asks the provider for the rows of the current page only, and a navigator lets the user move between pages.

## Write a data provider

An `IDataProvider` answers three questions: how many rows there are, which rows are on a page, and which model wraps a row:

*PersonDataProvider.java*
```java
public class PersonDataProvider implements IDataProvider<Person> {
    @SpringBean
    private PersonService personService;

    public PersonDataProvider() {
        Injector.get().inject(this);
    }

    @Override
    public Iterator<? extends Person> iterator(long first, long count) {
        return personService.find(first, count).iterator();
    }

    @Override
    public long size() {
        return personService.count();
    }

    @Override
    public IModel<Person> model(Person person) {
        return new PersonModel(person);
    }
}
```

`iterator(first, count)` maps directly to an offset and a limit in a query. `model` should return a [detachable model]({{ site.baseurl }}/docs/detachable-models.html) that keeps only the id, so the rows are not stored with the page. The provider is stored with the page itself, so it reaches the service through an injected field ([Inject Spring beans]({{ site.baseurl }}/docs/spring.html)).

For a list that is already in memory, `ListDataProvider` does all three: `new ListDataProvider<>(list)`.

## Show the rows with a DataView

*PersonsPage.html*
```html
<table>
    <tr wicket:id="rows">
        <td wicket:id="name"></td>
        <td wicket:id="email"></td>
    </tr>
</table>
<div wicket:id="navigator"></div>
```

*PersonsPage.java*
```java
DataView<Person> rows = new DataView<>("rows", new PersonDataProvider()) {
    @Override
    protected void populateItem(Item<Person> item) {
        item.add(new Label("name", item.getModel().map(Person::getFullName)));
        item.add(new Label("email", item.getModel().map(Person::getEmail)));
    }
};
rows.setItemsPerPage(20);
add(rows);
```

`setItemsPerPage` turns on paging. Without it the view shows every row the provider has.

## Add a navigator

`PagingNavigator` renders links to the first, previous, numbered, next and last pages of any pageable component:

```java
add(new PagingNavigator("navigator", rows));
```

![The links of a PagingNavigator]({{ site.baseurl }}/img/guide/paging-navigator.png)

Each click is a normal request that renders the whole page again. To replace only the table, use `AjaxPagingNavigator` and wrap the view in a container that writes its markup id. The navigator updates the nearest parent of the view that has `setOutputMarkupId(true)`:

```java
WebMarkupContainer table = new WebMarkupContainer("table");
table.setOutputMarkupId(true);
table.add(rows);
add(table);
add(new AjaxPagingNavigator("navigator", rows));
```

```html
<table wicket:id="table">
    <tr wicket:id="rows">...</tr>
</table>
<div wicket:id="navigator"></div>
```

Both navigators are [stateful]({{ site.baseurl }}/docs/stateful-stateless.html): they keep the current page in the view.

## Let DataTable build the table

`DataTable` in `wicket-extensions` generates the whole `<table>` from a list of columns. `DefaultDataTable` adds a header row with sortable headers, a navigation toolbar and a "no records" row. Sorting needs an `ISortableDataProvider`; extend `SortableDataProvider` and read the requested order from `getSort()`:

*PersonSortableProvider.java*
```java
public class PersonSortableProvider extends SortableDataProvider<Person, String> {
    @SpringBean
    private PersonService personService;

    public PersonSortableProvider() {
        Injector.get().inject(this);
        setSort("name", SortOrder.ASCENDING);
    }

    @Override
    public Iterator<? extends Person> iterator(long first, long count) {
        SortParam<String> sort = getSort();
        return personService.find(first, count, sort.getProperty(), sort.isAscending()).iterator();
    }

    @Override
    public long size() {
        return personService.count();
    }

    @Override
    public IModel<Person> model(Person person) {
        return new PersonModel(person);
    }
}
```

*PersonsPage.java*
```java
List<IColumn<Person, String>> columns = List.of(
        new LambdaColumn<Person, String>(Model.of("Name"), "name", Person::getFullName),
        new LambdaColumn<Person, String>(Model.of("Email"), Person::getEmail));

add(new DefaultDataTable<>("table", columns, new PersonSortableProvider(), 20));
```

```html
<table wicket:id="table"></table>
```

A column with a sort property, `"name"` here, gets a clickable header. `AjaxFallbackDefaultDataTable` takes the same arguments and sorts and pages with Ajax. [Repeaters]({{ site.baseurl }}/docs/repeaters.html#tables) lists the toolbars and column types.

`PageableListView` is a `ListView` with a page size, and works with `PagingNavigator` too, but it always holds the complete list.
