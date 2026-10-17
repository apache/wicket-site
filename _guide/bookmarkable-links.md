---
title: Link to a page
type: howto
topic: links
summary: Navigate to another page with a Link that runs code on the server first, or with a BookmarkablePageLink that points straight at the page.
since: 10
apis: [Link, BookmarkablePageLink, AbstractLink]
keywords: [anchor, a href, navigation, onClick, setResponsePage, menu, current page, link text, setBody]
order: 20
source: [urls/urls_2.adoc, helloWorld/helloWorld_4.adoc]
---

Every link starts as an `<a>` tag with a `wicket:id` in the markup. Which component you attach to it depends on whether the click has to run code on the server.

*HomePage.html*

```html
<a wicket:id="products">All products</a>
```

## Link straight to a page with BookmarkablePageLink

When the link only navigates, use a `BookmarkablePageLink`. It renders the URL of the target page into the `href`, so the browser goes straight to that page, and the user can open it in a new tab or bookmark it.

*HomePage.java*

```java
add(new BookmarkablePageLink<Void>("products", ProductListPage.class));
```

Pass `PageParameters` as the third argument to link to a page that needs them:

```java
add(new BookmarkablePageLink<Void>("product", ProductPage.class,
    new PageParameters().add("id", product.getId())));
```

The target page needs a constructor without arguments or one that takes `PageParameters`; see [Pass parameters to a page]({{ site.baseurl }}/docs/page-parameters.html). A `BookmarkablePageLink` does not make its own page stateful, which matters on [stateless pages]({{ site.baseurl }}/docs/stateless-links.html).

## Run code when the user clicks with Link

A `Link` is a click handler. Its `href` points back to the link itself; when the user clicks, Wicket calls `onClick()` on the server. After `onClick()`, Wicket renders the current page again unless you set another response page.

```java
add(new Link<Void>("delete") {
    @Override
    public void onClick() {
        cart.remove(item);
        setResponsePage(CartPage.class);
    }
});
```

`setResponsePage` takes a page class or a page instance:

- `setResponsePage(CartPage.class)` and `setResponsePage(CartPage.class, parameters)` make Wicket create a new instance of the page, through a redirect to the URL of that page.
- `setResponsePage(new ConfirmPage(order))` renders the instance you created. Use it when the next page needs objects or models that do not fit in a URL.

Why the response is a redirect, and when it is not, is explained in [Redirects after a request]({{ site.baseurl }}/docs/redirects.html).

Because its URL points at a component of the current page, a `Link` makes the page stateful. On a page that must stay stateless, use a `StatelessLink` or a `BookmarkablePageLink`.

## Set the text of a link from a model

The markup between the `<a>` tags is the default text. To replace it from Java, give the link a body model. Here `userModel` is an `IModel<User>`:

```java
add(new BookmarkablePageLink<Void>("profile", ProfilePage.class)
    .setBody(userModel.map(User::getDisplayName)));
```

The body is escaped like any model value.

## Disable the link to the current page

In a menu, the entry for the page the user is on should not be a link. `setAutoEnable(true)` disables a link when it points to the page it is rendered on; for a `BookmarkablePageLink` that means a page of the same class.

```java
add(new BookmarkablePageLink<Void>("menuProducts", ProductListPage.class)
    .setAutoEnable(true));
```

A disabled link on an `<a>` tag renders without its `href`, so the browser shows plain text. Use `onConfigure` with `setEnabled(...)` to disable a link for other reasons, as with any component; see [Show, hide or disable a component]({{ site.baseurl }}/docs/show-hide-components.html).

## Open the target in a popup window

`setPopupSettings` opens the target page in a new browser window with the size and features you choose:

```java
add(new BookmarkablePageLink<Void>("help", HelpPage.class)
    .setPopupSettings(new PopupSettings("help").setWidth(600).setHeight(400)));
```

For links to other sites, use an [ExternalLink]({{ site.baseurl }}/docs/external-links.html). For links written in plain HTML, without Java code, see [Turn plain links into page links with wicket:link]({{ site.baseurl }}/docs/wicket-link.html).
