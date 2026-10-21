---
title: Best practices
type: explanation
topic: start
summary: The habits that keep a Wicket application easy to change and to test, each with the reason it follows from how Wicket works.
since: 10
apis: [Panel, IModel, LoadableDetachableModel, Component, WebSession, IRequestCycleListener, IComponentInstantiationListener]
keywords: [patterns, anti-patterns, guidelines, conventions, code style, encapsulation, onConfigure, isVisible, setVisible, models, serialization, session, factory, wicket id naming, refactoring, Struts, JSF]
order: 20
source: [bestpractices.adoc, bestpractices/bestpractices_1.adoc, bestpractices/bestpractices_2.adoc, bestpractices/bestpractices_3.adoc, bestpractices/bestpractices_4.adoc, bestpractices/bestpractices_5.adoc, bestpractices/bestpractices_6.adoc, bestpractices/bestpractices_7.adoc, bestpractices/bestpractices_8.adoc, bestpractices/bestpractices_9.adoc, bestpractices/bestpractices_10.adoc, bestpractices/bestpractices_11.adoc, bestpractices/bestpractices_12.adoc, bestpractices/bestpractices_13.adoc, bestpractices/bestpractices_14.adoc, bestpractices/bestpractices_15.adoc, bestpractices/bestpractices_16.adoc, bestpractices/bestpractices_17.adoc]
---

Developers who come to Wicket from request-based frameworks such as Struts or Spring MVC tend to write procedural code: build what this request needs, then throw it away. Wicket pages are long-lived objects in a tree, and code that treats them that way stays simpler. Each practice below follows from that.

## Give a component its own markup

A component should hide how it is built. Whoever uses it should only need its constructor and its public methods, not the ids of its children.

That rules out subclassing `Form` or `WebMarkupContainer` and adding children to it: those classes have no markup of their own, so the page that uses the subclass has to supply tags for children it never added.

```java
// Every page that uses this form must know it has "username" and "email" fields
public class RegistrationForm extends Form<Registration> {
    public RegistrationForm(String id, IModel<Registration> model) {
        super(id, model);
        add(new TextField<>("username", LambdaModel.of(model, Registration::getUsername, Registration::setUsername)));
        add(new TextField<>("email", LambdaModel.of(model, Registration::getEmail, Registration::setEmail)));
    }
}
```

Make it a `Panel` instead, with the form and the fields in the panel's own markup. The page then contains one tag for the panel and nothing about its inside, and you can change the fields without touching any page. Adding behaviors and validators through a subclass is fine: they have no tags.

## Keep data in fields

A page is not recreated for every request. When a form fails validation, when the user clicks a link on the page, or when they come back with the back button, Wicket uses the same page object. Data the page needs, which is usually a model passed to its constructor, belongs in a field, where every method of the page can reach it.

Pages are stored by serializing them, so everything in their fields must be serializable and should be small. A service or a database connection does not belong in a field. Large or persistent data belongs in a `LoadableDetachableModel`, which keeps only what it needs to load the data again.

## Name ids after what they mean

Name a `wicket:id` after its business meaning, `birthDate`, not after the technology, `birthDateTextField`. The Java code and the markup already show what kind of component it is. When you replace the text field with a date picker, a technical id has to change in both files, and a business id does not. A `CompoundPropertyModel` uses the id as the name of a property, so `setBirthDateTextField()` would be the result.

## Build the component tree once

Build the tree in the constructor or in `onInitialize()`, and then leave it alone. The tree is the skeleton; the models fill it with data. If you find yourself calling `replace()` or `remove()`, or adding different components depending on a condition, the data probably is not in a model.

```java
// Decided once, at construction: wrong after the user logs in
if (MySession.get().isSignedIn()) {
    add(new EmptyPanel("login"));
} else {
    add(new LoginPanel("login"));
}
```

Always add the `LoginPanel`, and let it decide when it is visible, as described in the next section.

## Decide visibility in onConfigure

A component should decide for itself whether it is visible, based on current state. Set it in `onConfigure()`, which Wicket calls before every render:

```java
public class LoginPanel extends Panel {
    @Override
    protected void onConfigure() {
        super.onConfigure();
        setVisible(!MySession.get().isSignedIn());
    }
}
```

Calling `setVisible()` from outside, once, when you create the component, records a decision that goes stale: the page lives on, and something has to remember to call `setVisible()` again at the right moments.

![Calling setVisible from outside needs a call at every change of state; onConfigure needs none]({{ site.baseurl }}/img/guide/login_calls_hollywood.png)

