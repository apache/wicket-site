---
title: Maven dependencies
type: reference
topic: start
summary: The Maven dependencies, versions, scopes and build settings a Wicket project needs.
since: 10
apis: [WicketTester]
keywords: [pom.xml, dependency, artifactId, groupId, version, scope, test scope, provided, snapshot repository, resources in src/main/java, HTML files not found, MarkupNotFoundException, SLF4J, Java version, Jakarta Servlet, Gradle]
order: 20
source: [helloWorld/helloWorld_1.adoc, maven/maven_1.adoc, maven/maven_2.adoc]
---

## Requirements per release line

{% if site.wicket.version_11 %}
| | Wicket 10 | Wicket 11 |
|---|---|---|
| Java | 17 or newer | 21 or newer |
| Jakarta Servlet | 5.0 or newer (built against 6.0) | 6.1 or newer |
| Spring, for `wicket-spring` | 6 (built against 6.2) | 7 (built against 7.0) |
| Jakarta CDI, for `wicket-cdi` | 4.0 | 5.0 |
| JUnit, used by `wicket-tester` | 5 | 6 |
| Latest release | {{ site.wicket.version_10 }} | {{ site.wicket.version_11 | default: "Not released yet" }} |
{% else %}
| | Wicket 10 |
|---|---|
| Java | 17 or newer |
| Jakarta Servlet | 5.0 or newer (built against 6.0) |
| Spring, for `wicket-spring` | 6 (built against 6.2) |
| Jakarta CDI, for `wicket-cdi` | 4.0 |
| JUnit, used by `wicket-tester` | 5 |
| Latest release | {{ site.wicket.version_10 }} |
{% endif %}

## Version property

Declare the Wicket version once and use it for every Wicket module:

```xml
<properties>
    <wicket.version>{{ site.wicket.version }}</wicket.version>
</properties>
```

All Wicket modules of a project must have the same version, and libraries built on Wicket, such as WicketStuff modules, must be built for the same release line.

## Dependencies

The dependency for every application:

```xml
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-core</artifactId>
    <version>${wicket.version}</version>
</dependency>
```

Other modules use the same `groupId` and `version`:

| Artifact | Scope | Add it for |
|---|---|---|
| `wicket-core` | compile | Every application. |
| `wicket-extensions` | compile | Data tables, modal dialogs, tabs, the wizard and other extra components. |
| `wicket-auth-roles` | compile | Sign-in pages and role-based authorization. |
| `wicket-bean-validation` | compile | Jakarta Bean Validation on form components. Also add a validation provider, such as Hibernate Validator. |
| `wicket-spring` | compile | Spring bean injection. |
| `wicket-cdi` | compile | CDI bean injection. |
| `wicket-guice` | compile | Guice injection. |
| `wicket-native-websocket-javax` | compile | WebSocket support on the container's Jakarta WebSocket implementation. |
| `wicket-devutils` | compile | `DebugBar` and the inspectors, in development mode. |
| `wicket-velocity` | compile | Velocity templates. |
| `wicket-jmx` | compile | JMX management of the settings. |
| `wicket-tester` | test | `WicketTester` and `FormTester`. |
| `wicket-extensions-tester` | test | Test helpers for `wicket-extensions` components. |
| `wicket-native-websocket-tester` | test | `WebSocketTester`. |

[Wicket modules]({{ site.baseurl }}/docs/modules.html) describes what each module contains.

The test dependency:

```xml
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-tester</artifactId>
    <version>${wicket.version}</version>
    <scope>test</scope>
</dependency>
```

`wicket-tester` brings JUnit Jupiter along. Since Wicket 10, `WicketTester` is no longer part of `wicket-core`; without this dependency the `org.apache.wicket.util.tester` package is missing.

## Dependencies you add yourself

| Library | Scope | Why |
|---|---|---|
| An SLF4J back end, such as `org.slf4j:slf4j-simple` or `ch.qos.logback:logback-classic` | compile or runtime | Wicket logs through the SLF4J API. Without a back end you see no log output. |
| `jakarta.servlet:jakarta.servlet-api` | provided | Only if your own code uses servlet classes. The container provides the API at run time, and `wicket-core` does not pass it on to your project. |
| `org.bouncycastle:bcprov-jdk18on` | compile | Only for AES-GCM-SIV encryption, see {% if site.wicket.version_11 %}[Encryption in Wicket]({{ site.baseurl }}/docs/crypt-schemes.html){% else %}[Configure the page store]({{ site.baseurl }}/docs/configure-page-store.html#encrypt-stored-pages){% endif %}. |
| A servlet container for development, such as Jetty | test | To start the application from your IDE, as the quickstart's `Start` class does. |

## HTML files next to the Java classes

Wicket loads the markup of a page or panel from the classpath, next to its class. Maven only copies files from `src/main/resources` to the classpath by default, so a project that keeps `HomePage.html` next to `HomePage.java` in `src/main/java` needs this in its `<build>` section:

```xml
<resources>
    <resource>
        <directory>src/main/resources</directory>
    </resource>
    <resource>
        <directory>src/main/java</directory>
        <includes>
            <include>**</include>
        </includes>
        <excludes>
            <exclude>**/*.java</exclude>
        </excludes>
    </resource>
</resources>
<testResources>
    <testResource>
        <directory>src/test/resources</directory>
    </testResource>
    <testResource>
        <directory>src/test/java</directory>
        <includes>
            <include>**</include>
        </includes>
        <excludes>
            <exclude>**/*.java</exclude>
        </excludes>
    </testResource>
</testResources>
```

Without it, the application compiles but fails at run time with a `MarkupNotFoundException`. The second half does the same for markup in the test sources, such as test pages. The alternative is to keep the HTML files in `src/main/resources`, in the same package folders as the classes.

## Snapshot versions

Builds of the next release are published as `-SNAPSHOT` versions in the Apache snapshot repository:

```xml
<repositories>
    <repository>
        <id>apache-snapshots</id>
        <url>https://repository.apache.org/content/repositories/snapshots/</url>
        <releases>
            <enabled>false</enabled>
        </releases>
        <snapshots>
            <enabled>true</enabled>
        </snapshots>
    </repository>
</repositories>
```

Releases are on Maven Central and need no repository entry.

## Gradle

Gradle uses the same coordinates, for example `implementation "org.apache.wicket:wicket-core:$wicketVersion"` and `testImplementation "org.apache.wicket:wicket-tester:$wicketVersion"`. Gradle also copies only `src/main/resources` by default; add `src/main/java` to the resources source set, excluding `**/*.java`, to keep HTML files next to the classes.
