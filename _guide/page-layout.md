---
title: Give every page the same layout
type: tutorial
topic: start
summary: Move the header, navigation and footer of your application into a base page and two panels, so every page shares one layout.
since: 10
apis: [WebPage, Panel, BookmarkablePageLink]
keywords: [template, master page, layout, base page, wicket:child, wicket:extend, wicket:panel, header, footer, navigation menu, page title]
order: 20
source: [layout/layout_1.adoc, layout/layout_2.adoc, layout/layout_3.adoc, layout/layout_4.adoc]
---

In this tutorial you give the application from [Build your first application]({{ site.baseurl }}/docs/first-application.html) one layout for all its pages: a header with navigation, a footer, and a page title that each page fills in. You build it with a base page that other pages extend, and with panels for the header and the footer.

Start from the `myapp` project as you left it at the end of the previous tutorial, with `HomePage` and `AboutPage` in the package `com.example`.

## 1. Create a base page

Create *BasePage.java* in `com.example`:

```java
package com.example;

import org.apache.wicket.markup.html.WebPage;

public abstract class BasePage extends WebPage {
}
```

Create *BasePage.html* next to it. It holds everything the pages share, and a `<wicket:child/>` tag where each page puts its own content:

```html
<!DOCTYPE html>
<html xmlns:wicket="http://wicket.apache.org">
<head>
    <meta charset="utf-8">
    <title>My App</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div id="hd">
        <div id="logo">
            <img src="logo.png" width="50" height="50" alt="">
            <h1>My App</h1>
        </div>
    </div>
    <div id="bd">
        <wicket:child/>
    </div>
    <div id="ft"></div>
</body>
</html>
```

Now let `HomePage` extend `BasePage` instead of `WebPage`:

```java
public class HomePage extends BasePage {
```

A page that extends another page also inherits its markup. The page's own HTML file then only provides what goes in place of `<wicket:child/>`, inside a `<wicket:extend>` tag. Replace *HomePage.html* with:

```html
<!DOCTYPE html>
<html xmlns:wicket="http://wicket.apache.org">
<body>
<wicket:extend>
    <h2 wicket:id="greeting">Greeting goes here</h2>
    <p>The time on the server is <span wicket:id="time">12:00:00</span>.</p>
    <p><a wicket:id="count">Click me</a>. You clicked <span wicket:id="clicks">0</span> times.</p>
    <p><a wicket:id="about">About this application</a></p>
</wicket:extend>
</body>
</html>
```

Wicket ignores everything outside `<wicket:extend>`, so the `<html>` and `<body>` tags are only there to keep the file valid HTML for your editor.

Run `Start` and open <http://localhost:8080>. The home page now has a blue header with the Wicket logo and a footer. The greeting, time and counter work as before.

## 2. Move the about page onto the layout

Change `AboutPage` to extend `BasePage`, and replace *AboutPage.html*:

```html
<!DOCTYPE html>
<html xmlns:wicket="http://wicket.apache.org">
<body>
<wicket:extend>
    <h2>About this application</h2>
    <p>It was built with Apache Wicket.</p>
    <p><a wicket:id="home">Back to the home page</a></p>
</wicket:extend>
</body>
</html>
```

Restart and click through to the about page. It has the same header and footer as the home page, and its HTML file only contains what is different.

## 3. Put the navigation in a header panel

A panel is a component with its own HTML file, which you can place on any page. Use one for the header, so it can hold links to every page.

Create *HeaderPanel.java*:

```java
package com.example;

import org.apache.wicket.markup.html.link.BookmarkablePageLink;
import org.apache.wicket.markup.html.panel.Panel;

public class HeaderPanel extends Panel {
    public HeaderPanel(String id) {
        super(id);
        add(new BookmarkablePageLink<Void>("home", HomePage.class));
        add(new BookmarkablePageLink<Void>("about", AboutPage.class));
    }
}
```

A `BookmarkablePageLink` points straight at a page class. Unlike a `Link`, it needs no `onClick()`, and its URL works when you bookmark it or open it in a new tab.

Create *HeaderPanel.html*. The markup of a panel goes inside a `<wicket:panel>` tag:

