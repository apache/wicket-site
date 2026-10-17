---
title: Show images from an external URL
type: howto
topic: resources
summary: Render img and source tags whose URL comes from a model with ExternalImage and ExternalSource, for images on another server or a CDN.
since: 10
apis: [ExternalImage, ExternalSource, Picture, CompoundPropertyModel, CrossOrigin]
keywords: [external image, image URL from model, avatar, CDN image, remote image, img src from database, srcset, picture element, img-src]
order: 150
source: [resources/resources_17.adoc]
---

Use `ExternalImage` when your data holds the address of an image, such as an avatar URL or a product photo on a CDN. Wicket writes the URL from the model into the `src` attribute and does not serve the image itself.

## Show an image whose URL is in a model

Pass a model of the URL. Any `Serializable` value works; Wicket writes its `toString()`:

*UserPanel.java*

```java
public class UserPanel extends GenericPanel<User> {

    public UserPanel(String id, IModel<User> userModel) {
        super(id, userModel);
        IModel<Serializable> avatarUrl = () -> getModelObject().getAvatarUrl();
        add(new ExternalImage("avatar", avatarUrl));
    }
}
```

*UserPanel.html*

```html
<wicket:panel>
    <img wicket:id="avatar" alt="Profile picture"/>
</wicket:panel>
```

The constructor takes an `IModel<Serializable>`, so declare the lambda with that type; a model of `String` does not fit. Because the model is read at render time, the image follows changes to the user, also when you update the panel with Ajax.

With a `CompoundPropertyModel` on a parent, leave out the model and use the property name as the id:

```java
setDefaultModel(new CompoundPropertyModel<>(user));
add(new ExternalImage("avatarUrl"));
```

## Offer several sizes

The third constructor argument is a model of the URLs for `srcset`. Add descriptors with `setXValues` and `sizes` with `setSizes`:

```java
ExternalImage photo = new ExternalImage("photo",
    "https://images.example.com/p/42-640.jpg",
    List.of("https://images.example.com/p/42-640.jpg",
            "https://images.example.com/p/42-1280.jpg"));
photo.setXValues("1x", "2x");
add(photo);
```

Inside a `Picture`, use `ExternalSource` for the `<source>` tags and `setMedia` for the media query:

```java
Picture picture = new Picture("banner");

ExternalSource wide = new ExternalSource("wide",
    List.of("https://images.example.com/banner-wide.jpg"));
wide.setMedia("(min-width: 40em)");
picture.add(wide);

picture.add(new ExternalImage("fallback", "https://images.example.com/banner.jpg"));
add(picture);
```

```html
<picture wicket:id="banner">
    <source wicket:id="wide"/>
    <img wicket:id="fallback" alt="Spring sale"/>
</picture>
```

## Allow the image host in the Content Security Policy

The default Content Security Policy only allows images from your own origin, `img-src 'self'`, so the browser blocks images from another host. Add the host in `init()`:

```java
getCspSettings().blocking().add(CSPDirective.IMG_SRC, "https://images.example.com");
```

See [Configure the Content Security Policy]({{ site.baseurl }}/docs/csp.html).

When a script on the page reads the image, for example to draw it on a canvas, the server must allow cross-origin access and the tag needs a `crossorigin` attribute: `photo.setCrossOrigin(CrossOrigin.ANONYMOUS)`.

For images that you serve yourself, use `Image` with a resource reference instead, see [Serve files from your Java packages]({{ site.baseurl }}/docs/package-resources.html).
