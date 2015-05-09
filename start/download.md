---
layout: default
title: Download Wicket releases
---

Apache Wicket {{site.wicket.version}} is the current stable release.
Most users get Apache Wicket using [Apache Maven's dependency
management](#maven), which incidentally is the most convenient way of
obtaining the latest and greatest Wicket.

## Download

New projects should use [Wicket {{site.wicket.version}}](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version}}) as their base.

 * **Latest stable release**: [{{site.wicket.version}}](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version}})
 * **Latest 6.x release**: [{{site.wicket.version_60}}](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_60}})
 * **Latest 1.5.x release**: [{{site.wicket.version_15}}](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_15}})
 * **Latest 1.4.x release** (security updates only): [{{site.wicket.version_14}}](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_14}})
 * **Archived releases**: <http://archive.apache.org/dist/wicket>

We recommend you [start](quickstart.html) with our latest stable release. 

### Developer releases

If you like to live on the cutting edge and help development of Wicket
further along, you can try out the development milestone releases:

 * Latest **development milestone** release for 7.x: 
   [{{site.wicket.version_70}}](http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_70}})

This release is not fit for production use yet: it is only intended for
developers of Wicket, or for people trying out our development
versions. API changes will occur between releases.

### Requirements

#### Java version

 * Apache Wicket 7.x requires JDK 7.0 or newer
 * Apache Wicket 6.x requires JDK 6.0 or newer
 * Apache Wicket 1.5.x requires JDK 1.5 or newer
 * Apache Wicket 1.4.x requires JDK 1.5 or newer

#### Mixing Wicket versions

You cannot mix different Wicket versions in your project. You should
always use the artifacts from a particular release train.

For example it is **NOT** possible to use Wicket Extensions 1.5 in a
Wicket 6 project. The same goes for 3rd party libraries: make sure you
always use a compatible version of your 3rd party library.

#### Logging

You cannot use Wicket without adding an SLF4J logging implementation to
your classpath. Most people use
[log4j](http://logging.apache.org/log4j).

If you do, just include **slf4j-log4j12.jar** on your classpath to get
Wicket to use log4j too. If you want to use commons-logging or JDK14
logging or something else, please see the [SLF4J
site](http://www.slf4j.org/faq.html) for more information.


## Migrating from earlier versions

If you are migrating an existing application from earlier versions of
Wicket you may find our migration guides invaluable:

 * Migrating from [Wicket 1.2 to Wicket 1.3](https://cwiki.apache.org/confluence/display/WICKET/Migrating+to+Wicket+1.3)
 * Migrating from [Wicket 1.3 to Wicket 1.4](https://cwiki.apache.org/confluence/display/WICKET/Migrating+to+Wicket+1.4)
 * Migrating from [Wicket 1.4 to Wicket 1.5](https://cwiki.apache.org/confluence/display/WICKET/Migration+to+Wicket+1.5)
 * Migrating from [Wicket 1.5 to Wicket 6.x](https://cwiki.apache.org/confluence/display/WICKET/Migration+to+Wicket+6.0)
 * Migrating from [Wicket 6.x to Wicket 7.x](https://cwiki.apache.org/confluence/display/WICKET/Migration+to+Wicket+7.0)

## Maven

Add the following snippet to your Maven project descriptor (`pom.xml`):

{% highlight xml %}
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-core</artifactId>
    <version>{{site.wicket.version}}</version>
</dependency>
{% endhighlight %}

For the SLF4J log4j binding:

{% highlight xml %}
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-log4j12</artifactId>
    <version>1.6.4</version>
</dependency>
{% endhighlight %}

## SNAPSHOTs and latest bleeding-edge code ##

If you wish to build the latest code from scratch, master and branches
live in the Git repository: https://git-wip-us.apache.org/repos/asf/wicket.git

Branches:

* **7.x**: master
* **6.x**: wicket-6.x
* **1.5.x**: wicket-1.5.x
* **1.4.x**: wicket-1.4.x
* **1.3.x**: wicket-1.3.x
* **1.2.x**: wicket-1.2.x

There's also a Maven 2 repository providing SNAPSHOTs available here:

{% highlight xml %}
<repositories>
    <repository>
        <releases>
            <enabled>false</enabled>
        </releases>
        <snapshots>
            <enabled>true</enabled>
        </snapshots>
        <id>apache.snapshots</id>
        <name>Apache Snapshot Repository</name>
        <url>https://repository.apache.org/content/groups/snapshots</url>
        <layout>default</layout>
    </repository>
</repositories>
{% endhighlight %}