```html
<!DOCTYPE html>
<html xmlns:wicket="http://wicket.apache.org">
<body>
<wicket:panel>
    <div id="logo">
        <img src="logo.png" width="50" height="50" alt="">
        <h1>My App</h1>
        <nav id="nav">
            <a wicket:id="home">Home</a>
            <a wicket:id="about">About</a>
        </nav>
    </div>
</wicket:panel>
</body>
</html>
```

In *BasePage.html*, replace the content of the header `<div>` with a tag for the panel:

```html
<div id="hd" wicket:id="header"></div>
```

Add the panel in a constructor of `BasePage`:

```java
public abstract class BasePage extends WebPage {
    protected BasePage() {
        add(new HeaderPanel("header"));
    }
}
```

The navigation replaces the links between the pages, so remove the `about` link from `HomePage` and the `home` link from `AboutPage`, in both the Java class and the HTML file. `AboutPage` keeps an empty constructor, or none at all.

Make the navigation readable on the blue header by adding these lines to `src/main/webapp/style.css`:

```css
#nav { float: right; padding-top: 20px; }
#nav a, #nav a:visited { color: white; margin-left: 1em; }
```

Restart and reload. The header shows "Home" and "About" on every page, and the links take you between them.

## 4. Add a footer panel

Create *FooterPanel.java*. It shows which Wicket version the application runs on:

```java
package com.example;

import org.apache.wicket.markup.html.basic.Label;
import org.apache.wicket.markup.html.panel.Panel;

public class FooterPanel extends Panel {
    public FooterPanel(String id) {
        super(id);
        add(new Label("version",
                () -> getApplication().getFrameworkSettings().getVersion()));
    }
}
```

Create *FooterPanel.html*:

```html
<!DOCTYPE html>
<html xmlns:wicket="http://wicket.apache.org">
<body>
<wicket:panel>
    <p>Powered by Apache Wicket <span wicket:id="version">10.0.0</span></p>
</wicket:panel>
</body>
</html>
```

In *BasePage.html*, give the footer `<div>` a `wicket:id`:

```html
<div id="ft" wicket:id="footer"></div>
```

Add the panel in the constructor of `BasePage`:

```java
add(new FooterPanel("footer"));
```

And add a style for it to *style.css*:

```css
#ft p { text-align: center; color: white; padding-top: 40px; }
```

Restart and reload. The footer at the bottom of every page shows the Wicket version.

## 5. Let each page set its title

Every page still has the title "My App" in the browser tab. Make the title a label whose text comes from a method that pages can override.

In *BasePage.html*, give the `<title>` tag a `wicket:id`:

```html
<title wicket:id="title">My App</title>
```

In `BasePage`, add the label and the method:

```java
public abstract class BasePage extends WebPage {
    protected BasePage() {
        add(new Label("title", this::getPageTitle));
        add(new HeaderPanel("header"));
        add(new FooterPanel("footer"));
    }

    protected String getPageTitle() {
        return "My App";
    }
}
```

Import `org.apache.wicket.markup.html.basic.Label`. The method reference is a model, like the lambdas in the previous tutorial: Wicket calls `getPageTitle()` when it renders the title, so an override in a subclass is used.

Override the method in `AboutPage`:

```java
public class AboutPage extends BasePage {
    @Override
    protected String getPageTitle() {
        return "About - My App";
    }
}
```

Restart and open the about page. The browser tab shows "About - My App", and the home page keeps "My App".

Your application now has one layout. A new page only needs to extend `BasePage` and put its content in a `<wicket:extend>` tag.

## Continue with a form

In the next tutorial, [Build a form that saves data]({{ site.baseurl }}/docs/first-form.html), you add a guestbook page to this layout.

[Markup inheritance]({{ site.baseurl }}/docs/markup-inheritance.html) explains how Wicket merges the markup of a page with that of its parent, [Build a reusable panel]({{ site.baseurl }}/docs/build-panel.html) shows more of what panels can do, and [Wicket tags and attributes]({{ site.baseurl }}/docs/wicket-tags.html) lists `wicket:child`, `wicket:extend` and `wicket:panel` with the other Wicket tags.
