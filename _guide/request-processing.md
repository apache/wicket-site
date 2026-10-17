---
title: Request processing
type: reference
topic: lifecycle
summary: The objects that serve a request, the steps of RequestCycle in order, the request cycle listener hooks, and the request handlers Wicket ships.
since: 10
apis: [Application, WebApplication, RequestCycle, IRequestCycleListener, IRequestCycleProvider, IRequestHandler, IRequestMapper, IExceptionMapper, Request, WebRequest, ServletWebRequest, Response, WebResponse, ServletWebResponse, Session, WicketFilter]
keywords: [HttpServletRequest, HttpServletResponse, getContainerRequest, thread local, RequestCycle.get, onBeginRequest, onEndRequest, request handler, scheduleRequestHandlerAfterCurrent, urlFor, setResponsePage, RestartResponseException, servlet filter]
order: 20
source: [requestProcessing/requestProcessing_1.adoc, requestProcessing/requestProcessing_2.adoc, requestProcessing/requestProcessing_3.adoc]
---

How these parts work together, and why, is explained in [What happens during a request]({{ site.baseurl }}/docs/request-cycle.html).

## Objects of a request

| Object | Class | Lifetime | Get it with |
|---|---|---|---|
| Application | `WebApplication` | One per Wicket filter, for the life of the web application. | `Application.get()`, `Component.getApplication()` |
| Session | `WebSession` or your subclass | One per user, created by `Application.newSession()`. | `Session.get()`, `Component.getSession()` |
| Request cycle | `RequestCycle` | One per request. | `RequestCycle.get()`, `Component.getRequestCycle()` |
| Request | `ServletWebRequest` (a `WebRequest`, a `Request`) | One per request. | `RequestCycle.get().getRequest()`, `Component.getRequest()` |
| Response | `ServletWebResponse` (a `WebResponse`, a `Response`) | One per request; can be swapped during rendering. | `RequestCycle.get().getResponse()`, `Component.getResponse()` |

The static `get()` methods read a thread-local value that Wicket sets while it serves the request. Outside a request, for example in a background thread, `RequestCycle.get()` returns `null` and `Application.get()` throws a `WicketRuntimeException`. `Application.exists()` and `Session.exists()` tell you whether one is bound to the thread.

## Servlet request and response

`Request.getContainerRequest()` and `Response.getContainerResponse()` return the objects of the servlet container:

```java
var servletRequest = (HttpServletRequest) getRequest().getContainerRequest();
var servletResponse = (HttpServletResponse) getResponse().getContainerResponse();
String clientIp = servletRequest.getRemoteAddr();
```

Commonly used methods of the Wicket wrappers:

| Class | Method | Returns |
|---|---|---|
| `Request` | `getUrl()` | The URL relative to the Wicket filter. |
| `Request` | `getClientUrl()` | The URL as the browser sees it, relative to the filter. |
| `Request` | `getRequestParameters()` | Query and POST parameters together. |
| `Request` | `getQueryParameters()`, `getPostParameters()` | One kind of parameters. |
| `Request` | `getLocale()`, `getCharset()` | Locale and character set of the request. |
| `Request` | `getContextPath()`, `getFilterPath()` | The context path and the filter path. |
| `WebRequest` | `getHeader(name)`, `getHeaders(name)`, `getDateHeader(name)` | Request headers. |
| `WebRequest` | `getCookie(name)`, `getCookies()` | Cookies. |
| `WebRequest` | `isAjax()` | Whether Wicket's Ajax engine sent the request. |
| `Response` | `write(CharSequence)`, `write(byte[])` | Writes to the response. |
| `Response` | `encodeURL(CharSequence)` | Adds the session id to a URL when cookies are off. |
| `WebResponse` | `setHeader()`, `addHeader()`, `setContentType()`, `setStatus()` | Sets headers and status. |
| `WebResponse` | `addCookie()`, `clearCookie()` | Sets or removes a cookie. |
| `WebResponse` | `sendRedirect(url)`, `sendError(code, message)` | Redirects or sends an error. |
| `WebResponse` | `disableCaching()`, `enableCaching(duration, scope)` | Sets cache headers. |

## Steps of a request

`WicketFilter` receives every request mapped to it and asks the application for a request cycle. `RequestCycle.processRequestAndDetach()` then runs these steps:

