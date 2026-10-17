---
title: Load data once per request with detachable models
type: howto
topic: models
summary: Keep only an id in the page and load the entity fresh in every request with LoadableDetachableModel.
since: 10
apis: [LoadableDetachableModel, IDetachable]
keywords: [LDM, entity model, JPA, Hibernate, database, load, detach, onDetach, transient, NotSerializableException, LazyInitializationException, page size]
order: 40
source: [modelsforms/modelsforms_7.adoc]
---

Use a detachable model for data that comes from a database or a service. The model loads the object the first time a component asks for it in a request, drops it at the end of the request, and keeps only what it needs to load it again. The page stays small, and every request sees current data. [Models and component data]({{ site.baseurl }}/docs/about-models.html#detaching-drop-the-data-keep-the-key) explains why this matters.

The examples get their service through an injected field, as described in [Inject Spring beans]({{ site.baseurl }}/docs/spring.html). Injected fields hold a serializable proxy, so a lambda can use them.

## Load an entity by id

`LoadableDetachableModel.of` takes a supplier that is called once per request:

*PersonPage.java*
```java
public class PersonPage extends WebPage {
    @SpringBean
    private PersonService personService;

    public PersonPage(PageParameters parameters) {
        long id = parameters.get("id").toLong();

        IModel<Person> person = LoadableDetachableModel.of(() -> personService.findById(id));

        add(new Label("name", person.map(Person::getName)));
        add(new Label("email", person.map(Person::getEmail)));
    }
}
```

Both labels call `getObject()` while they render. The first call runs the supplier; the second gets the same object. At the end of the request Wicket detaches the labels, which detach their models and so `person`. The page is stored with the id and the lambda, not with the person.

## Write a reusable model class

Subclass `LoadableDetachableModel` when many pages load the same kind of entity. Pass the loaded object to the constructor when you already have it, so the first request does not load it twice:

*PersonModel.java*
```java
public class PersonModel extends LoadableDetachableModel<Person> {
    @SpringBean
    private PersonService personService;

    private final long id;

    public PersonModel(Person person) {
        super(person);
        this.id = person.getId();
        Injector.get().inject(this);
    }

    @Override
    protected Person load() {
        return personService.findById(id);
    }
}
```

Wicket injects `@SpringBean` fields of components when they are created, but not of other objects such as models. `Injector.get().inject(this)` fills the field.

## Keep the id of a new entity

A form that creates an entity starts with an object that has no id yet. Save it, then remember the id it got, so the model can load it in later requests. Read the id from the object when the model is detached:

```java
public class PersonModel extends LoadableDetachableModel<Person> {
    @SpringBean
    private PersonService personService;

    private Long id;

    public PersonModel(Person person) {
        super(person);
        this.id = person.getId();
        Injector.get().inject(this);
    }

    @Override
    protected Person load() {
        return id == null ? new Person() : personService.findById(id);
    }

    @Override
    protected void onDetach(Person person) {
        if (person != null) {
            id = person.getId();
        }
    }
}
```

`onDetach(T)` receives the object the model held in this request, or `null` when it held none.

> `onDetach(T)` exists since Wicket 11. On Wicket 10, override `onDetach()` and read the object with `getObject()`, which still returns the held object at that point without loading it again.
{: .since}

The model does not save anything. Changes made to the object during a request are lost when it is detached, unless your code saved them, usually in the form's `onSubmit()`.

## Replace the object

`setObject()` puts an object in the model until the end of the request:

```java
personModel.setObject(personService.findByEmail(email));
```

The next request calls `load()` again. If `load()` uses an id, change the id as well, or the model returns to the old entity. `PersonModel` above does that in `onDetach(Person)`.

## Use detachable models in repeaters

A list of rows needs a detachable model per row, not one model for the whole list. `IDataProvider.model(T)` is where a data view gets that model; return a `PersonModel` there. [Page through data]({{ site.baseurl }}/docs/paginate-data.html) shows a complete provider.

## Detach models the component does not own

Wicket detaches the default model of every component. A model that you keep in a field of your component, or that a behavior holds, is detached only if you do it yourself. [Use more than one model in a component]({{ site.baseurl }}/docs/multiple-models.html) shows how.
