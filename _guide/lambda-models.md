---
title: Read and write data with lambda models
type: howto
topic: models
summary: Use lambdas, method references and the default methods of IModel to show computed values and bind components to properties without strings.
since: 10
apis: [IModel, LambdaModel]
keywords: [method reference, map, flatMap, filter, orElse, orElseGet, combineWith, isPresent, functional interface, read-only model, UnsupportedOperationException, type-safe]
order: 10
source: [modelsforms/modelsforms_2.adoc, modelsforms/modelsforms_3.adoc]
---

Use lambda models when a component shows a value computed from other data, or reads and writes one property of an object that another model holds. They are checked by the compiler and survive a rename, unlike [property expressions]({{ site.baseurl }}/docs/property-models.html).

The examples use a `personModel` of type `IModel<Person>`, for instance a [detachable model]({{ site.baseurl }}/docs/detachable-models.html) that loads the person by id.

## Show a computed value

`IModel` has a single abstract method, `getObject()`, so any lambda that returns a value is a model:

```java
add(new Label("now", () -> LocalTime.now()));
```

Wicket calls the lambda every time the label renders. A model written this way is read-only: its `setObject()` throws `UnsupportedOperationException`. That is fine for labels, but a form component needs a model it can write to.

## Derive a value from another model

`map` turns a model into a model of something computed from its object:

```java
add(new Label("fullName", personModel.map(Person::getFullName)));
add(new Label("city", personModel.map(Person::getAddress).map(Address::getCity)));
```

`map` returns `null` instead of calling the function when the object is `null`, so a chain of `map` calls never throws a `NullPointerException` halfway. The resulting model is read-only. Detaching it detaches `personModel`.

## Read and write a property

`LambdaModel.of(target, getter, setter)` gives a model that reads and writes one property of the object in `target`:

```java
IModel<String> email = LambdaModel.of(personModel, Person::getEmail, Person::setEmail);
form.add(new EmailTextField("email", email));
```

When the form is submitted, the field calls `setObject()`, which calls `setEmail` on the person the target model holds at that moment. When the target holds `null`, `getObject()` returns `null` and `setObject()` does nothing. The model detaches its target.

`flatMap` does the same for a mapper that returns a model, which is useful when the object already offers models for its parts:

```java
IModel<String> name = personModel.flatMap(p -> LambdaModel.of(p::getName, p::setName));
```

## Bind a field of the page

For a value that belongs to the page or panel, use `LambdaModel.of(getter, setter)` with method references on `this`:

*SearchPage.java*
```java
public class SearchPage extends WebPage {
    private String query;

    public SearchPage() {
        Form<Void> form = new Form<>("form") {
            @Override
            protected void onSubmit() {
                setResponsePage(new ResultsPage(query));
            }
        };
        form.add(new TextField<>("query", LambdaModel.of(this::getQuery, this::setQuery)));
        add(form);
    }

    public String getQuery() { return query; }

    public void setQuery(String query) { this.query = query; }
}
```

## Fall back to a default

`orElse` returns a fixed value when the object is `null`; `orElseGet` calls a supplier instead:

```java
add(new Label("nickname", personModel.map(Person::getNickname).orElse("(none)")));
add(new Label("since", personModel.map(Person::getJoined).orElseGet(LocalDate::now)));
```

## Combine two models

`combineWith` computes a value from the objects of two models. It returns `null` when either object is `null`:

```java
IModel<String> first = personModel.map(Person::getFirstName);
IModel<String> last = personModel.map(Person::getLastName);
add(new Label("name", first.combineWith(last, (f, l) -> f + " " + l)));
```

## Keep or test an object

`filter` keeps the object only when a predicate holds, and returns `null` otherwise. `isPresent` gives a `Boolean` model that is `true` when the object is not `null`. `as` keeps the object only when it is an instance of a class:

```java
IModel<Order> openOrder = orderModel.filter(Order::isOpen);

add(new Link<>("cancel", openOrder) {
    @Override
    public void onClick() {
        orderService.cancel(getModelObject());
    }

    @Override
    protected void onConfigure() {
        super.onConfigure();
        setVisible(openOrder.isPresent().getObject());
    }
});

IModel<Customer> customer = partyModel.as(Customer.class);
```

## Keep what the lambda captures small

The lambdas you pass to these methods are serializable types (`SerializableSupplier`, `SerializableFunction` and so on), because they are stored with the page. Everything a lambda captures is stored with it.

- Capture models, ids and `this`. The page or panel is serialized anyway.
- Do not capture entities or large objects. `LambdaModel.of(person::getName, person::setName)` stores `person` in the page, with the problems described in [Why `new Model<>(entity)` goes wrong]({{ site.baseurl }}/docs/about-models.html#why-new-modelentity-goes-wrong). Use the `LambdaModel.of(personModel, ...)` form instead.
- Do not capture services or connections, which are rarely serializable. Reach them through an injected field of the component, as described in [Inject Spring beans]({{ site.baseurl }}/docs/spring.html).

[Model classes]({{ site.baseurl }}/docs/model-types.html#imodel-methods) lists every default method of `IModel`.
