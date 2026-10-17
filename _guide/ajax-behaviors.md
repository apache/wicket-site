---
title: Ajax behaviors
type: reference
topic: ajax
summary: The Ajax behaviors and call listeners in wicket-core and wicket-extensions, the callback each one calls and its lambda factory method.
since: 10
apis: [AbstractDefaultAjaxBehavior, AjaxEventBehavior, AjaxFormComponentUpdatingBehavior, OnChangeAjaxBehavior, AjaxFormChoiceComponentUpdatingBehavior, AjaxFormSubmitBehavior, AjaxFormValidatingBehavior, AbstractAjaxTimerBehavior, AjaxSelfUpdatingTimerBehavior, AjaxNewWindowNotifyingBehavior, AjaxClientInfoBehavior, AjaxDownloadBehavior, AjaxFileDropBehavior, AutoCompleteBehavior, AjaxIndicatorAppender, AjaxCallListener, AjaxDisableComponentListener, FilesSelectedBehavior]
keywords: [ajaxify, onchange, onclick, timer, polling, auto refresh, keyup, live validation, download, drag and drop upload]
order: 20
source: [ajax/ajax_3.adoc, ajax/ajax_9.adoc]
---

An Ajax behavior adds Ajax to a component that has none: it listens to a browser event on the component's element and calls a method on the server with an `AjaxRequestTarget`. Every behavior makes its component output a markup id. All Ajax behaviors extend `AbstractDefaultAjaxBehavior`, whose `updateAjaxAttributes(AjaxRequestAttributes)` you override to change how the request is sent; see [Change how an Ajax request is sent]({{ site.baseurl }}/docs/ajax-request-attributes.html).

## Event and form behaviors

All in wicket-core, package `org.apache.wicket.ajax` and its `form` subpackage.

| Class | What it does | Callback you override |
|---|---|---|
| `AjaxEventBehavior` | Calls the server when a browser event, such as `click` or `keyup`, fires on the component. Takes the event name; an `on` prefix is cut off. | `onEvent(AjaxRequestTarget)` |
| `AjaxFormComponentUpdatingBehavior` | On the given event, converts and validates the input of its form component and updates the model, without submitting the form. | `onUpdate(AjaxRequestTarget)`, `onError(AjaxRequestTarget, RuntimeException)` |
| `OnChangeAjaxBehavior` | `AjaxFormComponentUpdatingBehavior` on `input` and `change` for text fields and text areas, on `change` for other components. | `onUpdate(AjaxRequestTarget)` |
| `AjaxFormChoiceComponentUpdatingBehavior` | Updates the model of a group of choices on `change`: `RadioChoice`, `CheckBoxMultipleChoice`, `RadioGroup`, `CheckGroup`. | `onUpdate(AjaxRequestTarget)` |
| `AjaxFormSubmitBehavior` | Submits a form with Ajax when the event fires. Without a form argument it submits the form the component is in. | `onSubmit(AjaxRequestTarget)`, `onError(AjaxRequestTarget)`, `onAfterSubmit(AjaxRequestTarget)` |
| `AjaxFormValidatingBehavior` | Submits the form on the given event and refreshes every feedback panel on the page. Add it to a form or to a component in a form. | `onSubmit`, `onError`, `onAfterSubmit`, all with an `AjaxRequestTarget`, optional |
| `FilesSelectedBehavior` | Reports the files picked in a `FileUploadField`, before they are uploaded. | `onSelected(AjaxRequestTarget, List<FileDescription>)` |
| `AjaxPreventSubmitBehavior` | Stops Enter in a text field from submitting the form. Runs in the browser only. | none |
| `AbstractDefaultAjaxBehavior` | Base class for your own Ajax behavior. `getCallbackScript()` and `getCallbackFunction(CallbackParameter...)` give the JavaScript that calls it. | `respond(AjaxRequestTarget)` |

`AjaxFormComponentUpdatingBehavior` does not work for radio buttons and check boxes in a group; use `AjaxFormChoiceComponentUpdatingBehavior` there. Override its `getUpdateModel()` to return `false` when you want the input validated but the model left alone.

> Since Wicket 11, `AjaxFormComponentUpdatingBehavior` on a `FormComponentPanel` also converts, validates and updates the inner form components of the panel, so the panel's model is up to date when `onUpdate` runs. The inner components' input is then sent along with the request. Override `updateInnerComponents()` and return `false` for the Wicket 10 behavior.
{: .since}

`AjaxFormSubmitBehavior` does not prevent the browser's default action. On an `<input type="submit">` or a `<button>` in the form, call `attributes.setPreventDefault(true)` in `updateAjaxAttributes`, or the form is submitted twice.

When `shouldTriggerJavaScriptSubmitEvent()` returns `true`, on `AjaxFormSubmitBehavior`, `AjaxButton` or `AjaxFallbackButton`, the behavior fires a JavaScript `submit` event on the form before it sends the request, so that the form's submit handlers run. A handler that cancels the event cancels the Ajax request. The default is `false`.

> Since Wicket 11, that `submit` event is a native DOM event fired with `Wicket.Event.triggerSubmit`. Listeners added with `addEventListener` run as well, not only jQuery handlers. Calling `preventDefault()` in a listener on the form, or in one that captures the event on its way to the form, cancels the Ajax request; listeners further up the document see the event cancelled already. The browser never submits the form for this event; the Ajax request does.
{: .since}

