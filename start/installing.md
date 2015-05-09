---
layout: default
title: Installing Wicket
---

So you chose not to use one of the ready to use Maven archetypes, but rather
roll things on your own. While possible, it needs some close attention to
make things work properly. Most notable things you need to take care of are:

* dependencies
* logging

## Required dependencies to use Wicket

While we are adamant users of Apache Maven and its build infrastructure, this
may not be to everyone's liking. However, if you wish to learn all about
which dependencies you need for your Wicket project, we ask you to learn to
read the POM file format and retrieve the required versions stated there. We
take great care to keep the POM files up to date with the latest and greatest
of each dependency.

### Compilation & Testing ###

At a minimum a vanilla Wicket application requires for compilation:

* Java SDK 1.5 or newer
* servlet-api
* slf4j-api
* any slf4j implementation and dependencies necessary for that logging
  provider
* junit if you build Wicket from source or want to use `WicketTester` to test
  your pages and components

### Runtime dependencies ### 

At a minimum a barebones Wicket application requires the following at runtime:

* a servlet container (Apache Tomcat, Jetty) or any JEE container
* Java 5 runtime or newer
* slf4j-api and your slf4j implementation and required logging provider
  dependencies.

## Logging

As of Wicket 1.3.0, Wicket uses the [SLF4J](http://www.slf4j.org/) project
for logging. SLF4J is similar to
[commons-logging](http://jakarta.apache.org/commons/logging/), in that it
allows libraries/frameworks like Wicket to avoid forcing a choice of logging
framework on their users.

**You cannot use Wicket without adding an SLF4J logging implementation to
your classpath**. Most people use [log4j](http://logging.apache.org/log4j).
If you do, just include `slf4j-log4j12.jar` on your classpath to get Wicket
to use log4j too. If you want to use commons-logging or JDK14 logging or
something else, please see the [SLF4J site](http://www.slf4j.org/faq.html)
for more information.

