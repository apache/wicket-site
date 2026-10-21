---
title: Isolate the page with COOP and COEP
type: howto
topic: security
summary: Set the Cross-Origin-Opener-Policy and Cross-Origin-Embedder-Policy headers, which Wicket sends by default, to isolate your pages from other origins.
since: 10
apis: [CrossOriginOpenerPolicyConfiguration, CrossOriginEmbedderPolicyConfiguration, CrossOriginOpenerPolicyRequestCycleListener, CrossOriginEmbedderPolicyRequestCycleListener, SecuritySettings]
keywords: [COOP, COEP, Cross-Origin-Opener-Policy, Cross-Origin-Embedder-Policy, cross-origin isolated, SharedArrayBuffer, Spectre, require-corp, window.opener, popup]
order: 60
source: [security/security_10.adoc]
---

You need this when a page must be cross-origin isolated, for example to use `SharedArrayBuffer` or `performance.measureMemory()`, or when the default headers break a popup or an embedded resource. Two response headers control the isolation:

- `Cross-Origin-Opener-Policy` (COOP) puts your page in its own browsing context group, so a window from another origin that opened it, or that it opened, gets no reference to it.
- `Cross-Origin-Embedder-Policy` (COEP) with `require-corp` lets the page load cross-origin resources only when they allow it, through CORS or a `Cross-Origin-Resource-Policy` header.

A page is cross-origin isolated when both are enforced. The isolation protects against side-channel attacks such as Spectre; MDN's pages on [COOP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cross-Origin-Opener-Policy) and [COEP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cross-Origin-Embedder-Policy) describe the details.

## Know the defaults

Without any configuration Wicket adds both headers to every response:

```
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Embedder-Policy-Report-Only: require-corp
```

COOP is enforced. COEP only reports, so the browser loads everything and tells you what it would have blocked.

## Set the policies

Configure both in `init()`. Wicket reads the settings once, at the end of initialization, and adds a request cycle listener for each policy that is not disabled. Changing them later has no effect.

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();
    getSecuritySettings()
        .setCrossOriginOpenerPolicyConfiguration(CoopMode.SAME_ORIGIN)
        .setCrossOriginEmbedderPolicyConfiguration(CoepMode.ENFORCING);
}
```

With COEP enforced, check that every cross-origin image, font, script and frame the pages use still loads.

### COOP modes

| `CoopMode` | Header value | Effect |
|---|---|---|
| `SAME_ORIGIN` (default) | `same-origin` | Only same-origin documents share the browsing context group |
| `SAME_ORIGIN_ALLOW_POPUPS` | `same-origin-allow-popups` | As `same-origin`, but popups the page opens keep their reference to it |
| `UNSAFE_NONE` | `unsafe-none` | No isolation; the browser default |
| `DISABLED` | (no header) | Wicket sends no COOP header |

### COEP modes

| `CoepMode` | Header | Effect |
|---|---|---|
| `REPORTING` (default) | `Cross-Origin-Embedder-Policy-Report-Only: require-corp` | Violations are reported, nothing is blocked |
| `ENFORCING` | `Cross-Origin-Embedder-Policy: require-corp` | Cross-origin resources without permission are blocked |
| `DISABLED` | (no header) | Wicket sends no COEP header |

## Keep a popup working

A page that opens a window with `window.open` and keeps using the reference to it, such as a sign-in popup of an identity provider, loses that reference under `same-origin`. Use `SAME_ORIGIN_ALLOW_POPUPS` for the application:

```java
getSecuritySettings().setCrossOriginOpenerPolicyConfiguration(CoopMode.SAME_ORIGIN_ALLOW_POPUPS);
```

## Exempt part of the application

Both setters take exempted paths after the mode. Responses for an exempted path get no header:

```java
getSecuritySettings().setCrossOriginEmbedderPolicyConfiguration(CoepMode.ENFORCING, "/legacy");
```

Wicket compares each exemption exactly with the context path of the request, `HttpServletRequest.getContextPath()`, so an exemption applies to a whole web application deployed under that path, not to a single page.

## Turn the headers off

```java
getSecuritySettings()
    .setCrossOriginOpenerPolicyConfiguration(CoopMode.DISABLED)
    .setCrossOriginEmbedderPolicyConfiguration(CoepMode.DISABLED);
```

Do this when a proxy or the container already sets these headers, so that responses do not carry two different values.
