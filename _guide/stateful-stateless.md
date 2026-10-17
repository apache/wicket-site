---
title: Stateful and stateless pages
type: explanation
topic: state
summary: Why Wicket keeps pages between requests, how page versions serve the back button, and what a stateless page gives up and gains.
since: 10
apis: [Page, PageSettings, PageExpiredException, PageReference]
keywords: [state, session, page id, page version, versioning, back button, page expired, bookmarkable, scalability, memory, serialization, isPageStateless, setVersioned]
order: 10
source: [versioningCaching/versioningCaching_1.adoc, versioningCaching/versioningCaching_2.adoc, versioningCaching/versioningCaching_3.adoc]
---

Most web frameworks create a fresh page for every request and throw it away after the response. Wicket can do that too, but by default it keeps the page. A stateful page is a Java object that survives between requests: the user clicks a link on it, and Wicket calls `onClick()` on the very `Link` object that rendered that link, in the same page, with the same fields and models. A stateless page is created for a request and forgotten afterwards, like a page in most other frameworks.

## Why Wicket keeps pages

Keeping the page is what lets you program a web page like a desktop screen. A component can hold state in its fields and models, and an event handler can change the component tree, and none of that has to be written into URLs or hidden fields. A `Link` needs no parameters to know which row it belongs to: it is a Java object in that row.

The URLs show this. A stateful page renders links like `./orders?3-1.-table-rows-2-delete`: page instance 3, render count 1, then the path of the component to call. The request goes back to that instance and that component. A stateless page renders links that carry everything needed to build the page again, such as `./orders?status=open`.

## Page ids and versions

Every stateful page instance gets a page id from the session, the number after the `?` in its URL. When a request changes a stateful page, for example by replacing a component, adding one, or changing a model through `setDefaultModelObject()`, Wicket gives the page a new id before rendering it. The previous state stays in the store under the old id.

That is what makes the back button work. The browser goes back to the URL with the old id, and Wicket renders the page as it was then, not as it is now. A click on that old page acts on the old version. Without versions, the back button would show a page whose components no longer match what the server holds.

Versioning can be switched off per page with `setVersioned(false)`, or for all pages with `PageSettings.setVersionPagesByDefault(false)`. The page then keeps one id for its whole life, and the back button shows the current state.

`getPageReference()` returns a `PageReference` that can fetch the page instance later, for example to return to the calling page after an edit. Asking for a reference makes the page stateful.

## What keeping pages costs

A stateful page lives in the user's HTTP session and in the page store. Wicket creates the session the first time it has to store a page. From then on:

- Every object reachable from the page is serialized after each request. Components, models and their objects must be serializable, and large objects make every request slower. [Models and component data]({{ site.baseurl }}/docs/about-models.html) explains how detachable models keep pages small.
- Memory and disk grow with the number of users and the pages they open. Every version goes to disk, up to a size limit per session, and the last page used also stays in the session. [How pages are stored]({{ site.baseurl }}/docs/page-storage.html) describes the layers.
- A page can disappear: the session expires, or the store drops old versions when the limit is reached. A request for it then ends in a `PageExpiredException` and the page-expired error page. For a bookmarkable page, Wicket creates a new instance from the URL instead (`PageSettings.setRecreateBookmarkablePagesAfterExpiry`, on by default), but the old instance's state is gone and a click on a component of it is not executed.
- In a cluster, the session must reach the node that handles the next request, through sticky sessions or session replication.
- Every visitor of a stateful page gets a session, including search engine crawlers.

## What a stateless page gives up

A stateless page needs no session and can be cached and shared like any other URL. In exchange, nothing survives the response. Wicket has to be able to create the page again for every request, from its class and its `PageParameters`, so the page must be bookmarkable: a public constructor without arguments or with a single `PageParameters` argument. Anything the page needs must come from the URL, a cookie, the session or the database.

The components that normally keep state have stateless versions with the same limitation. A `StatelessLink` or `StatelessForm` makes Wicket create a new page instance when it is clicked or submitted, run the handler on the new instance, and render that. Ajax behaviors can be stateless too, as described in [Use Ajax on stateless pages]({{ site.baseurl }}/docs/stateless-ajax.html).

## How Wicket decides

You do not declare a page stateful or stateless; Wicket works it out before rendering. `Page.isPageStateless()` returns `true` when:

- the page class is bookmarkable,
- the page's stateless hint is not switched off, and
- every visible and enabled component on the page, and every behavior on those components, reports that it is stateless.

One `Link`, `Form` or Ajax behavior anywhere on the page makes the whole page stateful. A hidden or disabled one does not count, since it renders no callback. Because a single component can change the outcome, pages tend to turn stateful by accident; [Keep a page stateless]({{ site.baseurl }}/docs/keep-stateless.html) shows how to check.

A session exists for stateless requests too, but it is temporary: Wicket creates it for the request and drops it at the end, unless something binds it. [Keep data in the session]({{ site.baseurl }}/docs/use-session.html#temporary-and-permanent-sessions) describes when that happens.

## Choosing

Make pages stateless that are public, visited by many people who do not log in, or meant to be bookmarked and shared: the home page, product pages, search results, the login page. Their state fits in the URL, and a session per visitor would be waste.

Let pages be stateful when they behave like an application: multi-step forms, editors, pages with Ajax interaction, anything behind a login. That is where the programming model pays off, and the user has a session anyway.
