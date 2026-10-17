---
title: Create a project from the quickstart archetype
type: howto
topic: start
summary: Generate a ready-to-run Wicket project with Maven, know what is in it, and open it in your IDE.
since: 10
apis: [WebApplication, WicketFilter, WicketTester]
keywords: [new project, archetype, mvn archetype:generate, quickstart, Maven, skeleton, scaffold, Eclipse, IntelliJ IDEA, NetBeans, VS Code, Jetty, Start class]
order: 10
source: [maven/maven_2.adoc]
---

Use the quickstart archetype when you start a new Wicket application or need a small project to reproduce a bug. It gives you a Maven project with an application class, a home page, a test and an embedded Jetty server.

## Generate the project

Run the archetype with the Maven coordinates of your project. The `groupId` also becomes the Java package:

```shell
mvn archetype:generate \
  -DarchetypeGroupId=org.apache.wicket \
  -DarchetypeArtifactId=wicket-archetype-quickstart \
  -DarchetypeVersion={{ site.wicket.version }} \
  -DgroupId=com.mycompany \
  -DartifactId=myproject \
  -DinteractiveMode=false
```

Set `archetypeVersion` to the Wicket version you build on: {% if site.wicket.version_11 %}{{ site.wicket.version_11 }} for Wicket 11, which needs Java 21, or {% endif %}{{ site.wicket.version_10 }} for Wicket 10, which needs Java 17. To try an unreleased `-SNAPSHOT` version, Maven must know the Apache snapshot repository: add it to a profile in your `~/.m2/settings.xml`, as described under [snapshot versions]({{ site.baseurl }}/docs/maven-setup.html#snapshot-versions).

## What the project contains

Maven creates a folder named after the `artifactId`:

| File | What it is |
|---|---|
| `pom.xml` | Dependencies on `wicket-core` and `wicket-native-websocket-javax`, an SLF4J logger, and `wicket-tester`, JUnit and Jetty for tests. It also copies the HTML files in `src/main/java` into the build. |
| `src/main/java/.../WicketApplication.java` | The application class: home page and configuration in `init()`. It adds the application's own stylesheets and Google Fonts to the content security policy. |
| `src/main/java/.../HomePage.java` and `HomePage.html` | The home page, a class and its markup side by side. |
| `src/main/webapp/WEB-INF/web.xml` | Registers `WicketFilter` for all URLs and names the application class. |
| `src/main/webapp/style.css`, `logo.png` | Static files the home page uses. |
| `src/test/java/.../Start.java` | Starts Jetty with the application on port 8080, and on 8443 with HTTPS. |
| `src/test/java/.../TestHomePage.java` | A `WicketTester` test that renders the home page. |
| `src/test/jetty/*.xml`, `src/test/resources/keystore` | Jetty configuration and a self-signed certificate for HTTPS on your machine. |

`Start` and Jetty live in the test sources, so they are not packaged in the WAR file that `mvn package` builds.

## Open it in your IDE

All current Java IDEs import Maven projects directly:

- **IntelliJ IDEA**: choose File, Open, and select the project folder or its `pom.xml`.
- **Eclipse**: choose File, Import, Existing Maven Projects, and select the project folder.
- **NetBeans**: choose File, Open Project, and select the project folder.
- **VS Code** with the Java extensions: open the project folder.

A Wicket plugin lets IntelliJ IDEA and Eclipse jump between a component and its markup; see [Add Wicket support to your IDE]({{ site.baseurl }}/docs/ide-plugins.html).

## Run it

Run the `main` method of `Start` from your IDE, then open <http://localhost:8080>. The application runs in development mode, which `Start` sets with the system property `wicket.configuration`.

Run the generated test with:

```shell
mvn test
```

Build a WAR file for an application server with `mvn package`. Before you deploy it, [switch to deployment mode]({{ site.baseurl }}/docs/deployment-mode.html).

## Adjust the generated project

- Uncomment `wicket-extensions` in *pom.xml* when you need its components, such as data tables, modal dialogs or tabs. [Wicket modules]({{ site.baseurl }}/docs/modules.html) lists what each module offers, and [Maven dependencies]({{ site.baseurl }}/docs/maven-setup.html) shows the dependency for each.
- Replace `slf4j-simple` with the logging back end your organization uses.
- The content security policy in `init()` allows Google Fonts only because the generated home page uses them. When you replace the page, remove the two Google entries, but keep `STYLE_SRC` with `SELF` as long as your pages load stylesheets such as `style.css` from the application. See [Configure the Content Security Policy]({{ site.baseurl }}/docs/csp.html).

For a step-by-step walk through the generated project, follow the tutorial [Build your first application]({{ site.baseurl }}/docs/first-application.html).
