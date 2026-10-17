---
title: How Wicket keeps applications secure
type: explanation
topic: security
summary: What Wicket defends against by default (escaping, a strict CSP, stateful URLs and encryption) and what it leaves to your application and your deployment.
since: 10
apis: [IAuthorizationStrategy, CryptoMapper, ResourceIsolationRequestCycleListener, ContentSecurityPolicySettings, Component]
keywords: [security model, XSS, cross-site scripting, CSRF, escapeModelStrings, nonce, unsafe-inline, trust boundary, Host header, page store, deserialization, threat model]
order: 10
source: [security.adoc, security/security_9.adoc]
---

Wicket's security comes mostly from how it is built rather than from features you switch on. Pages are Java objects kept on the server, URLs point at those objects, and markup is produced by components that know what they write. That design closes some doors by default. It leaves others to you: who may do what, how users sign in, and what the servlet container and proxy in front of the application let through.

## Escaping by default

Cross-site scripting needs a way to get attacker-controlled text into a page as markup. In Wicket, text from a model reaches the page through a component, and every component escapes what it renders from its model: `escapeModelStrings` is on by default, so `<`, `>`, `&`, `"` and `'` become entities. A `Label` showing a user's name cannot inject a script, whatever the name contains. Attribute values that Wicket writes into a tag are escaped as well.

On the other side of that line are the inputs the developer writes. Markup files are templates, rendered as markup. Message bundles are trusted too: `<wicket:message>` renders its text as markup, so a bundle can contain formatting. Turning off escaping with `setEscapeModelStrings(false)` moves model data to that side: the application then says the value is markup and takes responsibility for it.

Two gaps remain. `${name}` in a message first resolves to a child component, whose output is escaped by that component; only when there is no such child is the value read from the model and written as it is. And HTML escaping is the wrong escaping for a JavaScript context, a `<style>` element, an unquoted attribute or a URL whose scheme is the payload. A value you put into a script, for example through a `TextTemplate`, needs JavaScript encoding, which you have to apply yourself.

## Content Security Policy

Escaping prevents injection; the Content Security Policy limits the damage if an injection gets through anyway. Wicket sends a strict policy with every page: scripts and stylesheets run only when they carry a nonce that is new for every response, and inline scripts, inline styles and event attributes are refused. There is no `'unsafe-inline'`, so a `<script>` that an attacker manages to place in the page does not run.

That policy is only usable because Wicket itself writes no inline JavaScript. Since Wicket 6, Ajax components do not write `onclick` attributes; they register their handlers from a script, and every script Wicket contributes is a header item that gets the nonce. `'strict-dynamic'` then lets those scripts load what they need. The cost lands on application code that still writes `onclick` attributes or `style` attributes, which has to move them into header items and stylesheets. [Configure the Content Security Policy]({{ site.baseurl }}/docs/csp.html) shows how.

## Cross-site request forgery

A forged request comes from a page on another site, but the browser sends your session cookie with it, so the server sees a signed-in user. The defence is to require something in the request that the other site cannot know or cannot produce.

On a stateful page, Wicket's URLs already ask for more than a cookie. The URL of a link or a form names a page instance that lives in the user's session, and the number of times that page has been rendered. If the instance does not exist, or has been rendered again since, Wicket renders the page and does not run the listener. The page id and render count are small counters, though, so they make a forgery unlikely to land, not impossible.

`CryptoMapper` closes that gap. It encrypts every URL with a key that is unique to the session, so the URL itself becomes a secret token that another site cannot construct. Stateless pages have no instance to name: the URL of a stateless form is the same for every user and easy to predict, so neither of these defences applies.

What does apply everywhere is checking where a request comes from. Browsers add `Sec-Fetch-Site` to every request, and other documents cannot forge or remove it. `ResourceIsolationRequestCycleListener` reads it and refuses a listener invocation that comes from another origin, while still letting other sites link to your pages. It is not registered by default. [Protect against cross-site request forgery]({{ site.baseurl }}/docs/csrf.html) shows how to add it.

## Encrypted URLs

An encrypted URL hides which pages and components exist and makes listener URLs unguessable per session. It is not access control. A URL can leak through a log, a browser history or a `Referer` header, and whoever has it can replay it within the session. Encrypted URLs are deterministic by design: the same URL must encrypt to the same text so that a regenerated URL matches the requested one and resources stay cacheable. Equal URLs are therefore recognisable as equal, and anyone holding the key can confirm a guess. With the default per-session key that stays within one user's session.

> Since Wicket 11, URLs and stored pages are encrypted with authenticated AES-256-GCM, so altered ciphertext is refused instead of decrypted to garbage. Wicket 10 encrypts URLs with `PBEWithMD5AndDES` and stored pages with AES-CBC, neither of which is authenticated. [Encryption in Wicket]({{ site.baseurl }}/docs/crypt-schemes.html) describes the Wicket 11 API.
{: .since}

## Authorization belongs in a strategy

Because a URL can be guessed, replayed or leaked, the question whether a user may see a page or press a button has to be answered on the server for every request. Wicket asks the `IAuthorizationStrategy` before it creates a component and before it renders or enables one. A restricted page therefore stays restricted whether the request came from a link, a bookmark or a hand-made URL. [Restrict access by role]({{ site.baseurl }}/docs/roles.html) shows the annotation-based strategy.

Signing in is part of the same picture: `AuthenticatedWebSession.signIn` gives the session a new id when the user signs in, so a session id planted before the sign-in cannot be used afterwards.

## What the deployment has to provide

Wicket takes its own identity, the scheme, host and port it is served on, from the servlet container. It does not check the `Host` header. Every absolute URL, every redirect to HTTPS, and the fallback Origin check of the resource isolation listener rely on it. The container or proxy has to reject unexpected host names; [Require HTTPS]({{ site.baseurl }}/docs/https.html#make-the-host-in-redirects-trustworthy) lists what to configure. `X-Forwarded-*` headers are ignored unless you install the wrapper that reads them.

Pages and sessions are serialized to the page store, and Java deserialization of untrusted bytes is dangerous. Wicket treats the page store and the session store as trusted, private storage. [Encrypting the page store]({{ site.baseurl }}/docs/configure-page-store.html) keeps stored pages confidential, and since Wicket 11 also tamper-evident, but the key lives in the session, so it protects against someone who can read or write the store, not against someone who holds the session.

Development mode adds debugging aids and detailed error pages. It is not hardened and must not run in production; see [Switch between development and deployment mode]({{ site.baseurl }}/docs/deployment-mode.html).

The [`SECURITY.md`](https://github.com/apache/wicket/blob/master/SECURITY.md) file in the Wicket source lists these trust boundaries in full, along with how to report a vulnerability.
