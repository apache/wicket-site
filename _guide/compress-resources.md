---
title: Minify and compress CSS and JavaScript
type: howto
topic: resources
summary: Serve pre-minified .min files, strip JavaScript in deployment mode, plug in your own CSS or JavaScript compressor, and rewrite URLs inside stylesheets with CssUrlReplacer.
since: 10
apis: [ResourceSettings, IJavaScriptCompressor, ICssCompressor, DefaultJavaScriptCompressor, CompositeCssCompressor, CompositeJavaScriptCompressor, CssUrlReplacer, NoOpTextCompressor]
keywords: [minify, minification, min.js, min.css, compressor, setJavaScriptCompressor, setCssCompressor, setUseMinifiedResources, gzip, background-image url, base64 embed, embedBase64]
order: 130
source: [resources/resources_15.adoc]
---

Wicket can make the CSS and JavaScript you serve from your packages smaller in two ways: by picking a minified copy of a file that you ship, and by running a compressor over a file while it serves it. Both apply to package resources, the files you reference with `CssResourceReference` and `JavaScriptResourceReference`.

## Ship minified files

Put the minified version next to the original, with `.min` before the extension:

```
com/example/components/
    calendar.js
    calendar.min.js
    calendar.css
    calendar.min.css
```

Keep referencing `calendar.js`. When minified resources are in use, Wicket serves `calendar.min.js` if it exists and falls back to `calendar.js` otherwise. Minified resources are off in development mode, so you debug the readable files, and on in deployment mode. To change that, set it in `init()`:

```java
getResourceSettings().setUseMinifiedResources(false);
```

Files in the web application folder follow the same naming rule with `ContextRelativeResourceReference`, but without the fallback, see [Use files from the web application root]({{ site.baseurl }}/docs/context-resources.html).

Whether the compressors described below run depends on the name you reference: a reference to `calendar.min.js` is never compressed, but when Wicket picks `calendar.min.js` for a reference to `calendar.js`, the compressor runs on the minified file as well.

## Strip JavaScript in deployment mode

In deployment mode Wicket installs `DefaultJavaScriptCompressor`, which removes comments and whitespace from JavaScript package resources. It does not rename variables. For real minification, ship `.min.js` files built by your front-end tooling, or plug in a minifier of your own.

## Plug in a compressor

A compressor is an object with one method, `compress(String)`, that returns the new content. Set one for CSS and one for JavaScript:

```java
@Override
protected void init() {
    super.init();
    if (usesDeploymentConfig()) {
        getResourceSettings().setCssCompressor(css -> MyCssMinifier.minify(css));
        getResourceSettings().setJavaScriptCompressor(js -> MyJsMinifier.minify(js));
    }
}
```

There is no CSS compressor by default. To run several compressors in turn, combine them with `CompositeCssCompressor` or `CompositeJavaScriptCompressor`:

```java
getResourceSettings().setCssCompressor(
    new CompositeCssCompressor(new CssUrlReplacer(), css -> MyCssMinifier.minify(css)));
```

Wicket runs the compressor each time it sends the file, so keep it fast; browsers keep the result for as long as the version in the URL stays the same. A reference with `readBuffered(false)` is streamed and skips the compressor. Setting `null`, or `new NoOpTextCompressor()`, switches compression off.

## Rewrite URLs inside stylesheets

`CssUrlReplacer` is a CSS compressor that does not compress. It finds the relative `url(…)` references in a stylesheet and replaces them with Wicket URLs for the package resources they point to, including the version, so images referenced from CSS are cached as long as the CSS itself:

```java
getResourceSettings().setCssCompressor(new CssUrlReplacer());
```

With `mycss.css` in `com/example/res/css/` and an image in `com/example/res/images/`, this rule

```css
body {
    background-image: url('../images/some.png');
}
```

is served as

```css
body {
    background-image: url('../images/some-ver-1712345678000.png');
}
```

Absolute URLs, context-relative URLs that start with `/` and `data:` URLs stay as they are. Pass file names to the constructor, `new CssUrlReplacer(List.of("vendor.css"))`, to leave those stylesheets alone.

Add `?embedBase64` to a URL to embed the image in the stylesheet as a `data:` URL:

```css
.logo {
    background-image: url('../images/logo.png?embedBase64');
}
```

The default Content Security Policy blocks images from `data:` URLs. Allow them with `getCspSettings().blocking().add(CSPDirective.IMG_SRC, "data:")`, see [Configure the Content Security Policy]({{ site.baseurl }}/docs/csp.html).

## Compress responses with gzip

Wicket does not gzip or brotli-compress responses itself. Turn on response compression in the servlet container or in the reverse proxy in front of it; it applies to pages and resources alike.
