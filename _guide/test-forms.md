---
title: Test forms
type: howto
topic: testing
summary: Fill in fields, pick options, upload files and submit a form in a unit test with FormTester, then check the feedback messages and the model.
since: 10
apis: [FormTester, WicketTester]
keywords: [submit form, setValue, select, selectMultiple, setFile, feedback messages, assertErrorMessages, assertInfoMessages, validation test, AjaxButton test, newFormTester]
order: 20
source: [testing/testing_2.adoc]
---

You need this when you want to test a form the way a user fills it in: type values, choose options, press a button, and see the result. `FormTester` does that for one form on the page that `WicketTester` last rendered. [Test pages and components]({{ site.baseurl }}/docs/test-pages.html) covers setting up the tester.

## Fill in and submit a form

Ask the tester for a `FormTester` with the path of the form, set the values with the ids of the fields relative to the form, and submit:

*SignUpPageTest.java*

```java
@Test
void signsUp() {
    tester.startPage(SignUpPage.class);

    FormTester form = tester.newFormTester("form");
    form.setValue("name", "Ada Lovelace");
    form.setValue("email", "ada@example.com");
    form.setValue("terms", true);
    form.submit();

    tester.assertNoErrorMessage();
    tester.assertRenderedPage(WelcomePage.class);
}
```

A new `FormTester` starts with the values the fields show, as a browser would send them. Text fields without a value are sent as empty strings; `newFormTester("form", false)` leaves them out of the request instead. Invisible and disabled fields are never sent.

Each `FormTester` submits once. Create a new one for the next submit.

`FormTester` sends the request directly, so the browser's own checks of `required` and `pattern` attributes do not run. A test that submits an empty required field therefore reaches Wicket's server-side validation, which is what you want to test.

> Since Wicket 11, text fields write `required` when they are required, `placeholder` from their label (`setLabel`), and `pattern` for a `PatternValidator`. Tests that compare rendered markup with an expected file, or check the attributes of an `<input>` with `TagTester`, see these attributes on Wicket 11 and not on Wicket 10.
{: .since}

## Set each kind of field

| Field | Method |
|---|---|
| `TextField`, `TextArea`, `PasswordTextField`, hidden fields | `setValue("id", "text")` |
| `CheckBox` | `setValue("id", true)` |
| `DropDownChoice`, `RadioChoice`, `RadioGroup`, `ListChoice` | `select("id", index)` |
| `ListMultipleChoice`, `CheckBoxMultipleChoice`, `CheckGroup` | `selectMultiple("id", new int[] {0, 2})` |
| `FileUploadField` | `setFile("id", file, "application/pdf")` |

`select` takes the position of the option in the list of choices, starting at 0. `selectMultiple` adds to the current selection; `selectMultiple("id", indexes, true)` replaces it. `setValue` also takes the component instead of its id.

## Press a specific button

`submit()` submits the form without naming a button, so no button's `onSubmit` runs. To press a button, name it:

```java
form.submit("save");
```

For an `AjaxButton` or `AjaxSubmitLink`, `submit("id")` fires the Ajax event, so you can check the Ajax response afterwards:

```java
form.submit("saveAjax");
tester.assertComponentOnAjaxResponse("feedback");
```

A `SubmitLink`, inside or outside the form, is pressed with `submitLink(path, pageRelative)`: with `true` the path starts at the page, with `false` at the form.

## Check the feedback messages

```java
form.setValue("email", "not an address");
form.submit();

tester.assertErrorMessages("The value of 'email' is not a valid email address.");
tester.assertModelValue("form:email", null);
```

| Method | Checks |
|---|---|
| `assertErrorMessages(String...)` | Exactly these error messages, in any order |
| `assertInfoMessages(String...)` | Exactly these info messages |
| `assertNoErrorMessage()`, `assertNoInfoMessage()` | No such messages |
| `assertFeedback(path, String...)` | What a `FeedbackPanel` at that path renders |
| `assertComponentFeedbackMessage(component, key, model, filter)` | A message from a resource key for one component |

The tester keeps all messages until the next request, and the `FormTester` clears them before it submits.

## Check the model after submitting

Read the model of a field with `assertModelValue`, or check the object behind the form directly:

```java
form.setValue("name", "Grace Hopper");
form.submit("save");

Person saved = (Person) tester.getComponentFromLastRenderedPage("form")
    .getDefaultModelObject();
assertEquals("Grace Hopper", saved.getName());
```

## Fire an Ajax event on a field

A field with an `AjaxFormComponentUpdatingBehavior` only processes its value when the event fires. Set the value with a `FormTester`, then fire the event:

```java
FormTester form = tester.newFormTester("form");
form.setValue("country", "NL");
tester.executeAjaxEvent("form:country", "change");
tester.assertComponentOnAjaxResponse("form:province");
```

If the application uses `ResourceIsolationRequestCycleListener`, add the `Sec-Fetch-Site` header before each submit; see [Test pages and components]({{ site.baseurl }}/docs/test-pages.html#set-request-headers).
