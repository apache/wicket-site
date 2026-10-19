---
title: Header items
type: reference
topic: resources
summary: Every header item type with its factory methods, the tag it renders and where it ends up, the rendering order, Ajax behaviour and the header response decorators.
since: 10
apis: [HeaderItem, IHeaderResponse, IHeaderContributor, CssHeaderItem, CssReferenceHeaderItem, CssUrlReferenceHeaderItem, CssContentHeaderItem, JavaScriptHeaderItem, JavaScriptReferenceHeaderItem, JavaScriptUrlReferenceHeaderItem, JavaScriptContentHeaderItem, OnDomReadyHeaderItem, OnLoadHeaderItem, OnEventHeaderItem, StringHeaderItem, MetaDataHeaderItem, PriorityHeaderItem, FilteredHeaderItem, PageHeaderItem, HtmlImportHeaderItem, AbstractCspHeaderItem, ResourceAggregator, FilteringHeaderResponse, JavaScriptFilteredIntoFooterHeaderResponse, JavaScriptDeferHeaderResponse, SubresourceHeaderResponse, HeaderResponseDecoratorCollection, JavaScriptReferenceType, JavaScriptBrowserProcessedContentType, JavaScriptDataBlockType]
keywords: [renderHead, script not rendered, script in wrong place, header order, nonce, CSP, inline script, domready, onload, event handler, meta tag, canonical link, import map, ES module, type module, defer, async, integrity, crossorigin, header response decorator]
order: 10
source: [resources/resources_4.adoc, resources/resources_6.adoc, resources/resources_7.adoc, resources/resources_8.adoc, resources/resources_9.adoc, keepControl/keepControl_6.adoc]
---

Header items are what components and behaviors hand to the `IHeaderResponse` in `renderHead`. Wicket collects them for the whole page, removes duplicates, adds dependencies, and writes them into the `<head>` or into a bucket elsewhere in the page. All classes are in `org.apache.wicket.markup.head` unless stated otherwise.

## Where header items come from

| Source | Method | Called for |
|---|---|---|
| `Component` | `renderHead(IHeaderResponse)` | every visible component on the page, and every component in an Ajax update |
| `Behavior` | `renderHead(Component, IHeaderResponse)` | every enabled behavior of those components |
| `IHeaderContributor` | `renderHead(IHeaderResponse)` | contributors registered with `Application#getHeaderContributorListeners().add(…)`, on every page |
| Markup | `<wicket:head>` | once per component class; written as markup, not as a header item |

Call `super.renderHead(response)` when you override the method in a component.

## Header item types

