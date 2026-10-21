---
title: Link to another site
type: howto
topic: links
summary: Render a link to a URL outside your application with ExternalLink, build the URL from a model, and redirect to another site from code.
since: 10
apis: [ExternalLink, RedirectToUrlException]
keywords: [external URL, absolute URL, href from model, outbound link, target blank, noopener, redirect to external site, context relative]
order: 40
source: [urls/urls_4.adoc]
---

A link to a fixed address on another site needs no component: write the `<a href="https://...">` in the markup. Use an `ExternalLink` when the address, or the text of the link, depends on data.

## Render a link with a computed URL

Give the anchor a `wicket:id`:

*PersonPage.html*

```html
<a wicket:id="search">Search for this person</a>
```

Create the `ExternalLink` with the URL as a string or as a model. A model is evaluated each time the page renders, so the link follows changes in the data:

*PersonPage.java*

```java
IModel<String> searchUrl = personModel.map(person ->
    "https://www.example.org/search?q="
        + URLEncoder.encode(person.getFullName(), StandardCharsets.UTF_8));

add(new ExternalLink("search", searchUrl));
```

Wicket writes the URL into the `href` as it is. Encode values that you put in a query string yourself, as above with `URLEncoder`.

When the model returns `null`, Wicket does not write an `href`.

## Set the text of the link

The markup between the tags is the default text. Pass a third argument to replace it: a string when the URL is a string, a model when the URL is a model.

```java
add(new ExternalLink("search", searchUrl,
    personModel.map(person -> "Search for " + person.getFullName())));
```

The text is escaped before it is written.

## Open the link in a new tab

Put the attributes in the markup, where they belong to the design:

```html
<a wicket:id="search" target="_blank" rel="noopener noreferrer">Search</a>
```

`rel="noreferrer"` also keeps the browser from sending the URL of your page, including a session id in the URL, to the other site. To set attributes from code instead, use an `AttributeModifier`; see [Change a tag's attributes]({{ site.baseurl }}/docs/modify-attributes.html).

## Link to a file in your web application

`ExternalLink` also links to paths of your own web application that Wicket does not serve, such as a PDF under the webapp root. Call `setContextRelative(true)`, and Wicket makes the path relative to the context root, wherever the current page is:

```java
add(new ExternalLink("manual", "/docs/manual.pdf").setContextRelative(true));
```

## Redirect to another site from code

When the decision is made on the server, for example after a form submit, throw a `RedirectToUrlException`. Wicket stops processing the request and sends a redirect to the URL:

```java
@Override
protected void onSubmit() {
    String url = paymentProvider.startPayment(order);
    throw new RedirectToUrlException(url);
}
```
