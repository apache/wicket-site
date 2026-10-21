---
title: Chain models
type: howto
topic: models
summary: Wrap one model in another so that a form, a panel or a label always works on the object the inner model currently holds.
since: 10
apis: [ChainingModel, CompoundPropertyModel, LambdaModel, FormComponentUpdatingBehavior]
keywords: [nested model, wrap model, master-detail, list detail, selected item, model pipeline, dropdown selection]
order: 30
source: [modelsforms/modelsforms_6.adoc]
---

Chain models when one component must work on whatever object another model holds at the moment, such as a form that edits the item selected in a drop-down. The outer model asks the inner model for its object every time, so it follows changes without being replaced.

Most models in Wicket accept a model where they accept an object: `CompoundPropertyModel`, `PropertyModel` and `LambdaModel.of(target, getter, setter)`. The models made with `map`, `filter` and the other default methods of `IModel` are chained to the model you call them on. Detaching the outer model detaches the inner one.

## Edit the item selected in a drop-down

This page shows a list of people in a drop-down and a form to edit the selected person. The drop-down and the form share one model, `selected`. The form wraps it in a `CompoundPropertyModel`, so its fields edit whichever person `selected` holds.

*PersonListDetails.html*
```html
<select wicket:id="persons"></select>

<form wicket:id="form">
    <label>Name <input type="text" wicket:id="name"></label>
    <label>Surname <input type="text" wicket:id="surname"></label>
    <label>Email <input type="email" wicket:id="email"></label>
    <button type="submit">Save</button>
</form>
```

*PersonListDetails.java*
```java
public class PersonListDetails extends WebPage {

    public PersonListDetails() {
        IModel<Person> selected = Model.of();

        DropDownChoice<Person> persons = new DropDownChoice<>("persons", selected,
                loadPersons(), new LambdaChoiceRenderer<>(Person::getFullName));
        persons.add(new FormComponentUpdatingBehavior());
        add(persons);

        Form<Person> form = new Form<>("form", new CompoundPropertyModel<>(selected)) {
            @Override
            protected void onConfigure() {
                super.onConfigure();
                setVisible(getModelObject() != null);
            }
        };
        form.add(new TextField<>("name"));
        form.add(new TextField<>("surname"));
        form.add(new EmailTextField("email"));
        add(form);
    }
}
```

`loadPersons()` returns the list of people to choose from. What happens:

1. The user picks a person. `FormComponentUpdatingBehavior` submits the drop-down on its `change` event, without needing a form around it, and the drop-down writes the choice into `selected`.
2. The page renders again. The form's `CompoundPropertyModel` calls `selected.getObject()` and gets the new person. Each field reads its property from that person.
3. The user edits the fields and saves. The fields write into the person that `selected` holds.

The form never gets a new model. Only the object at the end of the chain changes.

`Person` is `Serializable` here, so `Model` can hold it. When the people come from a database, hold the selection in a [detachable model]({{ site.baseurl }}/docs/detachable-models.html) that keeps the id. To update only the form and not the whole page, use an `AjaxFormComponentUpdatingBehavior` and add the form to the `AjaxRequestTarget`, as in [Update components with Ajax]({{ site.baseurl }}/docs/update-components.html).

## Chain a single property

For one value instead of a whole form, chain with `LambdaModel.of` or `map`:

```java
IModel<String> email = LambdaModel.of(selected, Person::getEmail, Person::setEmail);
IModel<String> initials = selected.map(Person::getInitials);
```

Both return `null` while `selected` is empty, and both detach `selected` when they are detached.

## Write your own chaining model

Extend `ChainingModel` for a custom model that may receive either an object or a model. When it was given a model, `getObject()` and `setObject()` go to that model; otherwise they read and replace the object itself. Its `detach()` detaches the inner model. `getChainedModel()` returns the inner model, or `null` when it was given a plain object.

```java
public class UpperCaseModel extends ChainingModel<String> {

    public UpperCaseModel(IModel<String> source) {
        super(source);
    }

    @Override
    public String getObject() {
        String value = super.getObject();
        return value == null ? null : value.toUpperCase(Locale.ROOT);
    }
}
```

For a read-only transformation like this one, `source.map(s -> s.toUpperCase(Locale.ROOT))` is shorter. A subclass of `ChainingModel` pays off when it also writes, or when it is reused in many places.
