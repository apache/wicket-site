---
layout: hub
title: Apache Wicket 1.3.x
series: "1.3"
config: version_13
java: "1.4"
servlet: Servlet 2.3 or newer
migration:
  from: "1.2"
  url: https://cwiki.apache.org/confluence/display/WICKET/Migrating+to+Wicket+1.3
status: eol
support: No longer supported
---
## Download

The most recent release in this branch is: **{{site.wicket.version_13}}**. 

You can get the release using Maven or download it manually.

### Download manually {#manually}

Use the following links to download Wicket manually to build Wicket
from source:

- Download source+bin [apache-wicket-{{site.wicket.version_13}}.tar.gz](https://archive.apache.org/dist/wicket/{{site.wicket.version_13}}/apache-wicket-{{site.wicket.version_13}}.tar.gz)
([PGP](https://archive.apache.org/dist/wicket/{{site.wicket.version_13}}/apache-wicket-{{site.wicket.version_13}}.tar.gz.asc),
[MD5](https://archive.apache.org/dist/wicket/{{site.wicket.version_13}}/apache-wicket-{{site.wicket.version_13}}.tar.gz.md5),
[SHA](https://archive.apache.org/dist/wicket/{{site.wicket.version_13}}/apache-wicket-{{site.wicket.version_13}}.tar.gz.sha)
)
- Download source+bin [apache-wicket-{{site.wicket.version_13}}.zip](https://archive.apache.org/wicket/{{site.wicket.version_13}}/apache-wicket-{{site.wicket.version_13}}.zip)
([PGP](http://archive.apache.org/dist/wicket/{{site.wicket.version_13}}/apache-wicket-{{site.wicket.version_13}}.zip.asc),
[MD5](http://archive.apache.org/dist/wicket/{{site.wicket.version_13}}/apache-wicket-{{site.wicket.version_13}}.zip.md5),
[SHA](http://archive.apache.org/dist/wicket/{{site.wicket.version_13}}/apache-wicket-{{site.wicket.version_13}}.zip.sha)
)

Note that the binary packages and the source packages don't contain any
dependencies necessary to have your project working out of the box. We
strongly urge you to use Maven (or Buildr, or Gradle) as your
dependency management system.

### Older releases

The Apache mirroring system only hosts the latest version of each actively supported branch.
When you need to download an older release you can find them in the archives.

Go to [the Apache archives](https://archive.apache.org/dist/wicket) to find your specific version.

## Requirements

Apache Wicket has few requirements in order to work properly. In this
section you'll find the minimum requirements for all Wicket modules.
Specific modules may need additional libraries, such as file upload,
date time APIs, CDI specifications, and more. See the module's POM for
more details on the necessary libraries.

### Java version

This Wicket version requires at least the following Java version: **JDK 1.4.0 or newer**.

Not only is a particular version of Java necessary, Wicket also needs
access to specific APIs.

### Servlet API

This Wicket version requires at least the following Servlet API
version: **Servlet API 2.3 or newer**. This is provided by your
container, please see the documentation of your container to see which
version of the Servlet specification is supported.

In addition to the Servlet API, Wicket uses SLF4J to let you choose
your own implementation of a logging framework.

### Don't mix Wicket versions

You cannot mix different Wicket versions in your project. You should
always use the artifacts from a particular release. For example it is
**not** possible to use Wicket Extensions 1.3 in a Wicket 1.5 project,
or Wicket Spring 1.4.19 in a Wicket 1.5 project. The same goes for 3rd
party libraries: make sure you always use a compatible version of your
3rd party library.

## Migrating from earlier versions {#migrate}

If you are migrating an existing application from earlier versions of
Wicket you may find our migration guides invaluable:

 * Migrating from [Wicket 1.2 to Wicket 1.3](https://cwiki.apache.org/confluence/display/WICKET/Migrating+to+Wicket+1.3)

