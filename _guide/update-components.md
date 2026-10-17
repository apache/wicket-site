---
title: Update components with Ajax
type: howto
topic: ajax
summary: Re-render components, show hidden ones, refresh lists and run JavaScript in response to an Ajax request.
since: 10
apis: [AjaxRequestTarget, AjaxLink, IPartialPageRequestHandler]
keywords: [refresh, repaint, partial update, setOutputMarkupId, setOutputMarkupPlaceholderTag, appendJavaScript, target.add, was not found while trying to perform markup update]
order: 10
source: [ajax/ajax_1.adoc, ajax/ajax_2.adoc]
---

Use this when an Ajax callback has changed some state and the browser should show the result without reloading the page. Every Ajax callback receives an `AjaxRequestTarget`; what you add to it is rendered again and sent back. For what happens underneath, see [How Wicket Ajax works]({{ site.baseurl }}/docs/how-ajax-works.html).

## Re-render a component

Give the component a markup id when you create it, change its state in the callback and add it to the target:

*HomePage.java*

```java
public class HomePage extends WebPage {
    private int clicks;

    public HomePage() {
        Label counter = new Label("counter", () -> clicks);
        counter.setOutputMarkupId(true);
        add(counter);

        add(new AjaxLink<Void>("increment") {
            @Override
            public void onClick(AjaxRequestTarget target) {
                clicks++;
                target.add(counter);
            }
        });
    }
}
```

*HomePage.html*

```html
<p>Clicked <span wicket:id="counter"></span> times.</p>
<a wicket:id="increment">Click me</a>
```

`target.add` takes any number of components. The markup id must be there from the first render: without `setOutputMarkupId(true)` the browser has no element to replace, and the browser console shows "Component with id ... was not found while trying to perform markup update". See [Give a component a markup id]({{ site.baseurl }}/docs/markup-ids.html) for the ways to set one.

## Show a component that was hidden

An invisible component renders nothing, so there is nothing to replace. Call `setOutputMarkupPlaceholderTag(true)` to make it leave an empty, hidden tag with its id:

```java
Label message = new Label("message", "Saved.") {
    @Override
    protected void onConfigure() {
        super.onConfigure();
        setVisible(saved);
    }
};
message.setOutputMarkupPlaceholderTag(true);
add(message);

add(new AjaxLink<Void>("save") {
    @Override
    public void onClick(AjaxRequestTarget target) {
        saved = true;
        target.add(message);
    }
});
```

The placeholder tag implies a markup id. Use it on every component that you hide or show through Ajax, and on a container whose visibility depends on its children. [Show, hide or disable a component]({{ site.baseurl }}/docs/show-hide-components.html) covers `onConfigure`.

## Refresh a list or table

Repeaters such as `ListView`, `RepeatingView` and `DataView` have no tag of their own, and `target.add` throws an `IllegalArgumentException` for them. Wrap the repeater in a container and add the container:

*TodoPage.html*

```html
<ul wicket:id="items">
    <li wicket:id="item"><span wicket:id="title"></span></li>
</ul>
```

*TodoPage.java*

```java
WebMarkupContainer items = new WebMarkupContainer("items");
items.setOutputMarkupId(true);
add(items);

items.add(new ListView<>("item", todos) {
    @Override
    protected void populateItem(ListItem<Todo> item) {
        item.add(new Label("title", item.getModel().map(Todo::getTitle)));
    }
});

// in the callback
target.add(items);
```

For tables with paging and sorting, the Ajax variants in [Ajax components]({{ site.baseurl }}/docs/ajax-components.html) refresh themselves. A whole page can be added too, `target.add(getPage())`; Wicket then redirects the browser to the page instead of sending a partial update.

## Run JavaScript after the update

`appendJavaScript` runs a script after the components are replaced, `prependJavaScript` before:

```java
target.add(counter);
target.appendJavaScript("document.getElementById('" + counter.getMarkupId() + "').scrollIntoView();");
```

Never put user input into the script without escaping it; Wicket sends the string as it is. To move the keyboard focus, use `target.focusComponent(component)`, which needs the component's markup id as well.

## Let a component refresh itself

When a component should be refreshed after every Ajax request on the page, for example a `FeedbackPanel` or a header with a shopping cart, let it add itself. Wicket sends the `AjaxRequestTarget` as an event to every component on the page before it responds:

```java
public class CartSummary extends Panel {
    public CartSummary(String id) {
        super(id);
        setOutputMarkupId(true);
        // ...
    }

    @Override
    public void onEvent(IEvent<?> event) {
        super.onEvent(event);
        if (event.getPayload() instanceof AjaxRequestTarget target) {
            target.add(this);
        }
    }
}
```

Code outside a callback, such as a service method that only has the component, can find the target of the current request with `RequestCycle.get().find(AjaxRequestTarget.class)`, which returns an `Optional` that is empty for a normal request. Events between components are covered in [Send events between components]({{ site.baseurl }}/docs/send-events.html).
