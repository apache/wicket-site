---
title: Use links on stateless pages
type: howto
topic: links
summary: Handle clicks on a stateless page with StatelessLink and keep the state the click needs in page parameters, because every click builds a new page.
since: 10
apis: [StatelessLink, BookmarkablePageLink]
keywords: [stateless page, stateless link, onClick on stateless page, page becomes stateful, instance variable reset, session not created]
order: 50
source: [urls/urls_5.adoc]
---

A plain `Link` makes its page stateful: its URL points to a component of a page instance that Wicket keeps in the page store. On a page that has to stay stateless, such as a landing page or a login page that must not create a session, use a `StatelessLink` for clicks that run code, and a `BookmarkablePageLink` for plain navigation. Why a page is stateful or stateless is explained in [Stateful and stateless pages]({{ site.baseurl }}/docs/stateful-stateless.html).

## Replace Link with StatelessLink

`StatelessLink` has the same `onClick()` as `Link`:

```java
add(new StatelessLink<Void>("logout") {
    @Override
    public void onClick() {
        getSession().invalidate();
        setResponsePage(getApplication().getHomePage());
    }
});
```

The page must be bookmarkable, with a constructor without arguments or one that takes `PageParameters`, and all its other components must be stateless too. One stateful component anywhere on the page makes the whole page stateful.

## Keep the state of a click in page parameters

The URL of a `StatelessLink` names the page class, the page parameters and the link. When the user clicks, Wicket creates a new instance of the page from those parameters, calls `onClick()` on the link in that new instance, and renders the result. Nothing from the instance the user saw survives. Instance fields start from their initial values on every click:

```java
public class CounterPage extends WebPage {
    private int count;

    public CounterPage(PageParameters parameters) {
        super(parameters);
        add(new StatelessLink<Void>("increment") {
            @Override
            public void onClick() {
                count++;   // always goes from 0 to 1
            }
        });
    }
}
```

Put the state that a click needs in the page parameters instead, and send the user to a page with new parameters:

*CounterPage.java*

```java
public class CounterPage extends WebPage {

    public CounterPage(PageParameters parameters) {
        super(parameters);
        int count = parameters.get("count").toInt(0);

        add(new Label("count", count));
        add(new StatelessLink<Void>("increment") {
            @Override
            public void onClick() {
                setResponsePage(CounterPage.class,
                    new PageParameters().add("count", count + 1));
            }
        });
    }
}
```

*CounterPage.html*

```html
<p>Clicked <span wicket:id="count">0</span> times.</p>
<a wicket:id="increment">Click</a>
```

The link URL carries the current page parameters, so the new instance that handles the click sees the same `count` as the page the user clicked on.

When a click only navigates, a `BookmarkablePageLink` with the new parameters does the same with one request instead of a click request and a redirect:

```java
add(new BookmarkablePageLink<Void>("increment", CounterPage.class,
    new PageParameters().add("count", count + 1)));
```

## Check that the page stays stateless

A page that you expect to be stateless can turn stateful when someone adds a component later. [Keep a page stateless]({{ site.baseurl }}/docs/keep-stateless.html) shows how to find the component that makes a page stateful and how to test for it. For forms and Ajax on stateless pages, see [Build a stateless form]({{ site.baseurl }}/docs/stateless-forms.html) and [Use Ajax on stateless pages]({{ site.baseurl }}/docs/stateless-ajax.html).
