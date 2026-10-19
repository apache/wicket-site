---
title: Declare dependencies between resources
type: howto
topic: resources
summary: Make a script or stylesheet pull in the libraries it needs by overriding getDependencies, so Wicket always renders them first and only once.
since: 10
apis: [ResourceReference, HeaderItem, JQueryPluginResourceReference, JavaScriptLibrarySettings, UrlResourceReference, JQueryResourceReference]
keywords: [getDependencies, depends on jQuery, load order, script order, jQuery plugin, CDN, library before plugin, CircularDependencyException]
order: 50
source: [resources/resources_6.adoc]
---

Declare a dependency when a script or stylesheet only works after another one is loaded, such as a jQuery plugin or a theme on top of a base stylesheet. Every component that renders the file then gets the library too, in the right order, without knowing about it.

## Declare what a reference depends on

Subclass the reference and override `getDependencies()`. Return header items for what must come first, and keep what the superclass returns:

*ChartJs.java*

```java
public class ChartJs extends JavaScriptResourceReference {

    private static final ChartJs INSTANCE = new ChartJs();

    public static ChartJs get() {
        return INSTANCE;
    }

    private ChartJs() {
        super(ChartJs.class, "chart.js");
    }

    @Override
    public List<HeaderItem> getDependencies() {
        List<HeaderItem> dependencies = super.getDependencies();
        dependencies.add(JavaScriptHeaderItem.forReference(ChartCoreJs.get()));
        dependencies.add(CssHeaderItem.forReference(ChartCss.get()));
        return dependencies;
    }
}
```

A component now renders only the reference it uses:

```java
@Override
public void renderHead(IHeaderResponse response) {
    super.renderHead(response);
    response.render(JavaScriptHeaderItem.forReference(ChartJs.get()));
}
```

Wicket renders `ChartCoreJs` and `ChartCss` before `chart.js`, and renders each file once even when several components on the page, or other references, depend on it. Dependencies can have dependencies of their own, and a script can depend on a stylesheet or the other way round. A cycle makes Wicket throw a `CircularDependencyException` while it renders the page.

## Depend on jQuery

For a jQuery plugin, extend `JQueryPluginResourceReference`. It depends on the jQuery that the application is configured with:

```java
public class DatePickerJs extends JQueryPluginResourceReference {

    private static final DatePickerJs INSTANCE = new DatePickerJs();

    public static DatePickerJs get() {
        return INSTANCE;
    }

    private DatePickerJs() {
        super(DatePickerJs.class, "datepicker.js");
    }
}
```

The jQuery version comes from `getJavaScriptLibrarySettings().getJQueryReference()`. Point that setting at another reference to use your own copy of jQuery everywhere, including in Wicket's own components.

{% if site.wicket.version_11 %}
> Wicket 11 uses jQuery 4 by default; Wicket 10 uses jQuery 3. A plugin that does not work with jQuery 4 can keep jQuery 3 on Wicket 11 with
> `getJavaScriptLibrarySettings().setJQueryReference(JQueryResourceReference.getV3())`.
{: .since}
{% else %}
By default that is jQuery 3.
{% endif %}

To depend on Wicket's own Ajax and event functions, such as `Wicket.Event` or `Wicket.Ajax`, add `JavaScriptHeaderItem.forReference(getJavaScriptLibrarySettings().getWicketAjaxReference())` to the dependencies; get the settings with `Application.get()`. That reference follows the application's choice of library{% if site.wicket.version_11 %}, including the jQuery-free one that Wicket 11 offers, see [Run Ajax without jQuery]({{ site.baseurl }}/docs/ajax-without-jquery.html){% endif %}.

## Depend on a library from a CDN

`UrlResourceReference` points to a file on another server. It can declare dependencies like any other reference, and other references can depend on it:

```java
public class JQueryUiJs extends UrlResourceReference {

    private static final JQueryUiJs INSTANCE = new JQueryUiJs();

    public static JQueryUiJs get() {
        return INSTANCE;
    }

    private JQueryUiJs() {
        super(Url.parse("https://code.jquery.com/ui/1.14.1/jquery-ui.min.js"));
    }

    @Override
    public List<HeaderItem> getDependencies() {
        List<HeaderItem> dependencies = super.getDependencies();
        dependencies.add(JavaScriptHeaderItem.forReference(
            Application.get().getJavaScriptLibrarySettings().getJQueryReference()));
        return dependencies;
    }
}
```

The default Content Security Policy allows the script because Wicket gives it a nonce, but stylesheets, fonts and images that the library loads from that server need the host in the matching directive, see [Configure the Content Security Policy]({{ site.baseurl }}/docs/csp.html). For subresource integrity, render the item with `setIntegrity(…)` and `setCrossOrigin(CrossOrigin.ANONYMOUS)`, or set both on the reference.

## Give a header item its own dependencies

`HeaderItem` has the same `getDependencies()` method. Override it when the dependency belongs to one inline script rather than to a file:

```java
response.render(new OnDomReadyHeaderItem("Chart.draw('" + getMarkupId() + "');") {
    @Override
    public List<HeaderItem> getDependencies() {
        List<HeaderItem> dependencies = super.getDependencies();
        dependencies.add(JavaScriptHeaderItem.forReference(ChartJs.get()));
        return dependencies;
    }
});
```

Wicket renders the dependencies first and the ready script after all files, as described in [Control the order of header items]({{ site.baseurl }}/docs/header-order.html).
