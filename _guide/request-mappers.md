---
title: Request mappers
type: reference
topic: links
summary: The request mappers that turn URLs into request handlers and back, the mount methods of WebApplication, and the syntax of mount paths.
since: 10
apis: [IRequestMapper, CompoundRequestMapper, SystemMapper, MountedMapper, PackageMapper, BookmarkableMapper, PageInstanceMapper, HomePageMapper, ResourceMapper, ResourceReferenceMapper, CryptoMapper, HttpsMapper, BufferedResponseMapper, IPageParametersEncoder, PageParametersEncoder, UrlPathPageParametersEncoder, IMapperContext, DefaultMapperContext, WebApplication]
keywords: [URL mapping, routing, mount, mountPage, mountPackage, mountResource, unmount, placeholder, path parameter, compatibility score, root request mapper, URL format]
order: 10
source: [urls/urls_6.adoc, requestProcessing/requestProcessing_3.adoc]
---

A request mapper works in two directions. For an incoming request it returns the request handler that produces the response, or `null` when it does not recognize the URL. When Wicket renders a link, form or resource reference, it asks the mappers for the URL of a request handler. How the handler then processes the request is described in [Request processing]({{ site.baseurl }}/docs/request-processing.html).

## IRequestMapper

| Method | Called | Returns |
|---|---|---|
| `getCompatibilityScore(Request)` | for every incoming request, on every mapper | how well the mapper fits the URL; higher is tried first |
| `mapRequest(Request)` | on the mappers in order of score, until one returns a handler | an `IRequestHandler`, or `null` |
| `mapHandler(IRequestHandler)` | when Wicket needs a URL for a handler | a `Url`, or `null` |

`IRequestMapperDelegate` marks a mapper that wraps another one; `getDelegateMapper()` returns the wrapped mapper.

## How Wicket picks a mapper

The application has one root mapper. By default it is a `SystemMapper`, a `CompoundRequestMapper` that holds the built-in mappers and every mount.

For an incoming request, a `CompoundRequestMapper` asks all its mappers for their score and calls `mapRequest` on them from the highest score down. When two mappers have the same score, the one added last goes first. To generate a URL, it calls `mapHandler` on its mappers from the last added to the first, and uses the first URL it gets. Mounts are added after the built-in mappers, so they win.

| Mapper | Score |
|---|---|
| `MountedMapper`, `PackageMapper` | 0 when the URL does not start with the mount path; otherwise it grows with the length of the mount path, where fixed segments weigh more than placeholders and optional placeholders do not count |
| `ResourceMapper` | as `MountedMapper`, minus 1, so that pages win over resources on the same path |
| `BookmarkableMapper`, `PageInstanceMapper`, `BufferedResponseMapper` | `Integer.MAX_VALUE` when the URL is theirs, otherwise 0 |
| `HomePageMapper` | `Integer.MIN_VALUE + 1`, the last resort |

## Mount methods

Methods of `WebApplication`, called in `init()`:

| Method | Adds | Returns |
|---|---|---|
| `mountPage(String path, Class<T> pageClass)` | `MountedMapper` | the `MountedMapper` |
| `mountPackage(String path, Class<P> pageClass)` | `PackageMapper` for the package of `pageClass` | the `PackageMapper` |
| `mountResource(String path, ResourceReference reference)` | `ResourceMapper`; also registers the reference | the `ResourceMapper` |
| `mount(IRequestMapper mapper)` | any mapper | — |
| `unmount(String path)` | removes every mapper that matches the path | — |

`mount` adds the mapper to `getRootRequestMapperAsCompound()`. If the root mapper is not a compound mapper, for example because you wrapped it in a `CryptoMapper`, that method wraps the root in a new `SystemMapper` first. Mount before you wrap the root mapper.

Methods of `Application`:

| Method | Description |
|---|---|
| `getRootRequestMapper()` | the root mapper |
| `setRootRequestMapper(IRequestMapper)` | replaces the root mapper; used to wrap it in a `CryptoMapper` or `HttpsMapper` |
| `getRootRequestMapperAsCompound()` | the root mapper as an `ICompoundRequestMapper` |
| `getMapperContext()` | the `IMapperContext`, created once by `newMapperContext()` |

## Mount path syntax

Mount paths of `mountPage`, `mountPackage`, `mountResource` and the mapper constructors are made of segments separated by `/`. A leading `/` is optional.

| Segment | Meaning | Example |
|---|---|---|
| `name` | fixed text that must match | `/products` |
| `${name}` | required named parameter; the URL must have this segment | `/products/${id}` |
| `#{name}` | optional named parameter; the segment is left out when the parameter is missing | `/products/${id}/#{tab}` |

| Rule | |
|---|---|
| A placeholder is a whole segment | `/item-${id}` is fixed text, not a placeholder |
| Values of placeholders | become named page parameters, read with `parameters.get("id")` |
| Named parameters without a placeholder | are encoded by the parameter encoder; by default in the query string |
| Segments after the mount path | become indexed parameters: `/products/42` on a mount at `/products` gives `get(0)` = `42` |
| Matching order | left to right; required parameters are matched before optional ones, optional ones eagerly from the left |
| Reserved segments | a mount path must not start with a segment of the mapper context, `wicket` by default |
| Missing required parameter | `mapHandler` returns `null`: no URL for this mount, the next mapper is tried |

```java
mountPage("/blog/${year}/#{month}/#{slug}", BlogPage.class);
mountResource("/export/${format}", new ExportResourceReference());
```

## Page mappers

