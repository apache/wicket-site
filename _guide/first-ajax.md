---
title: Update a page with Ajax
type: tutorial
topic: start
summary: Make the click counter and the guestbook form update only the parts of the page that change, open the form without a reload, and refresh the guestbook every ten seconds.
since: 10
apis: [AjaxLink, AjaxButton, AjaxRequestTarget, AjaxSelfUpdatingTimerBehavior, WebMarkupContainer]
keywords: [Ajax, partial page update, no reload, setOutputMarkupId, setOutputMarkupPlaceholderTag, placeholder, markup id, refresh component, show hidden component, onConfigure, polling, timer, asynchronous]
order: 40
source: [ajax/ajax_1.adoc]
---

In this tutorial you make the application update parts of a page without reloading it. The click counter on the home page and the guestbook form send their requests in the background, the form opens when a visitor asks for it, and the guestbook refreshes its list by itself. You write no JavaScript: you tell Wicket in Java which components to redraw.

Start from the `myapp` project as you left it at the end of [Build a form that saves data]({{ site.baseurl }}/docs/first-form.html).

## 1. Count clicks without a reload

On the home page, the link that counts clicks reloads the page on every click. Replace it with an `AjaxLink`. Its `onClick` method gets an `AjaxRequestTarget`: the list of components to send back to the browser.

In *HomePage.java*, replace the `count` link and the `clicks` label with:

```java
Label clicksLabel = new Label("clicks", () -> clicks);
clicksLabel.setOutputMarkupId(true);
add(clicksLabel);

add(new AjaxLink<Void>("count") {
    @Override
    public void onClick(AjaxRequestTarget target) {
        clicks++;
        target.add(clicksLabel);
    }
});
```

Import `org.apache.wicket.ajax.AjaxRequestTarget` and `org.apache.wicket.ajax.markup.html.AjaxLink`. The HTML stays as it is.

`setOutputMarkupId(true)` makes Wicket write an `id` attribute on the label's tag. Wicket's JavaScript needs that id to find the tag it replaces, so every component you add to the target needs it.

Run `Start`, open the home page and click the link. The number goes up, the rest of the page stays still, and the address in the browser does not change.

## 2. Give the guestbook list a container

You cannot redraw a `ListView` on its own: it has no tag of its own, only the repeated tags of its items. Wrap it in a `WebMarkupContainer`, a component that renders its tag and its children and nothing else.

In *GuestbookPage.java*, create the container, and add the `ListView` to it instead of to the page:

```java
WebMarkupContainer entriesContainer = new WebMarkupContainer("entries");
entriesContainer.setOutputMarkupId(true);
add(entriesContainer);

entriesContainer.add(new ListView<Entry>("entry", entries) {
    @Override
    protected void populateItem(ListItem<Entry> item) {
        item.add(new Label("name", item.getModel().map(Entry::getName)));
        item.add(new Label("text", item.getModel().map(Entry::getText)));
    }
});
```

Import `org.apache.wicket.markup.html.WebMarkupContainer`. In *GuestbookPage.html*, give the `<ul>` the container's id:

```html
<ul wicket:id="entries">
    <li wicket:id="entry">
        <strong wicket:id="name">Ann</strong>:
        <span wicket:id="text">Hello!</span>
    </li>
</ul>
```

Restart and open the guestbook. It looks the same as before.

## 3. Submit the form with Ajax

Replace the plain submit button with an `AjaxButton`. The form's `onSubmit()` still saves the entry; the button's `onSubmit` only says what to redraw: the list, the emptied form and the feedback panel with the thank-you message.

In *GuestbookPage.java*, replace `add(new FeedbackPanel("feedback"))` so you keep a reference to the panel, give the form and the panel a markup id, and add the button to the form:

```java
FeedbackPanel feedback = new FeedbackPanel("feedback");
feedback.setOutputMarkupId(true);
add(feedback);

form.setOutputMarkupId(true);

form.add(new AjaxButton("save") {
    @Override
    protected void onSubmit(AjaxRequestTarget target) {
        target.add(entriesContainer, getForm(), feedback);
    }
});
```

This code needs `entriesContainer`, so place it after the container is created. Import `org.apache.wicket.ajax.markup.html.form.AjaxButton`. In *GuestbookPage.html*, give the button a `wicket:id`:

```html
<p><button type="submit" wicket:id="save">Sign the guestbook</button></p>
```

