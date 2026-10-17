---
layout: section
title: Blog
summary: Releases, security advisories and articles from the Apache Wicket project.
rail: blog-rail.html
---
{% comment %}
  The newest post in full, the four after it as a title and a sentence, then a link to the
  archive where older posts continue. Ids inside the full post are dropped, so its headings
  do not clash with the page's own.
{% endcomment %}
{% for post in site.posts limit: 5 %}
{% include post-kind.html post=post %}
<article class="blog-entry{% unless forloop.first %} blog-entry--short{% endunless %}" id="post-{{ post.date | date: '%Y%m%d' }}-{{ post.slug }}">
    <header class="blog-entry-head">
        <p class="post-sign-meta">
            <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%-d %B %Y" }}</time>
            {% case post_kind %}
            {% when 'major' %}<span class="tag tag-post">Major release</span>
            {% when 'release' %}<span class="tag tag-post">Release</span>
            {% when 'security' %}<span class="tag tag-post tag-security">Security advisory</span>
            {% endcase %}
        </p>
        <h2><a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }}</a></h2>
    </header>
    {% if forloop.first %}
    <div class="page-content guide-content post-content">
        {{ post.content | replace: ' id="', ' data-id="' }}
    </div>
    {% else %}
    {% if post.description or post_kind != 'release' %}
    <p class="blog-entry-summary">{% include post-summary.html post=post %} <a href="{{ site.baseurl }}{{ post.url }}">Read the post</a></p>
    {% else %}{% include post-line.html post=post %}{% if line_page %}
    <p class="blog-entry-summary"><a href="{{ site.baseurl }}{{ line_page.url }}">Wicket {{ line_series }}.x: status, downloads and documentation</a></p>
    {% endif %}{% endif %}
    {% endif %}
</article>
{% endfor %}

{% assign older = site.posts[5] %}
{% if older %}{% assign older_year = older.date | date: "%Y" %}{% assign older_month = older.date | date: "%m" %}
<nav class="post-pager" aria-label="Older posts">
    <a class="post-pager-older" href="{{ site.baseurl }}/news/{{ older_year }}/#{{ older_month }}"><span>Older posts</span>From {{ older.date | date: "%B %Y" }}</a>
</nav>
{% endif %}

## Archive {#archive}

Every post since 2009, by year: {% for year in site.years %}{% assign y = year.first.first.date | date: "%Y" %}[{{ y }}]({{ site.baseurl }}/news/{{ y }}/){% unless forloop.last %}, {% endunless %}{% endfor %}. All posts are also in the [Atom feed]({{ site.baseurl }}/atom.xml) and on the [announce mailing list]({{ site.baseurl }}/community/#announce).