## Timers

| Class | What it does | Callback you override |
|---|---|---|
| `AbstractAjaxTimerBehavior` | Calls the server at a fixed interval, given as a `Duration`. `stop(target)` and `restart(target)` pause and resume it. | `onTimer(AjaxRequestTarget)` |
| `AjaxSelfUpdatingTimerBehavior` | Re-renders its own component at a fixed interval. | `onPostProcessTarget(AjaxRequestTarget)`, optional |

```java
Label clock = new Label("clock", () -> LocalTime.now().withNano(0));
clock.add(new AjaxSelfUpdatingTimerBehavior(Duration.ofSeconds(1)));
add(clock);
```

## Browser information

| Class | What it does | Callback you override |
|---|---|---|
| `AjaxClientInfoBehavior` | Collects screen size, time zone and other browser properties shortly after the page loads, with a timer. | `onClientInfo(AjaxRequestTarget, WebClientInfo)` |
| `AjaxOnDomReadyClientInfoBehavior` | The same, sent when the DOM is ready. | `onClientInfo(AjaxRequestTarget, WebClientInfo)` |
| `AjaxNewWindowNotifyingBehavior` | Detects that the page instance was opened in a second window or tab of the same session. | `onNewWindow(AjaxRequestTarget)` |

## Behaviors in wicket-extensions

| Class | What it does | Callback you override |
|---|---|---|
| `AjaxDownloadBehavior` | Starts a download of a resource from an Ajax callback with `initiate(target)`, without leaving the page. | `onBeforeDownload(IPartialPageRequestHandler)`, `onDownloadSuccess`, `onDownloadFailed`, `onDownloadCompleted`, all with an `AjaxRequestTarget` |
| `AjaxFileDropBehavior` | Uploads files dropped onto the component. | `onFileUpload(AjaxRequestTarget, List<FileUpload>)`, `onError(AjaxRequestTarget, FileUploadException)` |
| `AutoCompleteBehavior<T>` | Adds a suggestion list to any text field; `AutoCompleteTextField` uses it. | `getChoices(String input)` |
| `AjaxIndicatorAppender` | Renders a hidden busy indicator image after its component. See [Show that a request is running]({{ site.baseurl }}/docs/activity-indicator.html). | none |

> Since Wicket 11, the package `org.apache.wicket.extensions.ajax.veil` has `PageVeilBehavior` and `LocalVeilBehavior`, which cover the page or one component while an Ajax request runs. See [Block the page while a request runs]({{ site.baseurl }}/docs/ajax-veils.html).
{: .since}

## Call listeners

A call listener runs JavaScript at the stages of one Ajax request. You add it to `attributes.getAjaxCallListeners()`; see [React to Ajax requests in JavaScript]({{ site.baseurl }}/docs/ajax-call-listeners.html).

| Class | Module | What it does |
|---|---|---|
| `AjaxCallListener` | wicket-core | Base class with chainable setters: `onBefore`, `onPrecondition`, `onBeforeSend`, `onAfter`, `onSuccess`, `onFailure`, `onComplete`, `onInit`, `onDone`. |
| `AjaxDisableComponentListener` | wicket-extensions | Sets `disabled` on the component while the request runs. |
| `CancelEventIfAjaxListener` | wicket-core | Cancels the browser's default action when the Ajax call was made. `AjaxFallbackLink` uses it. |

## Lambda factory methods

These static methods create a behavior from a lambda instead of an anonymous subclass. The lambda receives the `AjaxRequestTarget`.

| Class | Factory method |
|---|---|
| `AjaxEventBehavior` | `onEvent(String event, SerializableConsumer<AjaxRequestTarget>)` |
| `AjaxFormComponentUpdatingBehavior` | `onUpdate(String event, SerializableConsumer<AjaxRequestTarget>)` |
| `OnChangeAjaxBehavior` | `onChange(SerializableConsumer<AjaxRequestTarget>)` |
| `AjaxFormChoiceComponentUpdatingBehavior` | `onUpdateChoice(SerializableConsumer<AjaxRequestTarget>)` |
| `AjaxFormSubmitBehavior` | `onSubmit(String event, SerializableConsumer<AjaxRequestTarget>)` |
| `AbstractAjaxTimerBehavior` | `onTimer(Duration, SerializableConsumer<AjaxRequestTarget>)` |
| `AjaxSelfUpdatingTimerBehavior` | `onSelfUpdate(Duration, SerializableConsumer<AjaxRequestTarget>)` |
| `AjaxNewWindowNotifyingBehavior` | `onNewWindow(SerializableConsumer<AjaxRequestTarget>)` |
| `AjaxClientInfoBehavior` | `onClientInfo(SerializableBiConsumer<AjaxRequestTarget, WebClientInfo>)` |
| `AjaxOnDomReadyClientInfoBehavior` | `onClientInfo(SerializableBiConsumer<AjaxRequestTarget, WebClientInfo>)` |
| `FilesSelectedBehavior` | `onSelected(SerializableBiConsumer<AjaxRequestTarget, List<FileDescription>>)` |

```java
nameField.add(OnChangeAjaxBehavior.onChange(target -> target.add(preview)));
```

[Write Ajax handlers as lambdas]({{ site.baseurl }}/docs/ajax-lambdas.html) shows them in use.
