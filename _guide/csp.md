---
title: Configure the Content Security Policy
type: howto
topic: security
summary: Work with the strict Content Security Policy Wicket sends by default, allow extra sources, report violations, and move inline scripts and styles out of the markup.
since: 10
apis: [ContentSecurityPolicySettings, CSPHeaderConfiguration, CSPDirective, CSPDirectiveSrcValue, OnEventHeaderItem, ReportCSPViolationMapper]
keywords: [CSP, Content-Security-Policy, nonce, unsafe-inline, strict-dynamic, XSS, inline script, onclick, style attribute, script-src-attr, style-src-attr, report-uri, Refused to execute inline script]
order: 50
source: [security/security_6.adoc]
---

You need this when the browser refuses a script, a stylesheet or an inline style on your pages, or when you want to tighten or loosen the policy. Every `WebPage` is sent with a `Content-Security-Policy` header. By default it is this strict policy, with a fresh nonce for every request:

```
Content-Security-Policy: default-src 'none'; script-src 'strict-dynamic' 'nonce-XYZ';
  style-src 'nonce-XYZ'; img-src 'self'; connect-src 'self'; font-src 'self';
  manifest-src 'self'; child-src 'self'; base-uri 'self'
```

Scripts and stylesheets only run when they carry the nonce. Wicket adds it to everything you contribute through `renderHead`. Images, fonts, frames and Ajax calls are allowed from your own origin. Anything inline is blocked: `<script>` and `<style>` in the markup, `onclick` and other event attributes, and `style` attributes. [How Wicket keeps applications secure]({{ site.baseurl }}/docs/security-model.html#content-security-policy) explains why the policy has no `'unsafe-inline'`.

All settings live in `getCspSettings()` of your `WebApplication`. Change them in `init()`, after `super.init()`.

## Allow a source

Add sources to a directive of the enforced (`blocking()`) policy:

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();
    getCspSettings().blocking()
        .add(CSPDirective.IMG_SRC, "data:")
        .add(CSPDirective.FONT_SRC, "https://fonts.gstatic.com")
        .add(CSPDirective.STYLE_SRC, "https://fonts.googleapis.com/css");
}
```

`CSPDirective` has a constant for every directive, `CSPDirectiveSrcValue` for keywords such as `SELF`, `NONE` and `UNSAFE_INLINE`. Scripts cannot be allowed by URL: `'strict-dynamic'` makes browsers ignore URL sources in `script-src`. Load them through a header item instead.

## Allow inline images, external images and media

`img-src 'self'` only allows images from your own origin. Images embedded as `data:` URLs, such as those of `InlineImage` or base64 images in a stylesheet, need `data:`; images from another host need that host. There is no `media-src`, so `default-src 'none'` blocks every `<video>` and `<audio>` source until you add one:

```java
getCspSettings().blocking()
    .add(CSPDirective.IMG_SRC, "data:", "https://images.example.com")
    .add(CSPDirective.MEDIA_SRC, CSPDirectiveSrcValue.SELF);
```

## Load CSS and JavaScript through header items

A `<link>` or `<script>` written in the markup gets no nonce. Contribute it from the component instead, and Wicket adds the nonce:

*MyPanel.java*

```java
@Override
public void renderHead(IHeaderResponse response) {
    super.renderHead(response);
    response.render(CssHeaderItem.forReference(
        new CssResourceReference(MyPanel.class, "my-panel.css")));
    response.render(JavaScriptHeaderItem.forReference(
        new JavaScriptResourceReference(MyPanel.class, "my-panel.js")));
}
```

A stylesheet or script inside `<wicket:link>` that Wicket turns into a package resource URL also gets the nonce. Scripts loaded this way may load further scripts, because of `'strict-dynamic'`. [Add CSS and JavaScript to a page]({{ site.baseurl }}/docs/add-css-javascript.html) covers the header items.

## Replace inline event handlers

Move an `onclick` or `onsubmit` attribute into an `OnEventHeaderItem`. Wicket renders it as a script with the nonce that attaches the handler:

```java
@Override
public void renderHead(IHeaderResponse response) {
    super.renderHead(response);
    response.render(OnEventHeaderItem.forComponent(this, "submit",
        "return confirm('Do you really want to submit?');"));
}
```

The component needs a markup id, so call `setOutputMarkupId(true)` on it. The same applies to an `AttributeModifier` that writes an event attribute.

## Replace style attributes

Put the styling in a stylesheet and switch CSS classes, for example with `AttributeModifier.append("class", "warning")` instead of a modifier on `style`. Scripts that set the `style` attribute in generated markup have to set the `style` DOM property instead, which the policy allows.

If you cannot remove the style attributes yet, allow them on their own and keep the nonce for stylesheets:

```java
getCspSettings().blocking().add(CSPDirective.STYLE_SRC_ATTR, CSPDirectiveSrcValue.UNSAFE_INLINE);
```

`style-src-attr` only governs `style` attributes, so `<style>` elements still need the nonce. `SCRIPT_SRC_ATTR` does the same for event handler attributes, but allowing those removes most of the protection against script injection.

## Report violations to the application

`reportBack()` adds a `report-uri` that points to an endpoint in your application. Wicket logs every report it receives at error level, through the logger `org.apache.wicket.csp.ReportCSPViolationMapper`.

```java
if (usesDevelopmentConfig()) {
    getCspSettings().blocking().reportBack();
}
```

The endpoint is open to anyone and every report ends up in your log. On a production system, limit the size of that log, or use `reportBackAt(path)` or `add(CSPDirective.REPORT_URI, url)` to send reports elsewhere.

## Try a policy before you enforce it

`reporting()` configures a second policy, sent as `Content-Security-Policy-Report-Only`. Browsers report what it would block without blocking anything:

```java
getCspSettings().reporting()
    .strict()
    .reportBack();
```

## Exclude pages from the policy

A page writes the header while it configures its response, after asking `getCspSettings().mustProtect(page)`. That method returns `true` when a policy is set and the protected filter accepts the page. Change the filter to leave pages out:

```java
getCspSettings().setProtectedFilter(page -> !(page instanceof LegacyReportPage));
```

> Since Wicket 11, every `WebPage` response asks `mustProtect(page)`, and the filter is a `Predicate<WebPage>`, as shown. In Wicket 10 a page writes the header only when the request is handled by a `RenderPageRequestHandler`, and the filter is a `Predicate<IRequestHandler>` that tests that handler, for example `handler -> !(handler instanceof RenderPageRequestHandler h && h.getPageClass() == LegacyReportPage.class)`. `setProtectedFilter(Predicate<IRequestHandler>)` is deprecated since 10.11.0. Wicket 10 also has a `CSPRequestCycleListener` for responses other than page renders; Wicket 11 removes it, so only pages send the header.
{: .since}

## Loosen or turn off the policy

`unsafeInline()` replaces the policy with a preset that allows inline scripts and styles and `eval`. It removes most of what CSP protects against, but it can be a first step for an application that is not ready for the strict policy:

```java
getCspSettings().blocking().unsafeInline();
```

To send no policy at all:

```java
getCspSettings().blocking().disabled();
```

`strict()` restores the default.
