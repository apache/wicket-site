---
title: Build a form that saves data
type: tutorial
topic: start
summary: Add a guestbook page with a form that validates its input, saves entries and lists them, and shows errors and a confirmation.
since: 10
apis: [Form, TextField, TextArea, LambdaModel, ListView, FeedbackPanel, StringValidator]
keywords: [guestbook, form submit, onSubmit, input, required field, validation, error message, feedback, wicket:for, ListView, data entry]
order: 30
source: [modelsforms/modelsforms_4.adoc, forms2/forms2_1.adoc, forms2/forms2_2.adoc]
---

In this tutorial you add a guestbook to the application: a page where visitors leave their name and a message, and see the messages others left. You build a form that writes its input into a Java object, check that input, and show errors and a confirmation.

Start from the `myapp` project as you left it at the end of [Give every page the same layout]({{ site.baseurl }}/docs/page-layout.html), with `BasePage`, `HeaderPanel` and `FooterPanel` in the package `com.example`.

## 1. Store guestbook entries

Create *Entry.java* for one message in the guestbook. It is serializable because the page that edits it is kept between requests:

```java
package com.example;

import java.io.Serializable;

public class Entry implements Serializable {
    private String name;
    private String text;

    public Entry() {
    }

    public Entry(String name, String text) {
        this.name = name;
        this.text = text;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getText() { return text; }
    public void setText(String text) { this.text = text; }
}
```

Create *Guestbook.java*. It keeps the entries in memory, newest first, and starts with one entry so the page has something to show:

```java
package com.example;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

public class Guestbook {
    private final List<Entry> entries = new CopyOnWriteArrayList<>();

    public Guestbook() {
        entries.add(new Entry("Wicket", "Welcome to the guestbook!"));
    }

    public void add(Entry entry) {
        entries.add(0, entry);
    }

    public List<Entry> getEntries() {
        return List.copyOf(entries);
    }
}
```

The application holds the one guestbook that all visitors share. In *WicketApplication.java*, add a field, a getter and a static `get()` method that returns the running application with its own type:

```java
public class WicketApplication extends WebApplication {
    private final Guestbook guestbook = new Guestbook();

    public static WicketApplication get() {
        return (WicketApplication) Application.get();
    }

    public Guestbook getGuestbook() {
        return guestbook;
    }

    // getHomePage() and init() stay as they are
}
```

Import `org.apache.wicket.Application`. Run `Start`: the application starts and looks as before.

## 2. List the entries on a guestbook page

Create *GuestbookPage.java*:

```java
package com.example;

import java.util.List;

import org.apache.wicket.markup.html.basic.Label;
import org.apache.wicket.markup.html.list.ListItem;
import org.apache.wicket.markup.html.list.ListView;
import org.apache.wicket.model.IModel;

public class GuestbookPage extends BasePage {
    public GuestbookPage() {
        IModel<List<Entry>> entries =
                () -> WicketApplication.get().getGuestbook().getEntries();

        add(new ListView<Entry>("entry", entries) {
            @Override
            protected void populateItem(ListItem<Entry> item) {
                item.add(new Label("name", item.getModel().map(Entry::getName)));
                item.add(new Label("text", item.getModel().map(Entry::getText)));
            }
        });
    }

    @Override
    protected String getPageTitle() {
        return "Guestbook - My App";
    }
}
```

A `ListView` repeats its tag once for every element of the list in its model, and calls `populateItem` to fill in each copy. `item.getModel()` is a model of one entry, and `map` turns it into a model of one of its properties.

Create *GuestbookPage.html*:

```html
<!DOCTYPE html>
<html xmlns:wicket="http://wicket.apache.org">
<body>
<wicket:extend>
    <h2>Guestbook</h2>
    <ul>
        <li wicket:id="entry">
            <strong wicket:id="name">Ann</strong>:
            <span wicket:id="text">Hello!</span>
        </li>
    </ul>
</wicket:extend>
</body>
</html>
```

Link to the page from the navigation. In *HeaderPanel.java*, add:

```java
add(new BookmarkablePageLink<Void>("guestbook", GuestbookPage.class));
```

And in *HeaderPanel.html*, inside the `<nav>`:

```html
<a wicket:id="guestbook">Guestbook</a>
```

Restart and click "Guestbook" in the header. The page lists the welcome entry.

## 3. Add a form that saves an entry

The form edits a new `Entry` that the page keeps in a model. Each field gets a `LambdaModel` that reads and writes one property of that entry. Add the field and the form to *GuestbookPage.java*:

