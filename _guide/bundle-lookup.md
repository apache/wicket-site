---
title: Where Wicket looks for texts
type: reference
topic: i18n
summary: The exact order in which Wicket searches resource bundles for a key, the file names it tries, and the settings that change the search.
since: 10
apis: [Localizer, IStringResourceLoader, ComponentStringResourceLoader, PackageStringResourceLoader, ClassStringResourceLoader, ValidatorStringResourceLoader, InitializerStringResourceLoader, ResourceSettings, PropertiesFactory]
keywords: [resource bundle lookup, properties file order, message key not found, MissingResourceException, wicket-package.properties, utf8.properties, properties.xml, component path key, override text, translation priority]
order: 10
source: [i18n/i18n_3.adoc]
---

Every text that Wicket looks up by key, through `Component#getString`, `ResourceModel`, `StringResourceModel`, `<wicket:message>`, feedback messages of validators and converters, or the null option of a choice, goes through the `Localizer`. The `Localizer` asks a chain of string resource loaders, and each loader searches a set of bundles. The first text found wins. Why the search runs in this order is explained in [How Wicket localizes]({{ site.baseurl }}/docs/about-localization.html).

## Inputs of a lookup

| Input | Taken from |
|---|---|
| key | the caller |
| component | the component the text is for; may be `null` |
| locale | `Component#getLocale()`, which asks the parents and finally `Session#getLocale()` |
| style | `Session#getStyle()` |
| variation | `Component#getVariation()`, which asks the parents; `null` for a page unless overridden |

## String resource loaders

The default chain in `ResourceSettings#getStringResourceLoaders()`, asked in this order:

| # | Loader | Searches |
|---|---|---|
| 1 | `ComponentStringResourceLoader` | bundles of the components from the page down to the component, and of their superclasses |
| 2 | `PackageStringResourceLoader` | `wicket-package` bundles in the packages of those components, up to the root package |
| 3 | `ClassStringResourceLoader` | bundles of the application class and its superclasses, down to Wicket's `Application` |
| 4 | `ValidatorStringResourceLoader` | bundles of the validators of the form component, or the form validators of the form, that asks |
| 5 | `InitializerStringResourceLoader` | bundles of the `IInitializer` classes of Wicket modules |

Two more loaders exist but are not in the default chain: `BundleStringResourceLoader`, which reads a Java `ResourceBundle` by base name, and `NestedStringResourceLoader`, which resolves references to other keys. See [Load texts from your own source]({{ site.baseurl }}/docs/custom-string-loaders.html).

## Order of components and keys

`ComponentStringResourceLoader` walks the component path from the page down to the component that asks. At each component it first tries the key prefixed with the path that is left below that component, with ids joined by dots, and then the plain key. For a key `title` asked by the label `total` inside the panel `summary` on `OrderPage`:

| Step | Bundles of | Key |
|---|---|---|
| 1 | `OrderPage` | `summary.total.title` |
| 2 | `OrderPage` | `title` |
| 3 | `OrderSummaryPanel` (id `summary`) | `total.title` |
| 4 | `OrderSummaryPanel` | `title` |
| 5 | `Label` (id `total`) | `title` |

| Rule | |
|---|---|
| Bundles of a component | the bundle of its class, then of each superclass. The walk stops after the first Wicket base class it meets: `WebPage`, `Page`, `WebMarkupContainer`, `MarkupContainer`, `WebComponent` or `Component` |
| Repeater items | the ids of the items of a repeater, such as the index of a `ListView` item, are left out of the prefix: `rows.name`, not `rows.0.name` |
| Component not on a page | the walk starts at the topmost parent. `Localizer` logs a warning, because the parents that will hold it later are not searched; this happens when `getString` is called in a constructor |
| Component `null` | this loader finds nothing |

`PackageStringResourceLoader` and `ClassStringResourceLoader` use the same steps and keys. Instead of the bundle of each component class they search:

| Loader | Bundles for a class |
|---|---|
| `PackageStringResourceLoader` | `wicket-package` in the package of the class, then in each parent package up to the root, then the same for each superclass |
| `ClassStringResourceLoader` | always the application class, then its superclasses up to and including `org.apache.wicket.Application`, whose bundle holds Wicket's default messages |

`ValidatorStringResourceLoader` and `InitializerStringResourceLoader` try only the plain key, in the bundles of the validator or initializer class and its superclasses.

## File names

For each class or package in the search, Wicket builds names from the path of the class, the variation, the style and the locale:

```
<path>[_<variation>][_<style>][_<language>[_<COUNTRY>[_<variant>]]]
```

It tries the combinations from the most specific to the plain path. For `com.example.OrderPage` with variation `compact`, style `acme` and locale `de_CH`:

| # | Name |
|---|---|
| 1 | `com/example/OrderPage_compact_acme_de_CH` |
| 2 | `com/example/OrderPage_compact_acme_de` |
| 3 | `com/example/OrderPage_compact_acme` |
| 4 | `com/example/OrderPage_acme_de_CH` |
| 5 | `com/example/OrderPage_acme_de` |
| 6 | `com/example/OrderPage_acme` |
| 7 | `com/example/OrderPage_compact_de_CH` |
| 8 | `com/example/OrderPage_compact_de` |
| 9 | `com/example/OrderPage_compact` |
| 10 | `com/example/OrderPage_de_CH` |
| 11 | `com/example/OrderPage_de` |
| 12 | `com/example/OrderPage` |

Combinations with an empty part are skipped: without a variation, names 1 to 3 and 7 to 9 are not tried. A locale variant adds `_de_CH_<variant>` before `_de_CH` in each group. The script and extensions of a locale are not used.

Unlike `java.util.ResourceBundle`, Wicket does not fall back to the default locale of the JVM. After the language comes the name without a locale.

## File formats

For each name, the `PropertiesFactory` tries these extensions in order and uses the first file that exists. Files with different extensions for the same name are not merged.

| Extension | Format | Encoding |
|---|---|---|
| `.properties` | `java.util.Properties` | ISO 8859-1; other characters as `\uXXXX` escapes |
| `.utf8.properties` | `java.util.Properties` | UTF-8 |
| `.properties.xml` | XML properties, DTD `http://java.sun.com/dtd/properties.dtd` | as declared in the XML header |

`getResourceSettings().getPropertiesFactory()` returns the factory; its `getPropertiesLoaders()` list can be changed to add or remove formats.

Files are found through the resource stream locator of the application, on the classpath by default, next to the class files. In development mode Wicket checks the files for changes every second and reloads them.

## Settings

| Setting | Default | Effect |
|---|---|---|
| `ResourceSettings#getStringResourceLoaders()` | the five loaders above | the chain; a modifiable list |
| `ResourceSettings#setThrowExceptionOnMissingResource(boolean)` | `true` | when no text and no default is found, `getString` throws a `MissingResourceException` and `<wicket:message>` a `WicketRuntimeException`. With `false`, `getString` returns `[Warning: Property for 'key' not found]`, and `<wicket:message>` logs a warning and renders its own body |
| `ResourceSettings#setUseDefaultOnMissingResource(boolean)` | `true` | use the default text passed by the caller when the key is not found |
| `Localizer#setEnableCache(boolean)` | `true` | cache results, including keys that were not found; `clearCache()` empties it |
| `PackageStringResourceLoader#setFilename(String)` | `wicket-package` | base name of package bundles |

## Find out why a text is not found

Set the log level of `org.apache.wicket.resource.loader` to `DEBUG` to log each class and key a loader tries, and of `org.apache.wicket.Localizer` to log where a key was found or that it was not.
