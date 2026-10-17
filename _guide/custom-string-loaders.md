---
title: Load texts from your own source
type: howto
topic: i18n
summary: Add a string resource loader that reads texts from a database or an existing Java ResourceBundle, and change the chain of loaders Wicket searches.
since: 10
apis: [IStringResourceLoader, ResourceSettings, BundleStringResourceLoader, NestedStringResourceLoader, Localizer, PackageStringResourceLoader]
keywords: [database translations, messages from database, ResourceBundle, string resource loader, custom localization, translation service, nested keys, clear localization cache]
order: 40
source: [i18n/i18n_3.adoc]
---

Add your own string resource loader when texts do not come from properties files next to your classes: translations kept in a database so that editors can change them, an existing Java `ResourceBundle` shared with other applications, or a translation service. Wicket asks its loaders in turn until one returns a text; see [Where Wicket looks for texts]({{ site.baseurl }}/docs/bundle-lookup.html#string-resource-loaders) for the default chain.

## Write a loader

Implement `IStringResourceLoader`. It has two methods: one that gets the component asking for the text, and one that gets only a class. Return `null` when you have no text for the key, so that the next loader gets its turn. Do not throw an exception for a missing key.

*DatabaseStringResourceLoader.java*

```java
public class DatabaseStringResourceLoader implements IStringResourceLoader {

    private final TranslationRepository translations;

    public DatabaseStringResourceLoader(TranslationRepository translations) {
        this.translations = translations;
    }

    @Override
    public String loadStringResource(Class<?> clazz, String key, Locale locale,
            String style, String variation) {
        return translations.find(key, locale).orElse(null);
    }

    @Override
    public String loadStringResource(Component component, String key, Locale locale,
            String style, String variation) {
        return loadStringResource(component != null ? component.getClass() : null,
            key, locale, style, variation);
    }
}
```

`TranslationRepository` stands for your own data access. Wicket passes the locale as it is, for example `de_CH`. Falling back from `de_CH` to `de` and then to a default text is up to the repository.

The locale, style and variation are already resolved from the component; use the arguments, not the component, to read them.

## Register the loader

Add the loader to the list in the resource settings, in the `init()` method of your application. The position decides its priority:

```java
@Override
protected void init() {
    super.init();
    List<IStringResourceLoader> loaders = getResourceSettings().getStringResourceLoaders();

    // database texts override the properties files
    loaders.add(0, new DatabaseStringResourceLoader(translationRepository));

    // or: properties files first, database as a fallback
    // loaders.add(new DatabaseStringResourceLoader(translationRepository));
}
```

The list is modifiable, so you can also remove a default loader, or clear it and build your own chain.

## Make changed texts visible

The `Localizer` caches every lookup by key, component path, locale, style and variation, including lookups that found nothing. When a text in your source changes, clear the cache:

```java
Localizer.get().clearCache();
```

`Localizer#setEnableCache(false)` turns the cache off, which helps while you edit texts during development and costs a lookup in every loader on every request.

## Reuse an existing Java ResourceBundle

`BundleStringResourceLoader` reads texts from a standard `ResourceBundle` by its base name, with Java's own lookup by locale:

```java
getResourceSettings().getStringResourceLoaders()
    .add(new BundleStringResourceLoader("com.example.i18n.Messages"));
```

It ignores style, variation and the component.

## Refer to other keys from a text

`NestedStringResourceLoader` wraps a list of loaders and replaces references to other keys inside a text. You choose the syntax with a regular expression whose first group is the key:

```java
List<IStringResourceLoader> loaders = getResourceSettings().getStringResourceLoaders();
NestedStringResourceLoader nested = new NestedStringResourceLoader(loaders,
    Pattern.compile("#\\(([^ ]*?)\\)"));
loaders.clear();
loaders.add(nested);
```

```properties
app.name=Acme Shop
welcome=Welcome to #(app.name)!
```

When a referenced key is not found, the whole text is not found.

## Rename the package bundle files

Package bundles are called `wicket-package.properties`. To use another name, replace the `PackageStringResourceLoader` in the list with one that has another file name:

```java
PackageStringResourceLoader packageLoader = new PackageStringResourceLoader();
packageLoader.setFilename("messages");
List<IStringResourceLoader> loaders = getResourceSettings().getStringResourceLoaders();
loaders.replaceAll(loader -> loader instanceof PackageStringResourceLoader ? packageLoader : loader);
```
