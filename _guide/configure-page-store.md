---
title: Configure the page store
type: howto
topic: state
summary: Change how much page history Wicket keeps per session and where, encrypt stored pages, or replace the disk store with another store.
since: 10
apis: [StoreSettings, DefaultPageManagerProvider, CryptingPageStore, InMemoryPageStore, InSessionPageStore, FilePageStore, SecuritySettings, DebugBar]
keywords: [page store size, maxSizePerSession, filestore folder, disk space, asynchronous, encrypt pages, crypt scheme, Bouncy Castle, GCM-SIV, in-memory, cluster, session replication, setPageManagerProvider, serializer, Kryo]
order: 20
source: [internals/pagestoring.adoc, versioningCaching/versioningCaching_2.adoc]
---

Configure the page store when the defaults do not fit: too little or too much page history per session, a temporary directory that is not suitable, stored pages that must be encrypted, or a cluster where pages must be reachable from every node. All settings go in your application's `init()`. [How pages are stored]({{ site.baseurl }}/docs/page-storage.html) explains the stores involved.

## Limit the history per session

Each session's pages go to a file of at most 10 MB. When it is full, the oldest pages are overwritten, and going back to them ends in an expired page. Raise the limit for applications where users go back far, lower it to save disk:

```java
getStoreSettings().setMaxSizePerSession(Bytes.megabytes(20));
```

## Move the store folder

By default the files go to the servlet container's temporary directory, in a folder named after the application followed by `-filestore`. Choose a folder that only the application can read, with enough space:

```java
getStoreSettings().setFileStoreFolder(new File("/var/lib/myapp/pages"));
```

## Write pages synchronously

Pages are written to disk on a background thread, with a queue of 100 pages. Writes beyond that capacity happen in the request thread. Change the capacity, or write every page in the request:

```java
getStoreSettings().setAsynchronousQueueCapacity(200);
getStoreSettings().setAsynchronous(false);
```

## Encrypt stored pages

Turn on encryption when the stored pages hold data that others with access to the disk must not read:

```java
getStoreSettings().setEncrypted(true);
```

{% if site.wicket.version_11 %}
Each session gets a random key, kept in the session. Pages are encrypted with the application's crypt scheme, by default AES-256-GCM, which also detects pages that were altered in the store. To use AES-256-GCM-SIV instead, add Bouncy Castle to the classpath, register its provider and set the scheme:

```java
Security.addProvider(new BouncyCastleProvider());
getSecuritySettings().setCryptScheme(new AesGcmSivCryptScheme());
getStoreSettings().setEncrypted(true);
```

The scheme also applies to encrypted URLs. [Encryption in Wicket]({{ site.baseurl }}/docs/crypt-schemes.html) describes the schemes and how to move from one to another.

> Wicket 10 configures the page store's cipher separately, with `StoreSettings.setCrypter`. The default `DefaultCrypter` uses AES-256-CBC, which is not authenticated. For tamper detection, use the GCM-SIV crypter, which needs Bouncy Castle:
>
> ```java
> getStoreSettings().setEncrypted(true).setCrypter(GCMSIVCrypter::new);
> ```
>
> Since Wicket 11, `setCrypter`, `DefaultCrypter` and `GCMSIVCrypter` no longer exist, and the page store uses the crypt scheme from `SecuritySettings`.
{: .since}
{% else %}
Each session gets a random key, kept in the session. The cipher comes from `StoreSettings.setCrypter`. The default `DefaultCrypter` uses AES-256-CBC, which is not authenticated. For tamper detection, use the GCM-SIV crypter, which needs Bouncy Castle:

```java
getStoreSettings().setEncrypted(true).setCrypter(GCMSIVCrypter::new);
```
{% endif %}

## Replace the disk store

Register a `DefaultPageManagerProvider` that creates another persistent store. The rest of the default chain stays as it is.

Keep the pages in the application's memory, at most 50 per session:

```java
setPageManagerProvider(new DefaultPageManagerProvider(this) {
    @Override
    protected IPageStore newPersistentStore() {
        return new InMemoryPageStore(getName(), 50);
    }
});
```

`InMemoryPageStore` also takes a `Bytes` limit instead of a page count. Its pages are lost when the server stops, and other nodes in a cluster cannot see them.

Keep serialized pages in the HTTP session, up to 2 MB per session. The servlet container then replicates them with the session, which suits a cluster with session replication. The session cannot be written from a background thread, so switch off asynchronous writing as well:

```java
getStoreSettings().setAsynchronous(false);
setPageManagerProvider(new DefaultPageManagerProvider(this) {
    @Override
    protected IPageStore newPersistentStore() {
        return new InSessionPageStore(Bytes.megabytes(2));
    }
});
```

Write each page to its own file instead of one file per session, which keeps pages from different browser tabs from pushing each other out:

```java
setPageManagerProvider(new DefaultPageManagerProvider(this) {
    @Override
    protected IPageStore newPersistentStore() {
        StoreSettings settings = getStoreSettings();
        return new FilePageStore(getName(), settings.getFileStoreFolder(),
                settings.getMaxSizePerSession());
    }
});
```

`DefaultPageManagerProvider` has a factory method for each store in the chain, such as `newCachingStore` and `newSerializingStore`, to replace other parts. Stores for databases and distributed caches are available from WicketStuff, or implement `IPageStore` yourself. Any store after the `SerializingPageStore` receives `SerializedPage`s.

## Change the serializer

Pages are serialized with Java serialization. Plug in another `ISerializer`, for example a Kryo-based one from WicketStuff:

```java
getFrameworkSettings().setSerializer(new MySerializer());
```

## Check the size of pages and sessions

The `DebugBar` from `wicket-devutils` shows the size of the session while you develop, and links to an inspector of the current page and to a browser of the page store. Add it to a base page:

```java
add(new DebugBar("debug"));
```

```html
<div wicket:id="debug"></div>
```
