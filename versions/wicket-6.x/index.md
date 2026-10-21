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

### Source and binaries {#manually}

Most projects get Wicket through Maven or Gradle, with the dependency at the top of this page. To build Wicket yourself, or to use it without a build tool, download the source:

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

Or the binaries:

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

Neither package contains the libraries Wicket depends on; a build tool such as Maven or Gradle brings those in.

### Older releases

The mirrors carry only the latest release of each line in service. Every older release is in [the Apache archives](https://archive.apache.org/dist/wicket).

### Change log

What changed in each release of this line is in the [change log](https://www.apache.org/dist/wicket/{{site.wicket.version_60}}/CHANGELOG-6.x).

## Requirements

The Java and Servlet API versions this line needs are at the [top of the page](#status).
Some modules need more libraries, such as file upload, date and time APIs or the CDI specification; each module's POM lists them.

### Logging

Wicket logs through SLF4J, so your application needs an SLF4J implementation on the classpath. The [SLF4J manual](https://www.slf4j.org/manual.html) lists them.

### Don't mix Wicket versions

Use one Wicket version for every Wicket module in a project: `wicket-core`, `wicket-extensions`, `wicket-spring` and the others are released together and only work with the same version. Libraries built on Wicket are made for one Wicket line; use the version made for yours.
