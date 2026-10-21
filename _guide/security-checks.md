---
title: Security headers and external checks
type: reference
topic: security
summary: The response headers that scanners such as Mozilla Observatory check, which of them Wicket sends by default, and the Wicket API or hook that sets each one.
since: 10
apis: [WebPage, IRequestCycleListener, WebResponse, ContentSecurityPolicySettings, SecuritySettings]
keywords: [Mozilla Observatory, security scan, HSTS, Strict-Transport-Security, X-Content-Type-Options, nosniff, X-Frame-Options, clickjacking, frame-ancestors, Referrer-Policy, Permissions-Policy, X-XSS-Protection, response headers]
order: 20
source: [security/security_8.adoc]
---

Scanners such as [Mozilla Observatory](https://developer.mozilla.org/en-US/observatory) grade a site by the security headers in its responses. Wicket sends some of them itself; the others you add in your application, in the container or in a reverse proxy in front of it.

## Headers and who sets them

| Header | Sent by Wicket by default | Set with |
|---|---|---|
| `Content-Security-Policy` | Yes, a strict policy with nonces, on every `WebPage` | `getCspSettings()`, see [Configure the Content Security Policy]({{ site.baseurl }}/docs/csp.html) |
| `Cross-Origin-Opener-Policy` | Yes, `same-origin`, on every response | `getSecuritySettings().setCrossOriginOpenerPolicyConfiguration(...)`, see [Isolate the page with COOP and COEP]({{ site.baseurl }}/docs/cross-origin-isolation.html) |
| `Cross-Origin-Embedder-Policy` | As `Cross-Origin-Embedder-Policy-Report-Only: require-corp`, on every response | `getSecuritySettings().setCrossOriginEmbedderPolicyConfiguration(...)` |
| `Vary: sec-fetch-dest, sec-fetch-site, sec-fetch-mode` | Only with `ResourceIsolationRequestCycleListener` registered | See [Protect against cross-site request forgery]({{ site.baseurl }}/docs/csrf.html) |
| `Cache-Control: no-cache, no-store`, `Pragma: no-cache`, `Expires` | Yes, on every `WebPage` | Override `WebPage#setHeaders(WebResponse)` |
| `Strict-Transport-Security` | No | Your own code, the container or the proxy |
| `X-Content-Type-Options: nosniff` | No | Your own code, the container or the proxy |
| `X-Frame-Options` | No | Your own code, or the `frame-ancestors` directive of the CSP |
| `Referrer-Policy` | No | Your own code, the container or the proxy |
| `Permissions-Policy` | No | Your own code, the container or the proxy |

`X-XSS-Protection` controlled a filter that current browsers no longer have. Leave it out; the Content Security Policy replaces it.

## Stop other sites from framing your pages

The CSP directive `frame-ancestors` is the current replacement for `X-Frame-Options`:

```java
getCspSettings().blocking().add(CSPDirective.FRAME_ANCESTORS, CSPDirectiveSrcValue.SELF);
```

## Add headers to every page

Override `setHeaders` in your base page. Call `super.setHeaders` to keep the caching headers.

*BasePage.java*

```java
@Override
protected void setHeaders(WebResponse response) {
    super.setHeaders(response);
    response.setHeader("X-Content-Type-Options", "nosniff");
    response.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
}
```

## Add headers to every response

A request cycle listener also reaches resources, Ajax responses and redirects. Set the headers both when the handler is resolved and after it has run, the way Wicket's own COOP and COEP listeners do, so they survive a redirect to a buffered response:

*SecurityHeadersListener.java*

```java
public class SecurityHeadersListener implements IRequestCycleListener {
    @Override
    public void onRequestHandlerResolved(RequestCycle cycle, IRequestHandler handler) {
        setHeaders(cycle);
    }

    @Override
    public void onRequestHandlerExecuted(RequestCycle cycle, IRequestHandler handler) {
        setHeaders(cycle);
    }

    private void setHeaders(RequestCycle cycle) {
        if (cycle.getResponse() instanceof WebResponse response && response.isHeaderSupported()) {
            response.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
            response.setHeader("X-Content-Type-Options", "nosniff");
        }
    }
}
```

*WicketApplication.java*

```java
getRequestCycleListeners().add(new SecurityHeadersListener());
```

Do not set `Content-Security-Policy` or the cross-origin policies this way: Wicket already sends them, and a second value either replaces Wicket's policy or is combined with it by the browser.

## Require HTTPS in web.xml

The servlet container can redirect every plain HTTP request to HTTPS:

*web.xml*

```xml
<security-constraint>
    <web-resource-collection>
        <web-resource-name>Entire application</web-resource-name>
        <url-pattern>/*</url-pattern>
    </web-resource-collection>
    <user-data-constraint>
        <transport-guarantee>CONFIDENTIAL</transport-guarantee>
    </user-data-constraint>
</security-constraint>
```

[Require HTTPS]({{ site.baseurl }}/docs/https.html) covers HTTPS in Wicket itself.

After adding headers, check that the application still works: `Strict-Transport-Security` with `includeSubDomains` affects every subdomain for as long as `max-age` says, and a strict `frame-ancestors` breaks pages that are meant to be embedded.
