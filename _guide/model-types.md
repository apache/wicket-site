---
title: Model classes
type: reference
topic: models
summary: Every model class and model interface in wicket-core, the default methods of IModel, the factory methods and the component methods that work with models.
since: 10
apis: [IModel, Model, LambdaModel, PropertyModel, CompoundPropertyModel, LoadableDetachableModel, ChainingModel, AbstractPropertyModel, ComponentModel, ComponentDetachableModel, ComponentPropertyModel, ResourceModel, StringResourceModel, ListModel, SetModel, MapModel, CollectionModel, GenericBaseModel, IDetachable, IComponentInheritedModel, IComponentAssignedModel, IWrapModel, IObjectClassAwareModel, IPropertyReflectionAwareModel, IModelComparator, GenericPanel, GenericWebPage]
keywords: [model list, model overview, which model, map, flatMap, filter, orElse, orElseGet, combineWith, isPresent, Model.of, ofList, ofMap, ofSet]
order: 10
source: [modelsforms/modelsforms_1.adoc, modelsforms/modelsforms_2.adoc, modelsforms/modelsforms_3.adoc, modelsforms/modelsforms_6.adoc, modelsforms/modelsforms_7.adoc]
---

The classes are in `org.apache.wicket.model`, except the collection models, which are in `org.apache.wicket.model.util`. [Models and component data]({{ site.baseurl }}/docs/about-models.html) explains what models are for.

## Model classes

| Class | Holds | Writable | Detach does | Use for |
|---|---|---|---|---|
| `Model<T extends Serializable>` | the object itself | yes | nothing | values that belong to the page: input, selections, small value objects |
| lambda (`IModel` as functional interface) | the lambda and what it captures | no | nothing | computed, read-only values |
| `LambdaModel` | a getter and setter, optionally a target model | yes, with a setter | detaches the target model | one property, type-safe |
| `PropertyModel<T>` | an object or model, and a property expression | yes | detaches the inner model | one property by name |
| `CompoundPropertyModel<T>` | an object or model | yes | detaches the inner model | a form or container whose children bind by id |
| `LoadableDetachableModel<T>` | the loaded object, transient | yes, until the end of the request | drops the object | entities and other data loaded per request |
| `ChainingModel<T>` | an object or model | yes | detaches the inner model | base class for models that wrap a model or an object |
| `AbstractPropertyModel<T>` | an object or model | yes | detaches the inner model | base class for models that resolve a property expression |
| `ComponentPropertyModel<T>` | a property name | no, `setObject` throws | detaches the wrapper | a property of the model of the component it is assigned to |
| `ComponentModel<T>` | nothing | when `setObject(Component, T)` is overridden | nothing | models that compute their object from the component they are assigned to, in `getObject(Component)` |
| `ComponentDetachableModel<T>` | a transient attached flag | when `setObject(Component, T)` is overridden | calls `detach()` when it was attached | as `ComponentModel`, with `attach()` before the first access in a request |
| `ResourceModel` | a resource key and a default | no, `setObject` throws | the wrapper drops the looked-up text | a localized text from the resource bundles |
| `StringResourceModel` | a key, an optional component, model and parameters | until the end of the request | drops the text and detaches its model | a localized text with values from a model filled in |
| `util.ListModel<T>` | a list | yes | nothing | lists that may not be serializable |
| `util.SetModel<T>` | a set | yes | nothing | sets, as above |
| `util.MapModel<K, V>` | a map | yes | nothing | maps, as above |
| `util.CollectionModel<T>` | a collection | yes | nothing | collections, as above |
| `util.GenericBaseModel<T>` | the object, or a serializable copy | yes | nothing | base class of the four collection models |

When the collection passed to a collection model is not `Serializable`, the model keeps a copy in an `ArrayList` (`ListModel`, `CollectionModel`), `HashSet` (`SetModel`) or `HashMap` (`MapModel`) instead. A serializable collection is kept as it is.

## Factory methods

| Method | Returns |
|---|---|
| `Model.of(T object)` | a `Model` holding a serializable object |
| `Model.of()` | an empty `Model` |
| `Model.of(Collection<C>)` | a `CollectionModel` |
| `Model.ofList(List<C>)` | a `ListModel` |
| `Model.ofSet(Set<C>)` | a `SetModel` |
| `Model.ofMap(Map<K, V>)` | a `MapModel` |
| `LambdaModel.of(getter)` | a read-only model calling the getter |
| `LambdaModel.of(getter, setter)` | a model calling the getter and setter |
| `LambdaModel.of(target, getter, setter)` | a model applying a function and bi-consumer to the object of `target`; `null` when the target holds `null` |
| `PropertyModel.of(object, expression)` | a `PropertyModel` |
| `CompoundPropertyModel.of(IModel<Z>)` | a `CompoundPropertyModel` wrapping a model |
| `CompoundPropertyModel.of(Z object)` | a `CompoundPropertyModel` holding a serializable object |
| `LoadableDetachableModel.of(supplier)` | a `LoadableDetachableModel` whose `load()` calls the supplier |
| `IModel.of(IModel<?>)` | the same model, cast to another type parameter; it creates nothing |

## IModel methods

`IModel<T>` extends `IDetachable`. Only `getObject()` is abstract. The models returned by the default methods detach the model they were made from.

