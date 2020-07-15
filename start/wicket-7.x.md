---
layout: default
title: Apache Wicket 7.x
active_link: download
preamble: Here you can learn about the status of Wicket 7.x, find links to download it, learn how to configure your Maven POM to use Wicket, find the minimal requirements, and migrate your existing application to this Wicket version.
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

The status for Wicket 7.x is: **security fixes only**.

This branch is **no longer actively maintained** and will only recieve
backported security fixes when relevant and as long as we are able to
actually build this branch.

<i class="fa fa-exclamation-circle"></i>
**You should upgrade to Wicket 9.x at your earliest convenience.**

### Semantic versioning

These releases follow semantic versioning so upgrades between minor
releases will not break compatibility.

### Change log

To see what changed in these releases you can read the
[change log](https://www.apache.org/dist/wicket/{{site.wicket.version_70}}/CHANGELOG-7.x).

## Download

The most recent release in this branch is: **{{site.wicket.version_70}}**. 
You can get the release using [Maven](#maven) or [download it manually](#manually).

### Using Apache Maven {#maven}

Use the following Maven dependency to use Wicket in your project:

{% highlight xml %}
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-core</artifactId>
    <version>{{site.wicket.version_70}}</version>
</dependency>
{% endhighlight xml %}

Add the snippet above to your project's POM in the dependency
(management) section.

You can add more Wicket modules to your project by adding more
dependencies (copy above snippet and change the `artifactId`
accordingly).

If you are not a Maven user, you can download the Wicket release manually.

### Download Manually {#manually}

Use the following links to download Wicket manually to build Wicket
from source:

- Download source [apache-wicket-{{site.wicket.version_70}}.tar.gz](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_70}}/apache-wicket-{{site.wicket.version_70}}.tar.gz)
([PGP](https://www.apache.org/dist/wicket/{{site.wicket.version_70}}/apache-wicket-{{site.wicket.version_70}}.tar.gz.asc),
[SHA-256](https://www.apache.org/dist/wicket/{{site.wicket.version_70}}/apache-wicket-{{site.wicket.version_70}}.tar.gz.sha256)
)
- Download source [apache-wicket-{{site.wicket.version_70}}.zip](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_70}}/apache-wicket-{{site.wicket.version_70}}.zip)
([PGP](https://www.apache.org/dist/wicket/{{site.wicket.version_70}}/apache-wicket-{{site.wicket.version_70}}.zip.asc),
[SHA-256](https://www.apache.org/dist/wicket/{{site.wicket.version_70}}/apache-wicket-{{site.wicket.version_70}}.zip.sha256)
)

Or use the following links to get the pre-packaged binaries instead:

- Download binaries [apache-wicket-{{site.wicket.version_70}}-bin.tar.gz](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_70}}/binaries/apache-wicket-{{site.wicket.version_70}}-bin.tar.gz)
([PGP](https://www.apache.org/dist/wicket/{{site.wicket.version_70}}/binaries/apache-wicket-{{site.wicket.version_70}}-bin.tar.gz.asc),
[SHA-256](https://www.apache.org/dist/wicket/{{site.wicket.version_70}}/binaries/apache-wicket-{{site.wicket.version_70}}-bin.tar.gz.sha256)
)
- Download binaries [apache-wicket-{{site.wicket.version_70}}-bin.zip](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_70}}/binaries/apache-wicket-{{site.wicket.version_70}}-bin.zip)
([PGP](https://www.apache.org/dist/wicket/{{site.wicket.version_70}}/binaries/apache-wicket-{{site.wicket.version_70}}-bin.zip.asc),
[SHA-256](https://www.apache.org/dist/wicket/{{site.wicket.version_70}}/binaries/apache-wicket-{{site.wicket.version_70}}-bin.zip.sha256)
)

Note that the binary packages and the source packages don't contain any
dependencies necessary to have your project working out of the box. We
strongly urge you to use Maven (or Buildr, or Gradle) as your
dependency management system.

### Verify distribution's signature

PGP signatures can be verified as described [on this page](http://www.apache.org/dev/release-signing.html#verifying-signature). The public key used to sign Wicket distributions can be found in the [KEYS file](https://www.apache.org/dist/wicket/KEYS). 

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

This Wicket version requires at least the following Java version: **JDK 7.0 or newer**.

Not only is a particular version of Java necessary, Wicket also needs
access to specific APIs.

### Servlet API

This Wicket version requires at least the following Servlet API
version: **Servlet API 3.0 or newer**. This is provided by your
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
 * Migrating from [Wicket 6.x to Wicket 7.x](https://cwiki.apache.org/confluence/display/WICKET/Migration+to+Wicket+7.0)
