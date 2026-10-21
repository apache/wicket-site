---
title: Translate component texts
type: howto
topic: i18n
summary: Move the texts of a page or panel into properties files, show them with wicket:message or from Java, and let the user switch the language.
since: 10
apis: [Session, Component, ResourceModel]
keywords: [translate, translation, multilingual, properties file, "wicket:message", getString, change language, language switcher, setLocale, UTF-8 properties, XML properties, localized markup, Chinese, Japanese]
order: 10
source: [i18n/i18n_2.adoc]
---

To translate a page or panel, put its texts in properties files next to its class, one file per language, and refer to them by key from the markup or the Java code. How Wicket finds the right file is explained in [How Wicket localizes]({{ site.baseurl }}/docs/about-localization.html).

## Create a properties file per language

Next to `HomePage.java` and `HomePage.html`, add a file with the default texts and one file per translation. The language code, and optionally the country, goes between the class name and the extension:

```
src/main/java/com/example/
├── HomePage.java
├── HomePage.html
├── HomePage.properties             default texts
├── HomePage_de.utf8.properties     German
└── HomePage_fr_CA.utf8.properties  French for Canada
```

*HomePage.properties*

```properties
greeting=Welcome to the shop!
search.placeholder=Search products
search.title=Type a product name and press Enter
```

*HomePage_de.utf8.properties*

```properties
greeting=Willkommen im Shop!
search.placeholder=Produkte suchen
search.title=Produktnamen eingeben und Enter drücken
```

A key missing in `HomePage_de.utf8.properties` falls back to `HomePage.properties`. Texts used on many pages go in the bundle of a base page, a package (`wicket-package.properties`) or the application class (`WicketApplication.properties`).

## Save files with non-Latin characters as UTF-8

Wicket reads `.properties` files as ISO 8859-1, like `java.util.Properties`. When your editor saves UTF-8, as most do, characters such as `ü` come out garbled, and Chinese or Cyrillic text cannot be written in that encoding at all. In a `.properties` file you have to write them as Unicode escapes, such as `ü`.

Name the file `.utf8.properties` instead, and Wicket reads it as UTF-8. This is the simplest choice for every language, German included:

```
HomePage_zh.utf8.properties
```

```properties
greeting=欢迎光临本网站！
```

Wicket also reads XML properties files, which declare their own encoding, with the extension `.properties.xml`:

*HomePage_ja.properties.xml*

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd">
<properties>
    <entry key="greeting">ショップへようこそ！</entry>
</properties>
```

For each file name, Wicket uses the first of `.properties`, `.utf8.properties` and `.properties.xml` that exists. Keep one format per file name.

## Show a text in the markup

`<wicket:message>` replaces itself with the text for its key. The content between the tags is only for previewing the markup:

*HomePage.html*

```html
<h1><wicket:message key="greeting">Welcome!</wicket:message></h1>
```

To translate attributes, add a `wicket:message` attribute with `attribute:key` pairs, separated by commas:

```html
<input type="search" wicket:message="placeholder:search.placeholder,title:search.title">
```

The text is not escaped by default. Add `escape="true"` to the tag when the text may contain `<` or `&`.

A key that is not found in any bundle makes Wicket throw an exception, so a missing translation shows up during development. `ResourceSettings#setThrowExceptionOnMissingResource(false)` makes Wicket log a warning instead.

## Put components inside a translated sentence

A sentence with a link or a value in the middle stays one key. Nest the components inside `<wicket:message>` and refer to them with `${id}` in the text:

*CartPage.html*

```html
<wicket:message key="cart.summary">
    You have <span wicket:id="count">3</span> items.
    <a wicket:id="checkout"><wicket:message key="cart.checkout">Check out</wicket:message></a>
</wicket:message>
```

*CartPage.properties*

```properties
cart.summary=You have ${count} items in your cart. ${checkout} now.
cart.checkout=Check out
```

*CartPage.java*

```java
add(new Label("count", cartModel.map(Cart::getItemCount)));
add(new BookmarkablePageLink<Void>("checkout", CheckoutPage.class));
```

Each translation can put `${count}` and `${checkout}` where its grammar needs them.

## Show a text from Java

Use a `ResourceModel` for the model of a component. It looks up the text when the component renders, so it follows a change of language and works in the constructor:

```java
add(new Label("greeting", new ResourceModel("greeting")));
```

`Component#getString(key)` returns the text right away. Call it during rendering, in `onConfigure` or inside a model lambda, not in the constructor: until the component is on a page, Wicket cannot search the bundles of its parents.

```java
add(new Label("greeting", () -> getString("greeting")));
```

To put values in a text, such as a name or a date, see [Put model values into translated texts]({{ site.baseurl }}/docs/resource-models.html).

## Use a different markup file per language

When a language needs a different layout, not only different words, add a localized markup file next to the default one:

```
CustomPanel.html
CustomPanel_de.html
```

For a German locale Wicket uses `CustomPanel_de.html`; for all other locales `CustomPanel.html`.

## Let the user switch the language

Wicket starts each session with the language of the browser. To let the user change it, set the locale of the session. This drop-down does so as soon as the user picks a language:

*BasePage.java*

```java
List<Locale> languages = List.of(Locale.ENGLISH, Locale.GERMAN, Locale.forLanguageTag("nl"));

DropDownChoice<Locale> language = new DropDownChoice<>("language",
    LambdaModel.of(() -> getSession().getLocale(), locale -> getSession().setLocale(locale)),
    languages,
    new LambdaChoiceRenderer<Locale>(locale -> locale.getDisplayLanguage(locale), Locale::toLanguageTag));
language.add(new FormComponentUpdatingBehavior());
add(language);
```

*BasePage.html*

```html
<select wicket:id="language"></select>
```

Each language is shown in its own language, so users find theirs whatever the page is currently in. The next render uses the new locale for texts, markup files and number and date formats.
