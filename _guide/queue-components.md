---
title: Add components without repeating the markup hierarchy
type: howto
topic: components
summary: Queue components on a page or panel and let Wicket put each one in the right container by following the nesting in the markup.
since: 10
apis: [MarkupContainer, IQueueRegion]
keywords: [component queueing, queue, dequeue, add, component hierarchy, nesting, markup hierarchy, wrap in div, Detach called on component while it had a non-empty queue]
order: 120
source: [componentQueueing/componentQueueing_1.adoc, componentQueueing/componentQueueing_2.adoc, componentQueueing/componentQueueing_3.adoc, componentQueueing/componentQueueing_4.adoc, componentQueueing/componentQueueing_5.adoc]
---

Use component queueing when the nesting of your markup changes often, or when you are tired of mirroring every `<div wicket:id>` in Java. With `add`, the Java hierarchy must match the markup exactly: wrapping two fields in a new container means moving their `add` calls into it. With `queue`, you hand the components to a page or panel and Wicket places them by reading the markup.

## Queue instead of add

Call `queue` on the page or panel for every component, containers included, in any order:

*CustomerPage.html*

```html
<form wicket:id="customer">
  <div wicket:id="nameRow" class="row">
    <input type="text" wicket:id="first">
    <input type="text" wicket:id="last">
  </div>
  <input type="email" wicket:id="email">
  <button type="submit">Save</button>
</form>
```

*CustomerPage.java*

```java
queue(new Form<Void>("customer"));
queue(new WebMarkupContainer("nameRow"));
queue(new TextField<>("first", LambdaModel.of(customer::getFirstName, customer::setFirstName)));
queue(new TextField<>("last", LambdaModel.of(customer::getLastName, customer::setLastName)));
queue(new EmailTextField("email", LambdaModel.of(customer::getEmail, customer::setEmail)));
```

Wicket adds `nameRow` and `email` to the form and `first` and `last` to `nameRow`. If the designer later removes the `nameRow` element, the fields end up directly in the form; remove the `queue` call for `nameRow` and nothing else changes.

You can mix `queue` and `add`. A container you created with `add` can still receive queued children.

## Queue components with the same id under different parents

Ids only need to be unique within one parent. When the same id appears twice in a file, queue each component on the container it belongs to, so Wicket knows which tag is meant:

```html
<form wicket:id="customer">
  <input wicket:id="name">
  <div wicket:id="partner">
    <input wicket:id="name">
  </div>
</form>
```

```java
queue(new Form<Void>("customer"));
queue(new TextField<>("name", customerNameModel));

WebMarkupContainer partner = new WebMarkupContainer("partner");
queue(partner);
partner.queue(new TextField<>("name", partnerNameModel));
```

## Know when components are placed

Wicket places queued components as soon as the container you queued them on is part of a page, because it needs the page to find the markup. On a page, and in a panel's `onInitialize`, that is right away: the components are placed before `queue` returns. In a panel's constructor the panel has no page yet, so its queued components are placed when the panel is added to a page and initialized. Until then `getParent()` returns `null`, and methods that depend on the hierarchy, such as `isVisibleInHierarchy()`, do not give useful answers.

A component that finds no matching tag stays in the queue. Wicket reports this at the end of the request with `Detach called on component with id '...' while it had a non-empty queue`.

## Keep sensitive components inside their container

Wicket places a queued component only inside the container you queued it on, or deeper. Use this to make sure markup changes cannot move a component out of a protected area:

```java
WebMarkupContainer payment = new WebMarkupContainer("payment") {
    @Override
    protected void onConfigure() {
        super.onConfigure();
        setVisible(isViewingOwnProfile());
    }
};
queue(payment);
payment.queue(new Label("cardNumber", cardNumberModel));
```

If someone moves the `cardNumber` tag outside the `payment` element, rendering fails instead of showing the number to everyone.

## Know where queueing stops

Pages, panels, borders, fragments and `FormComponentPanel`s each have their own markup. Wicket does not place components across these boundaries: a component queued on a page is never placed inside a panel on that page, even if the panel's markup has a tag with the same id. Queue components on the panel, typically in the panel's own `onInitialize`.

In a repeater, queue on the item:

```java
protected void populateItem(ListItem<Order> item) {
    item.queue(new Label("number", item.getModel().map(Order::getNumber)));
}
```

## Use queueing with wicket:enclosure

With `add`, a `<wicket:enclosure>` is not the parent of the components inside it, so fields in a hidden enclosure are still validated. With `queue`, Wicket places the components inside the enclosure, and hiding it skips them. See [Hide surrounding markup with wicket:enclosure]({{ site.baseurl }}/docs/use-enclosures.html).