| Mapper | URLs | Notes |
|---|---|---|
| `MountedMapper` | `/products/42`, `/products/42?3`, `/products/42?3-1.-form` | one page class on a mount path; constructors take a page class or a `Supplier` of one, and optionally an `IPageParametersEncoder` |
| `PackageMapper` | `/admin/UserAdminPage`, `/admin/UserAdminPage?3` | all bookmarkable pages of one package; the last segment is the simple class name. Constructor takes a `PackageName` |
| `HomePageMapper` | `/` | the page from `Application#getHomePage()` |
| `BookmarkableMapper` | `/wicket/bookmarkable/com.example.ProductPage?id=42` | any bookmarkable page that is not mounted. Disabled for requests by `SecuritySettings#setEnforceMounts(true)` |
| `PageInstanceMapper` | `/wicket/page?3`, `/wicket/page?3-1.-form` | a page instance from the page store, for pages that were not created from a bookmarkable URL |
| `BufferedResponseMapper` | the URL of a response stored by `REDIRECT_TO_BUFFER` | see [Redirects after a request]({{ site.baseurl }}/docs/redirects.html) |

The number after `?` is the page id. After it may follow the render count and the path of the component whose listener the URL calls, such as `3-1.-form`.

## Resource mappers

| Mapper | URLs | Notes |
|---|---|---|
| `ResourceMapper` | `/export/csv?from=2026-01-01` | one `ResourceReference` on a mount path; placeholders allowed |
| `ResourceReferenceMapper` | `/wicket/resource/com.example.HomePage/logo.png?en` | resource references that are not mounted; adds locale, style and variation to the query string. Wraps a `BasicResourceReferenceMapper` in a `ParentPathReferenceRewriter` |
| `HashBasedResourceReferenceMapper` | `/wicket/resource/<hash>/logo.png` | alternative to `ResourceReferenceMapper` that replaces the scope class name with a hash |
| `UrlResourceReferenceMapper` | — | generates URLs for `UrlResourceReference`, which points to an external URL |
| `ParentPathReferenceRewriter` | — | wraps a mapper and replaces `../` in resource paths with the placeholder from `ResourceSettings#getParentFolderPlaceholder()` |

## Wrapping mappers

These mappers wrap another mapper, usually the root mapper, with `setRootRequestMapper(new XMapper(getRootRequestMapper(), ...))`.

| Mapper | Constructor | What it does |
|---|---|---|
| `CryptoMapper` | `(IRequestMapper, Application)`, `(IRequestMapper, Supplier<ICrypt>)` | encrypts the URLs of the wrapped mapper; see [Encrypt URLs]({{ site.baseurl }}/docs/encrypt-urls.html) |
| `HttpsMapper` | `(IRequestMapper, HttpsConfig)` | redirects to HTTPS for pages annotated with `@RequireHttps`, and back to HTTP for others; see [Require HTTPS]({{ site.baseurl }}/docs/https.html) |

## Compound mappers

| Class | Description |
|---|---|
| `ICompoundRequestMapper` | a mapper made of other mappers: `add(IRequestMapper)`, `remove(IRequestMapper)`, and iteration |
| `CompoundRequestMapper` | the implementation; selects by score as described above |
| `SystemMapper` | the default root mapper. Holds, added in this order: `PageInstanceMapper`, `BookmarkableMapper`, `HomePageMapper`, `ResourceReferenceMapper`, `UrlResourceReferenceMapper`, the mapper for `RestartResponseAtInterceptPageException`, `BufferedResponseMapper`. Override its `new...Mapper()` factory methods to replace one of them |

Other features add their own mappers, such as `ReportCSPViolationMapper` for the reports of the [Content Security Policy]({{ site.baseurl }}/docs/csp.html).

## Parameter encoders

An `IPageParametersEncoder` turns `PageParameters` into the part of a `Url` after the mount path, and back. `MountedMapper`, `PackageMapper`, `ResourceMapper` and `BookmarkableMapper` accept one in their constructor.

| Encoder | Named parameters | Indexed parameters |
|---|---|---|
| `PageParametersEncoder` (default) | query string: `?id=42&tab=reviews` | path segments: `/42/reviews` |
| `UrlPathPageParametersEncoder` | path segments as name-value pairs: `/id/42/tab/reviews`; no POST parameters | not supported; encoding throws an exception |

```java
mount(new MountedMapper("/search", SearchPage.class, new UrlPathPageParametersEncoder()));
```

## Mapper context

`IMapperContext` provides the reserved segments of unmounted URLs and creates page instances for the mappers. Override `Application#newMapperContext()` to change the segments, usually by extending `DefaultMapperContext`.

| Method | Default | Used in |
|---|---|---|
| `getNamespace()` | `wicket` | first segment of every unmounted URL |
| `getBookmarkableIdentifier()` | `bookmarkable` | `/wicket/bookmarkable/...` |
| `getPageIdentifier()` | `page` | `/wicket/page?3` |
| `getResourceIdentifier()` | `resource` | `/wicket/resource/...` |

## Generate URLs in code

| Method | Returns |
|---|---|
| `RequestCycle#urlFor(Class<C> pageClass, PageParameters)` | the URL of a bookmarkable page, relative to the current page, as `CharSequence` |
| `RequestCycle#urlFor(IRequestHandler)` | the URL of any handler |
| `RequestCycle#urlFor(ResourceReference, PageParameters)` | the URL of a resource |
| `RequestCycle#mapUrlFor(...)` | the same, as a `Url` object |
| `Component#urlFor(...)` | shortcuts to the request cycle methods |
| `RequestCycle#getUrlRenderer().renderFullUrl(Url)` | the URL with protocol, host and port |
