---
layout: default
title: Wicket Velocity
---

Provides a specialized panel and some related utilities that enables users to
work with [Apache Velocity](http://velocity.apache.org) and [Apache
Wicket](http://wicket.apache.org). Particularly useful for simple CMS like
applications.

## Contents ##

* [Introduction](#introduction)
* [Example](#example)
* [Installing](#installing)

## Introduction ##

Velocity brings a templating language to your users. You can let them create
conditional markup, use loops and do all other things made possible by
Velocity.

Velocity templates look like the following:

{% highlight html %}
#set ($foo = "deoxyribonucleic acid")
#set ($bar = "ribonucleic acid")

#if ($foo == $bar)
  In this case it's clear they aren't equivalent. So...
#else
  They are not equivalent and this will be the output.
#end
{% endhighlight %}

Read
[more](http://velocity.apache.org/engine/releases/velocity-1.4/user-guide.html)
about the Velocity template language.

This project allows you to use Velocity templates as a component within your
Wicket pages, and let them live next to Wicket components. A typical usecase
would be to enable your users to embed Velocity templates in your application
and using that as a type of portlet.

The main component for the Veloticy/Wicket integration is the
[`VelocityPanel`](http://wicket.apache.org/docs/1.4/org/apache/wicket/velocity/markup/html/VelocityPanel.html).

## Example ##

Showing Hello, World using Velocity in a Wicket application, embedded in a
Wicket page.

{% highlight html %}
<h2>This is a Velocity template</h2>

<p>The secret message is: $message</p>
{% endhighlight %}

In this template we want to replace the string `$message` with the text
"Hello, World!". `$message` is Velocity markup denoting a variable that is
taken from the context that is provided to the Velocity rendering engine.

To use Velocity in your Wicket pages we provide a `VelocityPanel` which
enables you to generate parts of your page using Velocity markup. Adding the
panel to your Wicket page is shown in the following example:

{% highlight java %}
public VelocityPage() {
	HashMap<String, String> values = new HashMap<String, String>();
	values.put("message", "Hello, World!");
	Model<HashMap<String, String>> context = Model.of(values);
	
	UrlResourceStream template = new UrlResourceStream(getClass().getResource("test.html"));
	add(VelocityPanel.forTemplateResource("velocityPanel", context, template));
}
{% endhighlight %}

`VelocityPanel.forTemplateResource` creates a `VelocityPanel` and sets up the
engine such that the context is merged with the template with each render.

The markup of the page is quite simple: adding a VelocityPanel is as simple
as using a `div` and attaching a `wicket:identifier` to it. The following
example shows this.

{% highlight html %}
<!DOCTYPE html>
<h1>This is a test page for Velocity</h1>
<div wicket:id="velocityPanel"></div>
{% endhighlight %}

## Installing ##

Installing Wicket Velocity can be done through adding a dependency in your
project's Maven pom, or by putting the wicket-velocity.jar and the required
dependencies in your projects classpath.

### Using Maven ###

Add the following dependency to your pom:

{% highlight xml %}
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-velocity</artifactId>
    <version>{{site.wicket.version}}</version>
</dependency>
{% endhighlight %}

### Required dependencies ###

Wicket Velocity requires the following jar files to be on your classpath:

 * Wicket
 * Wicket Velocity
 * Apache Velocity

Check the [Apache Velocity project](http://velocity.apache.org) to find out
which other dependencies you need.
