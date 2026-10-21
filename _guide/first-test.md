---
title: Test a page with WicketTester
type: tutorial
topic: start
summary: Write JUnit tests that render your pages, click links, submit the guestbook form and check Ajax updates, without a browser or a server.
since: 10
apis: [WicketTester, FormTester]
keywords: [unit test, JUnit, test page, assertLabel, clickLink, assertRenderedPage, assertErrorMessages, executeAjaxEvent, assertComponentOnAjaxResponse, mvn test]
order: 50
source: [testing/testing_1.adoc]
---

In this tutorial you write tests for the application you built in the previous tutorials. The tests render the home page, click its links, submit the guestbook form and check what Ajax redraws. They run in JUnit, without a browser and without starting a server.

Start from the `myapp` project as you left it at the end of [Update a page with Ajax]({{ site.baseurl }}/docs/first-ajax.html). The quickstart already put the test dependencies in *pom.xml*: `wicket-tester` and JUnit.

## 1. Run the test you already have

The quickstart generated *TestHomePage.java* in `src/test/java/com/example`:

```java
public class TestHomePage {
    private WicketTester tester;

    @BeforeEach
    public void setUp() {
        tester = new WicketTester(new WicketApplication());
    }

    @Test
    public void homepageRendersSuccessfully() {
        tester.startPage(HomePage.class);
        tester.assertRenderedPage(HomePage.class);
    }
}
```

`WicketTester` runs your application in memory, with a fake request, response and session. `startPage` renders a page the way a browser request would. `assertRenderedPage` checks which page came out.

Run the tests from the project folder:

```shell
mvn test
```

Maven reports `Tests run: 1, Failures: 0`. The test still passes after all your changes, so the home page, the base page and both panels render without errors. A test like this catches a `wicket:id` in the HTML without a component in Java, and the other way around.

## 2. Check what a label shows

Add a test to `TestHomePage` that checks the greeting:

```java
@Test
public void greetsTheVisitor() {
    tester.startPage(HomePage.class);
    tester.assertLabel("greeting", "Hello, Wicket!");
}
```

The first argument is the path of the component: its id, prefixed with the ids of the containers it sits in, separated by colons. The greeting is added straight to the page, so its path is its id.

Run `mvn test`. Two tests pass. Change the expected text to `Hello!` and run again: the test fails and tells you what the label showed instead. Change it back.

## 3. Click the Ajax counter

`clickLink` clicks a link. For an `AjaxLink` it sends an Ajax request, as the browser would. Add:

```java
@Test
public void countsClicks() {
    tester.startPage(HomePage.class);
    tester.assertLabel("clicks", "0");

    tester.clickLink("count");

    tester.assertLabel("clicks", "1");
    tester.assertComponentOnAjaxResponse("clicks");
}
```

`assertComponentOnAjaxResponse` checks that the label was part of the Ajax response, so the browser would have redrawn it. Run `mvn test`: three tests pass.

## 4. Follow a link to another page

The links in the header sit inside the `HeaderPanel`, which has the id `header`. Their paths start with that id:

```java
@Test
public void navigatesToTheAboutPage() {
    tester.startPage(HomePage.class);

    tester.clickLink("header:about");

    tester.assertRenderedPage(AboutPage.class);
}
```

Run `mvn test`: four tests pass.

## 5. Test that the form opens

The guestbook form is hidden until the visitor clicks "Write a message". Create *TestGuestbookPage.java* in `src/test/java/com/example`, and test that link first. Keep the application in a field, so later tests can look at its guestbook:

```java
package com.example;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.apache.wicket.util.tester.FormTester;
import org.apache.wicket.util.tester.WicketTester;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

public class TestGuestbookPage {
    private WicketApplication application;
    private WicketTester tester;

    @BeforeEach
    public void setUp() {
        application = new WicketApplication();
        tester = new WicketTester(application);
    }

    @AfterEach
    public void tearDown() {
        tester.destroy();
    }

    @Test
    public void opensTheForm() {
        tester.startPage(GuestbookPage.class);
        tester.assertInvisible("form");

        tester.clickLink("write");

        tester.assertVisible("form");
        tester.assertInvisible("write");
        tester.assertComponentOnAjaxResponse("form");
    }
}
```

