---
layout: default
title: Apache Wicket 1.4.x
active_link: download
preamble: Here you can learn about the status of Wicket 1.4.x, find links to download it, learn how to configure your Maven POM to use Wicket, find the minimal requirements, and migrate your existing application to this Wicket version.
---

<div class="button-bar">
	<a class="button" href="#status"><i class="fa fa-info-circle"></i><br>Status</a>
	<a class="button" href="#download"><i class="fa fa-download"></i><br>Download</a>
</div>
<div class="button-bar">
	<a class="button" href="#requirements"><i class="fa fa-exclamation-triangle"></i><br>Requirements</a>
	<a class="button" href="#migrate"><i class="fa fa-history"></i><br>Migrate</a>
</div>

## Status

The status for Wicket 1.4.x is: **discontinued**.

This branch is **no longer maintained and will no longer receive any updates**.

<i class="fa fa-exclamation-circle"></i>
**You should upgrade to Wicket 9.x at your earliest convenience.**

### Semantic Versioning

This release branch **does not** follow semantic versioning. Upgrading
between minor versions may break binary compatibility.

### Change log

To see what changed in this release (and prior releases) you can read
the [change log](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/CHANGELOG-1.4).

## Download

The most recent release in this branch is: **{{site.wicket.version_14}}**. 

You can get the release using Maven or download it manually.

### Using Apache Maven

Use the following Maven dependency to use Wicket in your project:

{% highlight xml %}
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket</artifactId>
    <version>{{site.wicket.version_14}}</version>
</dependency>
{% endhighlight xml %}

Add the snippet above to your project's POM in the dependency
(management) section.

You can add more Wicket modules to your project by adding more
dependencies (copy above snippet and change the `artifactId`
accordingly).

If you are not a Maven user, you can download the Wicket release manually.

### Download Manually

Use the following links to download Wicket manually to build Wicket
from source:

- Download source [apache-wicket-{{site.wicket.version_14}}.tar.gz](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_14}}/apache-wicket-{{site.wicket.version_14}}-source.tgz)
([PGP](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}-source.tgz.asc),
[MD5](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}-source.tgz.md5),
[SHA](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}-source.tgz.sha)
)

Or use the following links to get the pre-packaged binaries instead:

- Download binaries [apache-wicket-{{site.wicket.version_14}}-bin.tar.gz](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.tar.gz)
([PGP](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.tar.gz.asc),
[MD5](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.tar.gz.md5),
[SHA](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.tar.gz.sha)
)
- Download binaries [apache-wicket-{{site.wicket.version_14}}-bin.zip](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.zip)
([PGP](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.zip.asc),
[MD5](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.zip.md5),
[SHA](http://archive.apache.org/dist/wicket/{{site.wicket.version_14}}/binaries/apache-wicket-{{site.wicket.version_14}}.zip.sha)
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

This Wicket version requires at least the following Java version: **JDK 5.0 or newer**.

Not only is a particular version of Java necessary, Wicket also needs
access to specific APIs.

### Servlet API

This Wicket version requires at least the following Servlet API
version: **Servlet API 2.3 or newer**. This is provided by your
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
**not** possible to use Wicket Extensions 1.3 in a Wicket 1.5 project,
or Wicket Spring 1.4.19 in a Wicket 1.5 project. The same goes for 3rd
party libraries: make sure you always use a compatible version of your
3rd party library.

## Migrating from earlier versions

If you are migrating an existing application from earlier versions of
Wicket you may find our migration guides invaluable:

 * Migrating from [Wicket 1.2 to Wicket 1.3](https://cwiki.apache.org/confluence/display/WICKET/Migrating+to+Wicket+1.3)
 * Migrating from [Wicket 1.3 to Wicket 1.4](https://cwiki.apache.org/confluence/display/WICKET/Migrating+to+Wicket+1.4)
