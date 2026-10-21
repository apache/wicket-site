---
title: Write Ajax handlers as lambdas
type: howto
topic: ajax
summary: Create Ajax behaviors from lambdas with their static factory methods instead of anonymous subclasses, and do the same for Ajax links and buttons.
since: 10
apis: [AjaxEventBehavior, OnChangeAjaxBehavior, AjaxFormComponentUpdatingBehavior, AjaxFormSubmitBehavior, AbstractAjaxTimerBehavior, IndicatingAjaxButton]
keywords: [lambda, functional, SerializableConsumer, onEvent, onUpdate, onChange, onTimer, factory method, ComponentFactory, anonymous class]
order: 70
source: [ajax/ajax_8.adoc, ajax/ajax_9.adoc]
---

Use this when an anonymous subclass with a single overridden method is more code than the handler itself. The common Ajax behaviors have static factory methods that take a lambda; the lambda receives the `AjaxRequestTarget`.

## Create a behavior from a lambda

```java
Label preview = new Label("preview", nameModel);
preview.setOutputMarkupId(true);
add(preview);

TextField<String> name = new TextField<>("name", nameModel);
name.add(OnChangeAjaxBehavior.onChange(target -> target.add(preview)));
add(name);
```

The factory methods and the method each one implements:

| Factory method | Implements |
|---|---|
| `AjaxEventBehavior.onEvent("click", target -> ...)` | `onEvent` |
| `AjaxFormComponentUpdatingBehavior.onUpdate("change", target -> ...)` | `onUpdate` |
| `OnChangeAjaxBehavior.onChange(target -> ...)` | `onUpdate` |
| `AjaxFormChoiceComponentUpdatingBehavior.onUpdateChoice(target -> ...)` | `onUpdate` |
| `AjaxFormSubmitBehavior.onSubmit("click", target -> ...)` | `onSubmit` |
| `AbstractAjaxTimerBehavior.onTimer(Duration.ofSeconds(5), target -> ...)` | `onTimer` |
| `AjaxSelfUpdatingTimerBehavior.onSelfUpdate(Duration.ofSeconds(5), target -> ...)` | `onPostProcessTarget` |
| `AjaxNewWindowNotifyingBehavior.onNewWindow(target -> ...)` | `onNewWindow` |
| `AjaxClientInfoBehavior.onClientInfo((target, info) -> ...)` | `onClientInfo` |
| `AjaxOnDomReadyClientInfoBehavior.onClientInfo((target, info) -> ...)` | `onClientInfo` |
| `FilesSelectedBehavior.onSelected((target, files) -> ...)` | `onSelected` |

The lambdas are `SerializableConsumer` and `SerializableBiConsumer` instances: they are stored with the page, so everything they capture has to be serializable. Capture components and models, not services; inject services into the page instead.

## Stop a timer from inside its lambda

The lambda does not get the behavior, so keep a reference when you need it:

```java
AbstractAjaxTimerBehavior poll = AbstractAjaxTimerBehavior.onTimer(Duration.ofSeconds(2), target -> {
    target.add(status);
});
status.add(poll);

add(new AjaxLink<Void>("pause") {
    @Override
    public void onClick(AjaxRequestTarget target) {
        poll.stop(target);
    }
});
```

## When you need more than one callback

A factory method implements one callback. An `AjaxFormSubmitBehavior` that also handles validation errors, or a behavior that overrides `updateAjaxAttributes`, still needs a subclass:

```java
quantity.add(new AjaxFormSubmitBehavior("change") {
    @Override
    protected void onSubmit(AjaxRequestTarget target) {
        target.add(result);
    }

    @Override
    protected void onError(AjaxRequestTarget target) {
        target.add(feedback);
    }
});
```

## Ajax links and buttons from lambdas

wicket-core has no factory methods for Ajax components; `AjaxLink`, `AjaxButton` and the others are subclassed. The exception is `IndicatingAjaxButton.onSubmit(id, (button, target) -> ...)` in wicket-extensions.

The WicketStuff module `wicketstuff-lambda-components` has a `ComponentFactory` with methods such as `ajaxLink`, `ajaxButton`, `ajaxCheckBox` and `ajaxSubmitLink`:

```java
add(ComponentFactory.ajaxLink("refresh", (link, target) -> target.add(table)));
add(ComponentFactory.ajaxSubmitLink("save",
    (link, target) -> target.add(result),
    (link, target) -> target.add(feedback)));
```

It is a separate dependency with its own release cycle; see [WicketStuff]({{ site.baseurl }}/docs/wicketstuff.html).
