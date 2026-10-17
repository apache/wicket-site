---
title: Configure a module with an initializer
type: howto
topic: lifecycle
summary: Let a jar configure every Wicket application it is added to, with an IInitializer registered through the Java ServiceLoader.
since: 10
apis: [IInitializer, Application]
keywords: [ServiceLoader, META-INF/services, module-info, provides, library setup, plugin, auto configuration, application startup, shutdown]
order: 70
source: [advanced/advanced_4.adoc]
---

Use an initializer when you write a library of components and want it to set itself up in any application that puts the jar on its classpath: mount its resources, register listeners, add settings. Code for one application belongs in its `init()` method instead.

## Write the initializer

Implement `IInitializer`. Wicket calls `init()` when the application starts and `destroy()` when it stops:

*ChartsInitializer.java*

```java
package com.example.charts;

public class ChartsInitializer implements IInitializer {

    @Override
    public void init(Application application) {
        application.getSharedResources().add("chartData", new ChartDataResource());
        application.getComponentInstantiationListeners().add(new ChartLicenseCheck());
    }

    @Override
    public void destroy(Application application) {
        // release what init() acquired, such as threads or connections
    }

    @Override
    public String toString() {
        return "Charts library";
    }
}
```

Wicket logs each initializer it runs at info level with its `toString()`, so a readable name helps.

## Register it with the ServiceLoader

Wicket finds initializers with `java.util.ServiceLoader`. Create the file *src/main/resources/META-INF/services/org.apache.wicket.IInitializer* and put the fully qualified class name in it:

```
com.example.charts.ChartsInitializer
```

The file may list several initializers, one per line.

If your library is a Java module with a *module-info.java*, declare the service there as well:

```java
module com.example.charts {
    requires org.apache.wicket.core;
    provides org.apache.wicket.IInitializer with com.example.charts.ChartsInitializer;
}
```

## When the initializer runs

`Application.initApplication()` runs these steps in order:

1. Wicket's internal setup.
2. The `init()` method of every initializer found.
3. The application's own `init()`.

Because the application's `init()` runs last, an application can change any setting an initializer made. When the application is destroyed, Wicket calls `destroy()` on every initializer, after the application's `onDestroy()`.

Wicket uses the same mechanism for its own modules: wicket-jmx, for example, registers its MBeans from an initializer as soon as the jar is on the classpath (see [Inspect and change settings with JMX]({{ site.baseurl }}/docs/jmx.html)). Each Wicket application in a web application runs every initializer once.

Wicket does not read the *META-INF/wicket/\*.properties* files with an `initializer=` entry that older documentation describes; only the ServiceLoader registration works.
