---
layout: section
title: Blog
summary: Releases, security advisories and articles from the Apache Wicket project.
---
{% include post-list.html posts=site.posts featured=4 rows=15 days=1100 %}

## Archive {#archive}

Every announcement since 2009, by year. All posts are also in the [Atom feed]({{ site.baseurl }}/atom.xml) and on the [announce mailing list]({{ site.baseurl }}/community/#announce).

<nav class="blog-years" aria-label="Years">
{% for year in site.years %}{% assign y = year.first.first.date | date: "%Y" %}
    <a href="{{ site.baseurl }}/news/{{ y }}/">{{ y }}</a>
{% endfor %}
</nav>
