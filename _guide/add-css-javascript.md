---
title: Add CSS and JavaScript to a page
type: howto
topic: resources
summary: Let a component or behavior add its stylesheets, script files and start-up code to the page header with renderHead and header items.
since: 10
apis: [IHeaderResponse, IHeaderContributor, CssHeaderItem, JavaScriptHeaderItem, OnDomReadyHeaderItem, CssResourceReference, JavaScriptResourceReference]
keywords: [renderHead, stylesheet, script tag, link tag, head, wicket:head, inline script, document ready, DOMContentLoaded, defer, Content-Security-Policy, CSP, nonce, script blocked]
order: 30
source: [resources/resources_4.adoc, keepControl/keepControl_6.adoc]
---

Add CSS and JavaScript from Java when a component needs them: the component then brings its own files to every page it is placed on, each file appears in the header once, and Wicket adds the nonce that the Content Security Policy requires.

## Add a stylesheet from a component

Put the file in the package of the component, override `renderHead` and render a `CssHeaderItem`:

*CalendarPanel.java*

```java
public class CalendarPanel extends Panel {

    private static final CssResourceReference CSS =
        new CssResourceReference(CalendarPanel.class, "calendar.css");

    public CalendarPanel(String id) {
        super(id);
    }

    @Override
    public void renderHead(IHeaderResponse response) {
        super.renderHead(response);
        response.render(CssHeaderItem.forReference(CSS));
    }
}
```

The page gets `<link rel="stylesheet" type="text/css" href="./wicket/resource/com.example.CalendarPanel/calendar-ver-….css" nonce="…"/>` in its `<head>`. A media query goes in a second argument: `CssHeaderItem.forReference(CSS, "print")`.

A reference is a small immutable name, so one static instance per file is enough.

## Add a script file

Render a `JavaScriptHeaderItem` the same way:

```java
private static final JavaScriptResourceReference JS =
    new JavaScriptResourceReference(CalendarPanel.class, "calendar.js");

@Override
public void renderHead(IHeaderResponse response) {
    super.renderHead(response);
    response.render(CssHeaderItem.forReference(CSS));
    response.render(JavaScriptHeaderItem.forReference(JS).setDefer(true));
}
```

`setDefer(true)` and `setAsync(true)` add the matching attributes to the `<script>` tag. When the script needs jQuery or another library first, declare that on the reference instead of rendering both in order, see [Declare dependencies between resources]({{ site.baseurl }}/docs/resource-dependencies.html).

Files that are not in a package have their own pages: [Use files from the web application root]({{ site.baseurl }}/docs/context-resources.html), and for a CDN, `JavaScriptHeaderItem.forUrl(url)` and `CssHeaderItem.forUrl(url)`.

## Run JavaScript when the page is ready

Code that sets up the component goes in an `OnDomReadyHeaderItem`. Give the component a markup id so the script can find its element:

```java
public CalendarPanel(String id) {
    super(id);
    setOutputMarkupId(true);
}

@Override
public void renderHead(IHeaderResponse response) {
    super.renderHead(response);
    response.render(JavaScriptHeaderItem.forReference(JS));
    response.render(OnDomReadyHeaderItem.forScript(
        "Calendar.init('" + getMarkupId() + "');"));
}
```

Wicket collects the ready scripts of all components into one inline script that runs when the DOM is loaded. When an Ajax request replaces the component, the script runs again after the new markup is in place, so the widget is set up again. Escape values from users before you put them in a script, for example with `JavaScriptUtils.escapeQuotes`.

`OnDomReadyHeaderItem` depends on Wicket's JavaScript library, which Wicket renders first. By default that library is built on jQuery, so the page also loads jQuery: version 3.7.1 in Wicket 10 and 4.0 in Wicket 11.

> Since Wicket 11, a plain JavaScript version of Wicket's library, `WicketAjaxResourceReference`, can replace the jQuery-based one, so that ready scripts and Ajax work without jQuery. See [Run Ajax without jQuery]({{ site.baseurl }}/docs/ajax-without-jquery.html).
{: .since}

To run code after images and other files have loaded, use `OnLoadHeaderItem`. To attach a handler to an event of an element, use `OnEventHeaderItem.forComponent(component, "click", script)`. All header item types are listed in [Header items]({{ site.baseurl }}/docs/header-items.html).

## Keep scripts out of the markup

Wicket's default Content Security Policy only lets the browser run scripts and apply styles that carry the nonce of the current response. Wicket adds the nonce to every script and style it renders from a header item, including `OnDomReadyHeaderItem` and `JavaScriptHeaderItem.forScript`. Tags you type yourself get no nonce:

```html
<!-- blocked by the default Content Security Policy -->
<script>Calendar.init('cal1');</script>
<button onclick="Calendar.today()">Today</button>
<div style="color: red">…</div>
```

The browser refuses to run the script and the `onclick` handler, ignores the `style` attribute, and reports a violation in its console. Move the code into a file and an `OnDomReadyHeaderItem`, attach handlers with `OnEventHeaderItem` or an Ajax behavior, and put styles in a stylesheet with a class. [Configure the Content Security Policy]({{ site.baseurl }}/docs/csp.html) shows how to relax the policy if you cannot avoid inline code.

## Contribute from a behavior

A behavior has the same hook, with the component as an extra argument. Use it to add a script to any component without subclassing it:

```java
public class AutoGrowBehavior extends Behavior {

    private static final JavaScriptResourceReference JS =
        new JavaScriptResourceReference(AutoGrowBehavior.class, "autogrow.js");

    @Override
    public void bind(Component component) {
        component.setOutputMarkupId(true);
    }

    @Override
    public void renderHead(Component component, IHeaderResponse response) {
        response.render(JavaScriptHeaderItem.forReference(JS));
        response.render(OnDomReadyHeaderItem.forScript(
            "AutoGrow.attach('" + component.getMarkupId() + "');"));
    }
}
```

```java
add(new TextArea<>("comment", commentModel).add(new AutoGrowBehavior()));
```

See [Add behavior to a component with a Behavior]({{ site.baseurl }}/docs/add-behaviors.html).

## Add header markup with wicket:head

A panel, border or page can also put markup into the page header with `<wicket:head>`. Wicket adds its content once per component class, however many instances are on the page. Inline `<script>` and `<style>` in it get no nonce and are blocked like any other inline code, so use it for tags that load files, and wrap those in `<wicket:link>` so Wicket writes the URLs and the nonce:

*CalendarPanel.html*

```html
<wicket:head>
    <wicket:link>
        <link rel="stylesheet" href="calendar.css"/>
    </wicket:link>
</wicket:head>
<wicket:panel>
    …
</wicket:panel>
```

Header items from `renderHead` take part in dependencies, ordering and bundles; the content of `<wicket:head>` does not.
