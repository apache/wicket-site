---
title: Wicket tags and attributes
type: reference
topic: components
summary: Every tag and attribute in the wicket namespace, what it does, which attributes it takes, with a minimal example of each.
since: 10
apis: [MarkupSettings, Panel, Border, Fragment, Enclosure, InlineEnclosure, EnclosureContainer, AutoLabelResolver, AutoLabelTextResolver, WicketMessageResolver, AutoLinkResolver, HtmlHeaderResolver, WicketContainerResolver]
keywords: [wicket namespace, xmlns:wicket, wicket:id, wicket:panel, wicket:extend, wicket:child, wicket:fragment, wicket:border, wicket:body, wicket:enclosure, wicket:container, wicket:message, wicket:link, wicket:head, wicket:header-items, wicket:remove, wicket:label, wicket:for, autolink, stripWicketTags, Unknown tag name with Wicket namespace]
order: 10
source: [layout/layout_2.adoc, layout/layout_4.adoc, keepControl/keepControl_4.adoc, keepControl/keepControl_5.adoc, keepControl/keepControl_6.adoc, keepControl/keepControl_7.adoc, keepControl/keepControl_9.adoc, keepControl/keepControl_10.adoc, i18n/i18n_2.adoc, urls/urls_3.adoc, resources/resources_8.adoc, resources/resources_9.adoc]
---

Wicket reads a small set of tags and attributes from your HTML. They all live in the `wicket` XML namespace. Declare it on the `<html>` tag of every markup file:

```html
<!DOCTYPE html>
<html xmlns:wicket="http://wicket.apache.org">
```

The declaration is optional: Wicket assumes the prefix `wicket` when there is none. It keeps editors and validators quiet, and it lets you choose another prefix. Any namespace URI that starts with `http://wicket.apache.org` works, so `xmlns:w="http://wicket.apache.org"` makes Wicket read `w:id` and `<w:panel>` instead.

## All tags and attributes

