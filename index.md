---
layout: default
title: Home
pageclasses: index
additionalContents:
  -
   path: news.html
   sectionId: news
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

<div class="l-first l-flex">
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
<div class="l-first l-flex">
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
<div class="l-first l-flex">
  <div class="l-full">
    <h3>Optional is Sometimes Required</h3>
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

<div class="l-first l-flex">
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

<div class="l-first l-flex">
  <div class="l-half">
    <h3>No Rewrite Necessary</h3>
    <p>
      The Wicket team has been very careful of adopting Java 8 technologies and as such you don’t have to rewrite your whole application, whilst still reaping all the benefits of Java 8.
    </p>
    <p>
      As this is a new major version we have, in accordance with semantic versioning, cleaned up many APIs and you will get compile errors when you migrate from previous Wicket versions.
    </p>
  </div>
  <div class="l-half">
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
<div class="l-first l-flex">
  <div class="l-full">
    <h2>Getting Started with Wicket 8</h2>
    <p>
      It is very easy to get started with Wicket: use our <a href="/start/quickstart.html">quick-start wizard</a> or 
      use one of the options below.
    </p>
  </div>
  <div class="l-half">
    <h3>Download using Apache Maven</h3>
    <p>
      With Apache Maven update your dependency to (and don't forget to
      update any other dependencies on Wicket projects to the same version):
    </p>
{% highlight xml%}
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-core</artifactId>
    <version>{{site.wicket.version_80}}</version>
</dependency>
{% endhighlight%}
  </div>
  <div class="l-half">
    <h3>Download sources/binaries manually</h3>
    <p>
      Or download and build the distribution yourself, or use our
      convenience binary package
    </p>
    <ul>
      <li>Source: <a href="http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_80}}">{{site.wicket.version_80}} source download</a></li>
      <li>Binary: <a href="http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_80}}/binaries">{{site.wicket.version_80}} binary download</a></li>
    </ul>
  </div>
</div>

<hr>

<div class="l-full l-first preamble">
    <h1 id="introduction">Introducing Apache&nbsp;Wicket</h1>
    <p>Invented in 2004, Wicket is one of the few survivors of the Java
    serverside web framework wars of the mid 2000's. Wicket is an open
    source, component oriented, serverside, Java web application framework.
    With a history of over a decade, it is still going strong and has a
    solid future ahead. Learn why you should consider Wicket for your next
    web application.</p>
</div>

<div class="l-first l-flex">
    <div class="l-one-third">
        <img src="{{site.baseurl}}/img/java-wicket-html5.png" class="l-full">
        <h3>Just Java &amp; HTML</h3>
        <p>Leverage what you know about Java or your favourite HTML 
        editor to write Wicket applications. With pure Java code and HTML 
        markup Wicket is the go-to web framework for purists.</p>
    </div>
    <div class="l-one-third">
        <img src="{{site.baseurl}}/img/wicket-safe.png" class="l-full">
        <h3>Secure by Default</h3>
        <p>URLs do not expose sensitive information and all component paths are
        session-relative. Wicket keeps your model private except those parts
        you explicitly expose.</p>
    </div>
    <div class="l-one-third">
        <img src="{{site.baseurl}}/img/wicket-components.png" class="l-full">
        <h3>AJAX Components</h3>
        <p>Write Ajax applications without having to write a single line 
        of JavaScript code. Wicket's Ajax functionality makes it trivial 
        to update selected parts of a UI, and comes with a great selection 
        of basic Ajax components.</p>
    </div>
</div>
<div class="l-first l-flex">
    <div class="l-one-third">
        <h3>Open Source with Apache License</h3>
        <p>Since its inception in 2004 Wicket has been an open source
        project and remains available under one of the most permissive
        licenses: the Apache Software License.</p>
    </div>
    <div class="l-one-third">
        <h3>Maintainable code</h3>
        <p>Pages and Components in Wicket are real Java objects that support
        encapsulation, inheritance and events. Create high level components
        with ease and bundle its stylesheets, JavaScript and other resources
        into one reusable package.</p>
    </div>
    <div class="l-one-third">
        <h3>Internationalized to take on the world</h3>
        <p>With support of over 25 languages out-of-the-box, Wicket let's 
        you get started in your own language, or a second language with no 
        effort. You can provide alternative languages on the application, 
        page, or even component level.</p>
    </div>
</div>
<div class="l-first l-flex">
    <div class="l-one-third">
        <h3>Multi-tab and window support</h3>
        <p>No more pain while keeping taps on multiple tabs and windows. 
        Wicket's automatic state storage ensures that your users can open 
        pages in new tabs and windows without causing problems.</p>
    </div>
    <div class="l-two-third">
        <h3>Work with JavaScript and CSS</h3>
        <p>Global JavaScript libraries and CSS styling mix properly with 
        component local JavaScript and CSS resources. You can use custom 
        component libraries that ship with default JavaScript behaviour and 
        CSS styling, without having to do anything yourself. Creating such 
        self-contained component libraries is as easy as creating a JAR 
        file.</p>
    </div>
</div>
<div class="l-first l-flex">
    <div class="l-one-third">
        <h3>Test your pages and components</h3>
        <p>With WicketTester you can achieve testing coverage your QA 
        department can only dream of. Test your pages without having to run 
        inside a browser, or start a container. Test your components directly, 
        check their rendered markup tags, attributes and contents with ease.</p>
    </div>
    <div class="l-one-third">
        <h3>Injection support</h3>
        <p>Inject your services into your pages and components with the 
        technology of your choosing: Wicket provides integration with CDI 
        (JSR-305), Spring and Guice.</p>
    </div>
    <div class="l-one-third">
        <h3>JavaEE integration</h3>
        <p>If you are using the Web profile of JavaEE 6 or newer, you can 
        leverage JPA, EJBs, Bean Validation and CDI with Wicket's integrations 
        for these specifications.</p>
    </div>
</div>
<div class="l-first">
</div>
<hr/>