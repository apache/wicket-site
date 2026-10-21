---
title: Build your first application
type: tutorial
topic: start
summary: Generate a project from the quickstart, run it, and build a home page with a label, a click counter and a link to a second page.
since: 10
apis: [WebApplication, WebPage, Label, Link]
keywords: [hello world, getting started, quickstart, archetype, wicket:id, first page, Jetty, Start class, setResponsePage]
order: 10
source: [introduction.adoc, howToSource.adoc, helloWorld/helloWorld_1.adoc, helloWorld/helloWorld_2.adoc, helloWorld/helloWorld_3.adoc, helloWorld/helloWorld_4.adoc, helloWorld/helloWorld_5.adoc, maven/maven_2.adoc]
---

In this tutorial you create a Wicket application and write its home page: a greeting, the time on the server, a link that counts your clicks, and a link to a second page. The tutorials after this one continue with the same application.

You need a JDK ({% if site.wicket.version_11 %}Java 17 or newer for Wicket 10, Java 21 or newer for Wicket 11{% else %}Java 17 or newer{% endif %}), Apache Maven, and an IDE that opens Maven projects.

## 1. Generate the project

Open a terminal in the folder where you keep your projects and run the quickstart archetype:

```shell
mvn archetype:generate \
  -DarchetypeGroupId=org.apache.wicket \
  -DarchetypeArtifactId=wicket-archetype-quickstart \
  -DarchetypeVersion={{ site.wicket.version }} \
  -DgroupId=com.example \
  -DartifactId=myapp \
  -DinteractiveMode=false
```

To build on Wicket 10, use `-DarchetypeVersion={{ site.wicket.version_10 }}` instead. The [quickstart page]({{ site.baseurl }}/start/quickstart.html) on this site builds the same command for you.

Maven creates a folder `myapp`. These are the files you work with:

```
myapp
├── pom.xml
└── src
    ├── main
    │   ├── java/com/example
    │   │   ├── HomePage.html
    │   │   ├── HomePage.java
    │   │   └── WicketApplication.java
    │   └── webapp
    │       ├── WEB-INF/web.xml
    │       ├── logo.png
    │       └── style.css
    └── test
        └── java/com/example
            ├── Start.java
            └── TestHomePage.java
```

## 2. Run the application

Open the `myapp` folder in your IDE as a Maven project. Then run the class `Start` in `src/test/java/com/example`: it has a `main` method that starts an embedded Jetty server with your application.

Open <http://localhost:8080> in your browser. You see a page that starts with "Congratulations!". The console shows a warning that Wicket runs in development mode, which is what you want while you build the application.

Leave the server running. After each change to a Java file in the steps below, stop `Start`, run it again and reload the page.

## 3. Find the three parts of the page

The home page you just saw comes from three files.

*WicketApplication.java* is the application class. Its `getHomePage()` method tells Wicket which page to show at the root URL, and its `init()` method is where you configure the application:

```java
public class WicketApplication extends WebApplication {
    @Override
    public Class<? extends WebPage> getHomePage() {
        return HomePage.class;
    }

    @Override
    public void init() {
        super.init();
        // configuration goes here
    }
}
```

The file `WEB-INF/web.xml` registers Wicket's servlet filter, `WicketFilter`, and passes it the name of this class.

*HomePage.java* and *HomePage.html* are the page. A page is a Java class with an HTML file of the same name in the same package. Look for `wicket:id="version"` in the HTML and for `new Label("version", ...)` in the Java class: the `wicket:id` attribute ties the tag to the component with the same id.

## 4. Write your own home page

Replace the content of *HomePage.java*:

```java
package com.example;

import org.apache.wicket.markup.html.WebPage;
import org.apache.wicket.markup.html.basic.Label;

public class HomePage extends WebPage {
    public HomePage() {
        add(new Label("greeting", "Hello, Wicket!"));
    }
}
```

And replace *HomePage.html*:

```html
<!DOCTYPE html>
<html xmlns:wicket="http://wicket.apache.org">
<head>
    <meta charset="utf-8">
    <title>My App</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div id="bd">
        <h2 wicket:id="greeting">Greeting goes here</h2>
    </div>
</body>
</html>
```

