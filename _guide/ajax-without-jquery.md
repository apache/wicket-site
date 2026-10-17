---
title: Run Ajax without jQuery
type: howto
topic: ajax
summary: Switch the application to Wicket's plain JavaScript Ajax implementation, so pages no longer download jQuery.
since: 11
apis: [WicketAjaxResourceReference, WicketAjaxJQueryResourceReference, JavaScriptLibrarySettings]
keywords: [jquery-free, vanilla javascript, plain javascript, remove jquery, wicket-ajax.js, wicket-ajax-jquery.js, setWicketAjaxReference, bundle size]
order: 90
source: [ajax/ajax_11.adoc]
---

Use this when you want your pages to stop downloading jQuery: to send less JavaScript, or to drop a third-party library you do not use yourself. Wicket 11 ships two implementations of its client-side Ajax library with the same JavaScript API (`Wicket.Ajax`, `Wicket.Event`, `Wicket.DOM`, `Wicket.Form`, `Wicket.Head`, `Wicket.Focus` and the rest). The default, `wicket-ajax-jquery.js`, is built on jQuery. `wicket-ajax.js` uses only browser APIs. Java code does not notice the difference.

## Switch the application to the plain JavaScript implementation

Set the Ajax reference in your application's `init()`:

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();
    getJavaScriptLibrarySettings()
        .setWicketAjaxReference(WicketAjaxResourceReference.get());
}
```

Pages now contribute `wicket-ajax.js` instead of jQuery and `wicket-ajax-jquery.js`. Check it in the browser's network panel: no `jquery` file is loaded unless something else asks for it. To switch back, remove the line or set `WicketAjaxJQueryResourceReference.get()`, which is the default.

## What keeps working

Every component and behavior that talks to the browser through the `Wicket.*` API depends on the configured reference, not on jQuery, and needs no further change. This covers all Ajax components and behaviors in wicket-core, and in wicket-extensions among others `AutoCompleteTextField`, `Palette`, `UploadProgressBar`, `AjaxDownloadBehavior`, `ModalDialog` with its `TrapFocusBehavior`, and the veil behaviors. The `DebugBar` of wicket-devutils works with both.

Pages with a `WebSocketBehavior` still need jQuery: the setup script that wicket-native-websocket renders calls `jQuery.extend`. Render the jQuery reference from those pages as shown below.

## Keep jQuery for your own scripts

The switch only removes Wicket's own use of jQuery. JavaScript of your own, or of a library, that calls `$(...)` or `jQuery(...)` still needs it. Render the jQuery reference from the component that needs it, as for any other library:

```java
@Override
public void renderHead(IHeaderResponse response) {
    super.renderHead(response);
    response.render(JavaScriptHeaderItem.forReference(
        getApplication().getJavaScriptLibrarySettings().getJQueryReference()));
    response.render(JavaScriptHeaderItem.forReference(MY_WIDGET_JS));
}
```

In Wicket 11 that reference is jQuery 4.0. A script that still needs jQuery 3 can have it application-wide with `getJavaScriptLibrarySettings().setJQueryReference(JQueryResourceReference.getV3())`.

Better still, declare jQuery as a dependency of your script's resource reference, so every page that uses the script loads jQuery first; see [Declare dependencies between resources]({{ site.baseurl }}/docs/resource-dependencies.html).

## Check your JavaScript callbacks

Code that only uses the documented `Wicket.*` functions runs unchanged. Look at code that uses what the jQuery implementation hands to callbacks:

- In call listener handlers, `jqXHR` is a plain `XMLHttpRequest` and `settings` a plain object. jQuery methods on them, such as `jqXHR.done()`, are not there.
- Subscribers registered with `Wicket.Event.subscribe` get a small plain event object as their first argument instead of a jQuery event. The other arguments are the same.
- Elements passed to `/dom/node/added` and `/dom/node/removing` subscribers are DOM elements in both implementations.

See [React to Ajax requests in JavaScript]({{ site.baseurl }}/docs/ajax-call-listeners.html) for the handlers and events. [How Wicket Ajax works]({{ site.baseurl }}/docs/how-ajax-works.html) explains what the library does during a request.