| Method | Description |
|---|---|
| `T getObject()` | returns the model object |
| `void setObject(T)` | sets the model object; the default throws `UnsupportedOperationException` |
| `void detach()` | releases data at the end of the request; the default does nothing |
| `filter(predicate)` | a read-only model with the object when the predicate holds, `null` otherwise |
| `map(function)` | a read-only model with the function applied to the object; `null` when the object is `null` |
| `flatMap(function)` | a read-write model that delegates to the model the function returns for the object; `null` when the object is `null` |
| `combineWith(other, function)` | a read-only model with the function applied to both objects; `null` when either is `null` |
| `orElse(T)` | a read-only model with the object, or the given value when it is `null` |
| `orElseGet(supplier)` | a read-only model with the object, or the supplier's value when it is `null` |
| `isPresent()` | a `Boolean` model that is `true` when the object is not `null` |
| `as(Class<R>)` | a read-only model with the object cast to `R` when it is an instance, `null` otherwise |

## LoadableDetachableModel methods

| Method | Description |
|---|---|
| `LoadableDetachableModel()` | creates the model detached; the first `getObject()` calls `load()` |
| `LoadableDetachableModel(T object)` | creates the model attached with `object`; `load()` is first called in the next request |
| `protected abstract T load()` | loads the object |
| `T getObject()` | returns the object, loading it first when the model is detached; final |
| `void setObject(T)` | holds the object until the next detach |
| `boolean isAttached()` | whether the model holds a loaded object |
| `void detach()` | calls `onDetach()` when attached, then drops the object |
| `protected void onAttach()` | called after `load()` |
| `protected void onDetach()` | called on detach when the model was attached |
| `protected void onDetach(T object)` | called by `onDetach()` with the object that was held; Wicket 11 |
| `protected void onDetachAlways()` | called on every `detach()`, attached or not, after `onDetach()`; Wicket 11 |

> In Wicket 11, `detach()` is final and calls `onDetachAlways()` at the end. In Wicket 10, `detach()` can be overridden, and `onDetach(T)` and `onDetachAlways()` do not exist.
{: .since}

## StringResourceModel methods

| Method | Description |
|---|---|
| `StringResourceModel(key)` | looks up `key` relative to the component it is assigned to |
| `StringResourceModel(key, component)` | looks up `key` relative to `component` |
| `StringResourceModel(key, model)` | substitutes `${property}` expressions in the text with properties of the model's object |
| `StringResourceModel(key, component, model)` | both |
| `setModel(IModel<?>)` | sets the model for `${property}` substitution |
| `setParameters(Object...)` | sets the values for `{0}`, `{1}` placeholders, formatted with `MessageFormat`; a parameter may be a model |
| `setDefaultValue(String)`, `setDefaultValue(IModel<String>)` | the text when the key is not found |
| `getString()` | the localized text |

[Put model values into translated texts]({{ site.baseurl }}/docs/resource-models.html) shows `ResourceModel` and `StringResourceModel` in use.

## Model interfaces

| Interface | Implemented by | Meaning |
|---|---|---|
| `IDetachable` | every model | has `detach()`, called at the end of the request |
| `IModel<T>` | every model | gets and sets an object |
| `IComponentInheritedModel<T>` | `CompoundPropertyModel` | children without a model get one from it through `wrapOnInheritance(Component)` |
| `IComponentAssignedModel<T>` | `ComponentModel`, `ComponentDetachableModel`, `ComponentPropertyModel`, `ResourceModel`, `StringResourceModel` | replaced by a wrapper that knows the component, through `wrapOnAssignment(Component)`, when assigned to a component |
| `IWrapModel<T>` | the wrappers made by the two interfaces above | wraps another model, returned by `getWrappedModel()` |
| `IObjectClassAwareModel<T>` | `Model`, `AbstractPropertyModel` and `PropertyModel`, `GenericBaseModel` | `getObjectClass()` returns the class of the object, which form components use to pick a converter |
| `IPropertyReflectionAwareModel<T>` | `AbstractPropertyModel` and subclasses | gives the `Field`, getter and setter of the property; `wicket-bean-validation` uses it to find the constraints |
| `IModelComparator` | returned by `Component.getModelComparator()` | decides whether a new object equals the current model object; `setDefaultModelObject` does nothing when it does |

## Component methods for models

| Method | Description |
|---|---|
| `getDefaultModel()` | the component's model; calls `initModel()` when it has none |
| `setDefaultModel(IModel<?>)` | replaces the model |
| `getDefaultModelObject()` | `getDefaultModel().getObject()`, or `null` without a model |
| `setDefaultModelObject(Object)` | sets the model object when it differs from the current one, calling `modelChanging()` before and `modelChanged()` after |
| `getDefaultModelObjectAsString()` | the model object converted to text and escaped as configured with `setEscapeModelStrings` |
| `initModel()` | provides a model when the component has none; looks for an `IComponentInheritedModel` in the parents |
| `modelChanging()`, `modelChanged()` | report a change to the model object; `modelChanging()` tells the page, which can start a new page version; they call `onModelChanging()` and `onModelChanged()` |
| `onModelChanging()`, `onModelChanged()` | override to react to a change |
| `onDetach()` | override to detach models kept in fields; call `super.onDetach()` |
| `detachModels()` | detaches the default model; called after `onDetach()` |

`GenericPanel<T>`, `GenericWebPage<T>` and other components implementing `IGenericComponent<T, C>` add typed methods: `getModel()`, `setModel(IModel<T>)`, `getModelObject()` and `setModelObject(T)`.
