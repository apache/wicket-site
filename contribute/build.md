---
layout: default
title: Build from source
---

The Wicket projects are built using a multi-module build as proposed by the
Maven project. We use Maven to build our projects and distributions. To be
able to build Wicket directly from subversion, you will need an understanding
of Maven.

This document contains the following sections.

1. Getting your Wicket version
2. Building Wicket
3. Coping with test failures
4. Using your own built artifacts

For more information on the project structure, please read the 'Better Builds
With Maven' book which has a detailed description on how to structure a
maintainable, enterprise ready build. The book is available for free from the
Mergere website.

## Getting your Wicket version ##

Clone the master branch from Apache Git Wicket repository

{% highlight console %}
$ git clone http://git-wip-us.apache.org/repos/asf/wicket.git
{% endhighlight %}

This will give you a directory structure like the following directory tree:

{% highlight console %}
wicket
wicket/wicket-core
wicket/wicket-extensions
wicket/wicket-spring
wicket/wicket-auth-roles
wicket/wicket-examples
wicket/wicket-spring-annot
...
{% endhighlight %}

To check out a different branch use:
{% highlight console %}
$ cd wicket
$ git checkout -b release/wicket-x.y.z release/wicket-x.y.z
# verify the branch with:
$ git branch
{% endhighlight %}

In this document we focus at the maven project descriptor located in the top
level directory, which enforces default settings for all Wicket projects such
as plug-in settings, versioning of the Wicket projects, managing the various
dependencies and more.

The artifacts in this project are there only for having a consistent build.
This top-level project doesn't have sources for itself.

## Building Wicket ##

The current development version of Wicket requires at least jdk 6.

If you want to ensure that your Wicket version is built using JDK-6 and
fully compatible with that Java version, you will need to build it with a Java
6 compiler and runtime library.

If you haven't done so already change into the Wicket root directory:

{% highlight console %}
cd wicket
{% endhighlight %}

Now building all of Wicket is as simple as issuing the following command:

{% highlight console %}
mvn install
{% endhighlight %}

This will compile, test, package and install all Wicket projects. Installation
means putting the jar files into your local Maven repository, including the
source, but without the javadoc jars (this is a Wicket specific configuration,
because build javadoc takes a long time).

The following commands are useful:
<table>
<tr><th>Commandline</th><th>Description</th></tr>
<tr><td>`mvn clean`</td><td>cleans up build artifacts</td></tr>
<tr><td>`mvn compile`</td><td>compiles the projects</td></tr>
<tr><td>`mvn package`</td><td>creates the jar files in the target/ subdirectories</td></tr>
<tr><td>`mvn install`</td><td>installs the jar files in your local repository</td></tr>
<tr><td>`mvn -Prelease package`</td><td>generates the javadoc/source jars as well</td></tr>
</table>

You can just run the install target, as Maven will build the previous stages
automatically.

### Coping with test failures ###

As this is our main development you might/will encounter failing unit tests.
These can be skipped using:

{% highlight console %}
mvn -Dmaven.test.skip=true install
{% endhighlight %}

Of course, all bets are off then and your mileage may vary if you use such a
built jar.

### Using your own built artifacts ###

Now you have built your own fresh Wicket jar you must be anxious to use it.
This is now as simple as adding a snapshot dependency on the specific Wicket
version. So in your pom.xml you can use:

{% highlight xml %}
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-core</artifactId>
    <version>6.0-SNAPSHOT</version>
    <scope>compile</scope>
</dependency>
{% endhighlight %}

And adding this to your Eclipse, NetBeans or IntelliJ IDEA project classpath
is then as simple as:

{% highlight console %}
mvn eclipse:eclipse
{% endhighlight %}

or opening the project using Netbeans or IDEAs Maven integration.

Maven will then add all the necessary JAR files to the project's classpath.

One thing you need to make sure is that you have set the `M2_REPO` classpath
variable in Eclipse (or a similar construct in Netbeans), and point it to your
local repository, typically found in `C:\Documents and Settings\username\.m2\repo`
or (for unix buffs) `~/.m2/repo`

You can add this setting using maven:

{% highlight console %}
mvn -Declipse.workspace=<path-to-eclipse-workspace> eclipse:add-maven-repo
{% endhighlight %}
