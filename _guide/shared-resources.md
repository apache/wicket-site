---
title: Share a resource across the application
type: howto
topic: resources
summary: Register a resource once under an application-wide key with getSharedResources and refer to it from any component with SharedResourceReference.
since: 10
apis: [SharedResources, SharedResourceReference, Application, ResourceLink]
keywords: [shared resource, global resource, application scope, register resource, getSharedResources, resource key, wicket/resource/org.apache.wicket.Application]
order: 110
source: [resources/resources_13.adoc]
---

Register a shared resource when one resource instance should serve the whole application under a fixed key, and components that link to it should not need a reference to the instance. If you want a readable URL instead, mount it: [Give a resource a URL]({{ site.baseurl }}/docs/mount-resources.html).

## Register the resource

Add the resource to the shared resources in `init()`, under a name:

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();
    getSharedResources().add("ordersCsv", new OrdersCsvResource());
}
```

`OrdersCsvResource` is the resource from [Generate a resource in code]({{ site.baseurl }}/docs/custom-resources.html).

## Refer to it by name

Anywhere in the application, a `SharedResourceReference` with the same name finds the registered resource:

```java
add(new ResourceLink<Void>("export", new SharedResourceReference("ordersCsv")));
```

The link renders a URL with the scope and the name:

```
./wicket/resource/org.apache.wicket.Application/ordersCsv
```

The scope of resources added by name alone is `Application`. A name that is not registered gives a 404 response when the URL is requested, so register shared resources before the first request, in `init()`.

To get the URL as text, use `RequestCycle.get().urlFor(new SharedResourceReference("ordersCsv"), null)`.

## Scope a shared resource to a class

Pass a class to keep names apart, for example in a library that registers resources from an `IInitializer`:

```java
getSharedResources().add(ReportsModule.class, "summary", null, null, null, new SummaryResource());
```

```java
new SharedResourceReference(ReportsModule.class, "summary")
```

The three `null` arguments are the locale, style and variation, which are part of the key. [Configure a module with an initializer]({{ site.baseurl }}/docs/initializers.html) shows where a library runs such code.

## Keep the resource safe for concurrent use

There is one instance for all users and all requests, and requests run in parallel. Do not keep request or user data in fields of the resource; read what you need from the request, the session or a service while it responds.

Package resources are shared resources too, without registration: Wicket finds them by their class and file name. Register only resources that you create in code.