Restart and sign the guestbook. Your entry appears in the list, the form empties and the thank-you message shows, all without a reload.

Now submit the form with both fields empty. Nothing happens. The input fails validation, so Wicket does not call `onSubmit`, and no component is redrawn.

## 4. Show validation errors

When validation fails, an `AjaxButton` calls its `onError` method instead. Redraw the feedback panel there. Add this method to the button, next to `onSubmit`:

```java
@Override
protected void onError(AjaxRequestTarget target) {
    target.add(feedback);
}
```

Restart and submit the empty form again. The two error messages appear above the form, without a reload.

## 5. Open the form on request

The form takes up the top of the page, above the entries most visitors come to read. Hide it until the visitor asks for it, behind a link that disappears once the form is open.

A component that is not visible renders nothing, not even its tag. When it becomes visible in an Ajax request, Wicket's JavaScript then has no tag to replace. `setOutputMarkupPlaceholderTag(true)` solves this: while the component is hidden, Wicket renders an empty placeholder tag with the component's id in its place.

Add a field to `GuestbookPage` that remembers whether the visitor opened the form:

```java
private boolean writing;
```

Wicket calls `onConfigure()` on a component each time before it renders it, which makes it the place to decide visibility. Override it in the form, next to `onSubmit()`:

```java
Form<Void> form = new Form<>("form") {
    @Override
    protected void onConfigure() {
        super.onConfigure();
        setVisible(writing);
    }

    @Override
    protected void onSubmit() {
        // unchanged
    }
};
```

Replace `form.setOutputMarkupId(true);` with:

```java
form.setOutputMarkupPlaceholderTag(true);
```

Then add the link, after the form. It opens the form, redraws the form and itself, and hides itself once the form is open:

```java
AjaxLink<Void> write = new AjaxLink<>("write") {
    @Override
    public void onClick(AjaxRequestTarget target) {
        writing = true;
        target.add(form, this);
    }

    @Override
    protected void onConfigure() {
        super.onConfigure();
        setVisible(!writing);
    }
};
write.setOutputMarkupPlaceholderTag(true);
add(write);
```

Import `org.apache.wicket.ajax.markup.html.AjaxLink`. In *GuestbookPage.html*, add the link above the form:

```html
<p><a wicket:id="write">Write a message</a></p>
```

Restart and open the guestbook. The page shows the link and the entries. Click the link: the form appears where the placeholder was and the link disappears, without a reload. The form stays open after you sign, ready for the next message.

## 6. Refresh the list every ten seconds

Other visitors sign the guestbook too. A behavior adds functionality to a component without changing its class. `AjaxSelfUpdatingTimerBehavior` redraws its component at a fixed interval. Add one to the container, after you create it:

```java
entriesContainer.add(new AjaxSelfUpdatingTimerBehavior(Duration.ofSeconds(10)));
```

Import `org.apache.wicket.ajax.AjaxSelfUpdatingTimerBehavior` and `java.time.Duration`.

Restart and open the guestbook in two browsers, or in a normal and a private window, so each has its own session. Sign the guestbook in one. Within ten seconds the new entry appears in the other.

Your application now updates parts of its pages over Ajax: from a link, from a form, and on a timer, and it shows a hidden component without a reload.

{% if site.wicket.version_11 %}
> Since Wicket 11, the same code runs without jQuery if you switch the application to Wicket's plain JavaScript Ajax implementation. See [Run Ajax without jQuery]({{ site.baseurl }}/docs/ajax-without-jquery.html).
{: .since}
{% endif %}

## Continue with tests

In the next tutorial, [Test a page with WicketTester]({{ site.baseurl }}/docs/first-test.html), you write tests for the pages, the form and the Ajax link, and run them without a browser or server.

[How Wicket Ajax works]({{ site.baseurl }}/docs/how-ajax-works.html) explains what happens between the click and the update, [Update components with Ajax]({{ site.baseurl }}/docs/update-components.html) covers more of `AjaxRequestTarget`, [Show, hide or disable a component]({{ site.baseurl }}/docs/show-hide-components.html) explains why visibility belongs in `onConfigure()`, and [Ajax components]({{ site.baseurl }}/docs/ajax-components.html) and [Ajax behaviors]({{ site.baseurl }}/docs/ajax-behaviors.html) list what Wicket ships.
