---
title: How Wicket localizes
type: explanation
topic: i18n
summary: Where the locale of a page comes from, why texts live in properties files next to the components that use them, and why the page can override its panels.
since: 10
apis: [Session, Component, Localizer, IStringResourceLoader]
keywords: [i18n, internationalization, l10n, translation, locale, language, resource bundle, properties file, style, variation, skin, browser language, Accept-Language]
order: 10
source: [i18n/i18n_1.adoc, i18n/i18n_2.adoc]
---

Wicket localizes an application with the same building blocks as Java: a `java.util.Locale` that names a language and country, and properties files with keys and translated texts. What Wicket adds is where it looks for those files. Instead of one bundle for the whole application, every page, panel and component can have its own, and Wicket searches them along the component tree. The exact search order is listed in [Where Wicket looks for texts]({{ site.baseurl }}/docs/bundle-lookup.html); this page explains the ideas behind it.

## Where the locale comes from

When Wicket creates a session, it takes the locale from the request, which the servlet container derives from the `Accept-Language` header that the browser sends. A visitor whose browser prefers German gets a session with a German locale, without any code in your application.

Components do not store a locale. `Component#getLocale()` asks the parent, which asks its parent, up to the page, which asks the session. So `Session#setLocale` switches the whole user interface at once, from the next render on. Override `getLocale()` on a panel to render that part of a page in another language, for example a preview of an email in the language of its recipient.

Everything that depends on the language reads the locale this way: the lookup of texts, the choice of markup files, and the converters that format and parse numbers and dates in form fields and labels. A Dutch user types `3,5` and a British user `3.5`, and both end up with the same `Double`.

## Texts belong to components

A Java `ResourceBundle` has one base name and is looked up once. Wicket reuses the naming scheme of bundles, `Name_de_CH.properties`, but runs its own lookup over many files: the bundle of the page, of each component on the path to the component that needs the text, of their superclasses, of their packages and of the application.

The reason is reuse. A panel that is shipped in a library brings its own texts in a properties file next to its class, just as it brings its markup file. Whoever uses the panel does not have to copy its keys into an application-wide bundle, and translating the panel means adding `DatePanel_nl.properties` beside it.

The same holds for class hierarchies. A `BasePage.properties` provides texts for every page that extends `BasePage`, and a subclass can override single keys in its own file, the way markup inheritance lets a subclass fill in parts of the base markup.

## Why the page wins over its panels

When a label inside a panel inside a page asks for a text, Wicket looks in the bundle of the page first, then the panel, then the label. That order surprises people who expect the most specific file to win, but it follows from reuse.

Picture three teams. Team A writes a reusable panel with its own texts. Team B builds a larger component that contains A's panel, and wants one of the texts to read differently. Team C puts B's component on a page, and later the customer asks for yet another wording on that page. If the innermost bundle won, B and C would have to change code they do not own. Because the outer bundle wins, B overrides A in B's bundle and C overrides both in the page bundle, and nobody touches the component they use.

Keys can also be aimed at one component. In the bundle of a page, `form.name.Required` applies only to the component at path `form:name`, while `Required` applies to every component that asks for that key. This lets one page bundle hold different texts for different instances of the same panel.

## Style and variation

Besides the locale, two strings take part in the lookup: the style and the variation. The style belongs to the session (`Session#setStyle`) and stands for a skin or brand, such as a white-label version of the application for one customer. The variation belongs to a component (`Component#getVariation`, inherited from the parent) and stands for a version of that component, such as a compact layout of a panel.

Both become part of the file name, `ProductPanel_compact_acme_de.properties`, and Wicket tries the names with style and variation before the plain name. The same names apply to markup files and package resources, so a style can change texts, markup and CSS together, while every file that has no styled version falls back to the plain one.

## Markup or properties

You can localize in two places. Properties files hold texts, and the markup refers to them with `<wicket:message>` or receives them through models. A localized markup file, `HomePage_de.html` next to `HomePage.html`, replaces the whole layout for that language.

Properties files keep one layout for all languages, so a change to the page has to be made only once. Localized markup files suit pages where the languages differ in more than words: a legal text that is structured differently per country, or a layout for a right-to-left script. Most applications use properties files and add a localized markup file for the few pages that need one.

## One mechanism for every text

The lookup is the same for every text Wicket shows. `Component#getString`, `ResourceModel`, `StringResourceModel`, `<wicket:message>`, the error messages of validators and converters, and the placeholder text of a drop-down all go through the `Localizer`, which asks a chain of string resource loaders. A validator you write can ship its messages in a properties file next to its class. Wicket's own messages, such as `'${label}' is required.` and the messages of its validators, live in the bundle of the `Application` class, near the end of the search, so that your bundles can replace them.

Because the loaders form a chain, you can add your own, for example to read texts from a database or from an existing Java `ResourceBundle`: see [Load texts from your own source]({{ site.baseurl }}/docs/custom-string-loaders.html). For the everyday work of translating a page, see [Translate component texts]({{ site.baseurl }}/docs/localize-components.html).
