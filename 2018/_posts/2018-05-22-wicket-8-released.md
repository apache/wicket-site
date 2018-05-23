---
layout: post
title: "Announcing Apache Wicket 8: Write Less, Achieve More"
---

The Apache Wicket project announces the 8th major release of the open source Java web framework servicing websites and applications across the globe for over a decade. With this release Wicket embraces Java 8 idioms fully, allowing the use of lambda expressions in all the right places. With Wicket 8 you can write fewer, faster and more maintainable code.

<!--more-->

## A Careful Application of Java 8

While previous versions of Wicket work well with Java 8 and beyond, the Wicket API was not optimized to make full use of Java 8 idioms. After careful consideration and trying many paths to adopt new ways of combining Java 8 and Wicket, we finally settled on the current API.

Java 8's new idioms and types have been applied throughout Wicket's API. Learn more about the details below.

## Java 8+ Required

Starting with Wicket 8 the minimum required version of Java is Java 8. All Wicket supplied projects have been upgraded to Java 8 and Wicket 8, and shortly all active community projects, such as Wicket Stuff, will follow suit.

With the adoption of Java 8 we were able to provide support for Lambdas.

## Lambdas in All The Right Places

The major feature of Java 8 was the addition of lambda support in the language. With Wicket 8 we have looked at providing lambda support in the API and have weighed it against performance and memory usage considerations.

In this light we have opted to continue using subclassing as the primary extension mechanism for Wicket components.

Factories for lambdas have been provided for various forms of models (databinding) and behaviors (adapters for components).

## Java Date/Time API

Wicket 8 provides out-of-the-box support for the new types for handling dates in Java 8. These can be converted, validated and bound to components.

## Optional is Somtimes Required

The new Optional type in Java 8 is intended for places in your API where things can be null. In Wicket's case we have adopted Optional in just those places to clarify the API. 

For example the AjaxFallbackLink, a link that works using both with and without AJAX, now uses Optional to signify whether the link was clicked utilizing AJAX or normal request processing: the AJAX request is wrapped in an Optional. Previous versions of Wicket would provide a null value for the AJAX request.

{% highlight java %}
// WICKET 7:
add(new AjaxFallbackLink<Void>("wicket7") {
    @Override
    public void onClick(AjaxRequestTarget target) {
        if(target != null) {
            // ...
        }
    }
});
// WICKET 8:
add(new AjaxFallbackLink<Void>("wicket8") {
    @Override
    public void onClick(Optional<AjaxRequestTarget> target) {
        if(target.isPresent()) {
            // ...
        }
    }
});
{% endhighlight %}

Because we have modified the API to utilize Optional, you will get compile errors when you start migrating to Wicket 8. This gives you the exact positions where these improvements have occurred and you can start working with the Optional API.

## Models as Functional Interface

Wicket uses models as the databinding method: each data-aware component can take a model implementation to retrieve and store data in. From Wicket 8 we have made the root interface IModel a _functional interface_. You can now use lambdas where you can use models.

The following example binds a Label component to the name of a person object in different ways using Wicket 8:

{% highlight java %}
add(new Label("name1", person::name));
add(new Label("name2", () -> person.getName()));
add(new Label("name3", LambdaModel.of(personModel, Person::getName)));
add(new Label("name4", 
    LambdaModel.of(contractModel, Contract::getPerson)
        .map(Person::getName)));
{% endhighlight %}

The new `LambdaModel` type in Wicket enables type safe, refactor safe databinding for components. Previously one would bind data to components using `PropertyModel`, using a string expression to determine the exact property to show. The string expression is something like `"person.name"`. This is inherently difficult to refactor when you decide to change the name field into for example `"lastName"`. With `LambdaModel`, this refactoring is trivial for IDEs to perform: the Java methods can easily be renamed and the IDE will find all the references.

Microbenchmarks have shown that using lambda models provides much better performance than the string based PropertyModel at the cost of slightly larger memory footprint.

## Servlet 3.1 Required

As of Wicket 8 we only support the Java Servlet API 3.1 (or newer). This means that to run applications built using Wicket 8 you have to run your application in a modern server like Tomcat 8.x, Jetty 9.1+ or a Java EE 7 compatible server.

## No Rewrite Necessary

The Wicket team has been very careful of adopting Java 8 technologies and as such you don't have to rewrite your whole application, whilst still reaping all the benefits of Java 8.

As this is a new major version we have, in accordance with semantic versioning, cleaned up many APIs and you will get compile errors when you migrate from previous Wicket versions.

## Migrating to Wicket 8

When you migrate from a previous Wicket version to Wicket 8, a full list of changes and migrations is available at the following page:

[https://s.apache.org/wicket8migrate](https://s.apache.org/wicket8migrate)

Please consult this migration guide when you are moving towards Wicket 8.

## Support

You can find out about our support channels through the following page on our website: [https://wicket.apache.org/help/](https://wicket.apache.org/help/)

## Download

With Apache Maven update your dependency to (and don't forget to
update any other dependencies on Wicket projects to the same version):

{% highlight xml%}
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-core</artifactId>
    <version>8.0.0</version>
</dependency>
{% endhighlight%}

Or download and build the distribution yourself, or use our
convenience binary package

 * Source: [8.0.0 source download](http://www.apache.org/dyn/closer.cgi/wicket/8.0.0)
 * Binary: [8.0.0 binary download](http://www.apache.org/dyn/closer.cgi/wicket/8.0.0/binaries)

## Thanks

Our many thanks go out to our contributors for testing this release during its development and providing invaluable feedback.


