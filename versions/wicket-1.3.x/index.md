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

### Source and binaries {#manually}

Most projects get Wicket through Maven or Gradle, with the dependency at the top of this page. To build Wicket yourself, or to use it without a build tool, download the source and binaries:

- Download source+bin [apache-wicket-{{site.wicket.version_13}}.tar.gz](https://archive.apache.org/dist/wicket/{{site.wicket.version_13}}/apache-wicket-{{site.wicket.version_13}}.tar.gz)
([PGP](https://archive.apache.org/dist/wicket/{{site.wicket.version_13}}/apache-wicket-{{site.wicket.version_13}}.tar.gz.asc),
[MD5](https://archive.apache.org/dist/wicket/{{site.wicket.version_13}}/apache-wicket-{{site.wicket.version_13}}.tar.gz.md5),
[SHA](https://archive.apache.org/dist/wicket/{{site.wicket.version_13}}/apache-wicket-{{site.wicket.version_13}}.tar.gz.sha)
)
- Download source+bin [apache-wicket-{{site.wicket.version_13}}.zip](https://archive.apache.org/dist/wicket/{{site.wicket.version_13}}/apache-wicket-{{site.wicket.version_13}}.zip)
([PGP](https://archive.apache.org/dist/wicket/{{site.wicket.version_13}}/apache-wicket-{{site.wicket.version_13}}.zip.asc),
[MD5](https://archive.apache.org/dist/wicket/{{site.wicket.version_13}}/apache-wicket-{{site.wicket.version_13}}.zip.md5),
[SHA](https://archive.apache.org/dist/wicket/{{site.wicket.version_13}}/apache-wicket-{{site.wicket.version_13}}.zip.sha)
)

Neither package contains the libraries Wicket depends on; a build tool such as Maven or Gradle brings those in.

### Older releases

The mirrors carry only the latest release of each line in service. Every older release is in [the Apache archives](https://archive.apache.org/dist/wicket).

## Requirements

The Java and Servlet API versions this line needs are at the [top of the page](#status).
Some modules need more libraries, such as file upload, date and time APIs or the CDI specification; each module's POM lists them.

### Don't mix Wicket versions

Use one Wicket version for every Wicket module in a project: `wicket-core`, `wicket-extensions`, `wicket-spring` and the others are released together and only work with the same version. Libraries built on Wicket are made for one Wicket line; use the version made for yours.
