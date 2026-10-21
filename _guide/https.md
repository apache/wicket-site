---
title: Require HTTPS
type: howto
topic: security
summary: Serve pages over HTTPS with HttpsMapper and @RequireHttps, and set up the container so redirects and absolute URLs use the right host.
since: 10
apis: [HttpsMapper, HttpsConfig, RequireHttps, Scheme, XForwardedRequestWrapperFactory]
keywords: [TLS, SSL, secure page, redirect to https, port 8443, reverse proxy, Host header, HSTS, X-Forwarded-Proto]
order: 30
source: [security/security_3.adoc]
---

You need this when pages must reach the browser over an encrypted connection. Most applications today serve everything over HTTPS and let the container or a reverse proxy redirect plain HTTP; then you do not need anything in Wicket. `HttpsMapper` is for applications that serve some pages over HTTP and others over HTTPS from the same container.

## Install HttpsMapper

`HttpsMapper` wraps the root request mapper. Install it last in `init()`, after mounting your pages, because it replaces the root mapper. `HttpsConfig` holds the HTTP and HTTPS ports, 80 and 443 by default.

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();
    mountPage("/account", AccountPage.class);

    setRootRequestMapper(new HttpsMapper(getRootRequestMapper(), new HttpsConfig(8080, 8443)));
}
```

## Mark the pages that need HTTPS

*AccountPage.java*

```java
@RequireHttps
public class AccountPage extends WebPage {
}
```

A request for an annotated page over HTTP is redirected to the same URL over HTTPS. Links and form actions to the page are rendered with `https://` and the HTTPS port.

To protect many pages at once, annotate a base class or an interface. `HttpsMapper` looks for the annotation on the class, its superclasses and every interface they implement:

```java
@RequireHttps
public interface SecurePage {
}

public class PaymentPage extends WebPage implements SecurePage {
}
```

## Keep the other pages on HTTPS as well

`HttpsMapper` sends pages without `@RequireHttps` back to HTTP: a request for such a page over HTTPS is redirected to the HTTP port. If you want HTTPS everywhere, either annotate your base page, or override `getDesiredSchemeFor` so that every page asks for HTTPS:

```java
setRootRequestMapper(new HttpsMapper(getRootRequestMapper(), new HttpsConfig(8080, 8443)) {
    @Override
    protected Scheme getDesiredSchemeFor(Class<? extends IRequestablePage> pageClass) {
        return pageClass == null ? Scheme.ANY : Scheme.HTTPS;
    }
});
```

Requests that do not concern a page, such as requests for resources, keep the scheme they arrived on.

## Create the session before switching to HTTPS

By default `HttpsMapper` creates the HTTP session before it redirects from HTTP to HTTPS, so that both schemes share one session. `HttpsConfig.setPreferStateful(false)` turns this off. Do so only if you accept that a user can end up with two sessions, one per scheme, each with its own sign-in state.

## Make the host in redirects trustworthy

The redirect to HTTPS uses the host name the servlet container reports, which is the `Host` header of the request. Every absolute URL Wicket renders uses it too. Wicket does not validate it, because only your deployment knows which host names are valid. Set up the deployment so that only expected values arrive:

- Configure the container or virtual host to reject requests with an unknown `Host`, with a 400 or 404 response.
- When a reverse proxy terminates TLS, let it set `Host` to the canonical name instead of passing on what the client sent.
- Do not serve the application from a catch-all or default virtual host.
- Serve over HTTPS and send an `HSTS` header, so plain HTTP requests are not part of normal traffic. [External security checks]({{ site.baseurl }}/docs/security-checks.html) shows how to add the header.

## Run behind a proxy that terminates TLS

When a proxy talks plain HTTP to the container, Wicket sees every request as HTTP. Configure the container to take the scheme from the proxy, or install Wicket's `XForwardedRequestWrapperFactory`, which reads `X-Forwarded-Proto` and `X-Forwarded-For`:

```java
getFilterFactoryManager().add(new XForwardedRequestWrapperFactory());
```

Only enable it when a trusted proxy strips any copies of these headers sent by the client; otherwise the client controls them. Wicket does not read `X-Forwarded-Host`: the host always comes from the container.
