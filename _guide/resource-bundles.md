---
title: Combine resources into one bundle
type: howto
topic: resources
summary: Serve several package stylesheets or scripts as one file with ResourceBundles, and replace a resource throughout the application with addResourceReplacement.
since: 10
apis: [ResourceBundles, ConcatResourceBundleReference, WebApplication, JavaScriptResourceReference, CssResourceReference]
keywords: [bundle, concatenate, merge files, fewer requests, addJavaScriptBundle, addCssBundle, addResourceReplacement, replace jQuery, CDN replacement, override library CSS]
order: 60
source: [resources/resources_7.adoc]
---

Bundle files that most pages load together, so the browser makes one request instead of several. You register the bundle once in the application; components keep rendering the individual files.

## Register a bundle

Call `addJavaScriptBundle` or `addCssBundle` in `init()`, with a scope class, a file name for the bundle and the references it consists of:

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();

    getResourceBundles().addJavaScriptBundle(WicketApplication.class, "app.js",
        ChartCoreJs.get(),
        ChartJs.get(),
        DashboardJs.get());

    getResourceBundles().addCssBundle(WicketApplication.class, "app.css",
        ChartCss.get(),
        DashboardCss.get());
}
```

When a component renders any of these references, Wicket renders the bundle instead. The page gets one `<script>` for `app.js` with the three files concatenated in the order you listed them, and later requests for the other members are already satisfied.

Follow these rules:

- Members must be package resources: `JavaScriptResourceReference` for a JavaScript bundle, `CssResourceReference` for a CSS bundle.
- List the files in the order they must run. Dependencies on references outside the bundle are kept, and Wicket renders those before the bundle.
- A reference can be part of one bundle only. Adding it to a second bundle throws an `IllegalArgumentException`.
- The name is the file name in the URL; give a JavaScript bundle a `.js` name and a CSS bundle a `.css` name.

## Defer a bundled script

`addJavaScriptBundle` has a variant with a `defer` flag that renders the bundle's `<script>` with the `defer` attribute:

```java
getResourceBundles().addJavaScriptBundle(WicketApplication.class, "app.js", true,
    ChartCoreJs.get(), ChartJs.get(), DashboardJs.get());
```

A bundle is a trade-off: a page that needs one of its files downloads all of them. Put files in a bundle that appear together on most pages, and leave rarely used ones out.

## Replace a resource throughout the application

`WebApplication#addResourceReplacement` makes Wicket render a different resource wherever the original is rendered, including in components you cannot change. Use it to serve a library from a CDN or to swap a component's stylesheet for your own:

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();

    addResourceReplacement(DatePickerCss.get(),
        new CssResourceReference(WicketApplication.class, "datepicker-theme.css"));

    addResourceReplacement(ChartCoreJs.get(),
        new UrlResourceReference(Url.parse("https://cdn.example.com/chart-core/4.4.0/chart-core.min.js")));
}
```

The first argument is a `CssResourceReference` or a `JavaScriptResourceReference`; the replacement can be any reference. A replaced CSS item keeps its media attribute, and a replaced script keeps `defer`, `async` and the nonce. A replacement is a bundle with one member, so the original cannot also be part of a bundle.

To replace jQuery, set the jQuery reference instead: `getJavaScriptLibrarySettings().setJQueryReference(…)`, see [Declare dependencies between resources]({{ site.baseurl }}/docs/resource-dependencies.html#depend-on-jquery).
