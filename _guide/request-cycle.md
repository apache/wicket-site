---
title: What happens during a request
type: explanation
topic: lifecycle
summary: How Wicket turns an HTTP request into a request handler, runs it, and cleans up afterwards, and why it is built that way.
since: 10
apis: [RequestCycle, IRequestHandler, IRequestMapper, IRequestCycleListener, WicketFilter]
keywords: [request lifecycle, request handling, servlet filter, thread local, detach, page store, listener invocation, redirect after post]
order: 30
source: [requestProcessing/requestProcessing_1.adoc, requestProcessing/requestProcessing_2.adoc, requestProcessing/requestProcessing_3.adoc]
---

A Wicket application is a servlet filter. Every request that reaches `WicketFilter` gets its own `RequestCycle`, and that object carries the request from the first byte to the last cleanup. Most of the time you do not see it, because pages, links and forms hide it. It becomes visible when you need the raw request, want to run code around every request, or try to understand why a component behaves differently in the second request than in the first. The classes and hooks named here are listed in [Request processing]({{ site.baseurl }}/docs/request-processing.html).

## One object per request, on the current thread

A servlet container serves each request on one thread. Wicket binds the application, the session and the request cycle to that thread while it works, which is why `RequestCycle.get()`, `Session.get()` and `Application.get()` work anywhere in your code without passing objects around. The same convenience is also the limit: code that runs in another thread, such as a scheduled job or a `CompletableFuture`, has no request cycle and no session unless you bind them yourself.

The request cycle owns the `Request` and `Response` of the request. They are Wicket's own abstractions, not the servlet classes. Wicket's request processing does not depend on the servlet API, which is what lets the same machinery run inside `WicketTester` without a container and serve WebSocket messages. When you do need the servlet objects, `getContainerRequest()` and `getContainerResponse()` give them to you.

## From URL to request handler

The first thing the request cycle does is decide what the request is for. It does not look at the URL itself. It asks a request mapper, an `IRequestMapper`, to turn the request into a request handler, an `IRequestHandler`. The application's root mapper is a list of mappers; each one reports how well it matches the request, and the best match produces the handler.

![The request cycle asks every mapper for its compatibility score, lets the best one map the request to a handler, and calls respond on that handler]({{ site.baseurl }}/img/guide/request-cycle-handler.png)

A request handler is the unit of work: render this page, call this link's `onClick()`, serve this CSS file, answer this Ajax call, redirect to that URL. Separating "what does the URL mean" from "what to do about it" is the core of the design. Because mappers work in both directions, the same mapper that reads `/products/42` also writes it when a link to that page renders. Changing your URL scheme means changing mappers; your pages do not notice. See [Request mappers]({{ site.baseurl }}/docs/request-mappers.html) and [Give pages readable URLs]({{ site.baseurl }}/docs/mount-pages.html).

If no mapper recognizes the request, Wicket hands it back to the filter chain, so the container can serve static files or other servlets.

## Handlers run one after another

Many requests consist of more than one handler. A click on a link first runs a `ListenerRequestHandler`, which finds the link on the stored page and calls `onClick()`. If `onClick()` calls `setResponsePage()`, the request cycle schedules a `RenderPageRequestHandler` to run next. If it does not, the listener handler schedules a render of the current page itself. The request cycle keeps executing the scheduled handler until none is left.

This is why `setResponsePage()` does not render anything when you call it. It only records what should happen after the current handler finishes, and the last call wins. It is also why exceptions such as `RestartResponseException` work as flow control: they abandon the current handler and put another one in its place, from wherever in the call stack they are thrown.

Whether the browser gets the page directly or is first redirected to it depends on the render strategy; [Redirects after a request]({{ site.baseurl }}/docs/redirects.html) explains why Wicket redirects after a form post by default.

## Components see two requests in one

For a stateful page, a click is handled on the page instance that rendered the link, taken from the page store. That gives a request its typical order: first the listener runs on the components as they were left by the previous render; then the page, or the part of it that an Ajax request updates, goes through `onConfigure()`, `onBeforeRender()` and rendering again. Code in `onClick()` changes state; code in `onConfigure()` reads that state and decides how the page looks. [Component lifecycle]({{ site.baseurl }}/docs/component-lifecycle.html) lists the hooks in order.

## Detach: forgetting what is not needed

When the last handler has run, the request cycle detaches. Every handler detaches what it used; for a page that means calling `detach()` on the page and every component in it, which detaches their models. After that the session detaches and the page manager stores the pages the request touched.

Detaching exists because a stateful page outlives the request. Between requests, Wicket keeps the page in the session and serializes it to disk, so the page must not hold the database entities, open connections or large result lists it used while rendering. A [detachable model]({{ site.baseurl }}/docs/detachable-models.html) drops its object in `detach()` and loads it again when the next request asks for it. [How pages are stored]({{ site.baseurl }}/docs/page-storage.html) describes what happens to the page after this point.

Detaching happens even when the request failed. The steps that end and detach a request run in `finally` blocks, so a database session opened in `onBeginRequest()` can be closed in `onEndRequest()` or `onDetach()` without leaking.

## Exceptions become handlers too

An exception thrown while a handler runs is not passed to the servlet container. The request cycle turns it into another handler. First every `IRequestCycleListener` gets the chance to return one in `onException()`; if none does, the application's exception mapper decides, for example by rendering the page-expired page or the internal error page. Treating an error as just another response keeps the error page inside Wicket, with the same session, localization and layout as the rest of the application. [Handle exceptions and error pages]({{ site.baseurl }}/docs/handle-exceptions.html) shows how to plug into this.

## Listeners instead of filters

You could wrap a Wicket application in servlet filters to time requests or manage transactions. A request cycle listener does the same from inside Wicket, and knows more: which handler was resolved, which page is about to render, which URL is being generated, and which exception happened. Wicket itself uses listeners for features such as protection against cross-site request forgery and the cross-origin isolation headers. A listener is shared by all requests and runs concurrently, so it keeps per-request data in the request cycle's metadata, not in its own fields.
