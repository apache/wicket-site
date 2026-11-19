---
title: Set up your IDE
type: howto
topic: wicket
summary: Open Wicket's source in IntelliJ IDEA, Eclipse or NetBeans, use Wicket's code format, and run tests and the examples from the IDE.
order: 30
---

This page sets up your IDE to work on Wicket itself. For IDE plugins that help you build applications with Wicket, see [Add Wicket support to your IDE]({{ site.baseurl }}/docs/ide-plugins.html) in the user guide.

Wicket is a Maven project, and every Java IDE opens it as one. Build it once on the command line first, as in [Build and test Wicket]({{ site.baseurl }}/contribute/wicket-build.html), so that the libraries are already downloaded.

## The code format

Wicket's code uses tabs for indentation, braces on their own line, and lines of at most 100 characters. The exact rules are an Eclipse formatter configuration in the repository, `wicket-eclipse-settings/files/org.eclipse.jdt.core.prefs`. The build does not check the format, so a reviewer will: format only the lines you change, and keep the rest of the file as it is. Reformatting a whole file makes your change hard to review.

## IntelliJ IDEA

IntelliJ IDEA Community Edition is enough.

1. Choose **File → Open**, select the `wicket` folder of your clone and open it as a project. IntelliJ reads the Maven modules, which takes a few minutes the first time.
2. In **File → Project Structure → Project**, set the SDK to JDK 21.
3. For the code format, install the plugin **Adapter for Eclipse Code Formatter** from **Settings → Plugins → Marketplace**. In its settings, choose to use the Eclipse code formatter with the configuration file `wicket-eclipse-settings/files/org.eclipse.jdt.core.prefs` from your clone.
4. In **Settings → Editor → Code Style → Java → Imports**, set **Class count to use import with '\*'** to 99, so that IntelliJ writes one import per class, as Wicket's code does.

To format only your changes, use **Code → Reformat Code** with **Only changes uncommitted to VCS**.

### Run a test

Open the test class and click the green arrow next to the class or a method. IntelliJ compiles the modules of the project from your working folder, so a change in `wicket-request` is used by a test in `wicket-core-tests` without installing it first. Run the test with Maven as well before you send the pull request, as in [Run one test]({{ site.baseurl }}/contribute/wicket-build.html#run-one-test): that is how GitHub runs it.

### Run the examples {#examples}

Open `wicket-examples/src/test/java/org/apache/wicket/examples/StartExamples.java` and run its `main` method. It starts the examples on <http://localhost:8080>, with your code from the working folder. The working directory of the run configuration must be the `wicket-examples` folder, which is the default; if the examples show only errors about missing files, check it under **Run → Edit Configurations**.

## Eclipse

Use the Eclipse IDE for Java Developers or for Enterprise Java, which include Maven support.

1. Before you import, install **M2E Settings** from the Eclipse Marketplace (**Help → Eclipse Marketplace**). It applies Wicket's code format to every module while they are imported.
2. Choose **File → Import → Maven → Existing Maven Projects**, select the `wicket` folder of your clone, and import all projects.
3. Set a JDK 21 as installed JRE under **Window → Preferences → Java → Installed JREs**.

To format only your changes, set **Window → Preferences → Java → Editor → Save Actions** to format edited lines.

Run a test with **Run As → JUnit Test** on the test class, and the examples with **Run As → Java Application** on `StartExamples` in the `wicket-examples` project.

## NetBeans

NetBeans opens Maven projects directly: **File → Open Project** and select the `wicket` folder. NetBeans cannot read Eclipse formatter files, so set the format by hand under **Tools → Options → Editor → Formatting** for Java: tabs with a size of 4, braces on a new line, and a right margin of 100.
