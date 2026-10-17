---
title: Repeaters
type: reference
topic: repeaters
summary: The repeaters of wicket-core and wicket-extensions compared, what each needs and when it re-creates items, plus data providers, navigators and table parts.
since: 10
apis: [AbstractRepeater, RepeatingView, RefreshingView, ListView, PropertyListView, PageableListView, Loop, DataView, GridView, DataGridView, DataTable, DefaultDataTable, AjaxFallbackDefaultDataTable, NestedTree, TableTree, IDataProvider, ISortableDataProvider, IItemReuseStrategy, IPageable, IColumn, PagingNavigator, AjaxPagingNavigator]
keywords: [repeater comparison, list components, table components, which repeater, item reuse, toolbars, columns, tree, grid]
order: 10
source: [repeaters/repeaters_1.adoc, repeaters/repeaters_2.adoc, repeaters/repeaters_3.adoc, repeaters/repeaters_4.adoc, repeaters/repeaters_5.adoc]
---

A repeater renders its markup once for each of its children. It writes no tag of its own: every child renders with the repeater's tag as if it were the child's. All repeaters extend `AbstractRepeater`, which calls `onPopulate()` before each render to create or update the children.

## Repeaters at a glance

| Repeater | Module | Data from | You implement | Item | Item model | Pageable |
|---|---|---|---|---|---|---|
| `RepeatingView` | core | the children you add | nothing | any component, id from `newChildId()` | none of its own | no |
| `RefreshingView<T>` | core | `getItemModels()` | `getItemModels()`, `populateItem(Item<T>)` | `Item<T>` | the model from the iterator | no |
| `ListView<T>` | core | a `List<T>` or `IModel<List<T>>` | `populateItem(ListItem<T>)` | `ListItem<T>` | `ListItemModel`: element *n* of the list | no |
| `PropertyListView<T>` | core | as `ListView` | `populateItem(ListItem<T>)` | `ListItem<T>` | `CompoundPropertyModel` around `ListItemModel` | no |
| `PageableListView<T>` | core | as `ListView`, plus items per page | `populateItem(ListItem<T>)` | `ListItem<T>` | `ListItemModel` | yes |
| `Loop` | core | an `int` or `IModel<Integer>` | `populateItem(LoopItem)` | `LoopItem` | none | no |
| `DataView<T>` | core | `IDataProvider<T>` | `populateItem(Item<T>)` | `Item<T>` | `IDataProvider.model(T)` | yes |
| `GridView<T>` | core | `IDataProvider<T>` | `populateItem(Item<T>)`, `populateEmptyItem(Item<T>)` | `Item<T>` in rows of `setColumns(n)` cells | `IDataProvider.model(T)` | yes |
| `DataGridView<T>` | extensions | `IDataProvider<T>` and a list of `ICellPopulator<T>` | the populators | a row `Item<T>` with a cell per populator | `IDataProvider.model(T)` | yes |
| `DataTable<T, S>` | extensions | `IDataProvider<T>` and a list of `IColumn<T, S>` | the columns | a `<tr>` with a `<td>` per column | `IDataProvider.model(T)` | yes |
| `DefaultDataTable<T, S>` | extensions | `ISortableDataProvider<T, S>` and columns | the columns | as `DataTable`, rows are `OddEvenItem` | `IDataProvider.model(T)` | yes |
| `AjaxFallbackDefaultDataTable<T, S>` | extensions | as `DefaultDataTable` | the columns | as `DefaultDataTable` | `IDataProvider.model(T)` | yes, with Ajax |
| `NestedTree<T>`, `DefaultNestedTree<T>` | extensions | `ITreeProvider<T>` | `newContentComponent` (for `NestedTree`) | nested branches | `ITreeProvider.model(T)` | no |
| `TableTree<T, S>`, `DefaultTableTree<T, S>` | extensions | `ITreeProvider<T>` and columns | the columns, and `newContentComponent` (for `TableTree`) | table rows, one per visible node | `ITreeProvider.model(T)` | through its `DataTable`, `getTable()` |

## When items are re-created

| Repeater | On every render | Keeps existing items when |
|---|---|---|
| `RepeatingView` | does nothing; the children stay until you remove them | always |
| `ListView`, `PropertyListView`, `PageableListView` | removes all items and creates new ones | `setReuseItems(true)`: keeps items by index, creates missing ones, removes those past the end |
| `Loop` | removes all items and creates new ones | never |
| `RefreshingView`, `DataView`, `GridView`, `DataGridView`, `DataTable` | asks the `IItemReuseStrategy` for the items | the strategy keeps them; `ReuseIfModelsEqualStrategy` keeps items whose model equals a new model |

`populateItem` runs only for newly created items. Form components inside a repeater need kept items, or they lose their input and error messages after a failed submit.

## Item reuse strategies

| Strategy | Behavior |
|---|---|
| `DefaultItemReuseStrategy` | the default; creates a new item for every model, every render |
| `ReuseIfModelsEqualStrategy` | keeps an existing item when its model `equals` a model returned for this render; the models must implement `equals` and `hashCode` |
| your own `IItemReuseStrategy` | implements `getItems(factory, newModels, existingItems)` |

