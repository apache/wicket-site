---
title: Test markup
type: howto
topic: testing
summary: Find tags in the rendered output with TagTester and check their attributes and content, render a component to a string, or compare a page with an expected file.
since: 10
apis: [TagTester, ComponentRenderer, WicketTester]
keywords: [HTML assertions, attribute, CSS class, rendered markup, getTagByWicketId, createTagByAttribute, expected output, golden file, snapshot test, executeTest]
order: 30
source: [testing/testing_3.adoc]
---

You need this when a test has to check the markup a page or component renders, not only which components it contains: a CSS class, an attribute, the text inside a tag. `TagTester` finds tags in a piece of markup and gives you their name, attributes and content. [Test pages and components]({{ site.baseurl }}/docs/test-pages.html) covers rendering the page first.

## Find a tag

The tester has shortcuts that search the last response:

```java
tester.startPage(OrderPage.class);

TagTester total = tester.getTagByWicketId("total");
TagTester status = tester.getTagById("order-status");
List<TagTester> rows = tester.getTagsByWicketId("row");
```

`getTagByWicketId` looks for the `wicket:id` attribute in the output. Wicket keeps that attribute in development mode, which is the default in tests, and strips it in deployment mode.

`TagTester` itself searches any markup string:

| Method | Returns |
|---|---|
| `TagTester.createTagByName(markup, "table")` | The first `<table>` tag |
| `TagTester.createTagByAttribute(markup, "class", "total")` | The first tag whose `class` is exactly `total` |
| `TagTester.createTagsByAttribute(markup, "class", "total", false)` | Every such tag; `true` stops after the first |
| `TagTester.createTags(markup, tag -> ..., false)` | Every tag the function accepts |

The methods return `null` or an empty list when nothing matches.

## Check a tag

*OrderPageTest.java*

```java
@Test
void showsTotalAsWarningWhenOverLimit() {
    tester.startPage(new OrderPage(Model.of(largeOrder)));

    TagTester total = tester.getTagByWicketId("total");
    assertNotNull(total);
    assertEquals("span", total.getName());
    assertTrue(total.getAttributeContains("class", "warning"));
    assertEquals("€ 12.500,00", total.getValue());
}
```

| Method | Returns |
|---|---|
| `getName()` | The tag name |
| `hasAttribute(name)` | Whether the attribute is present |
| `getAttribute(name)` | The attribute value, or `null` |
| `getAttributeIs(name, value)` | Whether the value equals `value` |
| `getAttributeContains(name, part)` | Whether the value contains `part` |
| `getAttributeEndsWith(name, end)` | Whether the value ends with `end` |
| `getValue()` | Everything between the open and close tag |
| `getMarkup()` | The tag itself with everything inside it |
| `hasChildTag(name)` | Whether a tag with that name is nested inside |
| `getChild(name)`, `getChild(attribute, value)` | The first nested tag that matches, as a `TagTester` |

{% if site.wicket.version_11 %}
> Since Wicket 11, text fields write `required`, `placeholder` (from `setLabel`) and `pattern` (from a `PatternValidator`) on their `<input>` tag. Assertions on the attributes of an input see them on Wicket 11 only.
{: .since}
{% endif %}

## Check the whole response

For a quick check without finding a tag, `assertContains` and `assertContainsNot` match a regular expression against the last response:

```java
tester.assertContains("<h1>Order 42</h1>");
tester.assertContainsNot("class=\"error\"");
```

`tester.getLastResponseAsString()` returns the markup if you want to search it yourself.

## Render a component to a string

`ComponentRenderer` renders a page or a component outside a request and returns the markup. Use it for components whose output you test or use elsewhere, such as the body of an email:

```java
var renderer = new ComponentRenderer();
CharSequence html = renderer.renderComponent(() -> new InvoicePanel("invoice", Model.of(invoice)));

TagTester amount = TagTester.createTagByAttribute(html.toString(), "class", "amount");
assertEquals("€ 99,00", amount.getValue());
```

A `ComponentRenderer` created without arguments uses its own mock application; `new ComponentRenderer(application)` uses yours. Call `destroy()` on it when you are done. Inside a running request, or in a test that already has a `WicketTester`, the static `ComponentRenderer.renderComponent(component)` renders a new component with the current application.

## Compare a page with an expected file

`executeTest` renders a page and compares the output with a file next to the test class:

```java
tester.executeTest(OrderPageTest.class, OrderPage.class, "OrderPage_expected.html");
```

Run the tests once with `-Dwicket.replace.expected.results=true` to create or update the files, and review the changes before you commit them. `executeTest` also takes a page instance or a component, and `executeListener` and `executeBehavior` compare the response of a listener or an Ajax behavior. These comparisons are strict: any change in the markup, including attributes a new Wicket version adds, makes them fail.
