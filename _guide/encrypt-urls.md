---
title: Encrypt URLs
type: howto
topic: links
summary: Hide class names and component paths behind encrypted URLs with CryptoMapper, and choose where the key lives so that stateless pages keep working.
since: 11
apis: [CryptoMapper, KeyInSessionCryptFactory, ApplicationKeyCryptFactory, ICryptFactory, SecuritySettings]
keywords: [URL encryption, obfuscate URL, hide class name, encrypted URL, crypt factory, secret key, CSRF token, stateless encryption, crypt. prefix]
order: 70
source: [urls/urls_6.adoc, security/security_4.adoc]
---

Encrypt URLs when they must not show the class names and component paths of your application, or when every user has to get URLs that nobody else can produce. With the default per-session key an encrypted URL also works as a token against [cross-site request forgery]({{ site.baseurl }}/docs/csrf.html).

For Wicket 10, where the encryption classes and their defaults differ, see the [Wicket 10 guide](https://nightlies.apache.org/wicket/guide/10.x/single.html#_encrypting_page_urls).

## Wrap the root mapper in a CryptoMapper

Install a `CryptoMapper` around the root request mapper at the end of `init()`, after all `mountPage`, `mountPackage` and `mountResource` calls:

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();

    mountPage("/products/${id}", ProductPage.class);
    // other mounts

    setRootRequestMapper(new CryptoMapper(getRootRequestMapper(), this));
}
```

The `CryptoMapper` only encrypts URLs of the mappers it wraps. Mounts that you add after this line are not wrapped and keep plain URLs.

An unmounted page URL such as `/wicket/bookmarkable/com.example.AccountPage?2` now looks like this:

```
/Zmtzn1Cn8ACMqZG2A8Y_WeFCz_locF47nadrt3linij6e-RaslOkvZTYeijZS6e2XuTSp9GnZ-1AykrFZAw56qTliDEOt5ZLjls/Zmt40/2Xu3e
```

The first segment holds the encrypted URL. Wicket adds a short checksum segment for every further segment of the original URL, so that relative URLs, such as images referenced from a CSS file, keep working.

## Which URLs are encrypted

| URL | After encryption |
|---|---|
| Unmounted pages, `/wicket/bookmarkable/...` and `/wicket/page?...` | Fully encrypted |
| Unmounted resources, `/wicket/resource/...` | Fully encrypted |
| Mounted pages and the home page, such as `/products/42?3-1.-form` | Path and query parameters stay readable; the page and listener part (`3-1.-form`) is encrypted |
| Full URLs, with protocol and host | Not changed |

Wicket refuses plain `/wicket/...` URLs once the `CryptoMapper` is installed. A page that has to be hidden completely must not be mounted.

The same URL encrypts to the same text for as long as the key lives. That is on purpose: Wicket compares a URL it generates with the URL that was requested, and browsers cache resources by URL. It also means that someone who sees two encrypted URLs from the same session can tell whether they are equal.

## Keep stateless pages free of a session

The default key source, `KeyInSessionCryptFactory`, generates a random 256-bit key per user and stores it in the HTTP session. It creates the session if there is none, so every page with an encrypted URL gets a session, stateless pages included.

To encrypt without a session, use one key for the whole application with an `ApplicationKeyCryptFactory`. Load the key from your configuration, so that all nodes of a cluster share it and URLs survive a restart:

```java
byte[] keyBytes = Base64.getDecoder().decode(System.getenv("WICKET_URL_KEY")); // 32 bytes
SecretKey key = new SecretKeySpec(keyBytes, "AES");

getSecuritySettings().setCryptFactory(new ApplicationKeyCryptFactory(key));
setRootRequestMapper(new CryptoMapper(getRootRequestMapper(), this));
```

Generate the key once, for example with `openssl rand -base64 32`, and keep it out of your source repository. `new ApplicationKeyCryptFactory(new SecureRandom())` generates a key on first use instead; that key is lost on restart and differs between cluster nodes.

With an application-wide key, encrypted URLs are no longer tied to a user: the same URL encrypts to the same text for everybody, and they no longer protect against cross-site request forgery.

## Show the page-expired page for URLs that no longer decrypt

With a per-session key, encrypted URLs stop working when the session ends. By default Wicket then treats the URL as unknown. Mark encrypted URLs to show the page-expired page instead:

```java
setRootRequestMapper(new CryptoMapper(getRootRequestMapper(), this)
    .setMarkEncryptedUrls(true));
```

Encrypted URLs then start with `crypt.`, and a marked URL that does not decrypt throws a `PageExpiredException`. See [Handle exceptions and error pages]({{ site.baseurl }}/docs/handle-exceptions.html) to change the page that follows.

## Change the cipher

`CryptoMapper` uses the encryption scheme configured in the security settings, authenticated AES-256-GCM by default. To switch schemes, or to supply your own `ICrypt` through the `CryptoMapper(IRequestMapper, Supplier<ICrypt>)` constructor, see [Encryption in Wicket]({{ site.baseurl }}/docs/crypt-schemes.html).
