---
title: Ajax components
type: reference
topic: ajax
summary: The Ajax components in wicket-core and wicket-extensions, what each does and which callback you override.
since: 10
apis: [AjaxLink, AjaxFallbackLink, AjaxButton, AjaxSubmitLink, AjaxFallbackButton, AjaxCheckBox, IndicatingAjaxLink, IndicatingAjaxButton, AutoCompleteTextField, AjaxEditableLabel, ModalDialog, AjaxLazyLoadPanel, AjaxTabbedPanel, AjaxPagingNavigator, AjaxFallbackDefaultDataTable, NestedTree, TableTree, AjaxListPanel, FileUploadToResourceField, UploadProgressBar]
keywords: [ajax link, ajax button, modal, dialog, popup, autocomplete, typeahead, editable label, inline edit, lazy loading, tabs, tree, paging, sortable table]
order: 10
source: [ajax/ajax_2.adoc]
---

Every component on this page renders an Ajax behavior and calls a method with an `AjaxRequestTarget`, or an `Optional<AjaxRequestTarget>` for the fallback components, which is empty when the request came in without Ajax. Components from wicket-core need no extra dependency; the others are in the `wicket-extensions` module. To add Ajax to a component that has none, use an [Ajax behavior]({{ site.baseurl }}/docs/ajax-behaviors.html).

## Links and buttons

| Class | Module | What it does | Callback you override |
|---|---|---|---|
| `AjaxLink<T>` | wicket-core | Calls the server on click. Works on any tag, not only `<a>`. | `onClick(AjaxRequestTarget)` |
| `AjaxFallbackLink<T>` | wicket-core | A `Link` that uses Ajax when it can and a normal request when JavaScript is off. | `onClick(Optional<AjaxRequestTarget>)` |
| `AjaxButton` | wicket-core | A button that submits its form with Ajax. | `onSubmit(AjaxRequestTarget)`, `onError(AjaxRequestTarget)`, `onAfterSubmit(AjaxRequestTarget)` |
| `AjaxSubmitLink` | wicket-core | A link that submits a form with Ajax. | `onSubmit(AjaxRequestTarget)`, `onError(AjaxRequestTarget)`, `onAfterSubmit(AjaxRequestTarget)` |
| `AjaxFallbackButton` | wicket-core | A button that submits with Ajax, or normally when JavaScript is off. | `onSubmit(Optional<AjaxRequestTarget>)`, `onError(Optional<AjaxRequestTarget>)`, `onAfterSubmit(Optional<AjaxRequestTarget>)` |
| `IndicatingAjaxLink<T>` | wicket-extensions | `AjaxLink` that shows a busy indicator while the request runs. | `onClick(AjaxRequestTarget)` |
| `IndicatingAjaxFallbackLink<T>` | wicket-extensions | `AjaxFallbackLink` with a busy indicator. | `onClick(Optional<AjaxRequestTarget>)` |
| `IndicatingAjaxButton` | wicket-extensions | `AjaxButton` with a busy indicator. | `onSubmit(AjaxRequestTarget)`, `onError(AjaxRequestTarget)` |

`AjaxLink`, `AjaxFallbackLink`, `AjaxButton` and `AjaxSubmitLink` are in `org.apache.wicket.ajax.markup.html` and its `form` subpackage; the indicating variants in `org.apache.wicket.extensions.ajax.markup.html`.

```java
add(new AjaxButton("save") {
    @Override
    protected void onSubmit(AjaxRequestTarget target) {
        repository.save(form.getModelObject());
        target.add(feedback);
    }

    @Override
    protected void onError(AjaxRequestTarget target) {
        target.add(feedback);
    }
});
```

## Form fields

| Class | Module | What it does | Callback you override |
|---|---|---|---|
| `AjaxCheckBox` | wicket-core | A `CheckBox` that updates its model as soon as it is clicked. | `onUpdate(AjaxRequestTarget)` |
| `AutoCompleteTextField<T>` | wicket-extensions | A text field that shows a list of suggestions while the user types. | `getChoices(String input)`, returns an `Iterator<T>` |
| `DefaultCssAutoCompleteTextField<T>` | wicket-extensions | `AutoCompleteTextField` with a default stylesheet for the suggestion list. | `getChoices(String input)` |
| `AjaxEditableLabel<T>` | wicket-extensions | A label that turns into a text field when clicked, and back after Enter or Escape. | `onEdit`, `onSubmit`, `onError`, `onCancel`, all with an `AjaxRequestTarget` |
| `AjaxEditableMultiLineLabel<T>` | wicket-extensions | Editable label that edits with a text area. | as `AjaxEditableLabel` |
| `AjaxEditableChoiceLabel<T>` | wicket-extensions | Editable label that edits with a drop-down choice. | as `AjaxEditableLabel` |
| `FileUploadToResourceField` | wicket-core | Uploads the selected files to a resource, without submitting a form. Start it with `startUpload(IPartialPageRequestHandler)`. | `onUploadSuccess(AjaxRequestTarget, List<UploadInfo>)`, `onUploadFailure`, `onUploadCanceled` |
| `UploadProgressBar` | wicket-extensions | Shows the progress of a multipart form submit. | none |

