---
title: Use Ajax on stateless pages
type: howto
topic: ajax
summary: Make Ajax components and behaviors stateless with getStatelessHint, so a page such as a login page keeps working without a stored page instance.
since: 10
apis: [AjaxFallbackLink, AjaxSubmitLink, AjaxFormComponentUpdatingBehavior, StatelessForm]
keywords: [stateless, getStatelessHint, setStatelessHint, page expired, login page, static markup id, session-less]
order: 60
source: [ajax/ajax_7.adoc]
---

Use this when a page has to stay stateless, for example a login page or a public landing page, and still uses Ajax. By default an Ajax component or behavior makes its page stateful, because its callback URL points to a page instance that Wicket must keep. A stateless Ajax callback recreates the page from its URL instead. [Stateful and stateless pages]({{ site.baseurl }}/docs/stateful-stateless.html) explains the difference.

## Make an Ajax component stateless

Override `getStatelessHint()` and return `true`. `AjaxLink`, `AjaxFallbackLink`, `AjaxButton`, `AjaxSubmitLink` and `AjaxFallbackButton` pass this hint on to their Ajax behavior:

```java
Label counterLabel = new Label("counterLabel",
    () -> getPageParameters().get("counter").toInt(0));
counterLabel.setMarkupId("counter").setOutputMarkupId(true);
add(counterLabel);

add(new AjaxFallbackLink<Void>("increment") {
    @Override
    public void onClick(Optional<AjaxRequestTarget> target) {
        int counter = getPage().getPageParameters().get("counter").toInt(0);
        getPage().getPageParameters().set("counter", counter + 1);
        target.ifPresent(t -> t.add(counterLabel));
    }

    @Override
    protected boolean getStatelessHint() {
        return true;
    }
});
```

Forms on a stateless page have to be stateless too. Put the Ajax submit components in a `StatelessForm`; see [Build a stateless form]({{ site.baseurl }}/docs/stateless-forms.html).

## Make an Ajax behavior stateless

For a behavior, override `getStatelessHint(Component)`:

```java
select.add(new AjaxFormComponentUpdatingBehavior("change") {
    @Override
    protected void onUpdate(AjaxRequestTarget target) {
        selected.setDefaultModelObject("Selected: " + select.getModelObject());
        target.add(selected);
    }

    @Override
    public boolean getStatelessHint(Component component) {
        return true;
    }
});
```

## Give the updated components fixed markup ids

On a stateless page, every Ajax request builds a new page instance from the URL and its parameters. The markup ids that `setOutputMarkupId(true)` generates come from a counter in the session, so the new instance can give a component another id than the one in the browser, and the update would not find its element. Give every component that you add to the target an id that does not change. Write it in the markup:

```html
<span id="counter" wicket:id="counterLabel"></span>
```

or set it in Java with `setMarkupId("counter")` together with `setOutputMarkupId(true)`, as in the first example. The id must be unique on the page.

## Keep the state in the URL

A stateless callback never sees the fields of the previous page instance: the instance is new. Keep what the page needs in its page parameters, as in the counter example above, or in the session; see [Keep data in the session]({{ site.baseurl }}/docs/use-session.html). To check that the page really stays stateless, see [Keep a page stateless]({{ site.baseurl }}/docs/keep-stateless.html).
