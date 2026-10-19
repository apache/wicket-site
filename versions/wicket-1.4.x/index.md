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

### Source and binaries {#manually}

Most projects get Wicket through Maven or Gradle, with the dependency at the top of this page. To build Wicket yourself, or to use it without a build tool, download the source:

- Download source [apache-wicket-{{site.wicket.version_14}}.tar.gz](https://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_14}}/apache-wicket-{{site.wicket.version_14}}-source.tgz)
([PGP](https://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}-source.tgz.asc),
[MD5](https://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}-source.tgz.md5),
[SHA](https://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}-source.tgz.sha)
)

Or the binaries:

- Download binaries [apache-wicket-{{site.wicket.version_14}}-bin.tar.gz](https://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.tar.gz)
([PGP](https://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.tar.gz.asc),
[MD5](https://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.tar.gz.md5),
[SHA](https://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.tar.gz.sha)
)
- Download binaries [apache-wicket-{{site.wicket.version_14}}-bin.zip](https://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.zip)
([PGP](https://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.zip.asc),
[MD5](https://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.zip.md5),
[SHA](https://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.zip.sha)
)

Neither package contains the libraries Wicket depends on; a build tool such as Maven or Gradle brings those in.

### Older releases

The mirrors carry only the latest release of each line in service. Every older release is in [the Apache archives](https://archive.apache.org/dist/wicket).

### Change log

What changed in each release of this line is in the [change log](https://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/CHANGELOG-1.4).

## Requirements

The Java and Servlet API versions this line needs are at the [top of the page](#status).
Some modules need more libraries, such as file upload, date and time APIs or the CDI specification; each module's POM lists them.

### Logging

Wicket logs through SLF4J, so your application needs an SLF4J implementation on the classpath. The [SLF4J manual](https://www.slf4j.org/manual.html) lists them.

### Don't mix Wicket versions

Use one Wicket version for every Wicket module in a project: `wicket-core`, `wicket-extensions`, `wicket-spring` and the others are released together and only work with the same version. Libraries built on Wicket are made for one Wicket line; use the version made for yours.
