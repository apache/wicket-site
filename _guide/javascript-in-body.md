---
title: Put JavaScript at the end of the body
type: howto
topic: resources
summary: Render all script header items in a container just before the closing body tag with JavaScriptFilteredIntoFooterHeaderResponse and HeaderResponseContainer.
since: 10
apis: [JavaScriptFilteredIntoFooterHeaderResponse, HeaderResponseContainer, FilteringHeaderResponse, FilteredHeaderItem, IHeaderResponseDecorator, HeaderResponseDecoratorCollection]
keywords: [footer scripts, scripts at bottom, before </body>, move JavaScript, page speed, render blocking, header response decorator, bucket]
order: 70
source: [resources/resources_8.adoc]
---

Move scripts to the end of the body when you want the browser to render the page before it downloads and runs the JavaScript. Components keep calling `renderHead`; a header response decorator sorts their items into the head and into a container at the bottom of the page.

## Send script items to a footer bucket

Register a `JavaScriptFilteredIntoFooterHeaderResponse` in `init()`. The second argument names the bucket for the scripts:

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();
    getHeaderResponseDecorators().add(
        response -> new JavaScriptFilteredIntoFooterHeaderResponse(response, "footer-scripts"));
}
```

From now on, every `JavaScriptHeaderItem`, `OnDomReadyHeaderItem`, `OnLoadHeaderItem` and `OnEventHeaderItem` goes into the `footer-scripts` bucket. Stylesheets, meta tags and the markup of the page's own `<head>` stay in the head.

`add` places the decorator inside the resource aggregation, so dependencies, bundles and ordering still apply before the items are sorted into buckets, and Wicket still adds the Content Security Policy nonce to every script.

## Render the bucket in the page

Add a `HeaderResponseContainer` with the bucket name to every page, as the last element of the body. A base page does it once for all pages:

*BasePage.java*

```java
public abstract class BasePage extends WebPage {

    public BasePage() {
        add(new HeaderResponseContainer("footerScripts", "footer-scripts"));
    }
}
```

*BasePage.html*

```html
<!DOCTYPE html>
<html xmlns:wicket="http://wicket.apache.org">
<head>
    <meta charset="utf-8"/>
    <title>Example</title>
</head>
<body>
    <wicket:child/>
    <wicket:container wicket:id="footerScripts"/>
</body>
</html>
```

The first argument is the component id, the second the bucket name. The container renders only the script tags, not its own tag. A page that renders script items without the container loses those scripts, so make sure every page extends the base page.

During an Ajax request Wicket sends header items with the Ajax response as usual, so components updated with Ajax keep working.

## Keep one script in the head

Some scripts must run before the body renders, for example one that sets a theme class on the document to prevent a flash of the wrong colours. Wrap its item in a `FilteredHeaderItem` with the name of the head bucket:

```java
@Override
public void renderHead(IHeaderResponse response) {
    super.renderHead(response);
    response.render(new FilteredHeaderItem(
        JavaScriptHeaderItem.forReference(ThemeJs.get()),
        FilteringHeaderResponse.DEFAULT_HEADER_FILTER_NAME));
}
```

A `FilteredHeaderItem` goes into the bucket it names, whatever the filters say, and its dependencies follow it. The same works the other way: wrap an item with your own bucket name and render that bucket with another `HeaderResponseContainer` anywhere in the page.

## Defer scripts instead

If you only want scripts not to block rendering, adding `defer` to the script tags in the head has the same effect without a container: `JavaScriptHeaderItem.forReference(…).setDefer(true)`. To defer every script of the application, Wicket has `JavaScriptDeferHeaderResponse`, which it marks as experimental. The decorators are listed in [Header items]({{ site.baseurl }}/docs/header-items.html#header-response-decorators).
