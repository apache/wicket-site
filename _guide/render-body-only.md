---
title: Render a component without its tag
type: howto
topic: components
summary: Leave out a component's own HTML tag and render only its content, and know what stops working when you do.
since: 10
apis: [Component, ExceptionSettings]
keywords: [setRenderBodyOnly, strip tag, remove span, no wrapper element, wicket:container, A partial update is not possible for a component that has renderBodyOnly enabled]
order: 90
source: [keepControl/keepControl_8.adoc]
---

Use this when a component's tag is only there to give Wicket a place to attach the component, and the element itself would be in the way: a `<span>` around plain text, or a wrapper that breaks your CSS or the HTML content model.

## Drop the tag in Java

Call `setRenderBodyOnly(true)`. Wicket renders what the component puts inside its tag, but not the tag.

*HomePage.html*

```html
<p>Hello, <span wicket:id="name">Jane</span>!</p>
```

*HomePage.java*

```java
add(new Label("name", () -> user.getFirstName()).setRenderBodyOnly(true));
```

Output:

```html
<p>Hello, Maria!</p>
```

## Drop the tag in the markup

When the choice belongs to the markup, attach the component to a `<wicket:container>` tag instead. It needs no Java change and makes the intent visible to whoever edits the HTML:

```html
<p>Hello, <wicket:container wicket:id="name">Jane</wicket:container>!</p>
```

In deployment mode Wicket removes the `<wicket:container>` tag. In development mode it stays in the output, which is harmless in the browser.

## Know what stops working without the tag

The tag carries everything Wicket writes about the component itself. Without it:

| Feature | Effect |
|---|---|
| Ajax updates | Adding the component to an `AjaxRequestTarget` fails with `A partial update is not possible for a component that has renderBodyOnly enabled`. Repaint a parent instead. |
| Markup id | Nothing to put the `id` on. Wicket logs `Markup id set on a component that renders its body only`. |
| Placeholder tag | `setOutputMarkupPlaceholderTag(true)` has no effect, and Wicket logs a warning. |
| Attribute modifiers | Behaviors that change attributes have nothing to change. |
| Ajax behaviors | Event handlers have no element to listen on. |

To make the warnings fail fast during development, set `getExceptionSettings().setNotRenderableErrorStrategy(NotRenderableErrorStrategy.THROW_EXCEPTION)` in your application's `init()`.

Components that need any of these keep their tag. If the tag is in the way only for styling, change the tag instead: a `<span>` inside a paragraph is valid HTML and invisible without CSS.