| Tag or attribute | Kind | What it does |
|---|---|---|
| [`wicket:id`](#wicketid) | attribute | Attaches an HTML tag to a Java component |
| [`wicket:panel`](#wicketpanel) | tag | Marks the part of a panel's file that is the panel |
| [`wicket:child`](#wicketchild) | tag | Marks where a subclass inserts its markup |
| [`wicket:extend`](#wicketextend) | tag | Marks the markup a subclass contributes to its parent's markup |
| [`wicket:fragment`](#wicketfragment) | tag | Defines inline markup for a `Fragment` |
| [`wicket:border`](#wicketborder) | tag | Marks the part of a border's file that wraps the body |
| [`wicket:body`](#wicketbody) | tag | Marks where a border puts the content it wraps |
| [`wicket:enclosure`](#wicketenclosure) | tag and attribute | Hides surrounding markup together with one component |
| [`wicket:container`](#wicketcontainer) | tag | A component tag that leaves no HTML element in the output |
| [`wicket:message`](#wicketmessage) | tag and attribute | Inserts a localized text, or localizes attribute values |
| [`wicket:label`](#wicketlabel) | tag | Writes the label text of a form component |
| [`wicket:for`](#wicketfor) | attribute | Connects a `<label>` to a form component |
| [`wicket:link`](#wicketlink) | tag | Turns plain links and resource references into Wicket links |
| [`wicket:head`](#wickethead) | tag | Content a panel, border or page contributes to the page `<head>` |
| [`wicket:header-items`](#wicketheader-items) | tag | Marks where in `<head>` Wicket writes header contributions |
| [`wicket:remove`](#wicketremove) | tag | Preview markup that never reaches the browser |

Any other tag in the namespace stops the parser with `Unknown tag name with Wicket namespace`.

## Wicket tags in development and deployment mode

In development mode Wicket tags and `wicket:` attributes stay in the HTML sent to the browser, which helps when you inspect the page. In deployment mode Wicket strips them. The `MarkupSettings#setStripWicketTags(boolean)` setting controls this; the configuration type sets it for you. Browsers ignore unknown tags, but CSS selectors such as `div > p` see the extra elements, so a selector can match in deployment mode and not in development mode. See [Switch between development and deployment mode]({{ site.baseurl }}/docs/deployment-mode.html).

## `wicket:id`

Attaches the tag to the Java component with the same id. Wicket looks for the component among the children of the container whose markup holds the tag, following the nesting of the HTML.

| Rule | Detail |
|---|---|
| Value | The component id. Must not be empty and must not contain `:` or `~`. |
| Uniqueness | Unique among the children of one container. The same id can appear under different parents. |
| Tag without component | Rendering fails with `Unable to find component with id '...'`. |
| Component without tag | Rendering fails in development mode with `The component(s) below failed to render`. |

*HomePage.html*

```html
<h1 wicket:id="title">Placeholder title</h1>
```

*HomePage.java*

```java
add(new Label("title", "Welcome"));
```

The body of the tag is replaced by whatever the component renders. For a `Label`, the placeholder text disappears.

## `wicket:panel`

Marks the part of a panel's markup file that is the panel. Everything outside it is ignored, apart from `<wicket:head>`, so you can surround the panel with a complete HTML page for previewing.

Attributes: none.

*AddressPanel.html*

```html
<html xmlns:wicket="http://wicket.apache.org">
<body>
  <wicket:panel>
    <p><span wicket:id="street"></span>, <span wicket:id="city"></span></p>
  </wicket:panel>
</body>
</html>
```

The panel's own tag in the parent page stays; the content of `<wicket:panel>` replaces its body. See [Build a reusable panel]({{ site.baseurl }}/docs/build-panel.html).

## `wicket:child`

Marks the place in a page's or panel's markup where a subclass inserts its markup. A markup file contains at most one `<wicket:child>`. Write it as an empty tag; Wicket does not allow Wicket tags or components between an opening and a closing `wicket:child`.

Attributes: none.

*BasePage.html*

```html
<body>
  <header>My site</header>
  <main><wicket:child/></main>
</body>
```

See [Markup inheritance]({{ site.baseurl }}/docs/markup-inheritance.html).

## `wicket:extend`

Wraps the markup a subclass contributes to its parent's markup. Wicket merges it into the parent's markup at `<wicket:child>`. Everything outside `<wicket:extend>` is ignored, except `<wicket:head>`. Without `<wicket:extend>`, a subclass's markup file replaces the parent's markup instead of extending it.

Attributes: none.

*ProductPage.html*

```html
<html xmlns:wicket="http://wicket.apache.org">
<body>
  <wicket:extend>
    <h1 wicket:id="name"></h1>
  </wicket:extend>
</body>
</html>
```

If the parent's markup has no `<wicket:child>`, loading fails with `Expected to find <wicket:child/> in base markup`.

## `wicket:fragment`

Defines a piece of markup inside a page's or panel's file that a `Fragment` component renders. The markup is not rendered where it is defined.

| Attribute | Required | Meaning |
|---|---|---|
| `wicket:id` | yes | The fragment id, passed as the second argument of the `Fragment` constructor |

*OrderPage.html*

```html
<div wicket:id="details"></div>

<wicket:fragment wicket:id="shipped">
  <p>Shipped on <span wicket:id="date"></span></p>
</wicket:fragment>
```

*OrderPage.java*

```java
Fragment fragment = new Fragment("details", "shipped", this);
fragment.add(new Label("date", shippedDate));
add(fragment);
```

The third argument is the container whose markup holds the fragment. See [Swap markup with fragments]({{ site.baseurl }}/docs/use-fragments.html).

## `wicket:border`

Marks the part of a `Border`'s markup file that is drawn around the content. Everything outside it is ignored, apart from `<wicket:head>`. It must contain one `<wicket:body>`.

Attributes: none.

*BoxBorder.html*

```html
<wicket:border>
  <div class="box">
    <wicket:body/>
  </div>
</wicket:border>
```

## `wicket:body`

Marks where a border puts the content of the tag it is attached to. Write it as an empty tag, or put preview content inside it; Wicket removes that content.

Attributes: none.

*Page using the border*

```html
<section wicket:id="box">
  <p>This paragraph ends up inside the box.</p>
</section>
```

Components in that content are added with `Border#add`; components in the border's own markup with `Border#addToBorder`. See [Wrap content with a Border]({{ site.baseurl }}/docs/use-borders.html).

## `wicket:enclosure`

Shows or hides a block of markup together with one component inside it. When that component is invisible, the whole block is left out. It exists as a tag and as an attribute.

### As a tag

| Attribute | Required | Meaning |
|---|---|---|
| `child` | only with more than one component inside | Id of the component that controls visibility. A path such as `address:street` reaches a nested component. |

The tag cannot be empty (`<wicket:enclosure/>` is an error). Enclosures can be nested.

```html
<wicket:enclosure child="phone">
  <dt>Phone</dt>
  <dd><span wicket:id="phone"></span> <span wicket:id="phoneType"></span></dd>
</wicket:enclosure>
```

### As an attribute

Put `wicket:enclosure` on any HTML element that can contain other elements. Leave the value empty to let the first component inside control the visibility, or give the controlling component's id. This form keeps its HTML element, gets a markup id, and is updated along with its controlling component in Ajax requests.

```html
<tr wicket:enclosure="">
  <th>Phone</th>
  <td wicket:id="phone"></td>
</tr>
```

If the element has both an `id` and a `wicket:id`, the two must be equal. See [Hide surrounding markup with wicket:enclosure]({{ site.baseurl }}/docs/use-enclosures.html).

## `wicket:container`

A tag for a component that should not produce an HTML element of its own. Use it where an extra `<div>` or `<span>` would be invalid, such as between table rows, or where it would get in the way of your CSS.

| Attribute | Required | Meaning |
|---|---|---|
| `wicket:id` | yes | The component id |

Do not put other attributes on it: in deployment mode the whole tag is stripped, attributes included. Wicket logs a warning in development mode when it finds any.

```html
<table>
  <wicket:container wicket:id="rows">
    <tr><td wicket:id="name"></td></tr>
    <tr><td wicket:id="description"></td></tr>
  </wicket:container>
</table>
```

## `wicket:message`

Inserts a text from the resource bundles, or puts localized texts into attribute values. See [Translate component texts]({{ site.baseurl }}/docs/localize-components.html) for where the texts come from.

### As a tag

| Attribute | Required | Meaning |
|---|---|---|
| `key` | yes | The resource key |
| `escape` | no | `true` escapes the text for HTML. Default: the text is written as is. |

```html
<wicket:message key="greeting">Hello</wicket:message>
```

The tag body is preview content and is replaced by the text. When the key is missing, Wicket throws an exception. With `ResourceSettings#setThrowExceptionOnMissingResource(false)` it logs a warning and renders the body instead.

Components nested in the tag are rendered into the text in place of `${id}` variables:

```html
<wicket:message key="balance">
  <span wicket:id="amount"></span>
  <a wicket:id="details"><wicket:message key="here"/></a>
</wicket:message>
```

```properties
balance=Your balance is ${amount}. Click ${details} for the details.
here=here
```

### As an attribute

Sets attributes of the tag it is on to localized texts. The value is a comma-separated list of `attribute:key` pairs. An existing value of the attribute is the default when the key is missing.

```html
<input type="submit" value="Send" wicket:message="value:send.label, title:send.title">
```

## `wicket:label`

Writes the label text of a form component. It looks for the text in this order: the component's label model, the resource key Wicket uses for the component's label, the resource named by `key`, and finally its own body. When the body is used, it becomes the component's label, so validation messages use it too.

| Attribute | Required | Meaning |
|---|---|---|
| `for` | outside a `wicket:for` label | Id or path of the form component |
| `key` | no | Resource key to use when the component has no label |
| `escape` | no | `false` writes the label without escaping. Default: escaped. Accepts `true`/`false`, `on`/`off`, `yes`/`no`, `y`/`n`, `1`/`0`. |

```html
<label wicket:for="email"><wicket:label>Email address</wicket:label></label>
<input type="email" wicket:id="email">

<wicket:label for="phone" key="phone.label"/>
```

## `wicket:for`

Connects a `<label>` tag to a form component without a component of its own. Wicket renders the `for` attribute with the form component's markup id and turns on `setOutputMarkupId(true)` for it. It also adds CSS classes to the label: `required` when the component is required, `error` when it failed validation, and `disabled` when it is not enabled. Override the class names with the resource keys `AutoLabel.CSS.required`, `AutoLabel.CSS.error` and `AutoLabel.CSS.disabled`.

| Rule | Detail |
|---|---|
| Value | Id of the form component, or a path relative to the label's container. `..` steps up to the parent container. When the path does not resolve, Wicket searches for the id in every container from the label up to the page. |
| Allowed on | `<label>` only, and not together with `wicket:id` |
| `wicket:auto` | `true` re-renders the label whenever the form component is updated with Ajax. `MarkupSettings#setUpdateAutoLabelsTogetherWithFormComponent(true)` does this for every label. |

```html
<label wicket:for="name">Name</label>
<input type="text" wicket:id="name">
```

## `wicket:link`

Turns links and resource references inside it into Wicket links, without Java code.

| Attribute | Required | Meaning |
|---|---|---|
| `autolink` | no | `false` turns automatic linking off inside the tag. Default: `true`. |

Inside the tag, Wicket handles every element without a `wicket:id` whose `href` or `src` holds no `:` (so no `https:` or `mailto:` URLs):

| Element | Attribute | Result |
|---|---|---|
| `<a>` | `href` ending in `.html` | A link to the page class with that name, relative to the package of the current page, or absolute such as `/com/example/HomePage.html`. A link to the current page renders without `href`. |
| `<a>`, `<link>` | `href` to another file | A URL for the package resource |
| `<script>`, `<img>`, `<input>`, `<embed>` | `src` | A URL for the package resource |

```html
<wicket:link>
  <a href="HomePage.html">Home</a>
  <img src="logo.png" alt="Logo">
</wicket:link>
```

An empty `<wicket:link/>` changes the setting until the end of the file or the next `<wicket:link>`. `MarkupSettings#setAutomaticLinking(true)` turns automatic linking on for all markup. See [Turn plain links into page links with wicket:link]({{ site.baseurl }}/docs/wicket-link.html).

## `wicket:head`

Wraps content that a panel, border or page contributes to the `<head>` of the page: `<style>`, `<script>`, `<meta>` and similar. Place it outside `<wicket:panel>`, `<wicket:border>` and `<wicket:extend>`; inside them, Wicket throws `Mis-placed <wicket:head>`.

| Attribute | Required | Meaning |
|---|---|---|
| `wicket:scope` | no | A name that groups head sections when Wicket decides whether a section was already written. Rarely needed. |

The content is written once per component class, however many instances of the component are on the page. With markup inheritance, the `<wicket:head>` sections of the parent and the subclass are both included.

*AddressPanel.html*

```html
<wicket:head>
  <style>.address { font-style: normal; }</style>
</wicket:head>
<wicket:panel>
  <address class="address" wicket:id="text"></address>
</wicket:panel>
```

For CSS and JavaScript files, contributing from Java is more flexible; see [Add CSS and JavaScript to a page]({{ site.baseurl }}/docs/add-css-javascript.html).

## `wicket:header-items`

Marks the place inside a page's `<head>` where Wicket writes all header contributions, from Java and from `<wicket:head>`. Without it they go at the end of `<head>`. Use it when your own tags must come before or after Wicket's.

Attributes: none. Allowed only inside the page's `<head>`, at most once.

```html
<head>
  <meta charset="UTF-8">
  <wicket:header-items/>
  <script src="patch-after-wicket.js"></script>
</head>
```

See [Control the order of header items]({{ site.baseurl }}/docs/header-order.html).

## `wicket:remove`

Wraps preview markup that Wicket drops when it reads the file. Use it for sample content a designer needs to see in the static file.

Attributes: none. It must have a closing tag, and it must not contain tags with a `wicket:id`.

```html
<ul>
  <li wicket:id="items"><span wicket:id="name"></span></li>
  <wicket:remove>
    <li>Second sample item</li>
    <li>Third sample item</li>
  </wicket:remove>
</ul>
```

See [Keep preview markup out of the output]({{ site.baseurl }}/docs/stub-markup.html).
