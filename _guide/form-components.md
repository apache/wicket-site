---
title: Form components
type: reference
topic: forms
summary: Every form, input, choice, upload and submit component in wicket-core and wicket-extensions, with the markup tag it needs and the type of its model.
since: 10
apis: [Form, StatelessForm, FormComponent, TextField, RequiredTextField, PasswordTextField, HiddenField, EmailTextField, UrlTextField, NumberTextField, RangeTextField, TextArea, DateTextField, LocalDateTextField, LocalDateTimeTextField, LocalTimeTextField, LocalDateTimeField, ZonedDateTimeField, TimeField, CheckBox, DropDownChoice, GroupedDropDownChoice, ListChoice, ListMultipleChoice, RadioChoice, CheckBoxMultipleChoice, RadioGroup, Radio, CheckGroup, Check, Palette, Select, SelectOptions, FileUploadField, MultiFileUploadField, FileUploadToResourceField, UploadProgressBar, Button, ImageButton, SubmitLink, AjaxButton, AjaxSubmitLink, AjaxFallbackButton, FormComponentPanel, FormComponentLabel, FeedbackPanel]
keywords: [input, input types, html tag, form fields, widgets, controls, which component]
order: 10
source: [modelsforms/modelsforms_4.adoc, modelsforms/modelsforms_5.adoc, forms2/forms2_7.adoc, forms2/forms2_11.adoc, forms2/forms2_12.adoc]
---

All form components extend `FormComponent` and must be inside a `Form`, except where noted. A component checks its tag when it renders and throws a `MarkupException` if the tag or its `type` attribute does not match. "Any" means any tag that can have a body, such as `<div>` or `<span>`.

Packages: wicket-core components are in `org.apache.wicket.markup.html.form` (uploads in its `upload` subpackage, Ajax buttons in `org.apache.wicket.ajax.markup.html.form`). wicket-extensions components are in `org.apache.wicket.extensions.markup.html.form` and its subpackages, and `UploadProgressBar` in `org.apache.wicket.extensions.ajax.markup.html.form.upload`.

## Forms

| Component | Module | Tag | Description |
|---|---|---|---|
| `Form` | core | `<form>` | Processes its components on submit. A nested `Form` renders as `<div>`. |
| `StatelessForm` | core | `<form>` | A `Form` that keeps its page stateless. |

## Text input

| Component | Module | Tag | Model object |
|---|---|---|---|
| `TextField` | core | `<input>` with `type` `text`, `search` or no type | any type with a converter |
| `RequiredTextField` | core | as `TextField` | as `TextField`; required from the start |
| `PasswordTextField` | core | `<input type="password">` | `String`; required by default, model set to `null` after each request |
| `HiddenField` | core | `<input type="hidden">` | any type with a converter |
| `EmailTextField` | core | `<input type="email">` | `String`; has an `EmailAddressValidator` |
| `UrlTextField` | core | `<input type="url">` | `String`; has a `UrlValidator` |
| `NumberTextField` | core | `<input type="number">` | a `Number`; renders `min`, `max` and `step` from `setMinimum`, `setMaximum`, `setStep` and validates the range |
| `RangeTextField` | core | `<input type="range">` | as `NumberTextField` |
| `TextArea` | core | `<textarea>` | any type with a converter |

## Dates and times

| Component | Module | Tag | Model object |
|---|---|---|---|
| `DateTextField` | extensions | `<input>` with `type` `text`, `date`, `datetime`, `datetime-local`, `month`, `time` or `week` | `java.util.Date`; pattern from the constructor, `MM/dd/yyyy` by default |
| `LocalDateTextField` | extensions | `<input type="text">` | `LocalDate`; pattern or `FormatStyle` from the constructor |
| `LocalDateTimeTextField` | extensions | `<input type="text">` | `LocalDateTime`; pattern or date and time `FormatStyle` |
| `LocalTimeTextField` | extensions | `<input type="text">` | `LocalTime`; pattern or `FormatStyle` |
| `TimeField` | extensions | any | `LocalTime`; a panel with hours, minutes and, when the locale uses a 12-hour clock, an AM/PM choice |
| `LocalDateTimeField` | extensions | any | `LocalDateTime`; a panel with a date field and a `TimeField` |
| `ZonedDateTimeField` | extensions | any | `ZonedDateTime`; as `LocalDateTimeField` |

