---
title: Wrap content with a Border
type: howto
topic: components
summary: Write the markup that goes around content once, as a Border, and wrap any part of a page in it while the page keeps its own components.
since: 10
apis: [Border, BorderBehavior]
keywords: [wicket:border, wicket:body, wrapper, frame, box, card, decorator, addToBorder, layout around content]
order: 70
source: [keepControl/keepControl_10.adoc]
---

Use a border when the same markup goes around different content: a card with a title bar, a collapsible box, a form section with a heading. A panel replaces the content of its tag; a border keeps that content and puts its own markup around it.

## Write the border class and its markup

Subclass `Border`. Its markup file has the same name as the class and a `<wicket:border>` tag with the markup that goes around the content. `<wicket:body/>` marks where the content goes. Wicket ignores everything outside `<wicket:border>`.

*CardBorder.java*

```java
public class CardBorder extends Border {
    public CardBorder(String id, IModel<String> title) {
        super(id);
        addToBorder(new Label("title", title));
    }
}
```

*CardBorder.html*

```html
<html xmlns:wicket="http://wicket.apache.org">
<body>
  <wicket:border>
    <div class="card">
      <h2 class="card-title" wicket:id="title">Title</h2>
      <div class="card-body">
        <wicket:body/>
      </div>
    </div>
  </wicket:border>
</body>
</html>
```

## Wrap content in the page

Attach the border to a tag in the page and write the content inside that tag. Components in that content are added to the border with `add`:

*AccountPage.html*

```html
<section wicket:id="profile">
  <p>Signed in as <span wicket:id="user"></span>.</p>
</section>
```

*AccountPage.java*

```java
CardBorder profile = new CardBorder("profile", Model.of("Profile"));
profile.add(new Label("user", () -> account.getUserName()));
add(profile);
```

The output, as in deployment mode:

```html
<section>
  <div class="card">
    <h2 class="card-title">Profile</h2>
    <div class="card-body">
      <p>Signed in as maria.</p>
    </div>
  </div>
</section>
```

The border's own tag, `<section>` here, stays in the output.

## Add components to the border or to the body

A border has two places for child components, and a separate method for each:

| Where the tag is | Method |
|---|---|
| In the border's own markup file (`title` above) | `addToBorder`, `removeFromBorder`, `replaceInBorder`, `queueToBorder` |
| In the content inside the border's tag in the page (`user` above) | `add`, `remove`, `replace`, `queue` |

`add` on a border goes to its body container, which you can also get with `getBodyContainer()`. If `<wicket:body/>` sits inside a component in the border's markup, add the body container to that component yourself:

```java
WebMarkupContainer collapsible = new WebMarkupContainer("collapsible");
addToBorder(collapsible);
collapsible.add(getBodyContainer());
```

## Hide the content but keep the frame

The body container is a component, so you can hide only the content, for example for a collapsed box:

```java
getBodyContainer().setVisible(false);
```

## Wrap a single component with BorderBehavior

When the content is one component and the frame needs no components of its own, a `BorderBehavior` is lighter. Subclass it, give it a markup file with `<wicket:border>` and `<wicket:body/>` like above, and add it to the component:

```java
public class FieldFrame extends BorderBehavior {
}
```

```java
form.add(new TextField<>("email", emailModel).add(new FieldFrame()));
```

The frame markup is written around the component's tag. A `BorderBehavior` cannot hold components in its markup.
