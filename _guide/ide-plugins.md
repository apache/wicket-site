---
title: Add Wicket support to your IDE
type: howto
topic: start
summary: Install WicketForge in IntelliJ IDEA or QWickie in Eclipse to jump between Java and markup and complete wicket:id values.
since: 10
keywords: [IDE, plugin, IntelliJ IDEA, Eclipse, WicketForge, QWickie, WicketLambdaFold, NetBeans, VS Code, navigate to markup, wicket:id completion, editor support]
order: 30
---

Every Wicket component in Java has a partner element in HTML, joined by its `wicket:id`. Any Java IDE edits both files, but it does not know they belong together. A Wicket plugin does: it takes you from a component to its markup and back, and completes `wicket:id` values while you type. The plugins are written and maintained by their own teams, not by the Wicket project, so report a problem with a plugin in its own issue tracker.

## IntelliJ IDEA: WicketForge

[WicketForge](https://plugins.jetbrains.com/plugin/1545-wicketforge) adds code completion, inspections and navigation for Wicket to IntelliJ IDEA.

1. Open Settings, Plugins, and the Marketplace tab.
2. Search for **WicketForge** and choose Install.
3. Restart the IDE when it asks.

With the plugin installed you can:

- switch between a page or panel class and its HTML file;
- go from a component in Java to its `wicket:id` in the markup, and from a `wicket:id` to the component that renders it;
- complete `wicket:id` values in Java and in HTML;
- create a page or panel together with its markup file;
- complete and extract keys in the component's properties files.

The [WicketForge wiki](https://github.com/wicketforge/wicketforge/wiki) describes each feature and its shortcut. Report problems in the [WicketForge issues](https://github.com/wicketforge/wicketforge/issues).

### Shorter lambda models: WicketLambdaFold

[WicketLambdaFold](https://plugins.jetbrains.com/plugin/9444-wicketlambdafold) folds the getter and setter references of a lambda model in the editor, so a line like `LambdaModel.of(model, Person::getName, Person::setName)` reads as the property it binds. It changes only how the code is shown, not the code itself. Install it from the Marketplace tab the same way.

## Eclipse: QWickie

[QWickie](https://marketplace.eclipse.org/content/qwickie) adds Wicket navigation and code assist to Eclipse. It needs the HTML editor of the Eclipse Web Tools Platform, which the Eclipse IDE for Enterprise Java and Web Developers already contains.

1. Choose Help, Eclipse Marketplace.
2. Search for **qwickie** and choose Install.
3. Restart Eclipse when it asks.

Without the Marketplace client, choose Help, Install New Software, and add the update site `https://raw.githubusercontent.com/count-negative/qwickie/master/qwickie.updatesite/site.xml`.

With the plugin installed you can:

- jump from a `wicket:id` in Java to the element in the HTML file, and see that HTML fragment when you hover over the component;
- jump from a `wicket:message` key to its properties file;
- complete `wicket:id` values in Java with Ctrl+1;
- rename the HTML and properties files along with a page or panel class;
- create a new page with a wizard.

Report problems in the [QWickie issues](https://github.com/count-negative/qwickie/issues).

## NetBeans and VS Code

There is no maintained Wicket plugin for NetBeans or VS Code. Wicket does not need one: a page is a Java class and an HTML file, and the Java support of either IDE handles both. Keep the HTML file next to its class, as [the quickstart project]({{ site.baseurl }}/docs/create-project.html#open-it-in-your-ide) does, and the IDE shows the pair together in the project tree.
