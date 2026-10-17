---
title: Pass parameters to a page
type: howto
topic: links
summary: Put values in the URL of a page with PageParameters, read them in the page constructor and convert them to the types you need.
since: 10
apis: [PageParameters, StringValue]
keywords: [query string, request parameter, URL parameter, named parameter, indexed parameter, fragment, getPageParameters, bookmarkable page]
order: 10
source: [urls/urls_1.adoc]
---

You need page parameters when the URL itself has to carry data: a link in an email that confirms a subscription, a product page that people bookmark, a search page that other sites link to. Inside your application, passing objects or models to a page constructor is usually simpler.

## Build the parameters

`PageParameters` holds name-value pairs, like a query string. `add` and `set` both return the `PageParameters`, so you can chain them. Values are stored as strings; Wicket calls `toString()` on what you pass.

```java
PageParameters parameters = new PageParameters()
    .add("id", 42)
    .add("tab", "reviews");
```

`set(name, value)` replaces any value the name already has. `add(name, value)` appends another value, so `add("tag", "red").add("tag", "blue")` produces `?tag=red&tag=blue`. `remove(name)` deletes a parameter.

## Send the user to a page with parameters

Call `setResponsePage` with the page class and the parameters, for example in the `onClick` of a link or the `onSubmit` of a form:

```java
setResponsePage(ProductPage.class, new PageParameters().add("id", product.getId()));
```

To render a plain link to the page without a click handler, use a `BookmarkablePageLink`, described in [Link to a page]({{ site.baseurl }}/docs/bookmarkable-links.html).

Without a mount, the URL contains the class name: `/wicket/bookmarkable/com.example.ProductPage?id=42&tab=reviews`. [Give pages readable URLs]({{ site.baseurl }}/docs/mount-pages.html) shows how to turn this into `/products/42`.

## Read the parameters in the page

Give the page a constructor that takes `PageParameters` and pass them to `super`. The page keeps them, so `getPageParameters()` returns them later, and Wicket uses them when it builds the URL of the page.

*ProductPage.java*

```java
public class ProductPage extends WebPage {

    public ProductPage(PageParameters parameters) {
        super(parameters);

        long id = parameters.get("id").toLong();
        // products is your own data access service
        IModel<Product> product = LoadableDetachableModel.of(() -> products.find(id));

        add(new Label("name", product.map(Product::getName)));
    }
}
```

A page with a `PageParameters` constructor, or with a constructor without arguments, is bookmarkable: Wicket can create it from the URL alone, without anything in the session.

## Convert a parameter to a number, date or enum

`get(name)` never returns `null`. It returns a `StringValue`, which is empty when the parameter is missing, and which converts the text for you:

| Method | Missing parameter | Text that does not convert |
|---|---|---|
| `toLong()`, `toInt()`, `toBoolean()`, `toEnum(Class)` | throws `StringValueConversionException` | throws `StringValueConversionException` |
| `toLong(42)`, `toInt(1)`, `toEnum(Tab.INFO)` | returns the default | returns the default |
| `toOptionalLong()`, `toOptionalInteger()`, `toOptionalString()` | returns `null` | throws `StringValueConversionException` |
| `toString()` | returns `null` | — |
| `isNull()`, `isEmpty()` | `true` | — |

Parameters come from the user, who can edit the URL. Decide what a missing or broken value means. To answer with a 404, throw an `AbortWithHttpErrorCodeException`:

```java
Long id = parameters.get("id").toOptionalLong();
if (id == null) {
    throw new AbortWithHttpErrorCodeException(404);
}
```

`getValues(name)` returns all values of a parameter that occurs more than once, as a `List<StringValue>`.

## Use indexed parameters

Besides named parameters, `PageParameters` holds indexed parameters. Wicket renders them as path segments after the page path, before the query string:

```java
PageParameters parameters = new PageParameters()
    .set(0, "2026")
    .set(1, "october")
    .add("sort", "date");
// /archive/2026/october?sort=date when ArchivePage is mounted at /archive
```

Read them with `get(0)`, `get(1)`, and so on. A mount path with placeholders such as `/archive/${year}/${month}` gives the same URL with named parameters, which are easier to read in code.

## Add a fragment to the URL

> Since Wicket 10.4, `PageParameters` supports the fragment of a URL, the part after `#`.
{: .since}

```java
PageParameters parameters = new PageParameters().add("id", 42);
parameters.setFragment("reviews");
setResponsePage(ProductPage.class, parameters);
// ...?id=42#reviews
```

Browsers do not send the fragment to the server, so you can set it on outgoing URLs but not read it from an incoming request.

## Build a full URL for an email

A confirmation link in an email needs the protocol and host as well. `mapUrlFor` builds the URL of a page with its parameters, and the URL renderer of the request cycle makes it absolute:

```java
RequestCycle cycle = RequestCycle.get();
Url url = cycle.mapUrlFor(ConfirmPage.class, new PageParameters().add("token", token));
String link = cycle.getUrlRenderer().renderFullUrl(url);
```