```java
public class GuestbookPage extends BasePage {
    private final IModel<Entry> entry = Model.of(new Entry());

    public GuestbookPage() {
        Form<Void> form = new Form<>("form") {
            @Override
            protected void onSubmit() {
                WicketApplication.get().getGuestbook().add(entry.getObject());
                entry.setObject(new Entry());
            }
        };
        add(form);

        TextField<String> name = new TextField<>("name",
                LambdaModel.of(entry, Entry::getName, Entry::setName));
        form.add(name);

        TextArea<String> text = new TextArea<>("text",
                LambdaModel.of(entry, Entry::getText, Entry::setText));
        form.add(text);

        // the ListView from step 2 stays here
    }
}
```

The new imports are `org.apache.wicket.markup.html.form.Form`, `TextField` and `TextArea` from the same package, `org.apache.wicket.model.Model` and `org.apache.wicket.model.LambdaModel`.

Add the form to *GuestbookPage.html*, between the heading and the list:

```html
<form wicket:id="form">
    <p>
        <label wicket:for="name">Name</label><br>
        <input type="text" wicket:id="name">
    </p>
    <p>
        <label wicket:for="text">Message</label><br>
        <textarea wicket:id="text" rows="4" cols="40"></textarea>
    </p>
    <p><button type="submit">Sign the guestbook</button></p>
</form>
```

`wicket:for` points a `<label>` at a form component, and Wicket writes the matching `for` attribute.

When you submit, Wicket copies each field's input into its model, so into the `Entry`, and then calls `onSubmit()`. There you save the entry and give the form a fresh one.

Restart, fill in your name and a message, and submit. Your entry appears at the top of the list and the form is empty again.

## 4. Check the input

Submit the form with both fields empty. An empty entry appears in the list. Make both fields required, give them a name to use in messages, and limit their length. Replace the code that creates the two fields:

```java
TextField<String> name = new TextField<>("name",
        LambdaModel.of(entry, Entry::getName, Entry::setName));
name.setRequired(true);
name.setLabel(Model.of("Name"));
name.add(StringValidator.maximumLength(50));
form.add(name);

TextArea<String> text = new TextArea<>("text",
        LambdaModel.of(entry, Entry::getText, Entry::setText));
text.setRequired(true);
text.setLabel(Model.of("Message"));
text.add(StringValidator.maximumLength(500));
form.add(text);
```

Import `org.apache.wicket.validation.validator.StringValidator`. When a check fails, Wicket does not update the model and does not call `onSubmit()`. It keeps what the user typed and records an error message instead.

To show those messages, add a `FeedbackPanel` to the constructor:

```java
add(new FeedbackPanel("feedback"));
```

Import `org.apache.wicket.markup.html.panel.FeedbackPanel`, and put its tag above the form in *GuestbookPage.html*:

```html
<div wicket:id="feedback"></div>
```

> Since Wicket 11, a required field also gets the HTML attribute `required`, so the browser stops the empty submit itself and shows its own message at the first empty field. Write the form tag as `<form wicket:id="form" novalidate>` to leave the check to Wicket and see its messages.
{: .since}

Restart and submit the empty form. Nothing is saved, and the page shows:

```
'Name' is required.
'Message' is required.
```

## 5. Confirm a saved entry

The feedback panel also shows messages you add yourself. In `onSubmit()`, add an info message before you replace the entry:

```java
@Override
protected void onSubmit() {
    Entry saved = entry.getObject();
    WicketApplication.get().getGuestbook().add(saved);
    info("Thanks for signing, " + saved.getName() + "!");
    entry.setObject(new Entry());
}
```

The panel marks each message with a CSS class for its level. Add colors for errors and info messages to *style.css*:

```css
.feedbackPanelERROR { color: #c00; }
.feedbackPanelINFO { color: #070; }
```

Restart and sign the guestbook. The page thanks you by name in green and lists your entry. An empty submit shows the errors in red.

You now have a page that takes input, checks it, saves it in a Java object and shows the result.

## Continue with Ajax

Every submit reloads the whole page. In the next tutorial, [Update a page with Ajax]({{ site.baseurl }}/docs/first-ajax.html), you update only the parts that change.

[How a form is processed]({{ site.baseurl }}/docs/form-processing.html) explains the steps between submit and `onSubmit()`, [Validate input and show errors]({{ site.baseurl }}/docs/validate-input.html) covers the other validators and how to change their messages, and [Read and write data with lambda models]({{ site.baseurl }}/docs/lambda-models.html) explains `LambdaModel` and `map`. To show a list from a database, read [Show a list with ListView]({{ site.baseurl }}/docs/list-items.html).
