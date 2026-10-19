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

### Download manually {#manually}

Use the following links to download Wicket manually to build Wicket
from source:

- Download source [apache-wicket-{{site.wicket.version_60}}.tar.gz](https://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_60}}/apache-wicket-{{site.wicket.version_60}}.tar.gz)
([PGP](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/apache-wicket-{{site.wicket.version_60}}.tar.gz.asc),
[MD5](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/apache-wicket-{{site.wicket.version_60}}.tar.gz.md5),
[SHA](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/apache-wicket-{{site.wicket.version_60}}.tar.gz.sha)
)
- Download source [apache-wicket-{{site.wicket.version_60}}.zip](https://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_60}}/apache-wicket-{{site.wicket.version_60}}.zip)
([PGP](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/apache-wicket-{{site.wicket.version_60}}.zip.asc),
[MD5](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/apache-wicket-{{site.wicket.version_60}}.zip.md5),
[SHA](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/apache-wicket-{{site.wicket.version_60}}.zip.sha)
)

Or use the following links to get the pre-packaged binaries instead:

- Download binaries [apache-wicket-{{site.wicket.version_60}}-bin.tar.gz](https://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_60}}/binaries/apache-wicket-{{site.wicket.version_60}}-bin.tar.gz)
([PGP](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/binaries/apache-wicket-{{site.wicket.version_60}}-bin.tar.gz.asc),
[MD5](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/binaries/apache-wicket-{{site.wicket.version_60}}-bin.tar.gz.md5),
[SHA](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/binaries/apache-wicket-{{site.wicket.version_60}}-bin.tar.gz.sha)
)
- Download binaries [apache-wicket-{{site.wicket.version_60}}-bin.zip](https://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_60}}/binaries/apache-wicket-{{site.wicket.version_60}}-bin.zip)
([PGP](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/binaries/apache-wicket-{{site.wicket.version_60}}-bin.zip.asc),
[MD5](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/binaries/apache-wicket-{{site.wicket.version_60}}-bin.zip.md5),
[SHA](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/binaries/apache-wicket-{{site.wicket.version_60}}-bin.zip.sha)
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
the [change log](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/CHANGELOG-6.x).

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
**not** possible to use Wicket Extensions 1.5 in a Wicket 6 project, or
Wicket CDI 6.19 in a Wicket 7 project. The same goes for 3rd party
libraries: make sure you always use a compatible version of your 3rd
party library.