## Choices

| Component | Module | Tag | Model object |
|---|---|---|---|
| `DropDownChoice` | core | `<select>` | one choice |
| `GroupedDropDownChoice` | core | `<select>` | one choice; abstract, renders `<optgroup>` elements |
| `ListChoice` | core | `<select>` | one choice; renders a `size` from `setMaxRows` |
| `ListMultipleChoice` | core | `<select>` | a `Collection` of choices; adds `multiple` |
| `RadioChoice` | core | any | one choice; renders a radio button and label per choice |
| `CheckBoxMultipleChoice` | core | any | a `Collection` of choices; renders a checkbox and label per choice |
| `Palette` | extensions | any | a `Collection` of choices; two lists with buttons to move choices between them |
| `Select` | extensions | `<select>` | one value, or a `Collection` with `multiple`; options come from `SelectOption` or `SelectOptions` children |

The choice components take their choices as a `List` or an `IModel` of a `List`, and an `IChoiceRenderer` for the option text and id: `ChoiceRenderer`, `LambdaChoiceRenderer` or `EnumChoiceRenderer`.

## Checkboxes and radio buttons

| Component | Module | Tag | Model object |
|---|---|---|---|
| `CheckBox` | core | `<input type="checkbox">` | `Boolean` |
| `RadioGroup` | core | any | the value of the selected `Radio` |
| `Radio` | core | `<input type="radio">` | the value it stands for; must be inside a `RadioGroup` |
| `CheckGroup` | core | any | a `Collection` of the values of the ticked `Check` components |
| `Check` | core | `<input type="checkbox">` | the value it stands for; must be inside a `CheckGroup` |
| `CheckBoxSelector` | core | `<input type="checkbox">` | none; ticks or clears a set of `CheckBox` components |
| `CheckGroupSelector` | core | `<input type="checkbox">` | none; ticks or clears the `Check` components of a `CheckGroup` |
| `CheckboxMultipleChoiceSelector` | core | `<input type="checkbox">` | none; ticks or clears the boxes of a `CheckBoxMultipleChoice` |

`Radio`, `Check` and the selectors are not form components themselves.

## File uploads

| Component | Module | Tag | Model object |
|---|---|---|---|
| `FileUploadField` | core | `<input type="file">`, optionally `multiple` | a `List` of `FileUpload`; switches the form to multipart |
| `MultiFileUploadField` | core | any | a `Collection` of `FileUpload`; lets the user add and remove files before submitting |
| `FileUploadToResourceField` | core | `<input type="file">` | uploads to a mounted resource with Ajax and does not need a form |
| `UploadProgressBar` | extensions | any | none; shows the progress of an upload when `setUploadProgressUpdatesEnabled(true)` is set |

## Submitting

| Component | Module | Tag | Description |
|---|---|---|---|
| `Button` | core | `<button>` or `<input type="submit">` | Submits its form; the model sets the text |
| `ImageButton` | core | `<input type="image">` | A `Button` that shows an image |
| `SubmitLink` | core | any clickable tag, usually `<a>` | Submits with JavaScript; can be outside the form when the form is passed to it |
| `AjaxButton` | core | as `Button` | Submits with Ajax |
| `AjaxSubmitLink` | core | as `SubmitLink` | Submits with Ajax |
| `AjaxFallbackButton` | core | as `Button` | Submits with Ajax, or with a normal request when JavaScript is off |

