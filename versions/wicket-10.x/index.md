---
layout: hub
title: Apache Wicket 10.x
series: "10"
config: version_10
java: "17"
servlet: Jakarta Servlet 5.0 or newer
migration:
  from: "9"
  url: https://cwiki.apache.org/confluence/display/WICKET/Migration+to+Wicket+10.0
---
## Download

### Source and binaries {#manually}

Most projects get Wicket through Maven or Gradle, with the dependency at the top of this page. To build Wicket yourself, or to use it without a build tool, download the source:

- Download source [apache-wicket-{{site.wicket.version_10}}.tar.gz](https://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_10}}/apache-wicket-{{site.wicket.version_10}}.tar.gz)
([PGP](https://downloads.apache.org/wicket/{{site.wicket.version_10}}/apache-wicket-{{site.wicket.version_10}}.tar.gz.asc),
[SHA-512](https://downloads.apache.org/wicket/{{site.wicket.version_10}}/apache-wicket-{{site.wicket.version_10}}.tar.gz.sha512)
)
- Download source [apache-wicket-{{site.wicket.version_10}}.zip](https://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_10}}/apache-wicket-{{site.wicket.version_10}}.zip)
([PGP](https://downloads.apache.org/wicket/{{site.wicket.version_10}}/apache-wicket-{{site.wicket.version_10}}.zip.asc),
[SHA-512](https://downloads.apache.org/wicket/{{site.wicket.version_10}}/apache-wicket-{{site.wicket.version_10}}.zip.sha512)
)

Or the binaries:

- Download binaries [apache-wicket-{{site.wicket.version_10}}-bin.tar.gz](https://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_10}}/binaries/apache-wicket-{{site.wicket.version_10}}-bin.tar.gz)
([PGP](https://downloads.apache.org/wicket/{{site.wicket.version_10}}/binaries/apache-wicket-{{site.wicket.version_10}}-bin.tar.gz.asc),
[SHA-512](https://downloads.apache.org/wicket/{{site.wicket.version_10}}/binaries/apache-wicket-{{site.wicket.version_10}}-bin.tar.gz.sha512)
)
- Download binaries [apache-wicket-{{site.wicket.version_10}}-bin.zip](https://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_10}}/binaries/apache-wicket-{{site.wicket.version_10}}-bin.zip)
([PGP](https://downloads.apache.org/wicket/{{site.wicket.version_10}}/binaries/apache-wicket-{{site.wicket.version_10}}-bin.zip.asc),
[SHA-512](https://downloads.apache.org/wicket/{{site.wicket.version_10}}/binaries/apache-wicket-{{site.wicket.version_10}}-bin.zip.sha512)
)

Neither package contains the libraries Wicket depends on; a build tool such as Maven or Gradle brings those in.

### Verify a download

Check its PGP signature with the keys in the [KEYS file](https://downloads.apache.org/wicket/KEYS), as the [ASF explains](https://www.apache.org/info/verification.html).

### Older releases

The mirrors carry only the latest release of each supported line. Every older release is in [the Apache archives](https://archive.apache.org/dist/wicket).

### Change log

What changed in each release of this line is in the [change log](https://downloads.apache.org/wicket/{{site.wicket.version_10}}/CHANGELOG-10.x).

## Requirements

The Java and Servlet API versions this line needs are at the [top of the page](#status).
Some modules need more libraries, such as file upload, date and time APIs or the CDI specification; each module's POM lists them.

### Logging

Wicket logs through SLF4J, so your application needs an SLF4J implementation on the classpath. The [SLF4J manual](https://www.slf4j.org/manual.html) lists them.

### Don't mix Wicket versions

Use one Wicket version for every Wicket module in a project: `wicket-core`, `wicket-extensions`, `wicket-spring` and the others are released together and only work with the same version. Libraries built on Wicket are made for one Wicket line; use the version made for yours.
