---
title: Bind components to a JavaBean
type: howto
topic: models
summary: Read and write bean properties with PropertyModel, and let form fields find their property by id with CompoundPropertyModel.
since: 10
apis: [PropertyModel, CompoundPropertyModel, IComponentInheritedModel]
keywords: [property expression, OGNL, model inheritance, bind, nested property, list index, map key, form fields, "Property could not be resolved for class"]
order: 20
source: [modelsforms/modelsforms_3.adoc]
---

Use property models when you bind many components to properties of one object, most often the fields of a form. They name the property with a string, a property expression. For a single property, [lambda models]({{ site.baseurl }}/docs/lambda-models.html) do the same with compile-time checks.

The examples bind to this bean, held in a `personModel` of type `IModel<Person>`:

*Person.java*
```java
public class Person implements Serializable {
    private String name;
    private String email;
    private Address address;
    private Person spouse;
    private List<Person> children;
    private Map<String, String> phones;

    // getters and setters
}
```

## Bind one component with PropertyModel

`PropertyModel` reads and writes one property of an object or of a model's object:

```java
add(new Label("name", new PropertyModel<>(personModel, "name")));
add(new Label("spouseName", PropertyModel.of(personModel, "spouse.name")));
```

When the first argument is a model, the property model reads the property of that model's current object, and detaches that model when it is detached itself. Pass a model rather than the bean, so the bean is not stored with the page.

`PropertyModel` uses the getter and setter when they exist and falls back to the field, private fields included. Reading is null-safe: when a step in the path is `null`, `getObject()` returns `null`.

## Write a property expression

| Expression | Resolves to |
|---|---|
| `name` | `getName()` and `setName()`, or the field `name` |
| `address.city` | `getAddress().getCity()`; on write, an `Address` is created when it is `null` and has a default constructor |
| `children.0.name` or `children[0].name` | the name of the first element of a list or array |
| `phones.home` or `phones[home]` | the value for key `home` in a map |
| `fullName()` | the result of calling the method `fullName()` |

A property that does not exist fails when the model is first used, with a `WicketRuntimeException` such as "Property could not be resolved for class: ... expression: ...". The compiler does not check the string, and renaming a property in your IDE does not update it.

## Bind a form with CompoundPropertyModel

Give the form a `CompoundPropertyModel` and leave the fields without a model. Each field then binds to the property named by its id:

*EditPersonPage.java*
```java
Form<Person> form = new Form<>("form", new CompoundPropertyModel<>(personModel)) {
    @Override
    protected void onSubmit() {
        personService.save(getModelObject());
    }
};
form.add(new TextField<>("name"));
form.add(new EmailTextField("email"));
form.add(new TextField<>("address.city"));
form.add(new Label("spouse.name"));
add(form);
```

*EditPersonPage.html*
```html
<form wicket:id="form">
    <input type="text" wicket:id="name">
    <input type="email" wicket:id="email">
    <input type="text" wicket:id="address.city">
    <span wicket:id="spouse.name"></span>
    <button type="submit">Save</button>
</form>
```

This works through model inheritance: a component created without a model asks its parents for an `IComponentInheritedModel`, and `CompoundPropertyModel` answers with a property model that uses the component's id as the expression. The fields do not have to be direct children of the form: Wicket walks up the parents until it finds an inheritable model, so containers in between do not get in the way.

The compound model can wrap a model, as above, or an object with `CompoundPropertyModel.of(person)`. Wrap a model when the object comes from a database, so that it is [loaded per request]({{ site.baseurl }}/docs/detachable-models.html).

## Use an id that differs from the property

When the id cannot be the property name, for example because two components show the same property, bind explicitly with `bind`:

```java
CompoundPropertyModel<Person> model = new CompoundPropertyModel<>(personModel);
Form<Person> form = new Form<>("form", model);
form.add(new TextField<String>("partner", model.bind("spouse.name")));
```

`bind` returns a property model on the same object, for any component that needs one, inside or outside the form.

## Give a field its own model inside the form

A component that has a model of its own does not inherit. Pass a model to the field and it ignores the form's compound model:

```java
form.add(new TextField<>("name"));                                           // inherits "name"
form.add(new TextField<>("nickname", LambdaModel.of(personModel,
        Person::getNickname, Person::setNickname)));                         // its own model
form.add(new CheckBox("subscribe", Model.of(false)));                         // not a Person property
```

[Model classes]({{ site.baseurl }}/docs/model-types.html) describes the other property-based models, such as `ComponentPropertyModel`.
