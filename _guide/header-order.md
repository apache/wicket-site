---
title: Control the order of header items
type: howto
topic: resources
summary: Put a header item first with PriorityHeaderItem, let the page's own items come before those of its components, and fix where Wicket inserts items with wicket:header-items.
since: 10
apis: [PriorityHeaderItem, PriorityFirstComparator, ResourceSettings, PageHeaderItem]
keywords: [header order, CSS order, stylesheet precedence, override CSS, script order, wicket:header-items, setHeaderItemComparator, meta charset first, head position]
order: 80
source: [resources/resources_9.adoc]
---

Change the order of header items when a stylesheet must override another one, or when a tag such as `<meta charset>` has to come before everything Wicket adds. Declare a dependency first if the order exists because one file needs another: [Declare dependencies between resources]({{ site.baseurl }}/docs/resource-dependencies.html) keeps the order right wherever the files are used.

## The default order

Without any configuration, Wicket writes the header in this order:

1. Items wrapped in a `PriorityHeaderItem`, those of parent components before those of their children.
2. All other items in the order they were rendered: items from application-level contributors, then those of the components from the deepest child up, and those of the page last. The markup of the page's own `<head>` counts as an item of the page.
3. The scripts of all `OnDomReadyHeaderItem` and `OnEventHeaderItem` items, combined into one inline script.
4. The scripts of all `OnLoadHeaderItem` items, combined into one inline script.

The dependencies of an item are written before the item. Because the page comes last in step 2, a stylesheet that the page renders can override the styles of its components. The content of `<wicket:head>` sections is written as Wicket meets it, outside this order.

## Put an item first

Wrap the item in a `PriorityHeaderItem`:

```java
@Override
public void renderHead(IHeaderResponse response) {
    super.renderHead(response);
    response.render(new PriorityHeaderItem(
        CssHeaderItem.forReference(ResetCss.get())));
}
```

The item and its dependencies move to the front of the header. When several components render priority items, those of the outer components come first. A typical use is a reset or base stylesheet in a base page that everything else builds on.

## Let the page come before its components

To give every item rendered by the page precedence over the items of its components, so that component styles override page styles, install the `PriorityFirstComparator` with `true`:

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();
    getResourceSettings().setHeaderItemComparator(new PriorityFirstComparator(true));
}
```

Priority items still come first; then follow the items of the page, including its `<head>` markup, and then those of the components.

You can write your own comparator of `ResourceAggregator.RecordedHeaderItem`, preferably by extending `PriorityFirstComparator` and overriding `compareWithinGroup`. It must not move an item before its dependencies. Setting `null` turns sorting off and leaves all items, priority items included, in the order they were rendered.

## Fix where Wicket inserts its items

Without further markup, the content of the page's `<head>` is just one of the page's items, so a `<meta charset>` you write there ends up after the stylesheets and scripts of the components. Place `<wicket:header-items/>` in the page's `<head>` to fix the spot where Wicket inserts its items:

*BasePage.html*

```html
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <wicket:header-items/>
    <wicket:link>
        <link rel="stylesheet" href="overrides.css"/>
    </wicket:link>
</head>
```

Markup before the tag stays before every item Wicket adds, and markup after it stays after, however components contribute. All header items, and the content of `<wicket:head>` sections, go where the tag is.

A page can contain only one `<wicket:header-items/>`, inside its `<head>`. Wicket throws an exception when it loads markup with a second one or with one after `</head>`.

The default Content Security Policy blocks a `<script>` or `<link rel="stylesheet">` written directly in the markup, because it has no nonce. Wrap such tags in `<wicket:link>`, as in the example, so Wicket writes the URL of the package resource and adds the nonce; for files outside your packages, render a header item instead. See [Configure the Content Security Policy]({{ site.baseurl }}/docs/csp.html).
