---
title: Turn plain links into page links with wicket:link
type: howto
topic: links
summary: Write ordinary anchors to page files in the markup and let wicket:link turn them into links to bookmarkable pages, without Java code.
since: 10
apis: [AutoLinkResolver, WicketLinkTagHandler, MarkupSettings]
keywords: ["wicket:link", autolink, automatic linking, href to html file, static navigation, menu without java, self link disabled]
order: 30
source: [urls/urls_3.adoc]
---

Use `<wicket:link>` when a page has static navigation, such as a menu, that you want to write and preview as plain HTML. Wicket replaces each anchor inside the tag with a link to the bookmarkable page the `href` names, so you add no components in Java.

## Wrap the anchors in wicket:link

Point each `href` at the markup file of the target page, relative to the package of the current page:

*HomePage.html*, in package `com.example`

```html
<wicket:link>
    <a href="HomePage.html">Home</a>
    <a href="ProductListPage.html">Products</a>
    <a href="account/ProfilePage.html">Your profile</a>
</wicket:link>
```

Wicket strips the `.html`, resolves the rest as a class name relative to the package, and creates a link to that page. `account/ProfilePage.html` becomes `com.example.account.ProfilePage`, and `../HomePage.html` in a page from `com.example.account` points back to `com.example.HomePage`. The target page must be bookmarkable: it needs a constructor without arguments or one that takes `PageParameters`.

Because the `href` values are real file paths, the links also work when you open the markup files in a browser from your source tree.

## Use an absolute path

A path that starts with `/` is a full package path:

```html
<a href="/com/example/account/ProfilePage.html">Your profile</a>
```

Relative paths resolve against the package of the page being rendered, also in the markup of a panel or border. Use absolute paths in a panel that you place on pages in different packages.

## Pass parameters or jump to an anchor

A query string in the `href` becomes the page parameters, and a fragment directly after the file name is kept in the URL:

```html
<a href="ProductPage.html?id=42">Product 42</a>
<a href="HelpPage.html#shipping">Shipping costs</a>
```

Wicket reads everything after the `?` as parameters, so do not put a fragment after a query string.

## How the link to the current page renders

A link that points to the page it is on is disabled. On the home page, the first anchor in the example renders as:

```html
<a disabled="disabled">Home</a>
```

The `href` is gone and the `disabled` attribute is added, so you can style the current menu entry with CSS such as `a[disabled]`.

## Which anchors are left alone

Inside `<wicket:link>`, Wicket only rewrites tags that have no `wicket:id` and whose `href` or `src` contains no colon. Links such as `https://wicket.apache.org` or `mailto:dev@wicket.apache.org` stay as they are.

A `href` that does not end in `.html` (or `.xml`, `.wml`, `.svg`) is treated as a package resource instead of a page: `<link href="style.css">` inside `<wicket:link>` becomes a URL to `style.css` in the package of the page. See [Serve files from your Java packages]({{ site.baseurl }}/docs/package-resources.html).

## Turn automatic linking on or off for a region

`<wicket:link>` regions can be nested, and the `autolink` attribute switches the behavior for the region:

```html
<wicket:link autolink="false">
    <a href="Prototype.html">Not rewritten</a>
</wicket:link>
```

To rewrite anchors in all markup without `<wicket:link>` tags, turn on automatic linking for the application:

```java
@Override
protected void init() {
    super.init();
    getMarkupSettings().setAutomaticLinking(true);
}
```

The tag itself is described with the other Wicket tags in [Wicket tags and attributes]({{ site.baseurl }}/docs/wicket-tags.html).