| Step | What happens | Hooks called |
|---|---|---|
| 1. Create | `Application.createRequestCycle(request, response)` builds the cycle with the `IRequestCycleProvider` set by `setRequestCycleProvider()`. | |
| 2. Begin | The cycle binds itself to the thread. | `IRequestCycleListener.onBeginRequest()`, then `RequestCycle.onBeginRequest()` |
| 3. Resolve | The root request mapper (`Application.getRootRequestMapper()`) maps the request to an `IRequestHandler`. If no mapper matches, the filter passes the request on to the rest of the filter chain, so the container can serve it. | |
| 4. Execute | The handler's `respond()` runs. If it schedules another handler, that one runs next, until none is left. | `onRequestHandlerResolved()` before and `onRequestHandlerExecuted()` after each handler; `onRequestHandlerScheduled()` when one is scheduled |
| 5. Handle an exception | When a step throws, the listeners can return a handler; otherwise the `IExceptionMapper` from `getExceptionMapperProvider()` maps the exception to one. Wicket retries up to `getRequestCycleSettings().getExceptionRetryCount()` times (default 10) if handling fails again. | `onException()`, then `onExceptionRequestHandlerResolved()` |
| 6. End | Runs also after an exception. | `IRequestCycleListener.onEndRequest()`, then `RequestCycle.onEndRequest()` |
| 7. Detach | Every executed handler is detached; a page handler detaches the page and its components. Then the session detaches and the request logger records the request. | `RequestCycle.onDetach()`, `IRequestCycleListener.onDetach()` |

![The request cycle asks every mapper for its compatibility score, lets the best one map the request to a handler, and calls respond on that handler]({{ site.baseurl }}/img/guide/request-cycle-handler.png)

## RequestCycle methods

| Method | Description |
|---|---|
| `get()` | The request cycle bound to the current thread. |
| `getRequest()`, `getResponse()`, `getOriginalResponse()` | The request, the current response, and the response before any swap. |
| `setResponse(Response)` | Replaces the response, returns the old one. Components use this to render into a buffer. |
| `setResponsePage(...)` | Schedules a page to render after the current handler, by class, class and parameters, or instance. `Component.setResponsePage()` delegates here. |
| `urlFor(...)` | The URL of a page class, a resource reference or a request handler, as a `CharSequence`. |
| `mapUrlFor(...)` | The same, as a `Url` object. |
| `scheduleRequestHandlerAfterCurrent(IRequestHandler)` | Runs a handler after the current one. |
| `replaceAllRequestHandlers(IRequestHandler)` | Stops the current handler and runs this one instead. |
| `getActiveRequestHandler()`, `getRequestHandlerScheduledAfterCurrent()` | The handler running now and the one that runs next. |
| `find(Class)` | The active or scheduled handler of a type, as an `Optional`. `find(AjaxRequestTarget.class)` tells whether this is an Ajax request. |
| `setMetaData(key, value)`, `getMetaData(key)` | Data that lives for this request only. |
| `getStartTime()` | When the cycle started, in milliseconds. |
| `getListeners()` | The listeners of this cycle. |

Override `onBeginRequest()`, `onEndRequest()` and `onDetach()` in a subclass to run code at those moments. Install the subclass with a provider, because `createRequestCycle()` is final:

```java
@Override
protected void init() {
    super.init();
    setRequestCycleProvider(MyRequestCycle::new);
}

public class MyRequestCycle extends RequestCycle {
    public MyRequestCycle(RequestCycleContext context) {
        super(context);
    }

    @Override
    protected void onBeginRequest() {
        super.onBeginRequest();
        // ...
    }
}
```

## IRequestCycleListener

All methods are default methods; implement the ones you need. Register a listener in `Application.init()` with `getRequestCycleListeners().add(listener)`. One instance serves all requests at the same time, so it must be thread-safe.

