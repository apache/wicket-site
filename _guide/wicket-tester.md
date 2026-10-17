---
title: WicketTester
type: reference
topic: testing
summary: The methods of WicketTester, grouped by purpose, with FormTester, TagTester and the JUnit helpers of the wicket-tester module.
since: 10
apis: [WicketTester, BaseWicketTester, FormTester, TagTester, Result, WicketTesterExtension, WicketTestCase]
keywords: [wicket-tester, assert methods, startPage, clickLink, executeAjaxEvent, assertLabel, assertErrorMessages, executeTest, expected result, JUnit 5, test helper]
order: 10
source: [testing/testing_1.adoc, testing/testing_2.adoc, testing/testing_3.adoc, testing/testing_4.adoc]
---

`WicketTester`, in the `wicket-tester` module, runs a Wicket application in memory with a mock servlet container. It processes requests synchronously on the calling thread and keeps the last rendered page, request and response. `WicketTester` adds JUnit assertions to `BaseWicketTester`, which holds the machinery. Component paths in all methods are relative to the page, with ids separated by `:`. [Test pages and components]({{ site.baseurl }}/docs/test-pages.html) shows them in use.

## Constructors

| Constructor | Application |
|---|---|
| `WicketTester()` | A new `MockApplication` |
| `WicketTester(Class<? extends Page> homePage)` | A `MockApplication` with this home page |
| `WicketTester(WebApplication application)` | Your application, initialized by the tester |
| `WicketTester(WebApplication application, String path)` | As above, with `path` as the root of the web application folder |
| `WicketTester(WebApplication application, ServletContext servletCtx)` | As above, with your own servlet context |
| `WicketTester(WebApplication application, boolean init)` | With `init` false the application is not initialized, for an application that is already running |
| `WicketTester(WebApplication application, ServletContext servletCtx, boolean init)` | Both |

`destroy()` shuts the application down. Call it after each test.

## Start a page, component or resource

| Method | Description |
|---|---|
| `startPage(Class<C>)`, `startPage(Class<C>, PageParameters)` | Renders a new instance of the page class and returns it |
| `startPage(T page)` | Renders the given page instance |
| `startPage(IPageProvider)` | Renders the page the provider returns |
| `startComponentInPage(C component)`, `startComponentInPage(Class<C>)` | Renders the component in a generated page, attached to a `<span>` |
| `startComponentInPage(C component, IMarkupFragment pageMarkup)` | The same with your own page markup |
| `startResource(IResource)` | Requests a resource |
| `startResourceReference(ResourceReference)`, `startResourceReference(ResourceReference, PageParameters)` | Requests the resource of a reference |
| `executeUrl(String url)` | Requests a URL and lets the request mappers resolve it |

## Interact with the page

| Method | Description |
|---|---|
| `clickLink(String path)`, `clickLink(Component link)` | Clicks a link as a browser with JavaScript would: Ajax links fire their Ajax event |
| `clickLink(String path, boolean isAjax)` | With `false`, as a browser without JavaScript: `AjaxLink` and `AjaxSubmitLink` fail, `AjaxFallbackLink` does a normal request |
| `submitForm(String path)`, `submitForm(Form<?>)` | Submits a form with the values already in the request |
| `newFormTester(String path)`, `newFormTester(String path, boolean fillBlankString)` | Returns a `FormTester` for the form at that path, see below |
| `executeListener(Component)` | Invokes the `IRequestListener` of a component in a new request |
| `invokeListener(Component)`, `invokeListener(Component, Behavior)` | Invokes a listener with the current request and response |
| `executeAjaxEvent(String path, String event)`, `executeAjaxEvent(Component, String event)` | Fires the Ajax behaviors of the component for that event |
| `executeBehavior(AbstractAjaxBehavior)` | Calls an Ajax behavior |
| `executeAllTimerBehaviors(MarkupContainer)` | Fires every Ajax timer in the container once |
| `executeAjaxUrl(Url)` | Requests a URL as an Ajax request |

## Assert a component

Each `assert` method fails the test with a message.

