---
layout: section
title: Learn Wicket
summary: The reference guide, books, courses and talks about Wicket, and the libraries the community builds on it.
---
<nav class="section-index" aria-label="On this page">
    <a href="#guide">Reference guide</a>
    <a href="#learning">Books, courses and talks</a>
    <a href="#ecosystem">Libraries and integrations</a>
</nav>

## Reference guide {#guide}

The reference guide, called the User Guide on this site before, is the complete guide to Wicket in one document per release line. The [Documentation]({{ site.baseurl }}/docs/#reference-guide) links it for every line, as one page or PDF, with the Javadoc next to it:
{% assign with_page = site.data.releases.lines | where_exp: "l", "l.page" | map: "series" %}{% assign lowest = 40 %}{% for v in with_page %}{% assign n = v | plus: 0 %}{% if n < lowest %}{% assign lowest = n %}{% endif %}{% endfor %}{% assign refs = '' | split: '' %}{% for n in (7..40) reversed %}{% assign series = n | append: '' %}{% assign line = site.data.releases.lines | where: "series", series | where_exp: "l", "l.page" | first %}{% unless line or n < lowest %}{% continue %}{% endunless %}{% capture a %}[Wicket {{ n }}](https://nightlies.apache.org/wicket/guide/{{ n }}.x/single.html){% endcapture %}{% assign refs = refs | push: a %}{% endfor %}{{ refs | join: ", " }}.

## Books, courses and talks {#learning}

- [Books about Wicket]({{ site.baseurl }}/learn/books/), from Wicket in Action to the Apache Wicket Cookbook.
- [Apache Wicket Kompakt](https://www.udemy.com/course/apache-wicket-kompakt/), a German course with many practical examples.
- [Starting with Apache Wicket](https://www.udemy.com/course/starting-with-apache-wicket-version-9x/?referralCode=C2A6EF19A72071AA2E22), for Wicket 9 and later, with forms, components, MongoDB and Spring Boot.
- [An introduction to Wicket]({{ site.baseurl }}/learn/presentations/wicketIntroduction.pdf), slides for developers new to Wicket.
- [A quick tour of Wicket]({{ site.baseurl }}/learn/examples/), small examples of what Wicket code looks like, and the [live examples]({{ site.live_examples_url }}) running on a server.

The [Wicket wiki](https://cwiki.apache.org/WICKET) holds older articles, the migration guides and community pages.

## Libraries and integrations {#ecosystem}

The community builds and maintains libraries on top of Wicket. They have their own release cycles and maintainers.

- [WicketStuff](https://github.com/wicketstuff/) gathers community-provided projects, from integrations with JavaScript libraries to REST resources and asynchronous tasks; the [project overview](https://github.com/wicketstuff/core/wiki) lists them.
- [Wicket Spring Boot](https://github.com/MarcGiffing/wicket-spring-boot) configures Wicket and its extensions automatically in a Spring Boot application.
- [Wicket-Bootstrap](https://github.com/l0rdn1kk0n/wicket-bootstrap/) integrates Bootstrap's components and styles, with a showcase of every feature.
- [Wicket jQuery UI](https://github.com/sebfz1/wicket-jquery-ui) wraps the jQuery UI and Kendo UI widgets as Wicket components.
- [Modern web development with Apache Wicket](https://github.com/bitstorm/modern-webdev-wicket) shows Wicket with Spring Boot, Hazelcast and WebJars in working examples.

The [Integration]({{ site.baseurl }}/docs/topics/integration.html) topic of the documentation covers Spring, CDI and the other integrations that ship with Wicket.
