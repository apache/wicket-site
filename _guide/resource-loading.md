---
title: Customize where resources are loaded from
type: howto
topic: resources
summary: Make Wicket find markup, properties and package files in a folder of the web application or the file system by adding resource finders.
since: 10
apis: [ResourceSettings, IResourceFinder, WebApplicationPath, Path, ClassPathResourceFinder, IResourceStreamLocator, ResourceStreamLocator, CachingResourceStreamLocator]
keywords: [markup folder, separate markup, html outside classpath, resource finder, getResourceFinders, sourceFolder, markup reload, templates folder, theme folder, resource locator]
order: 120
source: [resources/resources_14.adoc]
---

Add a resource finder when markup files, properties files or package resources should live somewhere other than next to the classes, for example in a folder that designers edit or that a theme replaces.

## Where Wicket looks by default

Wicket looks up a file such as `com/example/HomePage.html` with a list of resource finders, in order, and takes the first match:

1. the classpath, `ClassPathResourceFinder("")`;
2. the root of the web application, `WebApplicationPath(servletContext, "")`;
3. `META-INF/resources/` on the classpath, `ClassPathResourceFinder("META-INF/resources/")`.

In a Maven project, files under `src/main/resources` end up on the classpath, so `src/main/resources/com/example/HomePage.html` is found by the first finder without configuration.

## Add a folder in the web application

Create a `WebApplicationPath` for the folder and add it to the list in `init()`. The folder must repeat the package structure:

```
src/main/webapp/
    markup/
        com/example/
            HomePage.html
            HomePage.properties
```

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();
    getResourceSettings().getResourceFinders()
        .add(0, new WebApplicationPath(getServletContext(), "markup"));
}
```

Adding at index 0 makes the folder win over a file with the same name on the classpath, so a folder can override the markup of a component. Use `add(finder)` instead to search the folder only when the classpath has no match. `WebApplicationPath` never loads files under `WEB-INF`.

Everything Wicket looks up by class and name goes through these finders: markup, properties files and package resources such as CSS and images. The package resource guard still decides which package files found in a folder are served, see [Control which package resources are served]({{ site.baseurl }}/docs/package-resource-guard.html).

## Add a folder on the file system

`Path` searches a folder on disk. The folder must exist when the application starts:

```java
getResourceSettings().getResourceFinders()
    .add(0, new Path("/srv/example/templates"));
```

During development, a `Path` at index 0 that points at your source folder makes edits to markup show up without a rebuild: in development mode Wicket checks loaded markup files for changes every second and reloads them.

```java
if (usesDevelopmentConfig()) {
    getResourceSettings().getResourceFinders()
        .add(0, new Path("/home/me/projects/example/src/main/java"));
}
```

The `sourceFolder` init parameter of the Wicket filter also adds a `Path` in development mode, but at the end of the list, so it only finds files that are not on the classpath.

## Write your own finder

`IResourceFinder` has one method, `find(Class<?> clazz, String pathname)`, which returns an `IResourceStream` or `null`. Implement it to load files from a database or a remote store, and add it to the list like the finders above.

To replace the lookup as a whole, including the way locale, style and variation are combined into file names, set an `IResourceStreamLocator` with `getResourceSettings().setResourceStreamLocator(…)`. Wrap your locator in a `CachingResourceStreamLocator`, as Wicket does with its own, or every lookup goes to your source again. [Where Wicket looks for texts]({{ site.baseurl }}/docs/bundle-lookup.html) shows how locale and style become part of the names that the finders receive.
