---
title: Use files from the web application root
type: howto
topic: resources
summary: Add stylesheets, scripts and images that live in the web application folder, such as src/main/webapp, to your pages with ContextRelativeResourceReference and ContextImage.
since: 10
apis: [ContextRelativeResourceReference, ContextRelativeResource, ContextImage, CssHeaderItem, JavaScriptHeaderItem]
keywords: [webapp folder, src/main/webapp, context root, absolute path, site.css, theme, min.js, minified, ServletContext resource]
order: 40
source: [resources/resources_5.adoc]
---

Use this when a file is not part of a component but belongs to the whole site, such as a theme stylesheet, a logo or a script that a design team delivers into the web application folder:

```
src/main/webapp/
    css/site.css
    css/site.min.css
    js/site.js
    img/logo.png
```

## Add a stylesheet or script from the web application folder

Create a `ContextRelativeResourceReference` with the path from the root of the web application, and render it as a header item, usually from a base page:

*BasePage.java*

```java
public abstract class BasePage extends WebPage {

    private static final ContextRelativeResourceReference SITE_CSS =
        new ContextRelativeResourceReference("css/site.css");

    private static final ContextRelativeResourceReference SITE_JS =
        new ContextRelativeResourceReference("js/site.js", false);

    @Override
    public void renderHead(IHeaderResponse response) {
        super.renderHead(response);
        response.render(CssHeaderItem.forReference(SITE_CSS));
        response.render(JavaScriptHeaderItem.forReference(SITE_JS));
    }
}
```

Wicket serves the file through its resource handling, so the URL contains a version that changes with the file, the response gets long cache headers, and the tag gets the Content Security Policy nonce.

A plain `<link href="/css/site.css">` or `<script src="/js/site.js">` in the markup has no nonce, and the default Content Security Policy blocks it. See [Configure the Content Security Policy]({{ site.baseurl }}/docs/csp.html).

## Serve the minified file in deployment mode

By default the reference switches to the minified file when the application uses minified resources, which is the case in deployment mode. In the example, `css/site.css` becomes `css/site.min.css`. The reference does not fall back to the original name: when you use the default constructor, the `.min` file must exist next to every file you reference.

Choose per file:

| Constructor | Development mode | Deployment mode |
|---|---|---|
| `new ContextRelativeResourceReference("css/site.css")` | `css/site.css` | `css/site.min.css` |
| `new ContextRelativeResourceReference("js/site.js", false)` | `js/site.js` | `js/site.js` |
| `new ContextRelativeResourceReference("js/site.js", "minified")` | `js/site.js` | `js/site.minified.js` |

Whether minified files are used follows `getResourceSettings().setUseMinifiedResources(…)`; [Minify and compress CSS and JavaScript]({{ site.baseurl }}/docs/compress-resources.html) describes that setting.

## Link a file by URL without versioning

`CssHeaderItem.forUrl` and `JavaScriptHeaderItem.forUrl` write the URL you give them, with the nonce. A relative URL is resolved against the root of the web application, not against the current page:

```java
response.render(CssHeaderItem.forUrl("css/print.css", "print"));
```

The URL carries no version, so browsers may keep an old copy after a deployment. Use it for files that never change or that you version yourself.

## Show an image from the web application folder

`ContextImage` renders an `<img>` whose `src` is a path from the root of the web application:

*BasePage.java*

```java
add(new ContextImage("logo", "img/logo.png"));
```

*BasePage.html*

```html
<img wicket:id="logo" alt="Example Inc."/>
```

The path can also come from a model, `new ContextImage("logo", logoPathModel)`, to switch images per tenant or theme.

For files that belong to a component, prefer package resources: [Serve files from your Java packages]({{ site.baseurl }}/docs/package-resources.html).
