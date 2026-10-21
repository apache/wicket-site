---
title: Handle exceptions and show error pages
type: howto
topic: lifecycle
summary: Replace Wicket's error pages, choose what users see after an unexpected exception, and map your own exceptions and HTTP errors to pages.
since: 10
apis: [ExceptionSettings, ApplicationSettings, IExceptionMapper, DefaultExceptionMapper, IRequestCycleListener, AbstractErrorPage, InternalErrorPage, PageExpiredErrorPage, AccessDeniedPage, ExceptionErrorPage]
keywords: [error page, 404, 500, page expired, PageExpiredException, internal error, stack trace, onException, AjaxErrorStrategy, onFailure, error-page, web.xml]
order: 40
source: [requestProcessing/requestProcessing_5.adoc]
---

Use this when the default error pages do not fit your application, or when you want specific exceptions to lead to specific pages. Exceptions become request handlers inside the request cycle; [What happens during a request]({{ site.baseurl }}/docs/request-cycle.html#exceptions-become-handlers-too) explains how.

## Replace the built-in error pages

Wicket shows three pages for the exceptions it expects. Set your own in `Application.init()`:

```java
@Override
protected void init() {
    super.init();
    getApplicationSettings()
        .setInternalErrorPage(ErrorPage.class)
        .setPageExpiredErrorPage(SessionExpiredPage.class)
        .setAccessDeniedPage(NoAccessPage.class);
}
```

| Setting | Shown for |
|---|---|
| `setInternalErrorPage` | Unexpected exceptions, in deployment mode. |
| `setPageExpiredErrorPage` | `PageExpiredException`: the page a link or form belongs to is no longer in the page store, usually because the session expired. |
| `setAccessDeniedPage` | `AuthorizationException`, for example from a [role check]({{ site.baseurl }}/docs/roles.html), and listener calls on components that are disabled or invisible. |

Extend `AbstractErrorPage` for your pages. It turns off versioning for the page and adds a small default style sheet. Set the HTTP status in `setHeaders()`, otherwise the browser receives `200 OK`:

*ErrorPage.java*

```java
public class ErrorPage extends AbstractErrorPage {

    public ErrorPage() {
        add(homePageLink("home"));
    }

    @Override
    protected void setHeaders(WebResponse response) {
        super.setHeaders(response);
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
}
```

## Choose what users see after an unexpected exception

In development mode Wicket shows `ExceptionErrorPage` with the stack trace; in deployment mode it shows the internal error page (see [Switch between development and deployment mode]({{ site.baseurl }}/docs/deployment-mode.html)). Override this with the exception settings:

```java
getExceptionSettings().setUnexpectedExceptionDisplay(ExceptionSettings.SHOW_INTERNAL_ERROR_PAGE);
```

| Value | Result |
|---|---|
| `SHOW_EXCEPTION_PAGE` | The stack trace page. Never use it in production: it reveals your code. |
| `SHOW_INTERNAL_ERROR_PAGE` | The internal error page. |
| `SHOW_NO_EXCEPTION_PAGE` | An empty response with status 500. |

Wicket logs every unexpected exception at error level before it shows the page.

## Show a page for one exception

To send one kind of exception to its own page, register a request cycle listener and return a handler from `onException()`. Returning `null` leaves the exception to Wicket.

```java
getRequestCycleListeners().add(new IRequestCycleListener() {
    @Override
    public IRequestHandler onException(RequestCycle cycle, Exception ex) {
        var notFound = Exceptions.findCause(ex, ProductNotFoundException.class);
        if (notFound != null) {
            return new RenderPageRequestHandler(new ProductNotFoundPage(notFound.getProductId()));
        }
        return null;
    }
});
```

Wicket often wraps an exception, for example in a `WicketRuntimeException` when a component fails to render, so look for the cause with `org.apache.wicket.util.lang.Exceptions.findCause` instead of checking `ex` itself. Leave exceptions that implement `IWicketInternalException` alone; Wicket handles those itself.

For full control, replace the exception mapper. Extend `DefaultExceptionMapper` and override `mapUnexpectedExceptions` or `mapExpectedExceptions`, then install it:

```java
setExceptionMapperProvider(MyExceptionMapper::new);
```

## Send an HTTP error from your code

Throw `AbortWithHttpErrorCodeException` to stop the request and answer with a status code, for example when a page parameter points to nothing:

```java
Product product = products.find(id)
    .orElseThrow(() -> new AbortWithHttpErrorCodeException(404));
```

## Show a Wicket page for 404 and other container errors

Requests that Wicket does not map, and errors you send with a status code, end up at the servlet container. Let the container forward them to a mounted Wicket page. Mount the page:

```java
mountPage("/errors/404", NotFoundPage.class);
```

Map the status code to it in *web.xml*, and let the Wicket filter handle error dispatches:

```xml
<filter-mapping>
    <filter-name>wicket</filter-name>
    <url-pattern>/*</url-pattern>
    <dispatcher>REQUEST</dispatcher>
    <dispatcher>ERROR</dispatcher>
</filter-mapping>

<error-page>
    <error-code>404</error-code>
    <location>/errors/404</location>
</error-page>
```

Override `setHeaders()` in `NotFoundPage` to set status 404, as shown above.

## Handle errors in Ajax requests

By default an exception during an Ajax request makes the browser go to the error page. To keep the user on the page and let your JavaScript react instead, call the failure handlers:

```java
getExceptionSettings().setAjaxErrorHandlingStrategy(
    ExceptionSettings.AjaxErrorStrategy.INVOKE_FAILURE_HANDLER);
```

Wicket then answers with status 500 and runs the `onFailure` handlers of the request; see [React to Ajax requests in JavaScript]({{ site.baseurl }}/docs/ajax-call-listeners.html).
