---
title: Serve files from your Java packages
type: howto
topic: resources
summary: Keep images, media and other files next to the component that uses them and serve them with PackageResourceReference, from Java or from markup.
since: 10
apis: [PackageResourceReference, Image, Picture, Source, InlineImage, Video, Audio]
keywords: [package resource, classpath resource, image in jar, img src, responsive images, srcset, picture element, base64 image, data URI, video, audio, localized image]
order: 20
source: [resources/resources_3.adoc]
---

Put a file in the Java package of the component that uses it when the component should work wherever it is added, without anyone copying files into the web application. Wicket serves such *package resources* from the classpath and writes the URLs for you.

## Put the file next to the class

Place the file in the same package as the component. In a Maven project, put it in `src/main/java` next to the class, or in `src/main/resources` under the same package path:

```
src/main/java/com/example/components/
    CalendarPanel.java
    CalendarPanel.html
    calendar.png
```

Files in subfolders work too: name them with a relative path such as `"img/calendar.png"`.

## Show an image from the package

Create a `PackageResourceReference` with a class from the package and the file name, and pass it to an `Image`:

*CalendarPanel.java*

```java
public class CalendarPanel extends Panel {

    public CalendarPanel(String id) {
        super(id);
        add(new Image("icon", new PackageResourceReference(CalendarPanel.class, "calendar.png")));
    }
}
```

*CalendarPanel.html*

```html
<wicket:panel>
    <img wicket:id="icon" alt="Calendar"/>
</wicket:panel>
```

Wicket renders a URL such as `./wicket/resource/com.example.components.CalendarPanel/calendar-ver-1712345678000.png`. The version in the name changes when the file changes, so browsers can cache it safely; [How Wicket serves resources]({{ site.baseurl }}/docs/about-resources.html#urls-that-browsers-can-cache-forever) explains the scheme.

Use the class name, not `getClass()`, as the scope. A subclass in another package would otherwise look for the file in its own package.

For stylesheets and scripts, use `CssResourceReference` and `JavaScriptResourceReference` with a header item instead, see [Add CSS and JavaScript to a page]({{ site.baseurl }}/docs/add-css-javascript.html).

## Refer to package files from markup

Inside `<wicket:link>`, Wicket turns the `src` of `<img>` and `<script>` and the `href` of `<link>` into package resource URLs, relative to the package of the markup file:

```html
<wicket:link>
    <img src="calendar.png" alt="Calendar"/>
    <link rel="stylesheet" href="calendar.css"/>
</wicket:link>
```

Wicket adds the Content Security Policy nonce to the `<script>` and `<link>` tags it rewrites this way, so they also load under the default policy. See [Turn plain links into page links with wicket:link]({{ site.baseurl }}/docs/wicket-link.html).

## Offer several image sizes

`Image` takes more than one reference. Add `srcset` descriptors with `setXValues` and the `sizes` attribute with `setSizes`, and the browser picks the best file:

```java
Image photo = new Image("photo",
    new PackageResourceReference(ProductPanel.class, "photo-small.jpg"),
    new PackageResourceReference(ProductPanel.class, "photo-large.jpg"),
    new PackageResourceReference(ProductPanel.class, "photo-medium.jpg"),
    new PackageResourceReference(ProductPanel.class, "photo-small.jpg"));
photo.setXValues("1024w", "640w", "320w");
photo.setSizes("(min-width: 36em) 33.3vw", "100vw");
add(photo);
```

The first reference becomes `src`, the others make up `srcset`. For art direction, use a `Picture` with `Source` children (both in `org.apache.wicket.markup.html.image`) and an `Image` as fallback:

```java
Picture picture = new Picture("picture");

Source wide = new Source("wide",
    new PackageResourceReference(ProductPanel.class, "banner-wide.jpg"),
    new PackageResourceReference(ProductPanel.class, "banner-wide-2x.jpg"));
wide.setXValues("1x", "2x");
wide.setMedia("(min-width: 40em)");
picture.add(wide);

picture.add(new Image("fallback", new PackageResourceReference(ProductPanel.class, "banner.jpg")));
add(picture);
```

```html
<picture wicket:id="picture">
    <source wicket:id="wide"/>
    <img wicket:id="fallback" alt="Spring sale"/>
</picture>
```

## Embed a small image in the page

`InlineImage` writes the file into the `src` attribute as a base64 `data:` URI, which saves a request for small icons:

```java
add(new InlineImage("logo", new PackageResourceReference(HeaderPanel.class, "logo.png")));
```

The default Content Security Policy only allows images from your own origin (`img-src 'self'`) and blocks `data:` URIs. Allow them in `init()` before you use `InlineImage`:

```java
getCspSettings().blocking().add(CSPDirective.IMG_SRC, "data:");
```

## Stream video and audio

`Video` and `Audio` render `<video>` and `<audio>` tags for a reference. Package resources support HTTP range requests, so the browser can seek. Call `readBuffered(false)` so Wicket streams the file instead of loading it into memory:

```java
add(new Video("intro",
    new PackageResourceReference(TourPage.class, "intro.mp4").readBuffered(false)));
```

```html
<video wicket:id="intro" controls></video>
```

Two defaults stand in the way of media files. The package resource guard does not serve `.mp4`, `.webm` or `.mp3`; allow the extension as described in [Control which package resources are served]({{ site.baseurl }}/docs/package-resource-guard.html). And the default Content Security Policy sets no `media-src`, so it falls back to `default-src 'none'`; add your own origin:

```java
getCspSettings().blocking().add(CSPDirective.MEDIA_SRC, CSPDirectiveSrcValue.SELF);
```

## Serve a localized file

Package resources follow the same naming rules as markup and properties files. With `calendar.png` and `calendar_fr.png` in the package, a session with a French locale gets `calendar_fr.png` from the same reference. Styles and variations work the same way; [Where Wicket looks for texts]({{ site.baseurl }}/docs/bundle-lookup.html) describes the lookup order.
