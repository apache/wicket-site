---
title: Keep preview markup out of the output
type: howto
topic: components
summary: Leave sample content in your HTML files so they look complete in a browser or design tool, and make sure Wicket never sends it.
since: 10
apis: []
keywords: [wicket:remove, mock markup, sample data, placeholder content, designer, static preview, dummy content]
order: 100
source: [keepControl/keepControl_7.adoc]
---

Use this when the markup files are also your design: you or a designer open them directly in a browser and want them to show realistic content, while Wicket renders the real content at runtime. Wicket has three places where preview markup is safe.

## Put preview text in the body of a component tag

The body of a tag that a component replaces never reaches the browser. A `Label` replaces its body with the model value, so sample text in it is only for the preview:

```html
<h1 wicket:id="title">Spring sale: 20% off</h1>
<span wicket:id="price">€ 19.95</span>
```

The same goes for a panel: the panel's markup replaces the body of its tag in the page. A border is different, because it keeps the body of its tag and wraps it.

## Remove whole blocks with wicket:remove

Wrap any amount of sample markup in `<wicket:remove>`. Wicket drops it when it reads the file.

```html
<ul>
  <li wicket:id="products"><span wicket:id="name">First product</span></li>
  <wicket:remove>
    <li><span>Second product</span></li>
    <li><span>Third product</span></li>
  </wicket:remove>
</ul>
```

A list rendered by a `ListView` shows one sample item from its own tag; the extra items make the preview look like a real list.

`<wicket:remove>` must have a closing tag, and it must not contain tags with a `wicket:id`. If you move a component tag into it, Wicket stops with `Markup remove regions must not contain Wicket component tags`.

## Use the space outside wicket:panel, wicket:border and wicket:extend

In the file of a panel, a border or a page that extends another page, Wicket uses only the content of `<wicket:panel>`, `<wicket:border>` or `<wicket:extend>`, plus any `<wicket:head>`. Everything around it is yours for previewing: a full page with your stylesheet, a sample header, a parent layout.

*ProductPanel.html*

```html
<!DOCTYPE html>
<html xmlns:wicket="http://wicket.apache.org">
<head>
  <link rel="stylesheet" href="../../../../webapp/css/site.css">
</head>
<body>
  <main>
    <wicket:panel>
      <h2 wicket:id="name">Garden chair</h2>
      <p wicket:id="description">Weatherproof teak.</p>
    </wicket:panel>
  </main>
</body>
</html>
```

The `<link>` above only works when you open the file from disk; it is never rendered. The panel's CSS for the real page comes from a header contribution; see [Add CSS and JavaScript to a page]({{ site.baseurl }}/docs/add-css-javascript.html).

Inside a border, the content of `<wicket:body>` is preview content as well:

```html
<wicket:border>
  <div class="box">
    <wicket:body>Sample content that the page will put here.</wicket:body>
  </div>
</wicket:border>
```

For every tag mentioned here, see [Wicket tags and attributes]({{ site.baseurl }}/docs/wicket-tags.html).