| Method | Asserts |
|---|---|
| `assertComponent(path, Class)` | The component exists and is of that class |
| `assertExists(path)`, `assertNotExists(path)` | The component exists or not; `assertExists` returns it |
| `assertVisible(path)`, `assertInvisible(path)` | Visible in the hierarchy or not |
| `assertEnabled(path)`, `assertDisabled(path)` | Enabled in the hierarchy or not |
| `assertRequired(path)`, `assertNotRequired(path)` | A form component is required or not |
| `assertLabel(path, text)` | A `Label` shows this text |
| `assertModelValue(path, value)` | The model object of the component equals the value |
| `assertBehavior(path, Class)` | The component has a behavior of that class |
| `assertBookmarkablePageLink(id, pageClass, parameters)` | A `BookmarkablePageLink` points to the page with these parameters |
| `assertUsability(Component)` | The component is visible and enabled, so the user can use it |
| `assertMarkupLocale(Component, Locale)`, `assertMarkupStyle(Component, style)`, `assertMarkupVariation(Component, variation)` | Which variant of the markup file was used |

## Assert the page and response

| Method | Asserts |
|---|---|
| `assertRenderedPage(Class)` | The last rendered page is of that class |
| `assertContains(regex)`, `assertContainsNot(regex)` | The last response matches the regular expression or not |
| `assertRedirectUrl(url)` | The last response redirected to this URL |
| `assertAjaxLocation()` | The last Ajax response redirected with an `Ajax-Location` header |
| `assertComponentOnAjaxResponse(Component)`, `assertComponentOnAjaxResponse(path)` | The component was added to the last Ajax response |
| `assertResultPage(String document)` | The last response equals the document |
| `assertResultPage(Class<?> testClass, String filename)` | The last response equals a file next to the test class |

## Assert feedback messages

| Method | Asserts |
|---|---|
| `assertErrorMessages(Serializable...)` | Exactly these error messages, in any order |
| `assertInfoMessages(Serializable...)` | Exactly these info messages, in any order |
| `assertFeedbackMessages(IFeedbackMessageFilter, Serializable...)` | Exactly these messages among those the filter accepts |
| `assertNoErrorMessage()`, `assertNoInfoMessage()` | No messages of that level |
| `assertNoFeedbackMessage(int level)` | No messages of the `FeedbackMessage` level |
| `assertFeedback(path, Serializable...)` | The `FeedbackPanel` at the path shows exactly these messages |
| `assertComponentFeedbackMessage(Component, key, model, filter)` | The component has the message for that resource key |

The tester keeps feedback messages until they are cleared; `clearFeedbackMessages()` clears them, `getMessages(level)` and `getFeedbackMessages(filter)` return them.

## Check without failing

The `is` and `has` methods return a `Result` instead of failing, for your own assertions: `isComponent`, `isVisible`, `isInvisible`, `isEnabled`, `isDisabled`, `isRequired`, `isNotRequired`, `hasLabel`, `isRenderedPage`, `isResultPage`, `ifContains`, `ifContainsNot`, `hasNoErrorMessage`, `hasNoInfoMessage`, `hasNoFeedbackMessage` and `isComponentOnAjaxResponse`. `Result.wasFailed()` tells whether the check failed and `getMessage()` why.

## Compare with expected files

| Method | Compares |
|---|---|
| `executeTest(Class<?> testClass, Class<T> pageClass, filename)` | Renders the page class |
| `executeTest(Class<?> testClass, Class<T> pageClass, PageParameters, filename)` | The same with parameters |
| `executeTest(Class<?> testClass, Page page, filename)` | Renders the page instance |
| `executeTest(Class<?> testClass, Component component, filename)` | Renders the page of the component |
| `executeListener(Class<?> testClass, Component component, filename)` | The response of the component's listener |
| `executeBehavior(Class<?> testClass, AbstractAjaxBehavior behavior, filename)` | The response of the Ajax behavior |

Each compares the response with the file `filename` in the package of `testClass`. With the system property `wicket.replace.expected.results=true` the file is written instead.

> Since Wicket 11, text fields write `required`, `placeholder` and `pattern` attributes, so expected files of pages with text fields differ between Wicket 10 and 11.
{: .since}

## Inspect the page and response

