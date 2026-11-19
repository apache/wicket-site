---
title: Set up your IDE
type: howto
topic: wicket
summary: Open Wicket's source in IntelliJ IDEA, Eclipse, VS Code or NetBeans, keep its hand-made format, and run tests and the examples from the IDE.
order: 40
---

This page sets up your IDE to work on Wicket itself. For IDE plugins that help you build applications with Wicket, see [Add Wicket support to your IDE]({{ site.baseurl }}/docs/ide-plugins.html) in the user guide.

Wicket is a Maven project, and every Java IDE opens it as one. Open the root folder of your clone, so that the IDE sees all modules. Build once on the command line first, as in [Build and test Wicket]({{ site.baseurl }}/contribute/wicket-build.html), so that the libraries are already downloaded.

## The code format

Wicket's code uses tabs for indentation, braces on their own line, and lines of at most 100 characters. Set your IDE's Java formatter to these three rules. The exact Eclipse formatter settings are in the repository, in `wicket-eclipse-settings/files/org.eclipse.jdt.core.prefs`, but no IDE picks them up by itself.

The code is formatted by hand, and no formatter reproduces it exactly. So:

- Turn off formatting on save.
- Never reformat a whole file. Format only the lines you write, or match the code around them by hand.

A reformatted file shows hundreds of changed lines in the pull request, and the reviewer cannot find your change between them. It also makes the commit hard to cherry-pick to the older branches, where the same lines look different.

## Do tests from the IDE need an install?

Running a test with Maven needs an `mvn install` of the module you changed first, when the test is in another module; [Why most tests live in another module]({{ site.baseurl }}/contribute/wicket-test-modules.html) explains why. In the IDE it depends on how the IDE builds:

| IDE | Install first? |
|---|---|
| IntelliJ IDEA | No. It compiles the other modules from your working folder. |
| Eclipse | No. Its Maven support resolves the other modules from the workspace. |
| VS Code | No. Its Java language server resolves the other modules from source. |
| NetBeans | Probably yes. NetBeans builds through Maven, so a test may use the installed jar of another module. Install the changed module to be sure. |

Before you send a pull request, run the tests with Maven anyway, as in [Run one test]({{ site.baseurl }}/contribute/wicket-build.html#run-one-test): that is how GitHub runs them.

## IntelliJ IDEA

IntelliJ IDEA Community Edition is enough.

1. Choose **File → Open**, select the `wicket` folder of your clone and open it as a project. IntelliJ reads the Maven modules, which takes a few minutes the first time.
2. In **File → Project Structure → Project**, set the SDK to the JDK you build with.
3. In **Settings → Editor → Code Style → Java**, set **Tabs and Indents** to use the tab character with size 4, **Wrapping and Braces** to put braces on the next line and the hard wrap at 100, and in **Imports**, **Class count to use import with '\*'** to 99.
4. In **Settings → Tools → Actions on Save**, leave **Reformat code** off.

The plugin **Adapter for Eclipse Code Formatter** can use `org.eclipse.jdt.core.prefs` instead of step 3. It still reformats whatever you ask it to, so the rules above apply.

Run a test with the green arrow next to the class or a method. To run the examples, open `wicket-examples/src/test/java/org/apache/wicket/examples/StartExamples.java` and run its `main` method; it starts the examples on <http://localhost:8080>. The working directory of the run configuration must be the `wicket-examples` folder, the default. If the examples show only errors about missing files, check it under **Run → Edit Configurations**.

## Eclipse

Use the Eclipse IDE for Java Developers or for Enterprise Java, which include Maven support.

1. Choose **File → Import → Maven → Existing Maven Projects**, select the `wicket` folder of your clone, and import all projects. Every module becomes a project.
2. Add the JDK you build with under **Window → Preferences → Java → Installed JREs**.
3. Under **Window → Preferences → Java → Code Style → Formatter**, create a profile with tab indentation of size 4, braces on the next line, and a maximum line width of 100.
4. Under **Window → Preferences → Java → Editor → Save Actions**, leave **Perform the selected actions on save** off.

Run a test with **Run As → JUnit Test** on the test class. **Run As → Java Application** on `StartExamples` in the `wicket-examples` project starts the examples; Eclipse uses the project folder as working directory.

## VS Code

1. Install the **Extension Pack for Java** from the Extensions view.
2. Choose **File → Open Folder** and open the `wicket` folder of your clone. The Java extension reads the Maven modules, which takes a few minutes the first time.
3. Make sure **Editor: Format On Save** is off in the settings.

Run tests from the Testing view or with the run icon next to a test.

A Java program in VS Code starts in the root folder, but `StartExamples` needs `wicket-examples` as working directory. Create `.vscode/launch.json` in the root folder of your clone with this content, and start **StartExamples** from the **Run and Debug** view:

```json
{
	"version": "0.2.0",
	"configurations": [
		{
			"type": "java",
			"name": "StartExamples",
			"request": "launch",
			"mainClass": "org.apache.wicket.examples.StartExamples",
			"projectName": "wicket-examples",
			"cwd": "${workspaceFolder}/wicket-examples"
		}
	]
}
```

Git ignores the `.vscode` folder in the Wicket repository, so the file stays on your computer.

## NetBeans

Choose **File → Open Project**, select the `wicket` folder of your clone and check **Open Required Projects**. Set the format under **Tools → Options → Editor → Formatting** for Java: tabs with a size of 4, braces on a new line, and a right margin of 100.

Run a test with **Test File** and the examples with **Run File** on `StartExamples`. Install the modules you changed first, as in the table above.
