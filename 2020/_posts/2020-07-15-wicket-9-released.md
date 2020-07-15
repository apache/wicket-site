---
layout: post
title: "Announcing Apache Wicket 9: get into the modern Java world!"
---

The Apache Wicket project announces the 9th major release of the open source Java web framework servicing websites and applications across the globe since 2004. Built on top of Java 11, this version of Wicket brings web development into the modern Java world, offering a fundamental tool to keep you code up to date with Java evolution.

<!--more-->

## Bring the web into the modern Java era

The release of Java 9 has been a turning point in Java history which laid the foundation for the modern Java era. However, the magnitude of this change has discouraged many developers from leaving the safe harbor represented by Java 8. With Wicket 9 we finally have a fundamental tool to move on and bring our web applications into the new Java world.

With this version Wicket has been completely revisited and improved to embrace new technologies such as Java modularization and new libraries like JUnit 5. 

## Stay up to date with Java release cycle

With Java releasing at a faster pace it's important to keep a library up to date with the lastest changes introduced in the platform and ensure it works with the latest Java release. Wicket does all of this by taking part to the [OpenJDK Quality Outreach](https://wiki.openjdk.java.net/display/quality/Quality+Outreach), an initiative aimed to test popular Open Source projects with both the latest OpenJDK release and the Early Access release.

## Be ready for the next Java Enterprise 

Shortly after Java 9 was released, Oracle submitted Java EE to the Eclipse Foundation. As side effect of this owner change, the package name 'javax' had to be migrated to 'jakarta'. Wicket historically promoted decoupling of Java EE APIs and application code, making the transition to future Java Enterprise versions much easier. 

## Protect your web apps with Content Security Policy (CSP)

s the number of security threats grows, it's crucial for web applications to adopt the latest security standards and countermeasures. CSP is a modern standard that allows applications to declare approved origins of content (such as JavaScript, CSS, images, etc...) for the browser to load. Constructing a safe and at the same time complete CSP can be challenging. You either risk leaving holes in the defense of your application or you break certain functionality. Protecting against unwanted inline scripts is the most important target to attain. In CSP this is called 'unsafe-inline' and it's the most common cause of cross-site scripting vulnerabilities.

Wicket 9 comes with full support for CSP and does not need any unsafe directives. Wicket will automatically add a nonce to every header contribution and whitelist this nonce. This allows for flexible loading of resources without the need for a complex CSP. Of course it is possible to modify and customize the CSP, add additional directives or disable it entirely. Lookup our documentation for more information. 

## Migrating to Wicket 9

When you migrate from a previous Wicket version to Wicket 9, a full list of changes and migrations is available at the following page:

[https://s.apache.org/wicket9migrate](https://s.apache.org/wicket9migrate)

Please consult this migration guide when you are moving towards Wicket 9.

## Support

You can find out about our support channels through the following page on our website: [https://wicket.apache.org/help/](https://wicket.apache.org/help/)

## Download

With Apache Maven update your dependency to (and don't forget to
update any other dependencies on Wicket projects to the same version):

{% highlight xml%}
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-core</artifactId>
    <version>9.0.0</version>
</dependency>
{% endhighlight%}

Or download and build the distribution yourself, or use our
convenience binary package

 * Source: [9.0.0 source download](http://www.apache.org/dyn/closer.cgi/wicket/9.0.0)
 * Binary: [9.0.0 binary download](http://www.apache.org/dyn/closer.cgi/wicket/9.0.0/binaries)

## Thanks

Our many thanks go out to our contributors for testing this release during its development and providing invaluable feedback.


