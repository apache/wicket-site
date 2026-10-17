---
title: Test pages and components
type: howto
topic: testing
summary: Render pages and single components in a unit test, click links, fire Ajax events and check what they render, with WicketTester and JUnit.
since: 10
apis: [WicketTester, BaseWicketTester, MockHttpServletResponse]
keywords: [unit test, JUnit, startPage, assertRenderedPage, clickLink, executeAjaxEvent, startComponentInPage, assertLabel, request header, integration test]
order: 10
source: [testing/testing_1.adoc]
---

You need this when you want to check, without a browser or a server, that a page renders and reacts to the user as intended. `WicketTester` runs your application in memory: it renders pages, clicks links, submits forms and fires Ajax events, and remembers the last rendered page and response so you can check them. [Test a page with WicketTester]({{ site.baseurl }}/docs/first-test.html) is a step-by-step introduction; [WicketTester]({{ site.baseurl }}/docs/wicket-tester.html) lists every method.

## Add the dependencies

*pom.xml*

```xml
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-tester</artifactId>
    <version>${wicket.version}</version>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter</artifactId>
    <scope>test</scope>
</dependency>
```

The quickstart project already has both.

## Render a page

Create a tester with your application, start a page and check that it rendered. Create a new tester for every test and destroy it afterwards, so tests do not share an application or a session.

*HomePageTest.java*

```java
class HomePageTest {
    private WicketTester tester;

    @BeforeEach
    void setUp() {
        tester = new WicketTester(new WicketApplication());
    }

    @AfterEach
    void tearDown() {
        tester.destroy();
    }

    @Test
    void rendersSuccessfully() {
        tester.startPage(HomePage.class);
        tester.assertRenderedPage(HomePage.class);
    }
}
```

`startPage` also takes `PageParameters` or a page instance. `new WicketTester()` without arguments uses a `MockApplication`, which is enough for components that do not depend on your application class.

## Check what a component shows

Components are addressed by their path from the page: the ids of the containers, separated by colons.

```java
tester.assertLabel("greeting", "Hello, Ada");
tester.assertComponent("form:name", TextField.class);
tester.assertVisible("form:save");
tester.assertInvisible("adminPanel");
tester.assertDisabled("form:delete");
tester.assertModelValue("form:name", "Ada");
tester.assertContains("<h1>Orders</h1>");
```

`assertContains` matches a regular expression against the whole response. `getComponentFromLastRenderedPage(path)` gives you the component itself for anything the assert methods do not cover.

## Click a link

```java
tester.startPage(CounterPage.class);
tester.assertLabel("count", "0");

tester.clickLink("increment");
tester.assertLabel("count", "1");
```

`clickLink` simulates a browser with JavaScript. For an `AjaxLink` it fires the Ajax event; for an `AjaxFallbackLink` too. `clickLink(path, false)` simulates a browser without JavaScript: an `AjaxFallbackLink` then does a normal request, and an `AjaxLink` fails the test.

## Test Ajax

Fire an event on a component that has an `AjaxEventBehavior`, then check that the right components were added to the Ajax response:

```java
tester.startPage(CounterPage.class);
tester.executeAjaxEvent("ajaxIncrement", "click");

tester.assertComponentOnAjaxResponse("count");
tester.assertLabel("count", "1");
```

`executeBehavior(behavior)` calls any `AbstractAjaxBehavior` directly, and `executeAllTimerBehaviors(page)` fires the timers on a page once.

## Test a component on its own

`startComponentInPage` renders a component in a generated page, attached to a `<span>` tag. That suits panels and labels:

```java
tester.startComponentInPage(new AddressPanel("address", Model.of(address)));
tester.assertLabel("address:city", "Amsterdam");
```

Paths may start with the id of the component you passed; the tester adds it when you leave it out. A component that needs a specific tag, such as a `TextField` or a `Link`, needs page markup of its own: pass it with `startComponentInPage(component, markup)` as an `IMarkupFragment`.

## Check the response itself

`getLastResponse()` returns the `MockHttpServletResponse` of the last request, with its status, headers and content:

```java
tester.startResource(new ReportResource());
MockHttpServletResponse response = tester.getLastResponse();
assertEquals(200, response.getStatus());
assertTrue(response.getDocument().startsWith("id,name"));
```

`startResource` and `startResourceReference` request a resource. `executeUrl("./orders/42")` requests any URL, which is how you test mounted pages and request mappers.

## Set request headers

`addRequestHeader` sets a header on the next request only:

```java
tester.addRequestHeader("Accept-Language", "nl-NL");
tester.startPage(HomePage.class);
```

An application with `ResourceIsolationRequestCycleListener` refuses listener requests that carry no `Sec-Fetch-Site` header. Add it before each click or submit:

```java
tester.addRequestHeader(FetchMetadataResourceIsolationPolicy.SEC_FETCH_SITE_HEADER,
    FetchMetadataResourceIsolationPolicy.SAME_ORIGIN);
tester.clickLink("delete");
```

## Use files from the web application folder

When your application loads markup or resources from `src/main/webapp`, tell the tester where that folder is. There is no servlet container to ask:

```java
tester = new WicketTester(new WicketApplication(),
    new File("src/main/webapp").getAbsolutePath());
```

Forms have their own helper, `FormTester`; see [Test forms]({{ site.baseurl }}/docs/test-forms.html). Markup details are easier to check with `TagTester`, described in [Test markup]({{ site.baseurl }}/docs/test-markup.html).
