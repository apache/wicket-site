---
title: Wrap a JavaScript widget in a component
type: howto
topic: ajax
summary: Package a JavaScript library with a component, initialize it with the component's markup id, keep it working after Ajax updates and call back to the server.
since: 10
apis: [OnDomReadyHeaderItem, JavaScriptResourceReference, AbstractDefaultAjaxBehavior, CallbackParameter, JavaScriptLibrarySettings]
keywords: [javascript library, widget, datepicker, flatpickr, jquery plugin, renderHead, init script, getCallbackFunction, reusable component, dhtml]
order: 80
source: [jsintegration.adoc, jsintegration/jsintegration_1.adoc, jsintegration/jsintegration_2.adoc, jsintegration/jsintegration_3.adoc]
---

Use this when you want a JavaScript widget, such as a date picker, to behave like any other Wicket component: added in Java, configured from Java, and working without setup in every page that uses it. The example wraps the [flatpickr](https://flatpickr.js.org/) date picker around a `LocalDateTextField`; the same steps apply to any library that attaches itself to an element.

## Package the library with the component

Put the library's files in the component's package, next to the class, and write a small script of your own that connects the library to Wicket:

```
src/main/java/com/example/datefield/
    DateField.java
    DateFieldJavaScript.java
    datefield.js
    flatpickr.min.js
    flatpickr.min.css
```

Then make one resource reference that pulls in everything the script needs, so a page only has to render that one:

*DateFieldJavaScript.java*

```java
public class DateFieldJavaScript extends JavaScriptResourceReference {
    public static final DateFieldJavaScript INSTANCE = new DateFieldJavaScript();

    private DateFieldJavaScript() {
        super(DateFieldJavaScript.class, "datefield.js");
    }

    @Override
    public List<HeaderItem> getDependencies() {
        List<HeaderItem> dependencies = super.getDependencies();
        dependencies.add(JavaScriptHeaderItem.forReference(
            Application.get().getJavaScriptLibrarySettings().getWicketAjaxReference()));
        dependencies.add(JavaScriptHeaderItem.forReference(
            new JavaScriptResourceReference(DateFieldJavaScript.class, "flatpickr.min.js")));
        dependencies.add(CssHeaderItem.forReference(
            new CssResourceReference(DateFieldJavaScript.class, "flatpickr.min.css")));
        return dependencies;
    }
}
```

Wicket renders every reference once per page, however many date fields the page has. [Declare dependencies between resources]({{ site.baseurl }}/docs/resource-dependencies.html) has more on dependencies.

## Initialize the widget from renderHead

The component renders the reference and a DOM-ready script that starts the widget on its own element. The element is found by its markup id, so switch that on. Pass options as JSON built in Java rather than by concatenating strings:

*DateField.java*

```java
public class DateField extends LocalDateTextField {

    public DateField(String id, IModel<LocalDate> model) {
        super(id, model, "yyyy-MM-dd");
        setOutputMarkupId(true);
    }

    @Override
    public void renderHead(IHeaderResponse response) {
        super.renderHead(response);
        if (!isEnabledInHierarchy()) {
            return;
        }
        response.render(JavaScriptHeaderItem.forReference(DateFieldJavaScript.INSTANCE));

        JSONObject options = new JSONObject()
            .put("dateFormat", "Y-m-d")
            .put("allowInput", true);
        response.render(OnDomReadyHeaderItem.forScript(
            "DateField.init('" + getMarkupId() + "', " + options + ");"));
    }
}
```

`JSONObject` is `com.github.openjson.JSONObject`, which wicket-core already depends on. The Java pattern `yyyy-MM-dd` and flatpickr's `Y-m-d` must describe the same format, or the field cannot parse what the picker writes. A disabled field gets no picker.

*datefield.js*

```javascript
var DateField = {
    init: function (id, options) {
        flatpickr(document.getElementById(id), options);
    }
};
```

The init script carries a nonce when the content security policy is on, like every header item Wicket renders; see [Configure the Content Security Policy]({{ site.baseurl }}/docs/csp.html).

## Keep it working after an Ajax update

When the field, or a container around it, is added to an `AjaxRequestTarget`, Wicket replaces its element and calls `renderHead` again, so the init script runs on the new element. The old widget instance is never told and may leave elements and listeners behind. Destroy it when Wicket removes the element:

*datefield.js*

```javascript
Wicket.Event.subscribe('/dom/node/removing', function (event, element) {
    var inputs = Array.from(element.querySelectorAll('input'));
    inputs.push(element);
    inputs.forEach(function (input) {
        if (input._flatpickr) {
            input._flatpickr.destroy();
        }
    });
});
```

The event fires for the replaced element only, which can be a container around the field, so the script also looks inside it. [React to Ajax requests in JavaScript]({{ site.baseurl }}/docs/ajax-call-listeners.html) lists the other events.

## Call the server from the widget

To let the server react to the widget, add an Ajax behavior to the component and hand its callback function to the script. `getCallbackFunction` returns a JavaScript function; each `CallbackParameter.explicit` becomes an argument of that function and a request parameter of the same name:

```java
private final AbstractDefaultAjaxBehavior picked = new AbstractDefaultAjaxBehavior() {
    @Override
    protected void respond(AjaxRequestTarget target) {
        String date = RequestCycle.get().getRequest().getRequestParameters()
            .getParameterValue("date").toString();
        onPicked(target, LocalDate.parse(date));
    }
};

public DateField(String id, IModel<LocalDate> model) {
    super(id, model, "yyyy-MM-dd");
    setOutputMarkupId(true);
    add(picked);
}

protected void onPicked(AjaxRequestTarget target, LocalDate date) {
}

// in renderHead
response.render(OnDomReadyHeaderItem.forScript("DateField.init('" + getMarkupId() + "', "
    + options + ", " + picked.getCallbackFunction(CallbackParameter.explicit("date")) + ");"));
```

*datefield.js*

```javascript
var DateField = {
    init: function (id, options, onPick) {
        options.onChange = function (selectedDates, dateStr) {
            onPick(dateStr);
        };
        flatpickr(document.getElementById(id), options);
    }
};
```

The callback does not submit the form, so the field's model is not updated by it. Read the value from the parameter, as above, or submit the form with an `AjaxFormSubmitBehavior`.

## Libraries that need jQuery

A jQuery plugin needs jQuery on the page. Add `getJavaScriptLibrarySettings().getJQueryReference()` to the dependencies of your reference, before the plugin. Wicket's own Ajax library does not guarantee jQuery is there.

{% if site.wicket.version_11 %}
> Since Wicket 11, `getJQueryReference()` returns jQuery 4.0 by default instead of 3.7.1, and an application can run Wicket's Ajax without loading jQuery at all; see [Run Ajax without jQuery]({{ site.baseurl }}/docs/ajax-without-jquery.html).
{: .since}
{% else %}
By default `getJQueryReference()` returns jQuery 3.7.1.
{% endif %}
