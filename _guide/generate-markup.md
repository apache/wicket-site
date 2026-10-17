---
title: Generate markup from code
type: howto
topic: components
summary: Give a panel or page markup built in Java instead of an HTML file, and control whether Wicket caches it.
since: 10
apis: [IMarkupResourceStreamProvider, IMarkupCacheKeyProvider, StringResourceStream, MarkupFactory]
keywords: [dynamic markup, markup without html file, markup from database, template from string, markup cache, getMarkupResourceStream, getCacheKey, CMS]
order: 130
source: [advanced/advanced_6.adoc]
---

Use this when a component's markup cannot be a file next to its class: it comes from a database or a CMS, is assembled from configuration, or differs per customer. A page, panel or border can supply its own markup by implementing `IMarkupResourceStreamProvider`.

## Return the markup from the component

Implement `getMarkupResourceStream` and return the markup as an `IResourceStream`. For markup in a string, wrap it in a `StringResourceStream`. The markup follows the same rules as a file: a panel's markup needs `<wicket:panel>`, a border's `<wicket:border>`.

```java
public class NoticePanel extends Panel implements IMarkupResourceStreamProvider {

    public NoticePanel(String id, IModel<String> text) {
        super(id);
        add(new Label("text", text));
    }

    @Override
    public IResourceStream getMarkupResourceStream(MarkupContainer container, Class<?> containerClass) {
        return new StringResourceStream("""
            <wicket:panel>
              <aside class="notice"><p wicket:id="text"></p></aside>
            </wicket:panel>
            """);
    }
}
```

The markup can contain `wicket:id` tags; the component adds the matching components as usual. No `NoticePanel.html` is needed.

## Cache the markup per variant

Wicket caches markup per class, locale, style and variation, and asks for the markup stream only once per cache key. A component whose markup depends on other state must tell Wicket how to tell the versions apart. Implement `IMarkupCacheKeyProvider` and return a key that differs for each version of the markup:

```java
public class TenantPanel extends Panel
        implements IMarkupResourceStreamProvider, IMarkupCacheKeyProvider {

    private final String tenant;

    public TenantPanel(String id, String tenant) {
        super(id);
        this.tenant = tenant;
    }

    @Override
    public IResourceStream getMarkupResourceStream(MarkupContainer container, Class<?> containerClass) {
        return new StringResourceStream(templates.panelFor(tenant));
    }

    @Override
    public String getCacheKey(MarkupContainer container, Class<?> containerClass) {
        return containerClass.getName() + "_" + tenant + "_" + container.getLocale();
    }
}
```

Include the locale (and the style, if you use styles) in the key when the markup depends on them.

## Turn caching off

Return `null` from `getCacheKey` and Wicket does not cache the markup: it asks for the stream and parses it every time it needs the markup. Use this only for markup that really changes between renders. Parsing on every render costs time, and markup that changes between requests can break pages that are already in the browser, for example when an Ajax request refers to a component whose tag has gone.

```java
@Override
public String getCacheKey(MarkupContainer container, Class<?> containerClass) {
    return null;
}
```

## Keep user content out of the markup

Generated markup is parsed as a template, not escaped. Never paste user input or other untrusted text into it: it could add tags, scripts or `wicket:` tags. Put such content in a component, such as a `Label`, which escapes it. To show trusted HTML from a CMS without Wicket tags, a `Label` with `setEscapeModelStrings(false)` is simpler than generating markup.

## Change how all markup is loaded

`IMarkupResourceStreamProvider` works per component. To change where Wicket looks for the markup of every component, for example to load all templates from a directory outside the classpath, configure the resource stream locator in the resource settings instead; see [Customize where resources are loaded from]({{ site.baseurl }}/docs/resource-loading.html). How Wicket loads, parses and caches markup is described in [How markup becomes components]({{ site.baseurl }}/docs/auto-components.html).
