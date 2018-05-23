---
layout: title
title: Wicket 8 Released
pageclasses: wicket8 index
additionalContents:
jumbotronLinks:
  -
    text: Download now &raquo;
    url: /start/wicket-8.x.html
---

<div class="l-full l-first preamble">
    <h1 id="introduction">Announcing Apache&nbsp;Wicket&nbsp;8: Write Less, Achieve More</h1>
    <p>
      The Apache Wicket project announces the 8th major release of the open source Java web framework servicing websites and applications across the globe for over a decade. With this release Wicket embraces Java 8 idioms fully, allowing the use of lambda expressions in all the right places. With Wicket 8 you can write fewer, faster and more maintainable code.
    </p>
</div>
<div class="l-first">
  <div class="l-full">
    <h3>A Careful Application of Java 8</h3>

    <p>
      While previous versions of Wicket work well with Java 8 and beyond, the Wicket API was not optimized to make full use of Java 8 idioms. After careful consideration and trying many paths to adopt new ways of combining Java 8 and Wicket, we finally settled on the current API.
    </p>
    <p>
      Java 8’s new idioms and types have been applied throughout Wicket’s API. Learn more about the details below.
    </p>
  </div>
</div>

<div class="l-first">
  <div class="l-one-third">
    <h3>Java 8+ Required</h3>
    <p>
      Starting with Wicket 8 the minimum required version of Java is Java 8. All Wicket supplied projects have been upgraded to Java 8 and Wicket 8, and shortly all active community projects, such as Wicket Stuff, will follow suit.
    </p>
    <p>
      With the adoption of Java 8 we were able to provide support for Lambdas.
    </p>
  </div>
  <div class="l-one-third">
    <h3>Servlet 3.1 Required</h3>
    <p>
      As of Wicket 8 we only support the Java Servlet API 3.1 (or newer). This means that to run applications built using Wicket 8 you have to run your application in a modern server like Tomcat 8.x, Jetty 9.1+ or a Java EE 7 compatible server.
    </p>
  </div>
  <div class="l-one-third">
    <h3>Java Date/Time API</h3>
    <p>
      Wicket 8 provides out-of-the-box support for the new types for handling dates in Java 8. These can be converted, validated and bound to components.
    </p>
  </div>
</div>
<div class="l-first">
  <div class="l-two-third">
    <h3>Lambdas in All The Right Places</h3>
    <p>
      The major feature of Java 8 was the addition of lambda support in the language. With Wicket 8 we have looked at providing lambda support in the API and have weighed it against performance and memory usage considerations.
    </p>
    <p>
      In this light we have opted to continue using subclassing as the primary extension mechanism for Wicket components.
      Factories for lambdas have been provided for various forms of models (databinding) and behaviors (adapters for components).
    </p>
  </div>
</div>
<div class="l-first">
  <div class="l-full">
    <h3>Optional is Somtimes Required</h3>
  </div>
  <div class="l-one-third">
    <p>
      The new Optional type in Java 8 is intended for places in your API where things can be null. In Wicket’s case we have adopted Optional in just those places to clarify the API.
    </p>
    <p>
      For example the AjaxFallbackLink, a link that works using both with and without AJAX, now uses Optional to signify whether the link was clicked utilizing AJAX or normal request processing: the AJAX request is wrapped in an Optional. Previous versions of Wicket would provide a null value for the AJAX request.
    </p>
    <p>
      Because we have modified the API to utilize Optional, you will get compile errors when you start migrating to Wicket 8. This gives you the exact positions where these improvements have occurred and you can start working with the Optional API.
    </p>
  </div>
  <div class="l-two-third">
{% highlight java %}// WICKET 7:
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
  </div>
</div>

<div class="l-first">
  <div class="l-full">
    <h3>Models as Functional Interface</h3>
    <p>
      Wicket uses models as the databinding method: each data-aware component can take a model implementation to retrieve and store data in. From Wicket 8 we have made the root interface IModel a functional interface. You can now use lambdas where you can use models.
    </p>
    <p>
      The following example binds a Label component to the name of a person object in different ways using Wicket 8:
    </p>
{% highlight java %}
add(new Label("name1", person::name));
add(new Label("name2", () -> person.getName()));
add(new Label("name3", LambdaModel.of(personModel, Person::getName)));
add(new Label("name4",
  LambdaModel.of(contractModel, Contract::getPerson)
    .map(Person::getName)));
{% endhighlight %}
    <p>
      The new <code>LambdaModel</code> type in Wicket enables type safe, refactor safe databinding for components. Previously one would bind data to components using PropertyModel, using a string expression to determine the exact property to show. The string expression is something like <code>"person.name"</code>. This is inherently difficult to refactor when you decide to change the name field into for example <code>"lastName"</code>. With <code>LambdaModel</code>, this refactoring is trivial for IDEs to perform: the Java methods can easily be renamed and the IDE will find all the references.
    </p>

    <p>
      Microbenchmarks have shown that using lambda models provides much better performance than the string based PropertyModel at the cost of slightly larger memory footprint.
    </p>
  </div>
</div>

<div class="l-first">
  <div class="l-one-third">
    <h3>No Rewrite Necessary</h3>
    <p>
      The Wicket team has been very careful of adopting Java 8 technologies and as such you don’t have to rewrite your whole application, whilst still reaping all the benefits of Java 8.
    </p>
    <p>
      As this is a new major version we have, in accordance with semantic versioning, cleaned up many APIs and you will get compile errors when you migrate from previous Wicket versions.
    </p>
  </div>
  <div class="l-one-third">
    <h3>Migrating to Wicket 8</h3>
    <p>
      When you migrate from a previous Wicket version to Wicket 8, a full list of changes and migrations is available at the following page:
    </p>
    <p>
      <a href="https://s.apache.org/wicket8migrate">https://s.apache.org/wicket8migrate</a>
    </p>
    <p>
      Please consult this migration guide when you are moving towards Wicket 8.
    </p>
  </div>
</div>
