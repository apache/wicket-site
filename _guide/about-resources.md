---
title: How Wicket serves resources
type: explanation
topic: resources
summary: What resources and resource references are, why components carry their own CSS and JavaScript, and how Wicket gives every file a cacheable URL.
since: 10
apis: [IResource, ResourceReference, PackageResourceReference, AbstractResource, IHeaderResponse, ResourceAggregator, ResourceReferenceRegistry]
keywords: [static files, assets, static vs dynamic, resource URL, wicket/resource, caching, cache busting, versioning, -ver-, header contribution]
order: 10
source: [resources/resources_1.adoc, resources/resources_2.adoc]
---

A web page is more than its HTML. The browser also fetches stylesheets, scripts, images and fonts, and an application often hands out files it builds on request: a CSV export, a PDF invoice, a chart. Wicket calls all of these *resources*, and it serves them through the same request handling that serves pages.

## A resource answers a request of its own

A resource is an object that implements `IResource`. That interface has one method, `respond(IResource.Attributes)`, and the attributes give the resource the request, the response and the page parameters. Whatever the resource writes to the response is what the browser receives.

Resources come in two flavours, and the difference is only in how much work `respond` does:

- A **static** resource sends a file that already exists, such as a stylesheet on the classpath or an image in the web application folder. Wicket ships these as `PackageResource`, `ContextRelativeResource` and `FileSystemResource`.
- A **dynamic** resource builds its content when the request comes in. `CaptchaImageResource` in wicket-extensions draws a new captcha image every time, and an export that writes the rows of a database query is dynamic too. You build these by extending `AbstractResource`, see [Generate a resource in code]({{ site.baseurl }}/docs/custom-resources.html).

`AbstractResource` handles the HTTP side for both: content type, `Content-Disposition`, `Last-Modified`, cache headers and byte ranges for media files. A subclass only describes the response in a `ResourceResponse` and supplies the bytes.

## Resource references name a resource

Components rarely hold a resource directly. They hold a `ResourceReference`: a small, serializable name for a resource, made of a scope class, a name, and optionally a locale, a style and a variation. The reference creates the actual resource only when it is needed, in `getResource()`.

Separating the name from the thing has three effects:

- Wicket can write a URL for a resource while it renders a page, without loading or generating the resource.
- The URL contains the scope and the name, so a later request for that URL can find the reference again. The application keeps references in its `ResourceReferenceRegistry`, and for package files it creates a reference on the fly when a request names one it has not seen yet. A URL for a package resource keeps working after a restart.
- Pages stay small when they are serialized: a component stores a few strings, not file contents.

## Package resources make components self-contained

The usual home for a component's CSS, JavaScript and images is its own Java package, next to its class and its markup. These are *package resources*, served through `PackageResourceReference` and its subclasses `CssResourceReference` and `JavaScriptResourceReference`.

When a component brings its own files, using it means adding it to a page and nothing more. Nobody has to know which stylesheet a date picker needs or copy files into the web application folder. The files travel inside the JAR with the class, and a component library is one dependency. See [Serve files from your Java packages]({{ site.baseurl }}/docs/package-resources.html).

A package also holds class files and configuration that must never reach a browser. The package resource guard decides which files Wicket serves at all; by default only common web file types such as `.css`, `.js`, `.png` and `.woff2` pass. See [Control which package resources are served]({{ site.baseurl }}/docs/package-resource-guard.html).

## URLs that browsers can cache forever

The URL of a package resource looks like this:

```
./wicket/resource/com.example.CalendarPanel/calendar-ver-1712345678000.css
```

After the `wicket/resource` prefix come the scope class and the file name, and Wicket inserts a version into the file name. In development mode the version is the file's last-modified time; in deployment mode it is an MD5 digest of the content, computed once. When a request carries the current version, Wicket answers with headers that let browsers and proxies cache the file for a year.

The version makes that long cache safe. A changed file gets a new version and so a new URL, and the browser fetches it on the next page view. You never rename files to break a cache, and a deployment never serves a stale stylesheet. The caching strategy is a setting, `ResourceSettings#setCachingStrategy`, if you need a different scheme.

## Components ask for what they need

A component declares the files it needs in `renderHead(IHeaderResponse)`, and a behavior does the same in `renderHead(Component, IHeaderResponse)`. They do not write `<link>` or `<script>` tags; they hand *header items* to the header response, and Wicket decides what ends up in the page.

Behind the header response sits the `ResourceAggregator`. It collects the items of every visible component on the page and then:

- renders each file once, however many components ask for it;
- renders the dependencies of an item before the item itself, see [Declare dependencies between resources]({{ site.baseurl }}/docs/resource-dependencies.html);
- swaps members of a bundle for the bundle, see [Combine resources into one bundle]({{ site.baseurl }}/docs/resource-bundles.html);
- sorts the items, with priority items first, see [Control the order of header items]({{ site.baseurl }}/docs/header-order.html).

Because the header is assembled from items rather than written as text, Wicket can also secure it. Its default Content Security Policy allows only scripts and styles that carry the nonce of the current response, and Wicket adds that nonce to every script and style item it renders. A `<script>` you type into the markup gets no nonce, and the browser blocks it. That is why the pages in this topic add JavaScript through header items; see [Configure the Content Security Policy]({{ site.baseurl }}/docs/csp.html). The full list of items is in [Header items]({{ site.baseurl }}/docs/header-items.html).

During an Ajax request the same mechanism runs for the components being updated. Wicket sends their header items along with the new markup, and the browser loads only the files that the page does not have yet.

## Resources and page state

A URL for a resource reference does not involve a page: Wicket finds the reference by its key and lets the resource respond. Such URLs work on stateless pages and from anywhere, including another site.

A `ResourceLink` that you give an `IResource` object instead of a reference works differently. The resource is stored in the link, the link's URL points at the page instance, and the page becomes stateful. Use a reference, a mount or a shared resource when the page must stay stateless; [Stateful and stateless pages]({{ site.baseurl }}/docs/stateful-stateless.html) explains the difference.

A mounted or shared resource is one object for the whole application, used by all users and threads at once. It must not keep state about the current user in its fields; it reads what it needs from the request, the session or a service while it responds.
