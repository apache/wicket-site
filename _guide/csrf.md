---
title: Protect against cross-site request forgery
type: howto
topic: security
summary: Refuse link clicks, form submits and Ajax calls that another site makes on behalf of your users, with ResourceIsolationRequestCycleListener.
since: 10
apis: [ResourceIsolationRequestCycleListener, FetchMetadataResourceIsolationPolicy, OriginResourceIsolationPolicy, IResourceIsolationPolicy, WebSocketAwareResourceIsolationRequestCycleListener, WebSocketConnectionOriginFilter, CryptoMapper]
keywords: [CSRF, XSRF, Sec-Fetch-Site, fetch metadata, Origin header, Referer, cross-origin, same-site, 403 Forbidden, CsrfPreventionRequestCycleListener, cross-site WebSocket hijacking]
order: 40
source: [security/security_5.adoc]
---

You need this when a page on another site must not be able to make your users click a link, submit a form or fire an Ajax call in your application. Browsers send your session cookie along with such forged requests, so the request has to be checked for where it came from. [How Wicket keeps applications secure]({{ site.baseurl }}/docs/security-model.html#cross-site-request-forgery) explains what stateful pages and encrypted URLs already do against it.

## Register the listener

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();
    getRequestCycleListeners().add(new ResourceIsolationRequestCycleListener());
}
```

The listener is not registered by default. Once it is, every request that invokes a listener on a page (a `Link.onClick()`, a `Form.onSubmit()`, an Ajax behavior) is checked. A refused request ends with 403 Forbidden.

Requests that only render a page are not checked, so other sites can still link to your pages.

## What the default policies check

Without arguments the listener asks two policies, in order, and the first answer other than "unknown" decides:

1. `FetchMetadataResourceIsolationPolicy` reads the `Sec-Fetch-Site` header that browsers add to every request. It allows `same-origin` and `none` (a typed URL or a bookmark). A request from another origin may render a page through a plain top-level navigation, but may not invoke a listener.
2. `OriginResourceIsolationPolicy` compares the `Origin` or `Referer` header with the requested URL. It only gets a say when a request has no `Sec-Fetch-Site` header, which current browsers always send.

When neither policy can decide, the request is refused.

To rely on fetch metadata alone, pass the policy yourself:

```java
getRequestCycleListeners().add(
    new ResourceIsolationRequestCycleListener(new FetchMetadataResourceIsolationPolicy()));
```

## Allow requests from your other subdomains

`Sec-Fetch-Site: same-site` means a different origin on the same registrable domain, such as `shop.example.com` calling `app.example.com`. It is refused by default. If every origin on your site is part of the same application, allow it:

```java
getRequestCycleListeners().add(new ResourceIsolationRequestCycleListener(
    new FetchMetadataResourceIsolationPolicy().setSameSiteAllowed(true),
    new OriginResourceIsolationPolicy()));
```

This trusts every subdomain. A hostile sibling origin, through a subdomain takeover, user-provided content or an XSS hole elsewhere on the site, can then act on behalf of your users.

Wicket 10 releases before 10.11.0 allowed `same-site` requests without this setting.

## Accept a trusted origin

For clients without fetch metadata, `OriginResourceIsolationPolicy.addAcceptedOrigin("partner.example.com")` accepts requests from that host and every host below it.

## Exempt a path or a page

```java
var listener = new ResourceIsolationRequestCycleListener() {
    @Override
    protected boolean isChecked(IRequestablePage targetedPage) {
        return !(targetedPage instanceof PartnerCallbackPage);
    }
};
listener.addExemptedPaths("/api/callback");
getRequestCycleListeners().add(listener);
```

An exempted path is compared exactly with the path info of the request, `HttpServletRequest.getPathInfo()`.

## Check page renders as well

Override `isChecked(IRequestHandler)` to return `true` for every page request handler. Policies then also see renders, and `FetchMetadataResourceIsolationPolicy` still allows a plain top-level navigation from another site.

```java
var listener = new ResourceIsolationRequestCycleListener() {
    @Override
    protected boolean isChecked(IRequestHandler handler) {
        return handler instanceof IPageRequestHandler;
    }
};
```

## Change what happens to a refused request

| Setting | Default | Effect |
|---|---|---|
| `setDisallowedOutcomeAction(CsrfAction)` | `ABORT` | What to do when a policy refuses the request |
| `setUnknownOutcomeAction(CsrfAction)` | `ABORT` | What to do when no policy can decide |
| `setErrorCode(int)` | 403 | Status code for `ABORT` |
| `setErrorMessage(String)` | "The request was blocked by a resource isolation policy" | Message for `ABORT` |

`CsrfAction.ABORT` answers with the error code, `SUPPRESS` renders the targeted page without invoking the listener, and `ALLOW` logs the request and lets it through. `ALLOW` is useful to try the listener out on a running application before you enforce it.

## Keep your tests passing

`WicketTester` sends no `Sec-Fetch-Site` header, so with the listener registered its requests are refused. Set the header before clicking a link or submitting a form:

```java
tester.addRequestHeader(FetchMetadataResourceIsolationPolicy.SEC_FETCH_SITE_HEADER,
    FetchMetadataResourceIsolationPolicy.SAME_ORIGIN);
tester.clickLink("delete");
```

A request header applies to the next request only. [Test pages and components]({{ site.baseurl }}/docs/test-pages.html#set-request-headers) has more on headers in tests.

## Protect WebSocket connections

With native WebSockets, register `WebSocketAwareResourceIsolationRequestCycleListener` instead. It checks the HTTP request that opens the connection, which carries `Origin` and fetch metadata headers, and skips the messages that arrive over the open connection, which carry no headers:

```java
getRequestCycleListeners().add(new WebSocketAwareResourceIsolationRequestCycleListener());
```

Browsers let any page open a WebSocket to any host, and send your cookies with it. To accept connections only from your own pages, also install a `WebSocketConnectionOriginFilter` with the exact origins that may connect:

```java
WebSocketSettings.Holder.get(this).setConnectionFilter(
    new WebSocketConnectionOriginFilter(List.of("https://app.example.com")));
```

A connection whose single `Origin` header is not in the list is closed with code 1008, "Origin mismatch". An empty list allows every origin. [Push updates over a WebSocket]({{ site.baseurl }}/docs/use-websockets.html) covers the setup.

## Combine it with encrypted URLs

`CryptoMapper` and this listener work independently and can be combined. [Encrypt URLs]({{ site.baseurl }}/docs/encrypt-urls.html) covers the mapper. `CsrfPreventionRequestCycleListener`, the Origin-header check of Wicket 7 to 9, was removed in Wicket 10; `OriginResourceIsolationPolicy` contains its logic.
