---
title: Run on Apache Karaf
type: howto
topic: integration
summary: Install Wicket in Apache Karaf or another OSGi container with the Karaf feature that every Wicket release publishes.
since: 10
apis: []
keywords: [OSGi, bundle, Karaf feature, features.xml, "feature:install", "feature:repo-add", wicket-core feature, Karaf assembly, Pax Web]
order: 50
source: [karaf.adoc, karaf/karaf_1.adoc]
---

Use this when you deploy Wicket applications as bundles in Apache Karaf. Every Wicket jar is an OSGi bundle, and each release publishes a Karaf feature file that installs Wicket and its dependencies in one step.

Wicket uses the `jakarta.servlet` API, so the Karaf runtime needs an HTTP service that supports Jakarta Servlet.

## Install the Wicket feature

Add the feature repository of your Wicket version, with that version in place of `<version>`:

```
karaf@root()> feature:repo-add mvn:org.apache.wicket/wicket/<version>/xml/features
```

Check that the feature is available:

```
karaf@root()> feature:list | grep -i wicket
```

The list shows a feature named `wicket-core`. Install it:

```
karaf@root()> feature:install wicket-core
```

## What the feature contains

`feature:info wicket-core` lists the bundles the feature installs:

| Bundle | |
|---|---|
| `wicket-util`, `wicket-request`, `wicket-core` | The core of Wicket. |
| `wicket-extensions`, `wicket-auth-roles`, `wicket-devutils`, `wicket-jmx`, `wicket-objectsizeof-agent` | Optional Wicket modules. |
| `openjson`, `commons-io`, `commons-fileupload2-jakarta`, `commons-collections4`, `jdk-serializable-functional` | Libraries Wicket depends on. |

The feature also provides the OSGi capability `wicket;provider:=apache-wicket`, which your own features can require.

Modules outside this list, such as wicket-spring, wicket-cdi, wicket-native-websocket and wicket-bean-validation, are bundles too, but you install them and their dependencies yourself, for example in a feature of your own.

## Include Wicket in a Karaf assembly

To build a custom Karaf distribution with Wicket in it, reference the feature file as a Maven dependency of the assembly project:

```xml
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket</artifactId>
    <version>${wicket.version}</version>
    <type>xml</type>
    <classifier>features</classifier>
</dependency>
```

The [Karaf documentation on provisioning](https://karaf.apache.org/manual/latest/provisioning) describes how features and assemblies work.
