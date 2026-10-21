---
title: Translate the options of a choice
type: howto
topic: i18n
summary: Show translated options in a DropDownChoice, RadioChoice or other choice component, translate enum values, and change the "Choose One" text.
since: 10
apis: [AbstractChoice, EnumChoiceRenderer, DropDownChoice, RadioChoice, CheckBoxMultipleChoice, AbstractSingleSelectChoice]
keywords: [localizeDisplayValues, translate dropdown, translate select options, enum translation, Choose One, null option, nullValid, placeholder option]
order: 30
source: [i18n/i18n_4.adoc]
---

Choice components, such as `DropDownChoice`, `RadioChoice`, `ListChoice` and `CheckBoxMultipleChoice`, show the display value of each choice as it is. To show it in the user's language, look the display value up as a key, or render enum values through an `EnumChoiceRenderer`.

## Use the display values as keys

Override `localizeDisplayValues()` to return `true`. The choice component then treats each display value as a key:

*PreferencesPage.java*

```java
List<String> colors = List.of("green", "red", "blue", "yellow");

add(new DropDownChoice<>("color", colorModel, colors) {
    @Override
    protected boolean localizeDisplayValues() {
        return true;
    }
});
```

*PreferencesPage.properties*

```properties
green=Green
red=Red
blue=Blue
yellow=Yellow
```

*PreferencesPage_de.utf8.properties*

```properties
green=Grün
red=Rot
blue=Blau
yellow=Gelb
```

For each option, Wicket first tries the key `<component id>.<display value>`, here `color.green`, and then `green`. When neither exists, it shows the display value itself. The value that is submitted does not change; only the text the user sees is translated.

## Translate enum values

For an enum, use an `EnumChoiceRenderer`. It looks up the key `<enum class simple name>.<constant name>`:

```java
public enum Size { SMALL, MEDIUM, LARGE }

add(new DropDownChoice<>("size", sizeModel, List.of(Size.values()),
    new EnumChoiceRenderer<>(this)));
```

```properties
Size.SMALL=Small
Size.MEDIUM=Medium
Size.LARGE=Large
```

Pass a component to the constructor, usually the page or panel, so that its bundles are searched. Without one, the renderer only looks in application-wide bundles. Unlike `localizeDisplayValues`, a missing key is an error, so every constant needs a text. Override `resourceKey(T)` to use other keys.

## Change the text of the empty option

A `DropDownChoice` shows an extra option when it has no selection yet, by default "Choose One". When `setNullValid(true)` makes no selection a valid choice, the extra option is always there and is empty by default. Both texts are looked up like other texts:

| Option | Keys tried in turn | Default |
|---|---|---|
| no selection yet, null not valid | `<id>.null`, `null` | `Choose One` |
| null is valid | `<id>.nullValid`, `nullValid` | empty |

```properties
color.null=Pick a color
size.nullValid=No preference
```

`null=...` without an id in the application bundle changes the text for every drop-down in the application.

These keys work whether or not the display values are translated. The lookup of each key follows the usual order, described in [Where Wicket looks for texts]({{ site.baseurl }}/docs/bundle-lookup.html). The choice components themselves are listed in [Form components]({{ site.baseurl }}/docs/form-components.html).