| Method | Called |
|---|---|
| `onBeginRequest(RequestCycle)` | When the cycle starts, before the handler is resolved. |
| `onRequestHandlerResolved(RequestCycle, IRequestHandler)` | Before a handler is executed. Called for each handler in the request. |
| `onRequestHandlerScheduled(RequestCycle, IRequestHandler)` | When a handler is scheduled to run after the current one. |
| `onRequestHandlerExecuted(RequestCycle, IRequestHandler)` | After a handler has run without an exception. |
| `onUrlMapped(RequestCycle, IRequestHandler, Url)` | After Wicket generates a URL for a handler. The listener may change the `Url`, for example to add a query parameter. |
| `onException(RequestCycle, Exception)` | When processing throws. Return a handler to take over, or `null` to leave the exception to the next listener and the exception mapper. |
| `onExceptionRequestHandlerResolved(RequestCycle, IRequestHandler, Exception)` | When the handler for an exception is chosen. |
| `onEndRequest(RequestCycle)` | When the request is finished, also after an exception. |
| `onDetach(RequestCycle)` | After the handlers are detached. |

```java
public class RequestTimer implements IRequestCycleListener {
    @Override
    public void onEndRequest(RequestCycle cycle) {
        long millis = System.currentTimeMillis() - cycle.getStartTime();
        log.info("{} took {} ms", cycle.getRequest().getUrl(), millis);
    }
}
```

`getRequestCycleListeners()` returns a `RequestCycleListenerCollection`, which is itself an `IRequestCycleListener`, so you can group listeners.

## Request handlers

`IRequestHandler` has two methods: `respond(IRequestCycle)` writes the response, and `detach(IRequestCycle)` (a default method) releases what it held. The handlers Wicket ships:

| Handler | Package | Responds with |
|---|---|---|
| `RenderPageRequestHandler` | `org.apache.wicket.core.request.handler` | A page, rendered directly or after a redirect. |
| `BookmarkablePageRequestHandler` | `org.apache.wicket.core.request.handler` | Nothing: Wicket uses it only to generate the URL of a page class. |
| `ListenerRequestHandler` | `org.apache.wicket.core.request.handler` | Calls an `IRequestListener` of a component or behavior, such as a link click, then usually renders the page. |
| `BookmarkableListenerRequestHandler` | `org.apache.wicket.core.request.handler` | The same for a listener on a stateless page. |
| `AjaxRequestHandler` | `org.apache.wicket.ajax` | The Ajax response with the components added to the `AjaxRequestTarget`. |
| `ComponentRenderingRequestHandler` | `org.apache.wicket.core.request.handler` | The markup of a single component. |
| `BufferedResponseRequestHandler` | `org.apache.wicket.core.request.handler` | A response buffered by an earlier request, used by the redirect-after-post strategy. |
| `ResourceReferenceRequestHandler` | `org.apache.wicket.request.handler.resource` | A resource found through a `ResourceReference`. |
| `ResourceRequestHandler` | `org.apache.wicket.request.handler.resource` | An `IResource`. |
| `ResourceStreamRequestHandler` | `org.apache.wicket.request.handler.resource` | An `IResourceStream`, for example a file download. |
| `TextRequestHandler` | `org.apache.wicket.request.handler` | A string with a content type. |
| `RedirectRequestHandler` | `org.apache.wicket.request.http.handler` | A redirect to a URL. |
| `ErrorCodeRequestHandler` | `org.apache.wicket.request.http.handler` | An HTTP error status. |
| `EmptyRequestHandler` | `org.apache.wicket.request.handler` | Nothing. |

## Exceptions that change the flow

Throw these from a constructor, a listener or a lifecycle hook to stop the current handler and run another:

| Exception | Effect |
|---|---|
| `RestartResponseException` | Renders the given page instead. |
| `RestartResponseAtInterceptPageException` | Renders the given page and remembers the current URL, so `continueToOriginalDestination()` can return to it, for example after a login. |
| `NonResettingRestartException` | Like `RestartResponseException`, but keeps the headers already set on the response, such as cookies. |
| `RedirectToUrlException` | Redirects to a URL. |
| `AbortWithHttpErrorCodeException` | Sends an HTTP error status, such as 404. |

## Request mappers

`IRequestMapper` turns a request into a handler with `mapRequest(Request)` and a handler into a URL with `mapHandler(IRequestHandler)`. `getCompatibilityScore(Request)` says how well the mapper fits a request; when several mappers can map it, the one with the highest score wins. The root mapper of an application is a `SystemMapper` that holds the built-in mappers and the ones you add with `mount()` and `mountPage()`. The mappers are listed in [Request mappers]({{ site.baseurl }}/docs/request-mappers.html).