Each test gets a new application and so a new guestbook, and `destroy()` cleans up after each test. `assertInvisible` and `assertVisible` check the visibility that `onConfigure()` decided.

Run `mvn test`: five tests pass.

## 6. Test that the guestbook rejects empty input

`newFormTester` gives you a `FormTester` for the form at that path. Its `submit()` sends the form with the fields as they are. Add a test that submits the form empty:

```java
@Test
public void requiresNameAndMessage() {
    tester.startPage(GuestbookPage.class);
    tester.clickLink("write");

    FormTester form = tester.newFormTester("form");
    form.submit();

    tester.assertErrorMessages("'Name' is required.", "'Message' is required.");
    assertEquals(1, application.getGuestbook().getEntries().size());
}
```

`assertErrorMessages` checks the error messages the submit produced. The guestbook still holds only its welcome entry.

Run `mvn test`: six tests pass.

## 7. Test that the guestbook saves an entry

`setValue` fills in a field. Its first argument is the path of the field relative to the form. Add:

```java
@Test
public void savesAnEntry() {
    tester.startPage(GuestbookPage.class);
    tester.clickLink("write");

    FormTester form = tester.newFormTester("form");
    form.setValue("name", "Ann");
    form.setValue("text", "Nice site!");
    form.submit();

    tester.assertNoErrorMessage();
    tester.assertInfoMessages("Thanks for signing, Ann!");
    assertEquals("Ann", application.getGuestbook().getEntries().get(0).getName());
}
```

Run `mvn test`: seven tests pass.

## 8. Submit through the Ajax button

`form.submit()` submits the form as a plain request. To test the Ajax button, fill in the fields and fire the button's `click` event with `executeAjaxEvent`. Wicket then submits the form over Ajax, as the browser does:

```java
@Test
public void savesAnEntryWithAjax() {
    tester.startPage(GuestbookPage.class);
    tester.clickLink("write");

    FormTester form = tester.newFormTester("form");
    form.setValue("name", "Bob");
    form.setValue("text", "Hello from Ajax.");
    tester.executeAjaxEvent("form:save", "click");

    tester.assertComponentOnAjaxResponse("entries");
    tester.assertComponentOnAjaxResponse("feedback");
    assertEquals("Bob", application.getGuestbook().getEntries().get(0).getName());
}
```

Run `mvn test`: eight tests pass.

## 9. Fire the timer

A test does not wait ten seconds for the timer. `executeAllTimerBehaviors` fires every timer on a page at once. Add an entry to the guestbook behind the page's back, as another visitor would, and fire the timers:

```java
@Test
public void refreshesTheList() {
    tester.startPage(GuestbookPage.class);
    application.getGuestbook().add(new Entry("Cid", "Signed in another browser."));

    tester.executeAllTimerBehaviors(tester.getLastRenderedPage());

    tester.assertComponentOnAjaxResponse("entries");
    tester.assertContains("Signed in another browser.");
}
```

`assertContains` searches the last response, here the Ajax response with the redrawn list.

Run `mvn test`: all nine tests pass. Together they cover every page, the counter, the navigation, the hidden form, both ways of submitting the guestbook and the timer, and none of them needs a browser or a server.

## Continue from here

This is the last of the tutorials. From here, the how-to guides help you with a specific goal: start with [Test pages and components]({{ site.baseurl }}/docs/test-pages.html) and [Test forms]({{ site.baseurl }}/docs/test-forms.html) for more of what you used here, and [WicketTester]({{ site.baseurl }}/docs/wicket-tester.html) lists its methods. [Best practices]({{ site.baseurl }}/docs/best-practices.html) explains how to keep a growing Wicket application easy to change and to test.