`AutoCompleteTextField` takes an `AutoCompleteSettings` in its constructor for the throttle delay, the minimum input length and the look of the list. Suggestions are rendered with an `IAutoCompleteRenderer`; the default calls `toString()`.

```java
AutoCompleteSettings settings = new AutoCompleteSettings()
    .setThrottleDelay(400)
    .setMinInputLength(2);

add(new AutoCompleteTextField<String>("city", cityModel, settings) {
    @Override
    protected Iterator<String> getChoices(String input) {
        return cities.findByPrefix(input, 10).iterator();
    }
});
```

## Tables and paging

| Class | Module | What it does | Callback you override |
|---|---|---|---|
| `AjaxPagingNavigator` | wicket-core | A `PagingNavigator` whose links switch pages with Ajax. | `onAjaxEvent(AjaxRequestTarget)`, optional |
| `AjaxPagingNavigation`, `AjaxPagingNavigationLink`, `AjaxPagingNavigationIncrementLink` | wicket-core | The parts `AjaxPagingNavigator` is built from. | none |
| `AjaxFallbackDefaultDataTable<T, S>` | wicket-extensions | `DataTable` with Ajax sorting headers and an Ajax navigation toolbar. | none |
| `AjaxNavigationToolbar` | wicket-extensions | Navigation toolbar for a `DataTable` with Ajax page links. | `onAjaxEvent(AjaxRequestTarget)`, optional |
| `AjaxFallbackHeadersToolbar<S>` | wicket-extensions | Headers toolbar that sorts with Ajax. | none |
| `AjaxFallbackOrderByBorder<S>` | wicket-extensions | Sort border around a column header. | `onAjaxClick(AjaxRequestTarget)` |
| `AjaxOrderByLink<S>` | wicket-extensions | Sort link. | `onClick(AjaxRequestTarget)` |

`AjaxPagingNavigator` adds the nearest parent of the repeater that outputs a markup id to the target, and the whole page when there is none, so give the container around the repeater a markup id. `AjaxFallbackDefaultDataTable` sets its own. See [Page through data]({{ site.baseurl }}/docs/paginate-data.html).

## Panels, dialogs and tabs

| Class | Module | What it does | Callback you override |
|---|---|---|---|
| `ModalDialog` | wicket-extensions | A modal dialog; its content is a component with id `ModalDialog.CONTENT_ID`. Open and close it with `open(AjaxRequestTarget)` and `close(AjaxRequestTarget)`. | none |
| `AjaxLazyLoadPanel<T>` | wicket-extensions | Renders a placeholder first and loads the real content with a follow-up Ajax request. | `getLazyLoadComponent(String id)`, `onContentLoaded(T, Optional<AjaxRequestTarget>)` |
| `AjaxTabbedPanel<T>` | wicket-extensions | `TabbedPanel` that switches tabs with Ajax. | `onAjaxUpdate(Optional<AjaxRequestTarget>)`, optional |
| `AjaxListPanel` | wicket-extensions | A list that adds and removes single items without re-rendering the list: `append(component, target)`, `delete(component, target)`. | none |
| `AjaxWizardButtonBar` | wicket-extensions | Button bar for a `Wizard` that moves between steps with Ajax. Return it from `Wizard#newButtonBar`. | `updateAjaxAttributes(AjaxRequestAttributes)`, optional |

`ModalDialog` brings no styling of its own. Add a `DefaultTheme` behavior, or style its CSS classes yourself. `closeOnEscape()`, `closeOnClick()` and `trapFocus()` switch on the matching behavior.

*HomePage.html*

```html
<a wicket:id="open">Open the dialog</a>
<div wicket:id="dialog"></div>
```

*HomePage.java*

```java
ModalDialog dialog = new ModalDialog("dialog");
dialog.add(new DefaultTheme());
dialog.closeOnEscape();
dialog.setContent(new Label(ModalDialog.CONTENT_ID, "Saved."));
add(dialog);

add(new AjaxLink<Void>("open") {
    @Override
    public void onClick(AjaxRequestTarget target) {
        dialog.open(target);
    }
});
```

## Trees

The tree components are in `org.apache.wicket.extensions.markup.html.repeater.tree`. Expanding and collapsing a node updates the tree with Ajax.

| Class | Module | What it does | Callback you override |
|---|---|---|---|
| `NestedTree<T>` | wicket-extensions | Tree rendered as nested lists. Its nodes come from an `ITreeProvider<T>`. | `newContentComponent(String id, IModel<T> node)` |
| `TableTree<T, S>` | wicket-extensions | Tree rendered as a table with columns. | `newContentComponent(String id, IModel<T> node)` |
| `DefaultNestedTree<T>`, `DefaultTableTree<T, S>` | wicket-extensions | The two trees with a `Folder` as content and a theme applied. | none |
| `Folder<T>` | wicket-extensions | Node content that expands or collapses its node on click. | `onClick(Optional<AjaxRequestTarget>)` |
| `CheckedFolder<T>` | wicket-extensions | `Folder` with a check box. | `onUpdate(AjaxRequestTarget)` |
| `CheckFolder<T>` | wicket-extensions | `Folder` with a `Check`, for trees inside a `CheckGroup`. | none |

`HumanTheme` and `WindowsTheme` are behaviors that give a tree a look. The repeaters these trees build on are described in [Repeaters]({{ site.baseurl }}/docs/repeaters.html).
