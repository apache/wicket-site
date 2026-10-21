---
title: Give a resource a URL
type: howto
topic: resources
summary: Mount a resource reference on a path of your choice with mountResource, read path and query parameters in the resource, and link to the mounted URL.
since: 10
apis: [WebApplication, ResourceMapper, ResourceReference, ResourceLink, PageParameters]
keywords: [mountResource, resource URL, fixed URL, REST endpoint, feed URL, robots.txt, favicon, placeholder, path parameter, urlFor]
order: 100
source: [resources/resources_11.adoc, resources/resources_12.adoc]
---

Mount a resource when its URL matters: a feed that readers subscribe to, a file that another system downloads, an export that users bookmark, or a well-known path such as `/robots.txt`. Without a mount, the URL of a resource starts with `wicket/resource/` and contains a class name.

## Mount a resource reference

Call `mountResource` in `init()` with the path and a resource reference. `ResourceReference.of` turns a supplier of the resource into a reference:

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();
    mountResource("/exports/orders.csv",
        ResourceReference.of("orders.csv", OrdersCsvResource::new));
}
```

A request for `/exports/orders.csv` is now answered by the resource, and every link to the reference uses that URL. `OrdersCsvResource` is the resource from [Generate a resource in code]({{ site.baseurl }}/docs/custom-resources.html).

A mounted resource serves all users of the application. Keep no per-user state in it, and check in the resource whether the current user may see the data, because anyone can type the URL.

The path must not start with a segment that Wicket reserves for itself, such as `wicket`.

## Mount a file from a package

A package resource can be mounted too, so that a fixed path answers requests that do not come from your pages. Links that Wicket renders to it add the version to the file name, as for any package resource; requests without the version still work.

```java
mountResource("/robots.txt", new PackageResourceReference(WicketApplication.class, "robots.txt"));
mountResource("/favicon.ico", new PackageResourceReference(WicketApplication.class, "favicon.ico"));
```

The package resource guard still applies, so the file type must be one it serves; see [Control which package resources are served]({{ site.baseurl }}/docs/package-resource-guard.html).

## Put parameters in the path

A segment written as `${name}` is a placeholder. Wicket takes the value from the URL and passes it to the resource as a named parameter:

```java
mountResource("/invoices/${number}", ResourceReference.of("invoice", InvoicePdfResource::new));
```

In the resource, read it from the attributes:

*InvoicePdfResource.java*

```java
@Override
protected ResourceResponse newResourceResponse(Attributes attributes) {
    String number = attributes.getParameters().get("number").toString("");
    Invoice invoice = InvoiceService.get().findForCurrentUser(number);
    if (invoice == null) {
        return new ResourceResponse().setError(404);
    }

    byte[] pdf = InvoiceService.get().renderPdf(invoice);
    ResourceResponse response = new ResourceResponse();
    response.setContentType("application/pdf");
    response.setFileName("invoice-" + number + ".pdf");
    response.setWriteCallback(new WriteCallback() {
        @Override
        public void writeData(Attributes attributes) throws IOException {
            attributes.getResponse().write(pdf);
        }
    });
    return response;
}
```

Segments after the mount path become indexed parameters, and a query string becomes named parameters, as for pages: `/invoices/2024-0042?download=true`. [Pass parameters to a page]({{ site.baseurl }}/docs/page-parameters.html) shows how to read both kinds.

## Link to a mounted resource

Keep the reference in a constant, so links and the mount use the same instance, and pass parameters with `PageParameters`:

*Resources.java*

```java
public final class Resources {
    public static final ResourceReference INVOICE =
        ResourceReference.of("invoice", InvoicePdfResource::new);

    private Resources() {
    }
}
```

*WicketApplication.java*

```java
mountResource("/invoices/${number}", Resources.INVOICE);
```

*InvoicePanel.java*

```java
add(new ResourceLink<Void>("pdf", Resources.INVOICE,
    new PageParameters().add("number", invoice.getNumber())));
```

The link renders `/invoices/2024-0042`. To get the URL as text, for example for an e-mail, use `RequestCycle.get().urlFor(Resources.INVOICE, parameters)`, or `Component#urlFor` inside a component. Links to resource references are stateless, so they work on stateless pages.