Restart `Start` and reload the page. It shows "Hello, Wicket!" in a heading. The `Label` component replaced the text between the `<h2>` tags with its own text. The placeholder text is only there for when you open the HTML file directly in a browser or an editor.

Try a typo: change the `wicket:id` in the HTML to `greting` and reload. Wicket shows an error page saying that it cannot find a component for that id. Change it back.

## 5. Show a value that changes

A label can also take a lambda instead of a fixed text. Wicket calls the lambda every time it renders the page. Add a label with the time on the server to the constructor of *HomePage.java*:

```java
add(new Label("time",
        () -> LocalTime.now().format(DateTimeFormatter.ofPattern("HH:mm:ss"))));
```

Import `java.time.LocalTime` and `java.time.format.DateTimeFormatter`. Add the tag for it to *HomePage.html*, below the heading:

```html
<p>The time on the server is <span wicket:id="time">12:00:00</span>.</p>
```

Restart and reload a few times. The time changes on every reload. The lambda is a model: the object a component asks for its value.

## 6. Count clicks with a link

A Wicket `Link` does not point to a file. It calls its `onClick()` method on the server when you click it, and then Wicket renders the page again.

Add a field and two components to *HomePage.java*:

```java
public class HomePage extends WebPage {
    private int clicks;

    public HomePage() {
        add(new Label("greeting", "Hello, Wicket!"));
        add(new Label("time",
                () -> LocalTime.now().format(DateTimeFormatter.ofPattern("HH:mm:ss"))));

        add(new Link<Void>("count") {
            @Override
            public void onClick() {
                clicks++;
            }
        });
        add(new Label("clicks", () -> clicks));
    }
}
```

Import `org.apache.wicket.markup.html.link.Link`. In *HomePage.html*, add:

```html
<p><a wicket:id="count">Click me</a>. You clicked <span wicket:id="clicks">0</span> times.</p>
```

Restart, reload and click the link a few times. The number goes up. The field `clicks` keeps its value between requests because Wicket keeps the page object for you, and the address in the browser now has a number after the question mark that identifies that page object.

## 7. Add a second page

Create *AboutPage.java* next to `HomePage`:

```java
package com.example;

import org.apache.wicket.markup.html.WebPage;
import org.apache.wicket.markup.html.link.Link;

public class AboutPage extends WebPage {
    public AboutPage() {
        add(new Link<Void>("home") {
            @Override
            public void onClick() {
                setResponsePage(HomePage.class);
            }
        });
    }
}
```

Create *AboutPage.html* in the same package:

```html
<!DOCTYPE html>
<html xmlns:wicket="http://wicket.apache.org">
<head>
    <meta charset="utf-8">
    <title>About</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div id="bd">
        <h2>About this application</h2>
        <p>It was built with Apache Wicket.</p>
        <p><a wicket:id="home">Back to the home page</a></p>
    </div>
</body>
</html>
```

`setResponsePage(HomePage.class)` tells Wicket which page to show after the click. Add a link to the new page in the constructor of `HomePage`:

```java
add(new Link<Void>("about") {
    @Override
    public void onClick() {
        setResponsePage(AboutPage.class);
    }
});
```

And in *HomePage.html*:

```html
<p><a wicket:id="about">About this application</a></p>
```

Restart and reload. Click through to the about page and back. The counter on the home page starts at zero again, because `setResponsePage(HomePage.class)` creates a new `HomePage` object.

You now have an application with two pages, a component that shows a computed value and a link that changes the state of its page.

## Continue with a shared layout

Both pages repeat the same `<head>` and the same frame around their content. In the next tutorial, [Give every page the same layout]({{ site.baseurl }}/docs/page-layout.html), you move that into one base page.

To understand what you built: [Why component-oriented]({{ site.baseurl }}/docs/why-wicket.html) explains the idea behind pages and components, [What models are for]({{ site.baseurl }}/docs/about-models.html) explains the lambda you gave the labels, and [Stateful and stateless pages]({{ site.baseurl }}/docs/stateful-stateless.html) explains why the counter keeps its value. Before you put the application on a server, [switch it to deployment mode]({{ site.baseurl }}/docs/deployment-mode.html).
