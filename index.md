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
---
<div class="l-full l-first preamble">
    <a class="acevent"></a>
    <br/>
    <h1 id="introduction" class="announce">Announcing Apache Wicket <span class="color-brand">1</span><span class="color-brand" style="font-family: Wicket font;font-size: 46px;">0</span> : build modern web applications with Java!</h1>
    <div>
      <img src="{{ site.baseurl }}/img/logo.svg" alt="Apache Wicket" class="responsive-logo">
    </div>
    <p>
      The Apache Wicket project announces the 10th major release of the open source Java web framework servicing websites and applications across the globe since 2004.
      Built on top of Java 17, this version of Wicket brings web development into the modern Java world, offering a fundamental tool to write modern and robust web applications.
    </p>
</div>
<div class="l-first">
  <div class="l-full">
    <h3>Use Java to build modern and mantainable web applications</h3>
    <p>
     Building robust and manteinable web applications is not a trivial task, especially for Java developers who might feel lost with modern web technologies. With Wicket you can use the rock-solid Java platform to reach this goal without the burden of the complexity that comes with modern JavaScript development stack. 
    </p>
    <p>
     Using Wicket and other familiar tools like Apache Maven you can finally make the most of modern UI frameworks and JavaScript libraries without leaving the Java ecosystem!
    </p>
  </div>
</div>

<div class="l-first l-flex">
  <div class="l-half">
    <h3>Stay up to date with the Java release cycle</h3>
    <p>
      Wicket 10 is built on top of Java 17 and is compatible with Java 21. In addtion Wicket takes part in the <a href="https://wiki.openjdk.java.net/display/quality/Quality+Outreach" target="_blank">OpenJDK Quality Outreach</a> to further improve the effort to test compatibility with both the latest OpenJDK release and the Early Access release.
    </p>
  </div>
  <div class="l-half">
    <h3>Fast migration with OpenRewrite</h3>
    <p>
     Wicket 10 comes with a migration tool based on OpenRewrite to speed up migration from Wicket 9 and avoid repetitive and error-prone manual changes to your code. For more details on this tool see <a href="https://cwiki.apache.org/confluence/display/WICKET/Migration+to+Wicket+10.0#MigrationtoWicket10.0-AddmigrationrecipestoWicket10WICKET-7029">migration guide</a>.
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
     Wicket 10 comes with full support for CSP and does not need any unsafe directives. Wicket will automatically add a nonce to every header contribution and whitelist this nonce. This allows for flexible loading of resources without the need for a complex CSP. Of course it is possible to modify and customize the CSP, add additional directives or disable it entirely. Lookup our <a href="http://wicket.apache.org/learn/#guide" target="_blank">documentation</a> for more information.
    </p>
  </div>
</div>


<div class="l-first l-flex">
  <div class="l-half">
    <h2>Getting Started with Wicket 10</h2>
    <p>
      It is very easy to get started with Wicket: use our <a href="/start/quickstart.html">quick-start wizard</a> or 
      use one of the options below.
    </p>
  </div>
  <div class="l-half">
    <h3>Migrating to Wicket 10</h3>
    <p>
      When you migrate from a previous Wicket version to Wicket 10, a full list of changes and migrations is available at the following page:
    </p>
    <p>
      <a href="https://s.apache.org/wicket10migrate">https://s.apache.org/wicket10migrate</a>
    </p>
    <p>
      Please consult this migration guide when you are moving towards Wicket 10.
    </p>
  </div>
</div>
<div class="l-first l-flex">
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
    <version>{{site.wicket.version}}</version>
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
      <li>Source: <a href="http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version}}">{{site.wicket.version}} source download</a></li>
      <li>Binary: <a href="http://www.apache.org/dyn/closer.cgi/wicket/{{site.wicket.version}}/binaries">{{site.wicket.version}} binary download</a></li>
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
        <h3>Jakarta EE integration</h3>
        <p>If you are using the Jakarta EE, you can leverage JPA, EJBs, 
        Bean Validation and CDI with Wicket's integrations for these specifications.</p>
    </div>
</div>
<div class="l-first">
</div>
<hr/>
