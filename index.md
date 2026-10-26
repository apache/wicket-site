---
layout: home
title:
description: Apache Wicket is an open source, component-oriented Java web framework. Pages are Java components bound to plain HTML, with no JavaScript build chain.
additionalContents:
  -
   header: builtwithwicket--header.html
---
{% comment %}
  The homepage: the lockup on the season's photograph with what Wicket is and the supported
  release lines with what is new in them, the blog, the component tree on bookcloth (how a page works), why Wicket, the
  projects built with it, the five lessons and how to take part.
  The release facts come from _data/releases.yml and _config.yml; nothing here changes on release
  day. Scheduled releases are on /versions/, not here.
{% endcomment %}
{%- assign lts = site.data.releases.lines | where: "status", "lts" | first -%}
{%- assign current = site.data.releases.lines | where: "status", "current" | first -%}
{%- assign eol = site.data.releases.lines | where: "status", "eol" -%}
{%- comment %} The supported lines, the current one first. {% endcomment -%}
{%- assign supported = '' | split: '' -%}
{%- if current %}{% assign supported = supported | push: current %}{% endif -%}
{%- if lts %}{% assign supported = supported | push: lts %}{% endif -%}
<section class="hero" aria-labelledby="title">
    {% include season-photo.html hero="hero" %}
    <div class="hero-in">
        <h1 class="lockup" id="title">
            <img class="lockup-mark" src="{{ site.baseurl }}/img/logo-apachewicket-mark.svg" alt="" width="112" height="112">
            <span class="lockup-name"><span>Apache</span> <span>Wicket</span></span>
        </h1>
        <div class="lede">
            {% comment %} Tagline placeholder: "Write less, achieve more." is the Wicket 8 announcement's line, kept until the project picks one. {% endcomment %}
            <p class="tagline">Write less, achieve more.</p>
            <p class="definition">A component-oriented Java web framework, open source since 2004 and a project of the Apache Software Foundation since 2007. Every component keeps its behaviour and state in Java and its markup in plain HTML, so there is no JavaScript build chain to maintain.</p>
            <p class="hero-actions"><a class="button" href="{{ site.baseurl }}/start/quickstart.html">Get started</a></p>
            {% comment %} The one release element on the homepage: the supported lines, each with its brief from _data/highlights.yml when it has one, and the lines that reached end of life with how to upgrade. {% endcomment %}
            <div class="release">
                <h2 class="visually-hidden">Releases</h2>
                <ul class="release-lines-home">
                {%- for line in supported %}
                    <li><a class="release-v" href="{{ site.baseurl }}{{ line.page }}">{{ site.wicket[line.config] }}</a> {% if line.service == 'lts' %}<span class="tag tag-lts" title="Long-term support">LTS</span>{% else %}<span class="tag tag-current">{{ line.role }}</span>{% endif %} <span class="release-until">{{ line.support | replace: 'Until', 'supported until' }}</span>{% assign brief = site.data.highlights[line.series].brief %}{% if brief %}<span class="release-brief">{{ brief }}</span>{% endif %}</li>
                {%- endfor %}
                </ul>
                {%- if eol.size > 0 %}
                <p class="release-note">{% for line in eol %}{{ line.series }}.x{% unless forloop.last %}{% if forloop.rindex == 2 %} and {% else %}, {% endif %}{% endunless %}{% endfor %} reached end of life: support {{ eol[0].support | downcase }}. <a href="{{ site.baseurl }}/versions/#upgrade-paths">How to upgrade</a></p>
                {%- endif %}
                <p class="release-all"><a href="{{ site.baseurl }}/versions/">Release lines and support</a></p>
            </div>
        </div>
    </div>
</section>

<section class="home-news" aria-labelledby="blog">
    <div class="home-in home-split">
        <header class="home-head">
            <h2 class="sec-title" id="blog">From the blog</h2>
            <p class="home-links"><a href="{{ site.baseurl }}/news/">All posts</a> <a type="application/atom+xml" href="{{ site.baseurl }}/atom.xml">Atom feed</a></p>
        </header>
        {% include post-list.html posts=site.posts featured=3 rows=0 days=400 %}
    </div>
</section>

{% include home-tree.html %}

<section class="why" aria-labelledby="why">
    <div class="home-in">
        <header class="home-split why-head">
            <h2 class="sec-title" id="why">Why Wicket</h2>
            <p>Coming from Spring MVC, Jakarta Faces or Vaadin? <a href="{{ site.baseurl }}/docs/why-wicket.html">Why component-oriented</a> compares Wicket with request-based and other component frameworks, what it gains and what it costs, and the <a href="{{ site.baseurl }}/docs/glossary.html">glossary</a> gives each Wicket term with what other frameworks call it.</p>
        </header>
        <ul class="why-list">
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
        <p class="also"><span>Also included:</span> translations in over 25 languages, safe use of multiple tabs and windows, injection with CDI, Spring and Guice, Jakarta EE integration, and component-local JavaScript and CSS.</p>
    </div>
</section>

<section class="bww" id="builtwithwicket" aria-labelledby="bww-title">
    <div class="home-in">
        {% include builtwithwicket.html %}
    </div>
</section>

<section class="lessons" aria-labelledby="learn">
    <div class="home-in home-split">
        <header class="home-head">
            <h2 class="sec-title" id="learn">Learn Wicket in five lessons</h2>
            <p>The lessons build one application, from an empty project to a tested page with Ajax. Every page of the <a href="{{ site.baseurl }}/docs/">documentation</a> says which Wicket versions it covers.</p>
            <p class="home-links"><a href="{{ site.baseurl }}/docs/#start">Start here</a></p>
        </header>
        {% assign tutorials = site.guide | where: "type", "tutorial" | sort: "order", "last" %}
        <ol class="lesson-list">
        {% for doc in tutorials %}
            <li><a href="{{ site.baseurl }}{{ doc.url }}"><span class="lesson-n" aria-hidden="true">{{ forloop.index }}</span><span class="lesson-title">{{ doc.title }}</span></a></li>
        {% endfor %}
        </ol>
    </div>
</section>

<section class="involved" aria-labelledby="involved">
    <div class="home-in home-split">
        <h2 class="sec-title" id="involved">Built by the people who use it</h2>
        <div>
            <p>Apache Wicket is developed in the open by volunteers. Answer a question on the users list, report a bug with a quickstart, improve the documentation, or send a pull request to <a href="https://github.com/apache/wicket">apache/wicket</a>: a committer reviews it, and it goes out with the next release of its line.</p>
            <p class="home-links"><a href="{{ site.baseurl }}/contribute/">How to contribute</a> <a href="{{ site.baseurl }}/community/">Community and support</a></p>
        </div>
    </div>
</section>