All of them implement `IFormSubmittingComponent`, with `onSubmit()`, `onAfterSubmit()`, `onError()` and `setDefaultFormProcessing(boolean)`. In `AjaxButton` and `AjaxSubmitLink` you override `onSubmit(AjaxRequestTarget)` and `onError(AjaxRequestTarget)` instead; `AjaxFallbackButton` passes an `Optional<AjaxRequestTarget>`.

## Composite components

| Component | Module | Tag | Description |
|---|---|---|---|
| `FormComponentPanel` | core | any; markup in `<wicket:panel>` | Base class for a form component made of other form components |

## Labels and feedback

| Component or tag | Module | Tag | Description |
|---|---|---|---|
| `wicket:for` attribute | core | `<label>` | Points the label at a form component, adds the classes `required`, `error` and `disabled` |
| `<wicket:label>` | core | - | Writes the label of a form component, or sets it from its body or `key` |
| `FormComponentLabel` | core | `<label>` | A label component for a form component |
| `SimpleFormComponentLabel` | core | `<label>` | A `FormComponentLabel` that writes the component's label as its body |
| `FeedbackPanel` | core | any | Lists feedback messages, optionally filtered |
| `FencedFeedbackPanel` | core | any | Lists the messages from inside one container, without those of nested fences |
| `ComponentFeedbackPanel` | core | any | Lists the messages of one component |
| `FormComponentFeedbackBorder` | core | any | A border that shows a `*` when its child has an error |
| `FormComponentFeedbackIndicator` | core | any | Shows a `*` when a given component has an error |

## Methods on every form component

| Method | Effect |
|---|---|
| `setRequired(boolean)` | An empty input fails with the `Required` message |
| `setLabel(IModel<String>)` | The name used for `${label}` in messages and by `<wicket:label>` |
| `add(IValidator...)` | Adds validators, run in order after conversion |
| `setType(Class)` | The type the input is converted to |
| `getInput()` | The input as submitted in this request |
| `getConvertedInput()` | The converted input, after conversion succeeded |
| `getValue()` | The value the component renders: the raw input after a failed submit, otherwise the model value |
| `isValid()` | Whether the component has no error messages |
| `processInput()` | Runs required check, conversion, validation and model update for this component only |

## HTML attributes rendered from Java

| Component | Attribute | When |
|---|---|---|
{% if site.wicket.version_11 %}| `TextField`, `TextArea` and subclasses | `required` | the component is required |
| `TextField`, `TextArea` and subclasses | `placeholder` | the component has a label |
| `TextField`, `TextArea` and subclasses | `pattern` | the component has a `PatternValidator` |
| `Button` | `formnovalidate` | default form processing is off |
{% else %}| `TextField`, `TextArea` and subclasses | `required` | the component is required and has the `HTML5Attributes` behavior |
| `TextField`, `TextArea` and subclasses | `placeholder` | the component has a label and the `HTML5Attributes` behavior |
| `TextField`, `TextArea` and subclasses | `pattern` | the component has a `PatternValidator` and the `HTML5Attributes` behavior |
| `Button` | `formnovalidate` | default form processing is off and the button has the `HTML5Attributes` behavior |
{% endif %}| any with a `StringValidator` | `maxlength`, `minlength` | on `<input>` and `<textarea>` |
| `NumberTextField`, `RangeTextField` | `min`, `max`, `step` | the values are set |

{% if site.wicket.version_11 %}
> Since Wicket 11, the text components and `Button` render `required`, `placeholder`, `pattern` and `formnovalidate` themselves. In Wicket 10 they only do so when you add the `HTML5Attributes` behavior, for example to every form component with `HTML5Attributes.InstantiationListener`.
{: .since}

> Since Wicket 11, the scripts of `Palette`, `UploadProgressBar` and `FileUploadToResourceField` no longer need jQuery, so they work with the jQuery-free Ajax implementation.
{: .since}
{% else %}
`HTML5Attributes.InstantiationListener` adds the behavior to every form component.
{% endif %}
