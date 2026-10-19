---
layout: hub
title: Apache Wicket 1.4.x
series: "1.4"
config: version_14
java: "5"
servlet: Servlet 2.3 or newer
migration:
  from: "1.3"
  url: https://cwiki.apache.org/confluence/display/WICKET/Migrating+to+Wicket+1.4
status: eol
support: No longer supported
---
## Download

### Download manually {#manually}

Use the following links to download Wicket manually to build Wicket
from source:

- Download source [apache-wicket-{{site.wicket.version_14}}.tar.gz](https://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_14}}/apache-wicket-{{site.wicket.version_14}}-source.tgz)
([PGP](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}-source.tgz.asc),
[MD5](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}-source.tgz.md5),
[SHA](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}-source.tgz.sha)
)

Or use the following links to get the pre-packaged binaries instead:

- Download binaries [apache-wicket-{{site.wicket.version_14}}-bin.tar.gz](https://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.tar.gz)
([PGP](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.tar.gz.asc),
[MD5](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.tar.gz.md5),
[SHA](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.tar.gz.sha)
)
- Download binaries [apache-wicket-{{site.wicket.version_14}}-bin.zip](https://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.zip)
([PGP](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.zip.asc),
[MD5](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.zip.md5),
[SHA](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.zip.sha)
)

Note that the binary packages and the source packages don't contain any
dependencies necessary to have your project working out of the box. We
strongly urge you to use Maven or Gradle as your dependency management system.

### Older releases

The Apache mirroring system only hosts the latest version of each actively supported branch.
When you need to download an older release you can find them in the archives.

Go to [the Apache archives](https://archive.apache.org/dist/wicket) to find your specific version.

### Change log

To see what changed in this release (and prior releases) you can read
the [change log](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/CHANGELOG-1.4).

## Requirements

The Java and Servlet API versions this line needs are at the [top of the page](#status).
Specific modules may need additional libraries, such as file upload,
date time APIs, CDI specifications, and more. See the module's POM for
more details on the necessary libraries.

### Logging

You cannot use Wicket without adding an SLF4J logging implementation to
your classpath. The [SLF4J manual](https://www.slf4j.org/manual.html) lists them.

### Don't mix Wicket versions

You cannot mix different Wicket versions in your project. You should
always use the artifacts from a particular release. For example it is
**not** possible to use Wicket Extensions 1.3 in a Wicket 1.5 project,
or Wicket Spring 1.4.19 in a Wicket 1.5 project. The same goes for 3rd
party libraries: make sure you always use a compatible version of your
3rd party library.
