---
title: Give pages readable URLs
type: howto
topic: links
summary: Mount pages on paths of your choice, put page parameters in path segments with placeholders, and mount a whole package at once.
since: 10
apis: [WebApplication, MountedMapper, PackageMapper, UrlPathPageParametersEncoder, IMapperContext, DefaultMapperContext]
keywords: [mountPage, mountPackage, clean URLs, pretty URLs, SEO, friendly URL, route, routing, path parameter, placeholder, wicket/bookmarkable, enforce mounts]
order: 60
source: [urls/urls_6.adoc]
---

Without a mount, the URL of a page contains its class name, like `/wicket/bookmarkable/com.example.ProductPage?id=42`. Mount the pages that users see, bookmark or find through search engines, so that their URLs read like `/products/42`.

## Mount a page on a path

Call `mountPage` in the `init()` method of your application:

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();
    mountPage("/products", ProductListPage.class);
    mountPage("/about", AboutPage.class);
}
```

From now on, every link to `ProductListPage`, including `BookmarkablePageLink` and `setResponsePage(ProductListPage.class)`, uses `/products`, and a request for `/products` creates the page. Named page parameters go into the query string: `/products?sort=price`.

The home page from `getHomePage()` is already available at `/`; you do not need to mount it.

## Put parameters in the path

Use a placeholder for a path segment that holds the value of a named parameter. `${name}` is a required parameter:

```java
mountPage("/products/${id}", ProductPage.class);
```

A link with `new PageParameters().add("id", 42)` now points to `/products/42`, and in the page `parameters.get("id")` reads the value from the path, exactly like a query string parameter. A URL without the segment, `/products`, does not match this mount.

`#{name}` is an optional parameter. When the parameter is missing, the segment is left out:

```java
mountPage("/products/${id}/#{tab}", ProductPage.class);
// id=42           -> /products/42
// id=42, tab=reviews -> /products/42/reviews
```

A placeholder fills a whole segment; `/products-${id}` is not a placeholder. Named parameters without a placeholder still go into the query string. The full syntax is listed in [Request mappers]({{ site.baseurl }}/docs/request-mappers.html#mount-path-syntax).

## Mount all pages of a package

`mountPackage` mounts every bookmarkable page in the package of the class you pass, using the simple class name as the last segment:

```java
mountPackage("/admin", UserAdminPage.class);
// com.example.admin.UserAdminPage  -> /admin/UserAdminPage
// com.example.admin.AuditLogPage   -> /admin/AuditLogPage
```

New pages in the package get a URL without a change to `init()`. Pages in subpackages are not included.

## Why a stateful page gets a number in its URL

A mounted page that is stateful shows its page id: `/products/42?3`. Wicket needs the id to find this instance of the page again when the user clicks a link or reloads. A stateless page keeps the clean URL. See [Stateful and stateless pages]({{ site.baseurl }}/docs/stateful-stateless.html).

## Refuse the class name URLs of mounted pages

A mounted page stays reachable through `/wicket/bookmarkable/<class name>`. To accept only the mounted path, turn on enforced mounts:

```java
getSecuritySettings().setEnforceMounts(true);
```

Wicket then refuses every `/wicket/bookmarkable/` URL, also for pages that are not mounted. Mount every page that users reach through a `BookmarkablePageLink` or `setResponsePage(SomePage.class)` before you turn this on.

## Encode all parameters as path segments

To put every named parameter in the path as name-value pairs, mount the page with a `MountedMapper` and an `UrlPathPageParametersEncoder`:

```java
mount(new MountedMapper("/search", SearchPage.class, new UrlPathPageParametersEncoder()));
// q=wicket, page=2 -> /search/q/wicket/page/2
```

This encoder cannot read parameters from a POST request.

## Rename the wicket prefix of unmounted URLs

The fixed segments in unmounted URLs, `wicket`, `bookmarkable`, `page` and `resource`, come from the mapper context. Override `newMapperContext()` in your application to change them:

```java
@Override
protected IMapperContext newMapperContext() {
    return new DefaultMapperContext(this) {
        @Override
        public String getNamespace() {
            return "app";
        }

        @Override
        public String getBookmarkableIdentifier() {
            return "view";
        }
    };
}
```

Do not start a mount path with one of these reserved segments.

To give a resource a URL, see [Give a resource a URL]({{ site.baseurl }}/docs/mount-resources.html). To hide the paths behind encrypted URLs, see [Encrypt URLs]({{ site.baseurl }}/docs/encrypt-urls.html).