| Class | Create with | Renders | Nonce |
|---|---|---|---|
| `CssReferenceHeaderItem` | `CssHeaderItem.forReference(reference)`, `forReference(reference, media)`, `forReference(reference, pageParameters, media)`, `forReference(reference, pageParameters, media, rel)` | `<link rel="stylesheet">` with the URL of the resource reference | yes |
| `CssUrlReferenceHeaderItem` | `CssHeaderItem.forUrl(url)`, `forUrl(url, media)`, `forUrl(url, media, rel)` | `<link rel="stylesheet">` with the given URL; a relative URL is resolved against the context root | yes |
| `CssContentHeaderItem` | `CssHeaderItem.forCSS(css, id)` | `<style>` with the given CSS; `id` may be `null` | yes |
| `JavaScriptReferenceHeaderItem` | `JavaScriptHeaderItem.forReference(reference)`, `forReference(reference, id)`, `forReference(reference, pageParameters, id)` | `<script src>` with the URL of the resource reference | yes |
| `JavaScriptUrlReferenceHeaderItem` | `JavaScriptHeaderItem.forUrl(url)`, `forUrl(url, id)` | `<script src>` with the given URL; a relative URL is resolved against the context root | yes |
| `JavaScriptContentHeaderItem` | `JavaScriptHeaderItem.forScript(javascript, id)` | inline `<script>` with the given code; `id` may be `null` | yes |
| `OnDomReadyHeaderItem` | `OnDomReadyHeaderItem.forScript(javascript)` | code that runs when the DOM is loaded; see [Ready, load and event scripts](#ready-load-and-event-scripts) | yes |
| `OnLoadHeaderItem` | `OnLoadHeaderItem.forScript(javascript)` | code that runs on the window `load` event, after images and other files | yes |
| `OnEventHeaderItem` | `OnEventHeaderItem.forComponent(component, event, javascript)`, `forMarkupId(markupId, event, javascript)`, `forScript(target, event, javascript)` | code bound to a DOM event with `Wicket.Event.add`; `target` in `forScript` is a JavaScript expression, such as `"'myId'"` or `"window"` | yes |
| `StringHeaderItem` | `StringHeaderItem.forString(text)` | the text as it is, without escaping | no |
| `MetaDataHeaderItem` | `MetaDataHeaderItem.forMetaTag(name, content)`, `forHttpEquiv(httpEquiv, content)`, `forLinkTag(rel, href)`, or `new MetaDataHeaderItem(tagName).addTagAttribute(name, value)`; the factories also take models | `<meta>` or `<link>` with escaped attribute values | no |
| `PriorityHeaderItem` | `new PriorityHeaderItem(item)` | the wrapped item, moved to the front; see [Rendering order](#rendering-order) | as wrapped item |
| `FilteredHeaderItem` (package `…head.filter`) | `new FilteredHeaderItem(item, filterName)` | the wrapped item, in the bucket named `filterName` of a `FilteringHeaderResponse` | as wrapped item |
| `PageHeaderItem` | created by Wicket | the markup inside the page's own `<head>` | no |
| `MetaDataHeaderItem` from `HtmlImportHeaderItem` | `HtmlImportHeaderItem.forImportLinkTag(…)` | `<link rel="import">`; browsers no longer support HTML imports | no |
| `NoHeaderItem` | `NoHeaderItem.get()` | nothing; used by Wicket as a placeholder | no |

"Nonce" says whether Wicket adds the Content Security Policy nonce to the rendered tag. The items with a nonce extend `AbstractCspHeaderItem`. The default policy blocks scripts and stylesheets without a nonce, so a `<script>` or `<link rel="stylesheet">` written with `StringHeaderItem`, `MetaDataHeaderItem` or in markup does not load. See [Configure the Content Security Policy]({{ site.baseurl }}/docs/csp.html).

## Options of script and stylesheet items

The reference and URL items have setters that return the item, so they chain after the factory method.

| Method | On | Effect |
|---|---|---|
| `setDefer(boolean)` | script reference and URL items | adds `defer` |
| `setAsync(boolean)` | script reference and URL items | adds `async` |
| `setType(JavaScriptReferenceType)` | script reference and URL items | sets `type`; `JavaScriptReferenceType.MODULE` loads an ES module |
| `setType(JavaScriptContentType)` | `JavaScriptContentHeaderItem` | sets `type` of an inline script: `JavaScriptBrowserProcessedContentType.MODULE`, `IMPORT_MAP` or `SPECULATION_RULES`, or `new JavaScriptDataBlockType("application/json")` for a data block |
| `setIntegrity(String)` | script and stylesheet reference and URL items | adds `integrity` for subresource integrity; for a reference item, the default comes from `ResourceReference#getIntegrity()` |
| `setCrossOrigin(CrossOrigin)` | script and stylesheet reference and URL items | adds `crossorigin`; `CrossOrigin` is in `org.apache.wicket.markup.html` |
| `setCharset(String)` | script reference and URL items | adds `charset` |
| `setId(String)` | all `CssHeaderItem` and `JavaScriptHeaderItem` types | adds `id`; for script items and inline CSS the id also counts in duplicate detection |
| `setNonce(String)` | items with a nonce | sets the nonce; Wicket overwrites it when the Content Security Policy is enabled |

## Duplicates

Wicket renders an item only once per page and per Ajax response. Two items count as the same when they share a render token:

| Item | Token |
|---|---|
| CSS reference and URL items | the URL and the media |
| script reference and URL items | the URL, and the id if set |
| `CssContentHeaderItem`, `JavaScriptContentHeaderItem` | the content, and the id if set |
| `OnDomReadyHeaderItem`, `OnLoadHeaderItem`, `OnEventHeaderItem` | the script, and for `OnEventHeaderItem` the target and event |
| `StringHeaderItem`, `PageHeaderItem` | the text |

An item whose id was already rendered is skipped even if its content differs. A file that a component requests again in an Ajax response is not loaded a second time if the page already has it.

## Rendering order

`ResourceAggregator` collects the items and writes them in this order:

1. `PriorityHeaderItem`s, those of parent components before those of their children, each with its dependencies.
2. All other items in the order they were rendered, each after its dependencies: items of application-level contributors, items of components from the deepest child up, and the page's items last. The page's own `<head>` markup is a `PageHeaderItem` of the page.
3. One inline script that contains the code of all `OnDomReadyHeaderItem`s and `OnEventHeaderItem`s.
4. One inline script that contains the code of all `OnLoadHeaderItem`s.

Members of a resource bundle are replaced by the bundle before sorting. Steps 1 and 2 come from the comparator in `ResourceSettings#setHeaderItemComparator`; the default is `new PriorityFirstComparator(false)`, and `new PriorityFirstComparator(true)` moves the page's items before those of its components. The content of `<wicket:head>` is written as Wicket meets it, outside this order. See [Control the order of header items]({{ site.baseurl }}/docs/header-order.html).

Without `<wicket:header-items/>`, the items fill the whole `<head>`. With it, they go where the tag stands, between the markup before and after it.

## Ready, load and event scripts

| Item | Full page render | Ajax response |
|---|---|---|
| `OnDomReadyHeaderItem` | combined into one script, run on `domready` through `Wicket.Event` | run after the new markup is inserted, before scripts added with `appendJavaScript` |
| `OnEventHeaderItem` | combined into the `domready` script, which binds the handlers | evaluated with the scripts added with `appendJavaScript` |
| `OnLoadHeaderItem` | combined into one script, run on the window `load` event | evaluated with the scripts added with `appendJavaScript` |

These three items depend on Wicket's JavaScript library, `getJavaScriptLibrarySettings().getWicketAjaxReference()`, which Wicket renders first. By default that library is built on jQuery, so a page with one of these items also loads jQuery: {% if site.wicket.version_11 %}version 3.7.1 in Wicket 10 and 4.0 in Wicket 11{% else %}version 3.7.1{% endif %}.

{% if site.wicket.version_11 %}
> Since Wicket 11, Wicket also ships a plain JavaScript version of the library with the same API, `org.apache.wicket.ajax.WicketAjaxResourceReference`. Set it with `getJavaScriptLibrarySettings().setWicketAjaxReference(WicketAjaxResourceReference.get())`, and ready, load and event scripts no longer pull in jQuery. See [Run Ajax without jQuery]({{ site.baseurl }}/docs/ajax-without-jquery.html).
{: .since}
{% endif %}

## Header response decorators

A decorator wraps the `IHeaderResponse` and changes what happens to items. Register them on `Application#getHeaderResponseDecorators()`, a `HeaderResponseDecoratorCollection`:

| Method | Position of the new decorator |
|---|---|
| `add(decorator)` | inside the resource aggregation: it receives items after dependencies, bundles and sorting are applied |
| `addPreResourceAggregationDecorator(decorator)` | directly inside the resource aggregation, outside decorators added with `add` |
| `addPostProcessingDecorator(decorator)` | outside everything registered so far, before resource aggregation |
| `replaceAll(decorator)` | replaces all decorators, including the `ResourceAggregator`; dependencies and bundles stop working |

Decorators that Wicket provides:

| Class | Effect |
|---|---|
| `ResourceAggregator` | dependencies, bundles, duplicates and sorting; registered by default |
| `CSPNonceHeaderResponseDecorator` (package `org.apache.wicket.csp`) | adds the nonce; registered when the Content Security Policy is enabled |
| `FilteringHeaderResponse` (package `…head.filter`) | sorts items into named buckets; items that no filter accepts go into the `<head>`; renders `FilteredHeaderItem`s into their bucket; a `HeaderResponseContainer` renders a bucket in the page |
| `JavaScriptFilteredIntoFooterHeaderResponse` (package `…head.filter`) | a `FilteringHeaderResponse` that sends every script item, including ready, load and event scripts, to one bucket; see [Put JavaScript at the end of the body]({{ site.baseurl }}/docs/javascript-in-body.html) |
| `JavaScriptDeferHeaderResponse` (package `…head.filter`) | defers all script reference items and delays inline scripts until they have loaded; marked experimental |
| `SubresourceHeaderResponse` (package `…head.filter`) | abstract; calls `configure(ISubresourceHeaderItem)` for every script and stylesheet reference item, to set `integrity` and `crossorigin` in one place |

During an Ajax request, `FilteringHeaderResponse` does not sort into buckets; all items go into the Ajax response.

## Header markup tags

| Tag | Effect |
|---|---|
| `<wicket:head>` | in the markup of a panel, border or page: its content goes into the page header, once per component class; inline scripts and styles in it get no nonce |
| `<wicket:header-items/>` | in the `<head>` of a page: the place where Wicket writes the header items; at most one per page |

Both are described with the other tags in [Wicket tags and attributes]({{ site.baseurl }}/docs/wicket-tags.html).
