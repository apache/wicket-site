---
# Published on release day: set published to true when 11.0.0 is out.
published: false
layout: hub
title: Apache Wicket 11.x
series: "11"
config: version_11
java: "21"
servlet: Jakarta Servlet 6.1 or newer
---
## Download

The most recent release in this branch is: **{{site.wicket.version_11}}**. 
You can get the release using [Maven](#maven) or [download it manually](#manually).

### Download manually {#manually}

Use the following links to download Wicket manually to build Wicket
from source:

- Download source [apache-wicket-{{site.wicket.version_11}}.tar.gz](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_11}}/apache-wicket-{{site.wicket.version_11}}.tar.gz)
([PGP](https://downloads.apache.org/wicket/{{site.wicket.version_11}}/apache-wicket-{{site.wicket.version_11}}.tar.gz.asc),
[SHA-512](https://downloads.apache.org/wicket/{{site.wicket.version_11}}/apache-wicket-{{site.wicket.version_11}}.tar.gz.sha512)
)
- Download source [apache-wicket-{{site.wicket.version_11}}.zip](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_11}}/apache-wicket-{{site.wicket.version_11}}.zip)
([PGP](https://downloads.apache.org/wicket/{{site.wicket.version_11}}/apache-wicket-{{site.wicket.version_11}}.zip.asc),
[SHA-512](https://downloads.apache.org/wicket/{{site.wicket.version_11}}/apache-wicket-{{site.wicket.version_11}}.zip.sha512)
)

Or use the following links to get the pre-packaged binaries instead:

- Download binaries [apache-wicket-{{site.wicket.version_11}}-bin.tar.gz](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_11}}/binaries/apache-wicket-{{site.wicket.version_11}}-bin.tar.gz)
([PGP](https://downloads.apache.org/wicket/{{site.wicket.version_11}}/binaries/apache-wicket-{{site.wicket.version_11}}-bin.tar.gz.asc),
[SHA-512](https://downloads.apache.org/wicket/{{site.wicket.version_11}}/binaries/apache-wicket-{{site.wicket.version_11}}-bin.tar.gz.sha512)
)
- Download binaries [apache-wicket-{{site.wicket.version_11}}-bin.zip](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_11}}/binaries/apache-wicket-{{site.wicket.version_11}}-bin.zip)
([PGP](https://downloads.apache.org/wicket/{{site.wicket.version_11}}/binaries/apache-wicket-{{site.wicket.version_11}}-bin.zip.asc),
[SHA-512](https://downloads.apache.org/wicket/{{site.wicket.version_11}}/binaries/apache-wicket-{{site.wicket.version_11}}-bin.zip.sha512)
)

Note that the binary packages and the source packages don't contain any
dependencies necessary to have your project working out of the box. We
strongly urge you to use Maven (or Buildr, or Gradle) as your
dependency management system.

### Verify distribution's signature

PGP signatures can be verified as described [on this page](http://www.apache.org/dev/release-signing.html#verifying-signature). The public key used to sign Wicket distributions can be found in the [KEYS file](https://downloads.apache.org/wicket/KEYS). 

### Older releases

The Apache mirroring system only hosts the latest version of each actively supported branch.
When you need to download an older release you can find them in the archives.

Go to [the Apache archives](https://archive.apache.org/dist/wicket) to find your specific version.

### Change log

To see what changed in these releases you can read the
[change log](https://downloads.apache.org/wicket/{{site.wicket.version_11}}/CHANGELOG-11.x).

## Requirements

The Java and Servlet API versions this line needs are at the [top of the page](#status).
Specific modules may need additional libraries, such as file upload,
date time APIs, CDI specifications, and more. See the module's POM for
more details on the necessary libraries.

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
Wicket CDI 7.x in a Wicket 8 project. The same goes for 3rd party
libraries: make sure you always use a compatible version of your 3rd
party library.
