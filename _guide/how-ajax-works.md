---
title: How Wicket Ajax works
type: explanation
topic: ajax
summary: What happens between a click in the browser and the updated components on the page, and why components need a markup id.
since: 10
apis: [AjaxRequestTarget, AjaxRequestHandler, AbstractDefaultAjaxBehavior, AjaxRequestAttributes, IPartialPageRequestHandler]
keywords: [partial page update, ajax-response, callback url, round trip, XMLHttpRequest, markup id, placeholder, wicket-ajax.js]
order: 10
source: [ajax/ajax_1.adoc, ajax/ajax_5.adoc]
---

Wicket Ajax lets a component handle a browser event on the server and send back new markup for only the parts of the page that changed. You write no JavaScript for this. The component and its behavior generate the script, a JavaScript library that comes with Wicket sends the request and applies the response, and the server side works with the same component tree that rendered the page.

## The pieces involved

Every Ajax component is built on an Ajax behavior. An `AjaxLink` is a link with an `AjaxEventBehavior` for the `click` event; an `AjaxButton` carries an `AjaxFormSubmitBehavior`. All of them extend `AbstractDefaultAjaxBehavior`, which does three things:

- it makes its component output a markup id, so the browser can find the element;
- it contributes Wicket's client library, `wicket-ajax.js`, to the page header;
- it renders a script that tells the library which event to listen to and which URL to call.

That script is a single call with a JSON object of request attributes:

```javascript
Wicket.Ajax.ajax({"u":"./home?2-1.0-counter","c":"counter1","e":"click"});
```

`u` is the callback URL of the behavior, `c` the markup id of the element, `e` the event. The URL points at one behavior of one component in one page instance: page id `2`, render count `1`, behavior index `0`, component path `counter`. Wicket renders this call as a DOM-ready script in the page header, so the library binds the event handler once the document is loaded. Other attributes, such as the HTTP method, a form to submit, throttling or JavaScript handlers, are only written when they differ from the default. You change them by overriding `updateAjaxAttributes(AjaxRequestAttributes)`; see [Change how an Ajax request is sent]({{ site.baseurl }}/docs/ajax-request-attributes.html).

## The round trip

When the user clicks, the library builds an `XMLHttpRequest` to the callback URL. It adds the header `Wicket-Ajax: true` and the base URL of the page in `Wicket-Ajax-BaseURL`, and for a form submit it serializes the form fields into the request.

On the server the request is an ordinary request to a page instance. Wicket fetches the page from the page store by its id, locks it so that no other request for the same page runs at the same time, and calls the behavior. The behavior calls its callback method, such as `onClick` or `onEvent`, with an `AjaxRequestTarget`.

The `AjaxRequestTarget` collects what goes back to the browser. Your callback changes models and component state as in any other request, then adds the components that need to be rendered again with `target.add(...)`, and adds JavaScript with `appendJavaScript` and `prependJavaScript`. Wicket's default target is `AjaxRequestHandler`. Before it responds, it sends itself as an event payload to the application, which passes it on breadth-first to the session, the request cycle, the page and all its components. A component that should be refreshed after every Ajax request can add itself to the target in its `onEvent`, without the component that handled the click knowing about it.

The response is XML:

```xml
<ajax-response>
  <header-contribution>...</header-contribution>
  <component id="counter1"><![CDATA[<span id="counter1">3</span>]]></component>
  <priority-evaluate>...</priority-evaluate>
  <evaluate>...</evaluate>
</ajax-response>
```

Each added component renders on its own, with its complete tag, and ends up in a `component` element. The header contributions of those components, such as CSS and JavaScript references and their DOM-ready scripts, travel along; the library loads only the references the page does not have yet. Prepended JavaScript ends up in `priority-evaluate` and runs before the components are replaced; appended JavaScript ends up in `evaluate` and runs after.

Back in the browser, the library finds each element by its id and replaces it with the new markup. It publishes the events `/dom/node/removing` and `/dom/node/added` while doing so, and runs the scripts. If the server answered with a redirect instead, the library follows the URL in the `Ajax-Location` header and the browser loads a new page.

## Why components need a markup id

The browser knows nothing about the component tree. It only has the HTML, and the only way the library can find "the label" again is by its `id` attribute. Wicket does not render an `id` for every component, because ids it generates would clutter the markup and could clash with ids you write yourself. A component that is updated through Ajax has to render one, which you ask for with `setOutputMarkupId(true)`, or by writing the id in the markup yourself. See [Give a component a markup id]({{ site.baseurl }}/docs/markup-ids.html).

When a component is added to the target, Wicket switches the markup id on for it, but that is too late for the markup already in the browser: if the component did not render its id the first time, the library cannot find the element and logs that the component "was not found while trying to perform markup update".

An invisible component renders nothing at all, so there is no element to replace when it becomes visible. `setOutputMarkupPlaceholderTag(true)` makes an invisible component render an empty, hidden tag with its id in its place:

```html
<span id="message2" hidden="" data-wicket-placeholder=""></span>
```

The next Ajax update replaces this placeholder with the real markup. Placeholder tags imply `setOutputMarkupId(true)`.

Repeaters such as `ListView` and `RepeatingView` have no tag of their own: their markup is the repeated markup of their items. `AjaxRequestTarget` refuses them with an exception. To refresh a list, you add a container around it. The same goes for a component with `setRenderBodyOnly(true)`, which renders no tag either.

## Ordering, channels and state

The library sends Ajax requests one after the other per channel. By default all requests share one channel that queues them, so a second click waits until the first response has been applied. A channel can also drop all but the last waiting request, or discard a new request while one is running. Combined with the page lock on the server, this keeps the page instance and the DOM in step: the server never processes two requests for the same page at once, and the browser never applies two responses in an unknown order.

Because the callback URL addresses a page instance, an Ajax behavior makes its page stateful: the page has to be kept in the page store so the next request can find it. This is the same reason a `Link` makes a page stateful; see [Stateful and stateless pages]({{ site.baseurl }}/docs/stateful-stateless.html). Ajax components and behaviors can be made stateless when the page can be rebuilt from its URL alone; see [Use Ajax on stateless pages]({{ site.baseurl }}/docs/stateless-ajax.html).

## Two implementations of the client library

The default client library is `wicket-ajax-jquery.js`, which uses jQuery for DOM manipulation and the request itself. The JavaScript API it offers (`Wicket.Ajax`, `Wicket.Event`, `Wicket.DOM` and so on) is what the server-side code relies on, not jQuery.

> Since Wicket 11, Wicket also ships `wicket-ajax.js`, a second implementation of the same API in plain JavaScript that does not need jQuery. Which one a page loads is a single application setting; see [Run Ajax without jQuery]({{ site.baseurl }}/docs/ajax-without-jquery.html).
{: .since}
