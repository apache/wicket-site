---
layout: default
title: IDE Support for Wicket development
---

For Wicket plugins that help you build applications, see [Add Wicket support to your IDE]({{ site.baseurl }}/docs/ide-plugins.html) in the user guide. This page covers setting up your IDE to work on Wicket itself.

## Setting up your IDE ##

### Eclipse ###

Eclipse offers a native for Maven based projects. To import a maven project just go to 'File...->Import...->Existing Maven Projects' and import one or more Maven projects into your workspace.

Alternatively, you can generate an Eclipse project typing the following command on project's root:

{% highlight console %}
mvn eclipse:eclipse
{% endhighlight %}

Maven will add all the necessary JAR files to the project's classpath. Now the sources can be imported in Eclipse using the "Existing Projects into Workspace" wizard.

If you want to go along with the Wicket way of code formatting you should import the Wicket code format profile into your workspace (Preferences->Java->Code Style->Formatter), found in:

{% highlight console %}
<path-to-eclipse-workspace>/wicket-core/EclipseCodeFormat.xml
{% endhighlight %}

Finally configure the editor to automatically format all edited lines and organize imports on save (Preferences->Java->Editor->Save Actions).

### NetBeans ###

NetBeans comes with Maven integration. Further help can be found at their [Wiki](http://wiki.netbeans.org/MavenBestPractices "NetBeans Community Wiki")

### IDEA ###

IntelliJ IDEA comes with [Maven support](http://www.jetbrains.com/idea/webhelp/maven.html "IDEA Web Help") too.

With the [Eclipse Code Formatter plugin](http://plugins.jetbrains.com/plugin/6546) the Wicket format profile can be used in IntelliJ IDEA too. Configure the IDE to prevent star imports (Settings->Code Style->Imports).
