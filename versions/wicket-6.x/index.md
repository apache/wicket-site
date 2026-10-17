---
layout: hub
title: Apache Wicket 6.x
series: "6"
config: version_60
java: "6"
servlet: Servlet 2.5 or newer
migration:
  from: "1.5"
  url: https://cwiki.apache.org/confluence/display/WICKET/Migration+to+Wicket+6.0
status: eol
support: No longer supported
---
## Download

The most recent release in this branch is: **{{site.wicket.version_60}}**. 

You can get the release using Maven or download it manually.

### Download manually {#manually}

Use the following links to download Wicket manually to build Wicket
from source:

- Download source [apache-wicket-{{site.wicket.version_60}}.tar.gz](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_60}}/apache-wicket-{{site.wicket.version_60}}.tar.gz)
([PGP](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/apache-wicket-{{site.wicket.version_60}}.tar.gz.asc),
[MD5](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/apache-wicket-{{site.wicket.version_60}}.tar.gz.md5),
[SHA](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/apache-wicket-{{site.wicket.version_60}}.tar.gz.sha)
)
- Download source [apache-wicket-{{site.wicket.version_60}}.zip](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_60}}/apache-wicket-{{site.wicket.version_60}}.zip)
([PGP](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/apache-wicket-{{site.wicket.version_60}}.zip.asc),
[MD5](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/apache-wicket-{{site.wicket.version_60}}.zip.md5),
[SHA](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/apache-wicket-{{site.wicket.version_60}}.zip.sha)
)

Or use the following links to get the pre-packaged binaries instead:

- Download binaries [apache-wicket-{{site.wicket.version_60}}-bin.tar.gz](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_60}}/binaries/apache-wicket-{{site.wicket.version_60}}-bin.tar.gz)
([PGP](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/binaries/apache-wicket-{{site.wicket.version_60}}-bin.tar.gz.asc),
[MD5](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/binaries/apache-wicket-{{site.wicket.version_60}}-bin.tar.gz.md5),
[SHA](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/binaries/apache-wicket-{{site.wicket.version_60}}-bin.tar.gz.sha)
)
- Download binaries [apache-wicket-{{site.wicket.version_60}}-bin.zip](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_60}}/binaries/apache-wicket-{{site.wicket.version_60}}-bin.zip)
([PGP](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/binaries/apache-wicket-{{site.wicket.version_60}}-bin.zip.asc),
[MD5](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/binaries/apache-wicket-{{site.wicket.version_60}}-bin.zip.md5),
[SHA](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/binaries/apache-wicket-{{site.wicket.version_60}}-bin.zip.sha)
)

Note that the binary packages and the source packages don't contain any
dependencies necessary to have your project working out of the box. We
strongly urge you to use Maven (or Buildr, or Gradle) as your
dependency management system.

### Older releases

The Apache mirroring system only hosts the latest version of each actively supported branch.
When you need to download an older release you can find them in the archives.

Go to [the Apache archives](https://archive.apache.org/dist/wicket) to find your specific version.

### Change log

To see what changed in this release (and prior releases) you can read
the [change log](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/CHANGELOG-6.x).

## Requirements

Apache Wicket has few requirements in order to work properly. In this
section you'll find the minimum requirements for all Wicket modules.
Specific modules may need additional libraries, such as file upload,
date time APIs, CDI specifications, and more. See the module's POM for
more details on the necessary libraries.

### Java version

This Wicket version requires at least the following Java version: **JDK 6.0 or newer**.

Not only is a particular version of Java necessary, Wicket also needs
access to specific APIs.

### Servlet API

This Wicket version requires at least the following Servlet API
version: **Servlet API 2.5 or newer**. This is provided by your
container, please see the documentation of your container to see which
version of the Servlet specification is supported.

In addition to the Servlet API, Wicket uses SLF4J to let you choose
your own implementation of a logging framework.

### Logging

You cannot use Wicket without adding an SLF4J logging implementation to
your classpath. Most people use
[log4j](http://logging.apache.org/log4j).

If you do, just include **slf4j-log4j12.jar** on your classpath to get
Wicket to use log4j too. If you want to use commons-logging or JDK14
logging or something else, please see the [SLF4J site](http://www.slf4j.org/faq.html)
for more information.

### Don't mix Wicket versions

You cannot mix different Wicket versions in your project. You should
always use the artifacts from a particular release. For example it is
**not** possible to use Wicket Extensions 1.5 in a Wicket 6 project, or
Wicket CDI 6.19 in a Wicket 7 project. The same goes for 3rd party
libraries: make sure you always use a compatible version of your 3rd
party library.

## Migrating from earlier versions {#migrate}

If you are migrating an existing application from earlier versions of
Wicket you may find our migration guides invaluable:

 * Migrating from [Wicket 1.2 to Wicket 1.3](https://cwiki.apache.org/confluence/display/WICKET/Migrating+to+Wicket+1.3)
 * Migrating from [Wicket 1.3 to Wicket 1.4](https://cwiki.apache.org/confluence/display/WICKET/Migrating+to+Wicket+1.4)
 * Migrating from [Wicket 1.4 to Wicket 1.5](https://cwiki.apache.org/confluence/display/WICKET/Migration+to+Wicket+1.5)
 * Migrating from [Wicket 1.5 to Wicket 6.x](https://cwiki.apache.org/confluence/display/WICKET/Migration+to+Wicket+6.0)

