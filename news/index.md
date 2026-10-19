---
layout: section
title: Blog
summary: Releases, security advisories and articles from the Apache Wicket project.
---
{% comment %}
  Articles, major releases and security advisories as panels, then the release
  announcements as dated rows, then the archive by year.
{% endcomment %}
{% include post-list.html posts=site.posts featured=6 rows=0 days=400 %}

## Releases {#releases}

Every release announcement lists what changed and where to download it. The page of each [release line]({{ site.baseurl }}/versions/) has the current version and its Maven coordinates.

{% assign releases = '' | split: '' %}
{% for post in site.posts %}{% include post-kind.html post=post %}{% if post_kind == 'release' %}{% assign releases = releases | push: post %}{% endif %}{% if releases.size >= 12 %}{% break %}{% endif %}{% endfor %}
{% include post-list.html posts=releases featured=0 %}

{% assign older = releases | last %}{% assign older_year = older.date | date: "%Y" %}{% assign older_month = older.date | date: "%m" %}
<p class="hub-more"><a href="{{ site.baseurl }}/news/{{ older_year }}/#{{ older_month }}">Older releases in the {{ older_year }} archive</a></p>

## Archive {#archive}

Every post since 2009, by year: {% for year in site.years %}{% assign y = year.first.first.date | date: "%Y" %}[{{ y }}]({{ site.baseurl }}/news/{{ y }}/){% unless forloop.last %}, {% endunless %}{% endfor %}. All posts are also in the [Atom feed]({{ site.baseurl }}/atom.xml) and on the [announce mailing list]({{ site.baseurl }}/community/#announce).
