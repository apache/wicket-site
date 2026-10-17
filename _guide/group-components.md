---
title: Group components with WebMarkupContainer
type: howto
topic: components
summary: Attach a plain HTML element to a container component so you can hide, disable, style or repaint a group of components as one.
since: 10
apis: [WebMarkupContainer, TransparentWebMarkupContainer]
keywords: [container, div, group, section, hide group, wrapper, refresh several components, wicket:container]
order: 40
source: [keepControl/keepControl_4.adoc]
---

Use this when several components belong together on a page and you want to treat them as one: hide them all, disable them all, set a CSS class on the element around them, or repaint them in one Ajax response. A `WebMarkupContainer` is a component for an ordinary HTML element that has no Java behavior of its own. Unlike a panel, it needs no class and no markup file: its markup is the element in the page.

## Wrap the components in a container

Give the surrounding element a `wicket:id` and nest the components inside it, in the markup and in Java.

*InboxPage.html*

```html
<div wicket:id="newMail" class="notice">
  You have <span wicket:id="count"></span> new messages.
  <a wicket:id="open">Read them</a>
</div>
```

*InboxPage.java*

```java
WebMarkupContainer newMail = new WebMarkupContainer("newMail");
newMail.add(new Label("count", () -> mailbox.countUnread()));
newMail.add(new BookmarkablePageLink<Void>("open", UnreadPage.class));
add(newMail);
```

## Hide or disable the group

Visibility and the enabled state of a container apply to all of its children. Decide them in `onConfigure` so they follow the current state:

```java
WebMarkupContainer newMail = new WebMarkupContainer("newMail") {
    @Override
    protected void onConfigure() {
        super.onConfigure();
        setVisible(mailbox.countUnread() > 0);
    }
};
```

See [Show, hide or disable a component]({{ site.baseurl }}/docs/show-hide-components.html).

## Style the group

The container is a component, so behaviors work on it like on any other:

```java
newMail.add(AttributeModifier.append("class", () -> mailbox.hasUrgent() ? "urgent" : null));
```

## Repaint the group with Ajax

Turn on the markup id and add the container to the Ajax response. Everything inside it is rendered again.

```java
newMail.setOutputMarkupPlaceholderTag(true);

add(new AjaxLink<Void>("refresh") {
    @Override
    public void onClick(AjaxRequestTarget target) {
        target.add(newMail);
    }
});
```

`setOutputMarkupPlaceholderTag(true)` also writes the id, and keeps a placeholder in the page while the container is hidden so it can reappear. See [Update components with Ajax]({{ site.baseurl }}/docs/update-components.html).

## Group components without an HTML element

When an extra `<div>` would be invalid HTML or break your CSS, attach the container to a `<wicket:container>` tag. It works the same in Java, but in deployment mode it leaves no element in the output.

```html
<table>
  <wicket:container wicket:id="details">
    <tr><th>Weight</th><td wicket:id="weight"></td></tr>
    <tr><th>Size</th><td wicket:id="size"></td></tr>
  </wicket:container>
</table>
```

A container without an element cannot be repainted with Ajax or carry attributes; use a real element for that.

## Change a tag without regrouping its children

Sometimes you only want to control one element, such as setting a class on `<body>` in a base page, without making everything inside it a child of a new container. A `TransparentWebMarkupContainer` does that: components inside its tag in the markup can stay children of its parent in Java.

```java
public class BasePage extends WebPage {
    public BasePage() {
        add(new TransparentWebMarkupContainer("body")
            .add(AttributeModifier.append("class", this::getBodyClass)));
    }

    protected String getBodyClass() {
        return null;
    }
}
```

```html
<body wicket:id="body">
  <wicket:child/>
</body>
```

Subclasses keep adding their components to the page itself.
