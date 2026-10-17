---
title: Build a stateless form
type: howto
topic: forms
summary: Use StatelessForm so a page with a form stays stateless, never expires and does not create a session until it must.
since: 10
apis: [StatelessForm, Form]
keywords: [stateless, page expired, login form, PageExpiredException, session, bookmarkable, search form]
order: 110
source: [forms2/forms2_10.adoc]
---

You need this for forms on public pages, such as a login, search or contact form. A normal `Form` makes its page stateful: Wicket stores the page in the session, and a submit after the session has timed out ends in a "page expired" error. A `StatelessForm` keeps the page stateless, so a submit always works and a crawler that requests the page does not create sessions.

## Replace Form with StatelessForm

*LoginPage.java*

```java
public class LoginPage extends WebPage {
    private String username;
    private String password;

    public LoginPage(PageParameters parameters) {
        super(parameters);

        StatelessForm<Void> form = new StatelessForm<>("form") {
            @Override
            protected void onSubmit() {
                if (AuthenticatedWebSession.get().signIn(username, password)) {
                    continueToOriginalDestination();
                    setResponsePage(getApplication().getHomePage());
                } else {
                    error("Unknown username or password");
                }
            }
        };
        add(form);

        IModel<String> usernameModel = LambdaModel.of(() -> username, value -> username = value);
        IModel<String> passwordModel = LambdaModel.of(() -> password, value -> password = value);
        form.add(new TextField<>("username", usernameModel).setRequired(true));
        form.add(new PasswordTextField("password", passwordModel));
        add(new FeedbackPanel("feedback"));
    }
}
```

*LoginPage.html*

```html
<form wicket:id="form">
    <input type="text" wicket:id="username">
    <input type="password" wicket:id="password">
    <button type="submit">Log in</button>
</form>
<div wicket:id="feedback"></div>
```

## Keep everything on the page stateless

A `StatelessForm` only helps when the whole page is stateless. The page must be bookmarkable: it needs a constructor without arguments or one that takes `PageParameters`. Every other component on the page must be stateless too. Labels, fields and buttons are; a normal `Link` or an Ajax behavior makes the page stateful again. Use a `StatelessLink` or a `BookmarkablePageLink` for links. [Keep a page stateless]({{ site.baseurl }}/docs/keep-stateless.html) shows how to find the component that breaks it.

## Understand what the form gets on submit

When the form is submitted, Wicket does not find the page in the session. It creates a new instance of the page from its class and page parameters, and then processes the form on that new instance. For your code this means:

- The models start out the way the constructor sets them up. Anything you changed on the earlier instance, such as a value set by an earlier submit or a choice list filtered at runtime, is gone.
- Only what the browser submits reaches the models. A `DropDownChoice` can only find the submitted option if the constructor builds the same list of choices again.
- Hidden state belongs in page parameters or in a `HiddenField`, not in fields of the page.

A failed submit renders the new instance with the errors and the user's input, as with a normal form.

## Pass page parameters along

The form posts back to the page with the page's current parameters, so a search form on `/search?category=books` keeps `category` across the submit. Read the parameters in the constructor, as the page is built anew on each submit:

```java
public SearchPage(PageParameters parameters) {
    super(parameters);
    String category = parameters.get("category").toString("all");
    // build the form for this category
}
```

To show the result on a bookmarkable URL, redirect with new parameters from `onSubmit()`:

```java
setResponsePage(SearchPage.class, new PageParameters().set("q", query));
```
