---
title: Redirects after a request
type: explanation
topic: links
summary: Why Wicket answers a form submit or link click with a redirect, how the three render strategies differ, and what that means for stateless pages and clusters.
since: 10
apis: [RequestCycleSettings, RenderStrategy, RedirectPolicy, BufferedResponseMapper, WebPageRenderer]
keywords: [REDIRECT_TO_BUFFER, ONE_PASS_RENDER, REDIRECT_TO_RENDER, redirect after post, post-redirect-get, PRG, double submit, 302, refresh resubmits form, lost in redirection, sticky sessions, cluster, page id in URL]
order: 10
source: [redirects.adoc]
---

When a user submits a Wicket form or clicks a `Link`, the browser usually receives a redirect, followed by a second request that fetches the page. This is the redirect-after-post pattern, also known as post-redirect-get, and Wicket applies it to link clicks as well as form posts. It is why a stateful page has a number in its URL, and why the browser's reload button shows the page again instead of submitting the form a second time.

## The problem a redirect solves

A form submit is a POST to a URL that means "do this". If the server answers that POST with the page, the browser's address bar and history hold the POST. Reload, or going back and forward, sends the POST again: the order is placed twice, the row is deleted twice, or the browser asks the user whether to resend data they never knew they sent.

A redirect separates the action from the result. The server performs the action, then tells the browser to fetch the result from another URL with a GET. The address bar and history now hold that GET, and repeating it only shows the result again.

Wicket goes one step further than most frameworks: a click on a `Link` also calls code on the server, so it is answered with a redirect too.

## The three render strategies

`RequestCycleSettings` has three render strategies. The strategy decides how the two parts of a request, the action and the rendering of the page, map onto HTTP requests.

| Strategy | Requests | Double submit on reload | Notes |
|---|---|---|---|
| `REDIRECT_TO_BUFFER` (default) | action and rendering in the first, a redirect, the second request returns the stored result | prevented | the rendered page is kept in memory until the second request fetches it |
| `REDIRECT_TO_RENDER` | action in the first, a redirect, rendering in the second | prevented | models may be loaded and detached twice; two request cycles for one action |
| `ONE_PASS_RENDER` | action and rendering in one request, no redirect | not prevented | fewest requests; the address bar keeps the action URL |

You change the strategy in the `init()` method of your application:

```java
getRequestCycleSettings().setRenderStrategy(RequestCycleSettings.RenderStrategy.ONE_PASS_RENDER);
```

## How REDIRECT_TO_BUFFER works

With the default strategy, the first request runs the action, for example the `onSubmit` of a form, and renders the resulting page completely. Instead of sending the HTML, Wicket stores it in a buffer and answers with a redirect to the URL of the page, such as `/order?3`.

The browser follows the redirect. The `BufferedResponseMapper` recognizes the URL, finds the stored response for this session and URL, and sends it. No component code runs in the second request.

The page is rendered once, in the same request cycle as the action, so models that the action loaded are still attached and feedback messages from validation are rendered with the page. The browser ends up on a URL that shows the page, and reload asks for that URL. If the buffer is gone by then, Wicket renders the page instance again from the page store.

The buffers live in the `WebApplication` object, keyed by session id and URL. They are removed when fetched, and at most 1000 of them are kept for at most a minute.

## Why a stateful page gets an id in its URL

A request for `/order` creates a new instance of the page. If the page is stateful, its URL has to identify this instance, so that a later click on one of its links reaches the same object. Wicket renders the page, finds that its URL is now `/order?3`, stores the response and redirects to `/order?3`.

A stateless page has nothing to find again. Wicket renders it directly into the response, without a buffer and without a redirect, and the URL stays `/order`. This is one reason to [keep pages stateless]({{ site.baseurl }}/docs/keep-stateless.html) where you can; [Stateful and stateless pages]({{ site.baseurl }}/docs/stateful-stateless.html) explains the difference.

## When Wicket does not redirect

The renderer compares the URL of the request with the URL of the page it is about to render. Besides the strategy, these cases decide what happens:

- When the two URLs are equal and the page instance already exists, Wicket renders directly. A reload of `/order?3` does not redirect again.
- When the page is stateless after rendering, Wicket writes it directly, also after a submit of a stateless form. Call `setResponsePage` with a page class in `onSubmit` when you want the redirect.
- Ajax requests never render a full page into the response. When an Ajax handler calls `setResponsePage`, Wicket sends the browser to the new page with a redirect.
- `setResponsePage(OrderPage.class)` and `setResponsePage(OrderPage.class, parameters)` always redirect, also with `ONE_PASS_RENDER`, so the browser ends up on the bookmarkable URL of the new page.
- `setResponsePage(page)` with an instance redirects only when needed.

The last two are redirect policies, `ALWAYS_REDIRECT` and `AUTO_REDIRECT`, of the `RenderPageRequestHandler` that `setResponsePage` schedules. `RequestCycle#setResponsePage(Class, PageParameters, RedirectPolicy)` lets you pass `NEVER_REDIRECT` to render the page into the current response.

## Redirects in a cluster

The buffer of `REDIRECT_TO_BUFFER` is held in the memory of the server that rendered the page. It is not part of the session and is not replicated.

![A load balancer without sticky sessions sends the POST to one node and the GET after the redirect to another]({{ site.baseurl }}/img/guide/lost-in-redirection-mockup3.png)

When a load balancer sends the POST to one node and the redirected GET to another, the second node has no buffer. It handles the GET as a new request for the page, and whatever the first render showed only once is lost. The typical symptom is a form that, now and then, comes back without its validation errors. The same can happen when a node fails between the two requests.

![With sticky sessions both requests of a user go to the same node, and replication is only used for failover]({{ site.baseurl }}/img/guide/lost-in-redirection-mockup4.png)

The fix is sticky sessions: the load balancer sends all requests of a session to the same node, and session replication only serves failover. This keeps the default strategy and its protection against double submits.

Switching to `ONE_PASS_RENDER` also removes the problem, because there is no second request. It brings back the double-submit problem and the action URLs in the address bar, so it trades one problem for another. It suits clusters that cannot use sticky sessions, and applications whose pages are mostly stateless or driven by Ajax, where few full-page form posts happen.

How the request cycle resolves handlers and mappers around these redirects is described in [What happens during a request]({{ site.baseurl }}/docs/request-cycle.html).