Set a strategy with `setItemReuseStrategy` on `RefreshingView` and its subclasses, on `DataTable` and on `TableTree`. `getInstance()` returns the shared instance of either built-in strategy.

## Item classes

| Class | Extends | Used by | Adds |
|---|---|---|---|
| `ListItem<T>` | `WebMarkupContainer` | `ListView` | `getIndex()` |
| `OddEvenListItem<T>` | `ListItem<T>` | your `ListView.newItem` override | `class="odd"` or `class="even"` by default |
| `Item<T>` | `ListItem<T>` | `RefreshingView` and subclasses | `getPrimaryKey()` |
| `OddEvenItem<T>` | `Item<T>` | `DefaultDataTable` rows | `class="odd"` or `class="even"` by default; the class names are resource keys |
| `LoopItem` | `WebMarkupContainer` | `Loop` | `getIndex()` |

Override `newItem` in a repeater to use another item class.

## Data providers

| Type | Module | Description |
|---|---|---|
| `IDataProvider<T>` | core | `iterator(first, count)` returns one page of objects, `size()` the total, `model(T)` a model per object; `detach()` is called at the end of the request |
| `ListDataProvider<T>` | core | serves a `List<T>` held in the provider; `model(T)` returns a `Model` |
| `EmptyDataProvider<T>` | core | always empty; `getInstance()` |
| `ISortableDataProvider<T, S>` | extensions | an `IDataProvider` that is also an `ISortStateLocator<S>` |
| `SortableDataProvider<T, S>` | extensions | base class keeping a single sort property; `setSort(property, order)`, `getSort()` returns a `SortParam<S>` with `getProperty()` and `isAscending()` |
| `ITreeProvider<T>` | extensions | `getRoots()`, `hasChildren(T)`, `getChildren(T)`, `model(T)` |
| `SortableTreeProvider<T, S>` | extensions | an `ITreeProvider` with a sort state |

## Paging

| Type | Description |
|---|---|
| `IPageable` | `getCurrentPage()`, `setCurrentPage(long)`, `getPageCount()` |
| `IPageableItems` | adds `getItemCount()`, `getItemsPerPage()`, `setItemsPerPage(long)` |
| `AbstractPageableView<T>` | base of `DataView` and `GridView`; shows every item until `setItemsPerPage` is called |
| `PagingNavigator` | panel with links to the first, previous, numbered, next and last pages of an `IPageable` |
| `AjaxPagingNavigator` | the same with Ajax links; updates the nearest parent of the pageable with `setOutputMarkupId(true)` |
| `PagingNavigation` | the numbered links alone, as a `Loop` |
| `NavigatorLabel` | shows "Showing 1 to 10 of 42" for an `IPageableItems`; the text is the resource `NavigatorLabel` |

## Tables

`DataTable` is attached to a `<table>` tag and generates its caption, `<colgroup>`, `<thead>`, `<tbody>` and `<tfoot>`.

| Column class | Description |
|---|---|
| `IColumn<T, S>` | `getHeader(id)`, `getSortProperty()`, `populateItem(cellItem, componentId, rowModel)` |
| `AbstractColumn<T, S>` | base class with a display model for the header and an optional sort property |
| `LambdaColumn<T, S>` | shows the result of a function on the row object |
| `PropertyColumn<T, S>` | shows a property of the row object by property expression |
| `HeaderlessColumn<T, S>` | a column without header text |
| `IStyledColumn<T, S>` | adds `getCssClass()` for the cells |
| `FilteredPropertyColumn`, `TextFilteredPropertyColumn`, `ChoiceFilteredPropertyColumn` | property columns with a filter field for `FilterToolbar` |
| `AbstractExportableColumn` | a column that `ExportToolbar` can export |
| `TreeColumn` | the column of a `TableTree` that shows the node with its junction |

Columns that return a sort property get a sortable header in `HeadersToolbar`.

| Toolbar | Added by | Description |
|---|---|---|
| `HeadersToolbar` | `DefaultDataTable`, top | column headers; sortable headers use `OrderByBorder` |
| `AjaxFallbackHeadersToolbar` | `AjaxFallbackDefaultDataTable`, top | the same, sorting with Ajax |
| `NavigationToolbar` | `DefaultDataTable`, top | a `PagingNavigator` and a `NavigatorLabel`; hidden when there is one page |
| `AjaxNavigationToolbar` | `AjaxFallbackDefaultDataTable`, top | the same with an `AjaxPagingNavigator` |
| `NoRecordsToolbar` | `DefaultDataTable`, bottom | a row with a message when there are no rows |
| `FilterToolbar` | you | a row of filter fields, inside a `FilterForm` |
| `ExportToolbar` | you | links to download the data, for example as CSV with `CSVDataExporter` |

Add toolbars with `addTopToolbar(toolbar)` and `addBottomToolbar(toolbar)`.

## Sort links

| Component | Description |
|---|---|
| `OrderByLink` | a link that sets the sort property of an `ISortStateLocator` |
| `OrderByBorder` | a border around a header that adds an `OrderByLink` and CSS classes for the sort state |
| `AjaxOrderByLink`, `AjaxFallbackOrderByBorder` | the same with Ajax |

Use these to make the headers of a `DataView` sortable when you write the table markup yourself.
