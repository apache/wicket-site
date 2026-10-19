---
layout: home
title:
description: Apache Wicket is an open source, component-oriented Java web framework. Pages are Java components bound to plain HTML, with no JavaScript build chain.
additionalContents:
  -
   header: builtwithwicket--header.html
---
{% comment %}
  The homepage: what Wicket is, how a page works, why to choose it, where to start,
  the projects built with it, the blog and how to take part. The release lines sit in the hero; the blog follows it, then the code pair.
  The release facts come from _data/releases.yml and _config.yml; nothing here changes on release day.
{% endcomment %}
{% assign lts = site.data.releases.lines | where: "status", "lts" | first %}
{% assign current = site.data.releases.lines | where: "status", "current" | first %}
{% assign next = site.data.releases.lines | where: "status", "boarding" | first %}
<section class="home-hero">
    <div class="home-inner">
        <h1>Build web applications from Java components and plain&nbsp;HTML</h1>
        <p class="home-lead">Apache Wicket is an open source, component-oriented Java web framework, developed at the Apache Software Foundation since 2004. Every component keeps its behaviour and state in Java and its markup in plain HTML, so there is no JavaScript build chain to maintain.</p>
        <p class="home-actions">
            <a class="button" href="{{ site.baseurl }}/start/quickstart.html">Get started</a>
        </p>
        <dl class="home-release" aria-label="Releases">
            <div>
                <dt>For production</dt>
                <dd><a href="{{ site.baseurl }}{{ lts.page }}">{{ site.wicket[lts.config] }}</a> <span class="tag tag-lts">LTS</span> <span class="home-release-note">{{ lts.support | replace: 'Until', 'supported until' }}</span></dd>
            </div>
            {% if current %}
            <div>
                <dt>For new features</dt>
                <dd><a href="{{ site.baseurl }}{{ current.page }}">{{ site.wicket[current.config] }}</a> <span class="home-release-note">{{ current.support | replace: 'Until', 'supported until' }}</span></dd>
            </div>
            {% endif %}
            {% if next %}
            <div>
                <dt>Next release</dt>
                <dd><span class="home-release-next">{{ next.version }}</span> <span class="home-release-note">Announced for {{ next.when }}, not yet released. Hear when it ships on the <a href="{{ site.baseurl }}/community/#announce">announce list</a>.</span></dd>
            </div>
            {% endif %}
            {% assign ending = site.data.releases.lines | where: "status", "last-call" | where_exp: "l", "l.page" %}
            {% if ending.size > 0 %}
            <div>
                <dt>Last release coming</dt>
                <dd>{% for line in ending %}<a href="{{ site.baseurl }}{{ line.page }}">{{ site.wicket[line.config] }}</a>{% unless forloop.last %} · {% endunless %}{% endfor %} <span class="home-release-note">one final release each, then end of life. See the <a href="{{ site.baseurl }}/versions/#upgrade-paths">upgrade paths</a>.</span></dd>
            </div>
            {% endif %}
            <div class="home-release-all">
                <dt class="visually-hidden">Everything else</dt>
                <dd><a href="{{ site.baseurl }}/versions/">All releases and downloads</a></dd>
            </div>
        </dl>
    </div>
</section>

<section class="home-section home-news" aria-labelledby="blog">
    <div class="home-inner">
        <h2 id="blog">From the blog</h2>
        {% include post-list.html posts=site.posts featured=3 rows=0 days=400 %}
    </div>
</section>

<section class="home-section home-code" aria-labelledby="how">
    <div class="home-inner">
        <h2 id="how">A page is a Java class and an HTML file</h2>
        <div class="home-code-pair">
            <figure>
                <figcaption>HomePage.java</figcaption>
{% highlight java %}
public class HomePage extends WebPage {
    private int clicks;

    public HomePage() {
        add(new Link<Void>("count") {
            @Override
            public void onClick() {
                clicks++;
            }
        });
        add(new Label("clicks", () -> clicks));
    }
}
{% endhighlight %}
            </figure>
            <figure>
                <figcaption>HomePage.html</figcaption>
{% highlight html %}
<p>
  You clicked <span wicket:id="clicks">0</span> times.
  <a wicket:id="count">Click me</a>
