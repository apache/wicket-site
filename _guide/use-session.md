---
title: Keep data in the session
type: howto
topic: state
summary: Store per-user data in a typed Wicket session, in session attributes or as metadata, control when the session is created, and end it on logout.
since: 10
apis: [Session, WebSession, MetaDataKey, ISessionListener]
keywords: [HttpSession, session attribute, user data, shopping cart, current user, newSession, temporary session, bind, invalidate, logout, session fixation, metadata, scoped variable]
order: 30
source: [requestProcessing/requestProcessing_4.adoc]
---

Keep data in the session when it belongs to the user rather than to one page: the logged-in user, a shopping cart, preferences. Wicket wraps the HTTP session in a `Session` object, which you reach from anywhere in a request with `Session.get()`.

Everything in the session is serialized when the container stores or replicates it, so keep it small and serializable. Store ids, not entities, and never pages or components.

## Store typed data in your own session class

Subclass `WebSession`, give it fields with getters and setters, and add a static `get()` that casts:

*AppSession.java*
```java
public class AppSession extends WebSession {
    private Long userId;

    public AppSession(Request request) {
        super(request);
    }

    public static AppSession get() {
        return (AppSession) Session.get();
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
        dirty();
    }
}
```

Tell the application to create it:

*WicketApplication.java*
```java
@Override
public Session newSession(Request request, Response response) {
    return new AppSession(request);
}
```

Read and write it anywhere in a request: `AppSession.get().getUserId()`. Call `dirty()` after a change, as the setter does. It tells Wicket to store the session again at the end of the request, which session replication in a cluster needs, and it makes a temporary session permanent.

## Store loose values as session attributes

For a value that does not deserve a field, use attributes. The value must be `Serializable`:

```java
Session.get().setAttribute("lastSearch", query);
String last = (String) Session.get().getAttribute("lastSearch");
Session.get().removeAttribute("lastSearch");
```

Wicket stores the attributes in the HTTP session, with a prefix in front of the name so that they do not clash with attributes of other applications or filters in the same session.

## Store values under a typed key

Metadata stores a value under a `MetaDataKey`, which gives you type safety without a session subclass. Define the key once, as a constant:

```java
public static final MetaDataKey<Cart> CART = new MetaDataKey<>() {};

Session.get().setMetaData(CART, cart);
Cart cart = Session.get().getMetaData(CART);
```

The value must be `Serializable`. The same API exists on `Application`, `RequestCycle` and `Component`, for values that live as long as the application, the request or the component. Values stored on `Application` and `RequestCycle` do not have to be serializable.

## Temporary and permanent sessions

As long as a user only sees [stateless pages]({{ site.baseurl }}/docs/stateful-stateless.html), Wicket does not create an HTTP session. `Session.get()` still works, but returns a temporary session that is thrown away at the end of the request. `isTemporary()` returns `true` and `getId()` returns `null`.

Wicket makes the session permanent when a stateful page has to be stored. To keep data from a stateless page, make it permanent yourself with `bind()`:

```java
public class LandingPage extends WebPage {
    public LandingPage(PageParameters parameters) {
        Session.get().setAttribute("campaign", parameters.get("utm_campaign").toString());
        Session.get().bind();
        setResponsePage(HomePage.class);
    }
}
```

Without `bind()`, the attribute would be gone in the next request.

## End the session on logout

`invalidate()` ends the session at the end of the current request. The page rendered in this request still works:

```java
add(new Link<Void>("logout") {
    @Override
    public void onClick() {
        getSession().invalidate();
        setResponsePage(getApplication().getHomePage());
    }
});
```

`invalidateNow()` ends it immediately and removes all pages of the session, so the rest of the request cannot use them.

After a successful login, give the session a new id with `changeSessionId()`, to protect against session fixation. [Log users in]({{ site.baseurl }}/docs/login.html) shows this in context.

## React to new sessions

Register an `ISessionListener` to run code when a session is created or unbound:

```java
getSessionListeners().add(new ISessionListener() {
    @Override
    public void onCreated(Session session) {
        log.info("Session created, locale {}", session.getLocale());
    }

    @Override
    public void onUnbound(String sessionId) {
        log.info("Session {} ended", sessionId);
    }
});
```

## Reach the HTTP session directly

Some tools need an attribute with an exact name in the `HttpSession`, without Wicket's prefix. Get the servlet session from the request:

```java
HttpSession httpSession = ((ServletWebRequest) RequestCycle.get().getRequest())
        .getContainerRequest().getSession();
httpSession.setAttribute("userName", user.getName());
```

Prefer the Wicket session for everything else: it works the same in tests with `WicketTester` and does not tie your code to the servlet API.
