---
title: Models and component data
type: explanation
topic: models
summary: Why a component reads its data through a model, what happens to that data between requests, and why wrapping an entity in Model goes wrong.
since: 10
apis: [IModel, IDetachable, Model, LoadableDetachableModel]
keywords: [data binding, getObject, setObject, detach, serialization, NotSerializableException, LazyInitializationException, stale data, entity, raw object]
order: 10
source: [modelsforms/modelsforms_1.adoc, modelsforms/modelsforms_9.adoc]
---

A Wicket component does not hold the value it shows. A `Label` does not keep its text, and a `TextField` does not keep the value it edits. Each one holds a model: an object the component asks for the value whenever it needs it, and hands a new value to when the user submits one. The model is all the component knows about its data. Whether that data lives in a field, a database or a resource bundle is the model's business.

## A page outlives the request that built it

A Wicket page lives longer than a request. Its constructor runs once. After that, the same page handles every click, form submit and Ajax call on it, sometimes for an hour. A component that copied its value in the constructor would show that value for the life of the page.

```java
// The text is fixed when the constructor runs
add(new Label("total", order.getTotal()));

// The model is asked again every time the label renders
add(new Label("total", orderModel.map(Order::getTotal)));
```

The second label shows the current total after a form on the same page changed the order. That is the point of the indirection: the component asks late, at the moment it renders or processes input, and the model decides what "the current value" means.

## The IModel interface

A model is any implementation of `IModel<T>`. It has one abstract method, `getObject()`. `setObject(T)` has a default implementation that throws `UnsupportedOperationException`, so a model is read-only unless it overrides it. `detach()` has an empty default. The other methods, such as `map`, `filter` and `orElse`, are defaults that build new models from an existing one.

Because `IModel` has a single abstract method, a lambda is a model:

```java
add(new Label("now", () -> LocalTime.now()));
```

A component has at most one model of its own, its default model (`getDefaultModel()`, `setDefaultModel()`). `GenericPanel` and `GenericWebPage` add typed versions, `getModel()` and `getModelObject()`. One model can serve several components: a form and its fields share the form's object, and a label and a link can show and act on the same person.

Components use the model at fixed moments. A `Label` calls `getObject()` while it renders and converts the result to text. A form component calls `setObject()` when its form is submitted and the input is valid. Between those moments the component does not touch the data. See [How a form is processed]({{ site.baseurl }}/docs/form-processing.html) for the order of those calls in a submit.

## Between requests the page is serialized

At the end of a request, Wicket stores every stateful page that took part in it, so that the next request and the back button can find it again. Storing means serializing: Wicket writes the page and everything reachable from it to the page store. That includes the components, their behaviors, their models and the objects the models hold. [How pages are stored]({{ site.baseurl }}/docs/page-storage.html) describes where they go.

Two things follow from this. The objects your models hold must be serializable, which is why `Model` only accepts `Serializable` values and why a `NotSerializableException` usually names a field in one of your components. And whatever a model holds is copied to the store after every request: a list of ten thousand rows in a `Model` is written to disk each time the user clicks.

## Detaching: drop the data, keep the key

Before the page is stored, Wicket detaches it. It calls `detach()` on every component, and each component detaches its model and its behaviors. A model that can find its data again uses this moment to let go of it.

`LoadableDetachableModel` works this way. It keeps the loaded object in a transient field, clears that field on detach, and calls `load()` again the first time it is asked for the object in a later request. Only what `load()` needs is serialized, usually an id.

Over two requests, a detachable model that shows person 42 goes through these steps:

1. Request 1: the label renders and calls `getObject()`. The model loads person 42 from the database.
2. End of request 1: `detach()` clears the person. The page is stored with the id 42 and nothing else.
3. Request 2: the page is read back. The first `getObject()` loads person 42 again, as the database has it now.

Every model is detachable, since `IModel` extends `IDetachable`, but not every model has something to drop. `Model` keeps its value. A lambda model keeps what the lambda captured. A model that derives from another model, such as one made with `map`, passes the detach on to the model it came from.

## Why `new Model<>(entity)` goes wrong

This code works on the first render:

```java
Person person = personService.findById(id);
add(new PersonPanel("person", Model.of(person)));
```

The trouble starts after the first request:

- The whole entity is serialized with the page, along with everything it references: lazily loaded collections, proxies, sometimes a reference to the persistence session. You get a `NotSerializableException`, or pages that are much larger than they need to be.
- On the next request the panel works with a deserialized copy that belongs to no persistence context. Touching a lazy collection throws `LazyInitializationException`, and saving the copy can overwrite what another user changed in the meantime.
- The copy never changes. When someone else edits the person, this page keeps showing the old values until the user opens a new page.

Passing the entity to a component's constructor and keeping it in a field has the same effect, because the field is serialized in the same way, and the component can no longer get at fresh data. Give the component a model instead, and make that model one that loads the entity by its id. [Load data once per request with detachable models]({{ site.baseurl }}/docs/detachable-models.html) shows how.

`Model` is the right choice for values that belong to the page itself: the search term the user typed, the selected tab, a small value object.

## Static and dynamic models

A model that holds a value, like `Model`, is static: `getObject()` returns what was put in. A model that computes its value each time from something else is dynamic. Lambda models, `LambdaModel`, `PropertyModel` and models made with `map` read their source at every call, and `LoadableDetachableModel` reads it once per request. When a value shown on a page must follow changes to other data, it needs a dynamic model.

The choice comes down to where the data lives:

- A value the page owns: `Model`, or a lambda on a field of the page.
- A property of an object another model holds: [lambda models]({{ site.baseurl }}/docs/lambda-models.html) or [property models]({{ site.baseurl }}/docs/property-models.html).
- Data from a database or service: [a detachable model]({{ site.baseurl }}/docs/detachable-models.html).
- A value that depends on another model's current value: [a chained model]({{ site.baseurl }}/docs/chain-models.html).

[Model classes]({{ site.baseurl }}/docs/model-types.html) lists every model class in `wicket-core`.

## Models a component finds on its own

A component created without a model asks its parents for one. When a parent holds a model that implements `IComponentInheritedModel`, the component gets a model derived from it. `CompoundPropertyModel` is the common case: it gives each child a model for the property named by the child's id. A form with a `CompoundPropertyModel` of a person and a `TextField` with id `email` edits the person's email without any model code on the field. [Bind components to a JavaBean]({{ site.baseurl }}/docs/property-models.html) shows this in a form.
