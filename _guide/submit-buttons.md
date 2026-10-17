---
title: Use more than one submit button
type: howto
topic: forms
summary: Give a form several buttons that each run their own code, pick the button for the Enter key, and add a Cancel button that skips validation.
since: 10
apis: [Button, SubmitLink, IFormSubmittingComponent, IFormSubmitter]
keywords: [cancel button, default button, enter key, skip validation, setDefaultFormProcessing, onAfterSubmit, formnovalidate, submit link]
order: 70
source: [forms2/forms2_5.adoc]
---

You need this when a form has more than one action, such as "Save" and "Save and close", or a "Cancel" that must work while the form is still invalid.

## Run different code per button

Add a `Button` per action and override its `onSubmit()`. The button's `onSubmit()` runs after the form has been validated and the models are updated, before the form's own `onSubmit()`. Use `onAfterSubmit()` for code that has to run after the form's `onSubmit()`, such as navigating away.

*EditArticlePage.java*

```java
Form<Article> form = new Form<>("form", articleModel) {
    @Override
    protected void onSubmit() {
        articleService.save(getModelObject());
    }
};
add(form);

form.add(new Button("save"));

Button publish = new Button("publish") {
    @Override
    public void onSubmit() {
        form.getModelObject().setPublished(true);
    }

    @Override
    public void onAfterSubmit() {
        setResponsePage(ArticlesPage.class);
    }
};
form.add(publish);
```

*EditArticlePage.html*

```html
<form wicket:id="form">
    ...
    <button type="submit" wicket:id="save">Save</button>
    <button type="submit" wicket:id="publish">Publish</button>
</form>
```

A `Button` works on `<button>` and on `<input type="submit">`. Give it a model to set the text from Java: the model becomes the body of a `<button>` or the `value` of an `<input>`.

If validation fails, the clicked button's `onError()` is called first, then the form's `onError()`. Neither `onSubmit()` runs.

## Choose the button for the Enter key

When the user presses Enter in a text field, the browser acts as if the first submit button of the form was clicked. To make Enter act as another button, set it as the default button:

```java
form.setDefaultButton(publish);
```

Wicket adds a small script to the form that clicks this button when Enter is pressed in an input field.

## Add a Cancel button that skips validation

Turn off default form processing on the button. Wicket then skips validation and the model update, and only calls the button's `onSubmit()` and `onAfterSubmit()`. The form's `onSubmit()` is not called.

```java
form.add(new Button("cancel") {
    @Override
    public void onSubmit() {
        setResponsePage(ArticlesPage.class);
    }
}.setDefaultFormProcessing(false));
```

The user's input is neither validated nor stored.

> Since Wicket 11, a `Button` with default form processing turned off renders `formnovalidate`, so the browser does not block it on empty required fields either.
{: .since}

## Submit a form from a link

A `SubmitLink` submits the form with JavaScript, so it works on an `<a>` or any element that can be clicked. It has the same `onSubmit()`, `onAfterSubmit()` and `onError()` as a `Button`.

Unlike a button, a `SubmitLink` can sit outside the form. Pass the form to its constructor:

```java
add(new SubmitLink("saveFromToolbar", form));
```

```html
<nav>
    <a href="#" wicket:id="saveFromToolbar">Save</a>
</nav>
<form wicket:id="form">...</form>
```

## Submit without reloading the page

`AjaxButton` and `AjaxSubmitLink` do the same over Ajax and give you an `AjaxRequestTarget` in `onSubmit` and `onError`, so you can update the feedback panel without rendering the whole page. See [Ajax components]({{ site.baseurl }}/docs/ajax-components.html).
