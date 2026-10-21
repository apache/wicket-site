---
title: Swap markup with fragments
type: howto
topic: components
summary: Keep small alternative pieces of markup inside a page or panel and choose in Java which one to show, without a panel class for each.
since: 10
apis: [Fragment]
keywords: [wicket:fragment, inline panel, alternative markup, switch markup, replace content, conditional markup, variant]
order: 60
source: [keepControl/keepControl_5.adoc]
---

Use a fragment when a spot on a page shows one of a few small blocks of markup, and a separate panel class with its own HTML file for each block would be overkill. A fragment is a component whose markup sits in the file of the page or panel that uses it, inside a `<wicket:fragment>` tag.

## Define the fragments and the place they go

Put each alternative in a `<wicket:fragment>` with its own `wicket:id`. Wicket does not render fragment markup where it is defined. Add a normal tag where the chosen fragment should appear.

*RegistrationPage.html*

```html
<body>
  <h1>Register</h1>
  <div wicket:id="content"></div>

  <wicket:fragment wicket:id="formFragment">
    <form wicket:id="form">
      <label wicket:for="email">Email</label>
      <input type="email" wicket:id="email">
      <button type="submit">Register</button>
    </form>
  </wicket:fragment>

  <wicket:fragment wicket:id="doneFragment">
    <p>Check your mail to activate your account.</p>
  </wicket:fragment>
</body>
```

## Create the fragment in Java

The `Fragment` constructor takes three things: the id of the tag where it goes, the `wicket:id` of the `<wicket:fragment>`, and the container whose markup file holds the fragment. Components inside the fragment are added to the `Fragment`.

*RegistrationPage.java*

```java
public class RegistrationPage extends WebPage {
    private String email;

    public RegistrationPage() {
        Fragment formFragment = new Fragment("content", "formFragment", this);
        add(formFragment);

        Form<Void> form = new Form<Void>("form") {
            @Override
            protected void onSubmit() {
                register(email);
                formFragment.replaceWith(new Fragment("content", "doneFragment", RegistrationPage.this));
            }
        };
        form.add(new EmailTextField("email", LambdaModel.of(() -> email, value -> email = value)));
        formFragment.add(form);
    }
}
```

After a successful submit, the `<div>` holds the content of the second fragment (shown as in deployment mode, without Wicket attributes):

```html
<div>
  <p>Check your mail to activate your account.</p>
</div>
```

## Swap one fragment for another

Fragments are components, so you swap them like any component: `replaceWith` on the old one, or `replace` on the parent with a new component that has the same id. To swap with Ajax, give the fragment's tag a markup id with `setOutputMarkupId(true)` on both fragments, swap, and add the new fragment to the `AjaxRequestTarget`.

## Use fragments in a list

Fragments work well when the items of a list need different markup. The markup provider is the page or panel whose file holds the fragments, not the list item:

```java
add(new ListView<Message>("messages", messagesModel) {
    @Override
    protected void populateItem(ListItem<Message> item) {
        String fragmentId = item.getModelObject().isUrgent() ? "urgent" : "normal";
        item.add(new Fragment("message", fragmentId, InboxPage.this, item.getModel()));
    }
});
```

The fourth argument is the fragment's model; components inside the fragment get it from the fragment with `getDefaultModel()`, as they would from a panel.

## Choose between a fragment and a panel

A fragment belongs to the page or panel that defines it: other classes cannot use its markup. When the same block is needed in more than one place, make it a panel. See [Build a reusable panel]({{ site.baseurl }}/docs/build-panel.html).
