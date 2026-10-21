---
title: Keep a page stateless
type: howto
topic: state
summary: Build a page that Wicket does not store in the session, find the component that makes it stateful, and guard it with a test.
since: 10
apis: [Page, StatelessChecker, StatelessComponent, StatelessLink, StatelessForm, BookmarkablePageLink]
keywords: [stateless, no session, isPageStateless, setStatelessHint, getStatelessHint, isStateless, "is not stateless because of component", public pages, crawler, jsessionid]
order: 10
source: [versioningCaching/versioningCaching_3.adoc]
---

Keep a page stateless when it is public, visited by many anonymous users or meant to be bookmarked, such as a home page, a product page or a login page. A stateless page needs no session. [Stateful and stateless pages]({{ site.baseurl }}/docs/stateful-stateless.html) explains the trade-off.

## Make the page bookmarkable

Wicket must be able to create the page itself, for every request. Give it a public constructor without arguments, or one that takes only `PageParameters`, and read everything else from the parameters:

```java
public class ProductPage extends WebPage {
    public ProductPage(PageParameters parameters) {
        long id = parameters.get("id").toLong();
        IModel<Product> product = LoadableDetachableModel.of(() -> productService.find(id));
        add(new Label("name", product.map(Product::getName)));
    }
}
```

Link to it by class, with `BookmarkablePageLink` or `setResponsePage(ProductPage.class, parameters)`, so Wicket creates it from the URL. [Pass parameters to a page]({{ site.baseurl }}/docs/page-parameters.html) shows how to build those URLs.

## Use stateless components

A page is stateless only when every visible, enabled component on it, and every behavior on those components, is stateless. These components are:

| Instead of | Use |
|---|---|
| `Link` | `BookmarkablePageLink` to go to a page, `StatelessLink` to run code on click |
| `Form` | `StatelessForm`, see [Build a stateless form]({{ site.baseurl }}/docs/stateless-forms.html) |
| Ajax behaviors and links | their stateless variants, see [Use Ajax on stateless pages]({{ site.baseurl }}/docs/stateless-ajax.html) |
| any link to another site | `ExternalLink`, which has no callback |

Labels, images, containers and other components without a callback are stateless already. A stateful component that is hidden or disabled does not make the page stateful.

Calling `getPageReference()` on a page makes it stateful, and so does `setStatelessHint(false)`.

## Find the component that makes the page stateful

`Page.isPageStateless()` tells you whether the page is stateless. To find the culprit, visit the components and log those that are not:

```java
@Override
protected void onBeforeRender() {
    super.onBeforeRender();
    if (getApplication().usesDevelopmentConfig() && !isPageStateless()) {
        visitChildren((component, visit) -> {
            if (!component.isStateless()) {
                log.warn("Stateful component: {}", component.getPageRelativePath());
            }
        });
    }
}
```

With debug logging on for `org.apache.wicket.Page`, Wicket logs the same thing itself: "Page '...' is not stateless because of component with path '...'".

## Fail fast with StatelessChecker

`wicket-devutils` has an annotation and a checker that throws an exception when a page or component marked as stateless is not. Register the checker in development mode:

*WicketApplication.java*
```java
@Override
protected void init() {
    super.init();
    if (usesDevelopmentConfig()) {
        getComponentPostOnBeforeRenderListeners().add(new StatelessChecker());
    }
}
```

and annotate the page:

```java
@StatelessComponent
public class ProductPage extends WebPage {
    // ...
}
```

When `ProductPage` renders with a stateful component, `StatelessChecker` throws a `StatelessCheckFailureException` that names the component. The annotation has no effect without the checker, and is inherited by subclasses; `@StatelessComponent(enabled = false)` turns it off for a subclass that is allowed to be stateful.

## Test it

Assert the statelessness in a test, so a later change cannot break it unnoticed:

```java
@Test
void productPageIsStateless() {
    tester.startPage(ProductPage.class, new PageParameters().add("id", 42));
    assertTrue(tester.getLastRenderedPage().isPageStateless());
}
```

[Test pages and components]({{ site.baseurl }}/docs/test-pages.html) shows how to set up `WicketTester`.
