---
title: Use more than one model in a component
type: howto
topic: models
summary: Detach the extra models a component, behavior or custom model keeps in its fields, so their data is not stored with the page.
since: 10
apis: [Component, IDetachable, Behavior, LoadableDetachableModel]
keywords: [onDetach, detach, second model, additional model, model field, detachModels, onDetachAlways, nested model, memory leak, page size]
order: 50
source: [modelsforms/modelsforms_8.adoc]
---

You need this when a component works with more than one model. A component has one default model, and Wicket detaches that one at the end of each request. Any other model you keep in a field is detached only when you do it yourself. A model that is not detached keeps its loaded object, which is then stored with the page.

## Detach extra models in onDetach

Override `onDetach()` in the component, detach each model you keep, and call `super.onDetach()`:

*PersonOrdersPanel.java*
```java
public class PersonOrdersPanel extends GenericPanel<Person> {
    private final IModel<List<Order>> orders;

    public PersonOrdersPanel(String id, IModel<Person> person, IModel<List<Order>> orders) {
        super(id, person);
        this.orders = orders;

        add(new Label("name", person.map(Person::getName)));
        add(new ListView<>("orders", orders) {
            @Override
            protected void populateItem(ListItem<Order> item) {
                item.add(new Label("number", item.getModel().map(Order::getNumber)));
            }
        });
    }

    @Override
    protected void onDetach() {
        orders.detach();
        super.onDetach();
    }
}
```

Wicket checks that `super.onDetach()` is called and fails the request with an error when it is not.

Detaching the same model twice does no harm. Here the `ListView` also detaches `orders`, because it is the list view's default model, but the panel cannot rely on that: the list view might be replaced or removed.

## Pass derived models instead of fields

A model you hand to a child component is detached with that child. When the panel only needs a model to build its children, do not keep it in a field. The `person` model above is the panel's default model, and the label gets `person.map(...)`, which detaches `person` too.

## Detach models held by a behavior

A behavior that keeps a model overrides `detach(Component)`:

```java
public class TitleBehavior extends Behavior {
    private final IModel<String> title;

    public TitleBehavior(IModel<String> title) {
        this.title = title;
    }

    @Override
    public void onComponentTag(Component component, ComponentTag tag) {
        tag.put("title", title.getObject());
    }

    @Override
    public void detach(Component component) {
        title.detach();
        super.detach(component);
    }
}
```

`AttributeModifier` and the other behaviors in Wicket that take a model already detach it.

## Detach models inside your own model

A model that wraps other models detaches them in its own `detach()`:

```java
public class FullNameModel implements IModel<String> {
    private final IModel<String> first;
    private final IModel<String> last;

    public FullNameModel(IModel<String> first, IModel<String> last) {
        this.first = first;
        this.last = last;
    }

    @Override
    public String getObject() {
        return first.getObject() + " " + last.getObject();
    }

    @Override
    public void detach() {
        first.detach();
        last.detach();
    }
}
```

The models made by `map`, `combineWith`, `LambdaModel.of(target, ...)` and the other model methods in Wicket already do this. `first.combineWith(last, (f, l) -> f + " " + l)` replaces the whole class above.

{% if site.wicket.version_11 %}
A `LoadableDetachableModel` that uses other models detaches them in `onDetachAlways()`, which runs on every detach, also in requests where the model itself was never loaded:
{% else %}
A `LoadableDetachableModel` that uses other models overrides `detach()`, calls `super.detach()` and detaches the other models there, so they are detached also in requests where the model itself was never loaded:
{% endif %}

```java
public class OrdersModel extends LoadableDetachableModel<List<Order>> {
    @SpringBean
    private OrderService orderService;

    private final IModel<Person> person;

    public OrdersModel(IModel<Person> person) {
        this.person = person;
        Injector.get().inject(this);
    }

    @Override
    protected List<Order> load() {
        return orderService.findByCustomer(person.getObject());
    }
{% if site.wicket.version_11 %}
    @Override
    protected void onDetachAlways() {
        person.detach();
    }{% else %}
    @Override
    public void detach() {
        super.detach();
        person.detach();
    }{% endif %}
}
```

{% if site.wicket.version_11 %}
> `onDetachAlways()` exists since Wicket 11, where `LoadableDetachableModel.detach()` is final. On Wicket 10, override `detach()` instead, call `super.detach()` and detach the other models there. `onDetach()` is the wrong place on both versions: it only runs when the model itself was loaded in the request.
{: .since}
{% else %}
`onDetach()` is the wrong place: it only runs when the model itself was loaded in the request.
{% endif %}

[Load data once per request with detachable models]({{ site.baseurl }}/docs/detachable-models.html) covers `LoadableDetachableModel` itself.
