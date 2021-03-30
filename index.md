---
layout: post
title: 
pageclasses: index
additionalContents:
  -
   header: builtwithwicket--header.html
   path: builtwithwicket.html
   sectionId: builtwithwicket
   cssClass: builtwithwicket
  -
   path: news.html
   sectionId: news
jumbotronLinks:
  -
    text: Download now &raquo;
    url: /start/wicket-8.x.html
---
<div class="l-full l-first preamble">
    <a class="acevent"></a>
    <br/>
    <h1 id="introduction" class="announce">Announcing Apache Wicket 9: get into the modern Java world!</h1>
    <div>
      <img src="{{ site.baseurl }}/img/wicket-9-sun.png" alt="Apache Wicket" class="responsive-logo">
    </div>
    <p>
      The Apache Wicket project announces the 9th major release of the open source Java web framework servicing websites and applications across the globe since 2004.     
      Built on top of Java 11, this version of Wicket brings web development into the modern Java world, offering a fundamental tool to keep you code up to date with Java's evolution.
    </p>
</div>
<div class="l-first">
  <div class="l-full">
    <h3>Bring the web into the modern Java era</h3>
    <p>
     The release of Java 9 has been a turning point in Java history which laid the foundation for the modern Java era. However, the magnitude of this change has discouraged many developers from leaving the safe harbor represented by Java 8. With Wicket 9 we finally have a fundamental tool to move on and bring our web applications into the new Java world.  
    </p>
    <p>
      With this version Wicket has been completely revisited and improved to embrace new technologies such as Java modularization and new libraries like JUnit 5.
    </p>
  </div>
</div>

<div class="l-first l-flex">
  <div class="l-half">
    <h3>Stay up to date with the Java release cycle</h3>
    <p>
      With Java releasing at a faster pace it's important to keep a library up to date with the latest changes introduced in the platform and ensure it works with the latest Java release. Wicket does all of this by taking part in the <a href="https://wiki.openjdk.java.net/display/quality/Quality+Outreach" target="_blank">OpenJDK Quality Outreach</a>, an initiative aimed to test popular Open Source projects with both the latest OpenJDK release and the Early Access release.
    </p>
  </div>
  <div class="l-half">
    <h3>Be ready for the next Java Enterprise</h3>
    <p>
     Shortly after Java 9 was released, Oracle submitted Java EE to the Eclipse Foundation. As side effect of this owner change, the package name 'javax' had to be migrated to 'jakarta'. Wicket historically promoted decoupling of Java EE APIs and application code, making the transition to future Java Enterprise versions much easier. 
    </p>
  </div>
</div>

<div class="l-first l-flex">
  <div class="l-full">
    <h3>Protect your web apps with Content Security Policy (CSP)</h3>
    <p>
     As the number of security threats grows, it's crucial for web applications to adopt the latest security standards and countermeasures. CSP is a modern standard that allows applications to declare approved origins of content (such as JavaScript, CSS, images, etc...) for the browser to load. Constructing a safe and at the same time complete CSP can be challenging. 
     You either risk leaving holes in the defense of your application or you break certain functionality. Protecting against unwanted inline scripts is the most important target to attain. In CSP this is called 'unsafe-inline' and it's the most common cause of cross-site scripting vulnerabilities.
    </p>
    <p>
     Wicket 9 comes with full support for CSP and does not need any unsafe directives. Wicket will automatically add a nonce to every header contribution and whitelist this nonce. This allows for flexible loading of resources without the need for a complex CSP. Of course it is possible to modify and customize the CSP, add additional directives or disable it entirely. Lookup our <a href="http://wicket.apache.org/learn/#guide" target="_blank">documentation</a> for more information.     
    </p>
  </div>
</div>


<div class="l-first l-flex">
  <div class="l-half">
    <h3>A Smooth Transition to Java 11+</h3>
    <p>
      If you come from Wicket 8 chances are you don't need to change your application code to enjoy all the improvements offered by Java 11, such as better Docker support, improved performance, new Z Garbage Collector, etc...
    </p>
    <p>
      That said, as this is a new major version we have, in accordance with semantic versioning, cleaned up many APIs and you might have compile errors when you migrate from previous Wicket versions.
    </p>
  </div>
  <div class="l-half">
    <h3>Migrating to Wicket 9</h3>
    <p>
      When you migrate from a previous Wicket version to Wicket 9, a full list of changes and migrations is available at the following page:
    </p>
    <p>
      <a href="https://s.apache.org/wicket9migrate">https://s.apache.org/wicket9migrate</a>
    </p>
    <p>
      Please consult this migration guide when you are moving towards Wicket 9.
    </p>
  </div>
</div>
<div class="l-first l-flex">
  <div class="l-full">
    <h2>Getting Started with Wicket 9</h2>
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
    <version>{{site.wicket.version_90}}</version>
</dependency>
{% endhighlight%}
  </div>
  <div class="l-half">
    <h3>Download sources/binaries manually</h3>
    <p>
      You can download and build the distribution yourself, or use our
      convenient binary package:
    </p>
    <ul>
      <li>Source: <a href="http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_90}}">{{site.wicket.version_90}} source download</a></li>
      <li>Binary: <a href="http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version_90}}/binaries">{{site.wicket.version_90}} binary download</a></li>
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
        <p>No more pain while keeping tabs on multiple tabs and windows. 
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