With `onConfigure()` the logic is in one place, inside the component it concerns, and it reads the current state on every render. The same goes for `setEnabled()`. When visibility depends on data, let the component read its model in `onConfigure()`; a button that shows something then only changes the model.

Do not override `isVisible()` for this. Wicket calls it many times per request, also in phases where the answer must not change, and an override that depends on changing state leads to errors that are hard to trace. Form components inside an invisible or disabled container are not processed when the form is submitted.

## Pass models, not objects

Give components and your own constructors an `IModel<Registration>`, not a `Registration`. A component that holds the object itself cannot get a fresh one: after the next request the page still shows the entity it loaded the first time, even if the database changed. With a model, where the object comes from is the model's business. The same component works with a `Model`, a lambda or a `LoadableDetachableModel` that loads the entity from the database each request.

## Unwrap models only in event methods

Do not call `getObject()` in a constructor. The constructor runs once, but the page lives for many requests, so a value you read there is a copy that goes stale and takes up space in the stored page. Read models where you need their value now: in `onSubmit()`, `onClick()`, `onUpdate()`, in `onConfigure()`, or in a lambda model that Wicket evaluates during rendering.

## Pass the model to the superclass

When your component takes a model, pass it to `super(id, model)`. Wicket detaches the models a component knows about at the end of every request; a model you only keep in a field of your own is not detached unless you do it in `onDetach()`. A `LoadableDetachableModel` that is not detached keeps its loaded object, and the object ends up in the stored page.

## Let validators only validate

A validator answers one question: is this input acceptable? It should not change the input, the model or anything else. Nobody reading the form expects a validator to correct a bank name or save data. That work belongs in `onSubmit()` of the form or of a button, which runs after all validators passed.

## Use callbacks instead of passing pages

Do not pass a page or component to a constructor so the new page can return to it later:

```java
// The caller must create the page to return to before it is needed
public SettingsPage(IModel<Settings> settings, WebPage backTo)
```

Give the page a method that runs when its work is done, and let the caller override it:

```java
public class SettingsPage extends WebPage {
    public SettingsPage(IModel<Settings> settings) {
        Form<Settings> form = new Form<>("form", settings) {
            @Override
            protected void onSubmit() {
                onSaved();
            }
        };
        add(form);
    }

    protected void onSaved() {
    }
}

// In the calling page
setResponsePage(new SettingsPage(settingsModel) {
    @Override
    protected void onSaved() {
        setResponsePage(CallingPage.this);
    }
});
```

The caller decides what happens next at the moment it matters, can do more than navigate, such as show a message, and no page is created that may never be shown.

## Use the session only for global data

Wicket's session is your own subclass of `WebSession`, with typed fields. Put data there that nearly every page needs during the whole visit: the signed-in user and what that user may do. Data of one form or one flow of pages does not belong there. Pass it from page to page in the constructor, as a model. It then lives exactly as long as the pages that use it, and disappears when the user leaves the flow, without code to clean it up.

## Subclass instead of using factories

A factory method that builds and configures a component hides its class. Callers cannot override `onConfigure()` or other methods, and cannot subclass it. Write a class instead, such as a `CmsLabel` that extends `Label`, and create it with `new`.

If the factory exists to give components their services, use injection: an `IComponentInstantiationListener` runs for every component that is constructed. `SpringComponentInjector` from `wicket-spring` is one, and fills fields annotated with `@SpringBean`. See [Inject Spring beans]({{ site.baseurl }}/docs/spring.html).

## Test every page and component

Every page and panel should have at least a test that renders it with `WicketTester`. It catches a `wicket:id` without a component and a component without a tag, and it runs in a fraction of the time of starting a server. Tests of forms and Ajax behaviors with `FormTester` and `executeAjaxEvent` catch errors in your logic before a user does. The tutorial [Test a page with WicketTester]({{ site.baseurl }}/docs/first-test.html) shows how.

## Stay inside Wicket instead of using servlet filters

Code that needs to run around each request, such as opening and closing a unit of work, fits in an `IRequestCycleListener`, registered with `getRequestCycleListeners().add()`. It has hooks such as `onBeginRequest`, `onEndRequest` and `onException`, and runs with Wicket's request cycle, session and page available. Data that lives as long as the visit belongs in your `WebSession`, not in attributes of the `HttpSession`. Access the servlet API directly only when you must, for example to read a cookie set by another application, and keep that code in one place.

## Keep classes and methods small

A page whose constructor builds everything in nested anonymous classes is hard to read and harder to change. Extract methods named after what they create, such as `createAddressFields()`, so the constructor reads as a summary of the page. When a part grows, make it a panel of its own. Smaller components are easier to reuse and to test.