| Method | Returns |
|---|---|
| `getLastRenderedPage()` | The page of the last render |
| `getComponentFromLastRenderedPage(path)` | A component of that page; variants take `wantVisibleInHierarchy` and `failOnAbsent` |
| `getFirstComponentByWicketId(id)`, `getAllComponentsByWicketId(id)` | Components by id anywhere on the page |
| `getTagByWicketId(id)`, `getTagsByWicketId(id)`, `getTagById(id)` | `TagTester`s for tags in the last response |
| `getLastResponse()` | The `MockHttpServletResponse`: status, headers, `getDocument()`, `getBinaryContent()` |
| `getLastResponseAsString()` | The last response as text |
| `getContentTypeFromResponseHeader()`, `getContentLengthFromResponseHeader()`, `getLastModifiedFromResponseHeader()`, `getContentDispositionFromResponseHeader()` | Single headers of the last response |
| `getPreviousRequests()`, `getPreviousResponses()` | All requests and responses so far |
| `urlFor(IRequestHandler)`, `urlFor(Link<?>)`, `urlFor(AjaxLink<?>)` | The URL Wicket generates |
| `getApplication()`, `getSession()`, `getHttpSession()`, `getServletContext()` | The objects behind the tester |
| `dumpPage()`, `debugComponentTrees()` | Print the last response or the component tree, for debugging |

## Control the next request

| Method | Description |
|---|---|
| `getRequest()` | The `MockHttpServletRequest` for the next request; set parameters, cookies and headers on it |
| `addRequestHeader(name, value)` | Adds a header to the next request only |
| `setFollowRedirects(boolean)` | Whether the tester follows redirects, `true` by default |
| `setExposeExceptions(boolean)` | Whether an exception during a request fails the test, `true` by default |
| `setUseRequestUrlAsBase(boolean)` | Whether relative URLs are resolved against the URL of the last request |
| `processRequest()`, `processRequest(MockHttpServletRequest)`, `processRequest(IRequestHandler)` | Processes a request directly |
| `applyRequest()` | Rebuilds Wicket's request from the mock request without processing it |

## FormTester

Returned by `newFormTester(path)`. Ids are relative to the form. Every setter returns the `FormTester`. [Test forms]({{ site.baseurl }}/docs/test-forms.html) shows it in use.

| Method | Description |
|---|---|
| `setValue(id, String)`, `setValue(Component, String)` | Sets the input of a text component |
| `setValue(id, boolean)` | Checks or unchecks a `CheckBox` |
| `select(id, int index)` | Selects an option of a single or multiple choice, `RadioGroup` or `CheckGroup` |
| `selectMultiple(id, int[] indexes)`, `selectMultiple(id, int[] indexes, boolean replace)` | Selects several options, adding to or replacing the current selection |
| `setFile(id, File, contentType)` | Sets the file of a `FileUploadField` or `MultiFileUploadField` |
| `submit()` | Submits the form without a button |
| `submit(String buttonId)`, `submit(Component button)` | Submits with that button; Ajax buttons fire their Ajax event |
| `submitLink(path, boolean pageRelative)` | Submits with a `SubmitLink`, with a path from the page or from the form |
| `getTextComponentValue(id)` | The value a text component will send |
| `setClearFeedbackMessagesBeforeSubmit(boolean)` | Whether messages are cleared before submitting, `true` by default |
| `getForm()` | The form under test |

A `FormTester` submits once.

## TagTester

Created with the static methods `createTagByName`, `createTagByAttribute`, `createTagsByAttribute` and `createTags`, or by the `getTag...` methods of the tester. It reads tags with `getName`, `hasAttribute`, `getAttribute`, `getAttributeIs`, `getAttributeContains`, `getAttributeEndsWith`, `getValue`, `getMarkup`, `hasChildTag` and `getChild`. [Test markup]({{ site.baseurl }}/docs/test-markup.html) describes each.

## JUnit helpers

| Class | Description |
|---|---|
| `WicketTesterExtension` | JUnit 5 extension that creates a tester before each test and destroys it afterwards. Override `create()` to build it with your application; register it with `@RegisterExtension` and get the tester with `getTester()`. |
| `WicketTestCase` | Abstract base class with a public `tester` field, created before and destroyed after each test. Override `newApplication()` or `newWicketTester(WebApplication)` to change it. Also offers `executeTest` and markup comparison helpers. |

```java
class HomePageTest {
    @RegisterExtension
    WicketTesterExtension wicket = new WicketTesterExtension() {
        @Override
        protected WicketTester create() {
            return new WicketTester(new WicketApplication());
        }
    };

    @Test
    void rendersSuccessfully() {
        wicket.getTester().startPage(HomePage.class);
        wicket.getTester().assertRenderedPage(HomePage.class);
    }
}
```
