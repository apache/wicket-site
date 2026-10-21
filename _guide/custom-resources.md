---
title: Generate a resource in code
type: howto
topic: resources
summary: Build files on request, such as a CSV export, a PDF or an image, by extending AbstractResource or writing a lambda, and offer them for download with ResourceLink.
since: 10
apis: [AbstractResource, ResourceResponse, WriteCallback, IResource, ResourceLink, ByteArrayResource, DynamicImageResource, ContentDisposition, ResourceReference]
keywords: [dynamic resource, download, export, CSV, PDF, generate file, file download, attachment, Content-Disposition, content type, newResourceResponse, writeData, lambda resource]
order: 90
source: [resources/resources_10.adoc, resources/resources_12.adoc]
---

Write a resource when the application has to hand out a file that does not exist until someone asks for it: an export of the rows on screen, a generated invoice, a chart. A resource answers its own request, so it can write any content type, outside the page.

## Write the resource

Extend `AbstractResource` and implement `newResourceResponse`. Describe the response in a `ResourceResponse` and write the content in a `WriteCallback`:

*OrdersCsvResource.java*

```java
public class OrdersCsvResource extends AbstractResource {

    @Override
    protected ResourceResponse newResourceResponse(Attributes attributes) {
        ResourceResponse response = new ResourceResponse();
        response.setContentType("text/csv");
        response.setTextEncoding("UTF-8");
        response.setFileName("orders.csv");
        response.setContentDisposition(ContentDisposition.ATTACHMENT);
        response.disableCaching();

        response.setWriteCallback(new WriteCallback() {
            @Override
            public void writeData(Attributes attributes) throws IOException {
                List<Order> orders = OrderService.get().findForCurrentUser();
                StringBuilder csv = new StringBuilder("number;date;total\n");
                for (Order order : orders) {
                    csv.append(order.getNumber()).append(';')
                        .append(order.getDate()).append(';')
                        .append(order.getTotal()).append('\n');
                }
                attributes.getResponse().write(csv.toString().getBytes(StandardCharsets.UTF_8));
            }
        });
        return response;
    }
}
```

`ContentDisposition.ATTACHMENT` makes the browser save the file under the name from `setFileName`; `INLINE` shows it in the browser when it can. Wicket calls `writeData` only when the content has to be sent, so do the expensive work there. For large output, write to `attributes.getResponse().getOutputStream()` instead of building it in memory.

To refuse a request, return a response with an error code, for example `new ResourceResponse().setError(404)`.

## Offer it as a download link

Give a `ResourceLink` the resource:

*OrdersPage.java*

```java
add(new ResourceLink<Void>("export", new OrdersCsvResource()));
```

*OrdersPage.html*

```html
<a wicket:id="export">Download as CSV</a>
```

The resource is stored in the link and the link's URL points at the page, which makes the page stateful. To keep the page stateless, or to give the file a URL that works without the page, link to a resource reference instead:

```java
private static final ResourceReference ORDERS_CSV =
    ResourceReference.of("orders.csv", OrdersCsvResource::new);

add(new ResourceLink<Void>("export", ORDERS_CSV));
```

`ResourceReference.of` creates a reference whose resource comes from the supplier. The link registers the reference with the application when it renders; to choose the URL yourself, mount the reference as in [Give a resource a URL]({{ site.baseurl }}/docs/mount-resources.html). A reference serves all users, so the resource must find the current user's data while it responds, as the example does, and not hold it in a field.

## Write a resource as a lambda

`IResource` has a single method, so a small resource can be a lambda that writes to the response:

```java
IResource ping = attributes -> attributes.getResponse().write("pong");
```

A lambda sets no content type, file name or cache headers. Use it for plain text or for tests, and `AbstractResource` for anything a browser should handle properly.

## Serve bytes you already have

When the content is already in a byte array, for example a PDF from a report library, use `ByteArrayResource` with the content type and an optional file name:

```java
byte[] pdf = invoiceService.render(invoiceId);
add(new ResourceLink<Void>("invoice",
    new ByteArrayResource("application/pdf", pdf, "invoice-" + invoiceId + ".pdf")));
```

The byte array becomes part of the link and is serialized with the page, so keep this for small files. For a file on disk, `DownloadLink` takes a `File` or a model of one.

## Generate an image

`DynamicImageResource` turns bytes into an image response; implement `getImageData`. Use `toImageData` to encode a `BufferedImage` in the format you pass to the constructor:

```java
public class BadgeImage extends DynamicImageResource {

    private final int level;

    public BadgeImage(int level) {
        super("png");
        this.level = level;
    }

    @Override
    protected byte[] getImageData(Attributes attributes) {
        BufferedImage image = new BufferedImage(120, 30, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g = image.createGraphics();
        g.drawString("Level " + level, 10, 20);
        g.dispose();
        return toImageData(image);
    }
}
```

Pass it to an `Image`: `add(new Image("badge", new BadgeImage(3)))`.