</p>
{% endhighlight %}
                <ul class="home-code-notes">
                    <li>The <code>wicket:id</code> joins each tag to the Java component with the same id. The HTML stays plain HTML that any editor opens.</li>
                    <li>A click runs <code>onClick()</code> on the server, and Wicket renders the page again.</li>
                    <li>The field <code>clicks</code> keeps its value between requests, because Wicket keeps the page object for you.</li>
                    <li>A part you reuse on many pages is a <code>Panel</code>: again a Java class and an HTML file. <a href="{{ site.baseurl }}/docs/topics/components.html">Components and markup</a> shows how.</li>
                </ul>
                <p class="home-more"><a href="{{ site.live_examples_url }}">See the examples running</a></p>
            </figure>
        </div>
    </div>
</section>

<section class="home-section" aria-labelledby="why">
    <div class="home-inner">
        <h2 id="why">Why Wicket</h2>
        <ul class="home-why">
            <li>
                <h3>Just Java and HTML</h3>
                <p>Use what you know about Java and your favourite HTML editor. Behaviour lives in Java, markup stays plain HTML, and no JavaScript build is needed.</p>
            </li>
            <li>
                <h3>Secure by default</h3>
                <p>URLs do not expose sensitive information and component paths are session-relative. Wicket supports a Content Security Policy without <code>unsafe-inline</code>: it adds a nonce to every header contribution itself.</p>
            </li>
            <li>
                <h3>Ajax without writing JavaScript</h3>
                <p>Update selected parts of a page without a single line of JavaScript, with a large set of ready-made Ajax components.</p>
            </li>
            <li>
                <h3>Components you can reuse</h3>
                <p>Pages and components are real Java objects with encapsulation, inheritance and events. Bundle a component with its stylesheets, JavaScript and other resources into one reusable package.</p>
            </li>
            <li>
                <h3>Tests without a browser</h3>
                <p>WicketTester renders your pages and components in a unit test, without a browser or a container, and checks their markup, attributes and contents.</p>
            </li>
            <li>
                <h3>Stable for the long run</h3>
                <p>Open source under the Apache License since 2004. Breaking changes only when needed, deprecated alternatives kept where possible, and every change documented in the migration guide.</p>
            </li>
        </ul>
        <p class="home-also">Coming from Spring MVC, Jakarta Faces or Vaadin? <a href="{{ site.baseurl }}/docs/why-wicket.html">Why component-oriented</a> compares Wicket with request-based and other component frameworks, what it gains and what it costs, and the <a href="{{ site.baseurl }}/docs/glossary.html">glossary</a> gives each Wicket term with what other frameworks call it.</p>
        <p class="home-also"><span>Also included:</span> translations in over 25 languages, safe use of multiple tabs and windows, injection with CDI, Spring and Guice, Jakarta EE integration, and component-local JavaScript and CSS.</p>
    </div>
</section>

<section class="home-section" id="builtwithwicket" aria-labelledby="bww-title">
    <div class="home-inner">
        {% include builtwithwicket.html %}
    </div>
</section>

<section class="home-section" aria-labelledby="learn">
    <div class="home-inner home-split">
        <div>
            <h2 id="learn">Learn Wicket in five lessons</h2>
            <p>The lessons build one application, from an empty project to a tested page with Ajax. Every page of the <a href="{{ site.baseurl }}/docs/">documentation</a> says which Wicket versions it covers.</p>
        </div>
        {% assign tutorials = site.guide | where: "type", "tutorial" | sort: "order", "last" %}
        <ol class="guide-route home-lessons">
        {% for doc in tutorials %}
            <li>
                <a class="guide-list-title" href="{{ site.baseurl }}{{ doc.url }}">{{ doc.title }}</a>
                <span class="guide-list-summary">{{ doc.summary }}</span>
            </li>
        {% endfor %}
        </ol>
    </div>
</section>

<section class="home-section home-involved" aria-labelledby="involved">
    <div class="home-inner">
        <h2 id="involved">Built by the people who use it</h2>
        <p class="home-section-lead">Apache Wicket is developed in the open by volunteers. Answer a question on the users list, report a bug with a quickstart, improve the documentation, or send a pull request to <a href="https://github.com/apache/wicket">apache/wicket</a>: a committer reviews it, and it goes out with the next release of its line.</p>
        <p class="home-more"><a href="{{ site.baseurl }}/contribute/">How to contribute</a> · <a href="{{ site.baseurl }}/community/">Community and support</a></p>
    </div>
</section>
