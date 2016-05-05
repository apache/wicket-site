---
layout: news_archive
title: Apache Wicket News
subtitle: Releases, Security updates and more&mdash;all in one neat feed.
preamble: The news is published in several venues. All announcements are sent to the Apache announcement mailing list, our announcement, user and development mailing lists, the news feed of this website and of course this website.
---
{% for year in site.years %}
<div class="l-first" markdown="1">

# All News for {{ year.first.first.date | date: "%Y" }}

This section contains all news items published in <a href="{{site.baseurl}}/news/{{ year.first.first.date | date: '%Y' }}">{{ year.first.first.date | date: "%Y" }}</a>.

{% for month in year %}
    {% for post in month %}
<article>
	<h3 id="{{ site.baseurl }}{{post.url}}">{{post.title}}</h3>
    <small>{{post.date | date_to_string}}</small>
	<p>{{ post.content | markdownify | strip_html | truncatewords:50 }}
	<a href="{{ site.baseurl }}{{post.url}}">more</a></p>
</article>
    {% endfor %}
{% endfor %}
<div class="l-first"></div>
---
{% endfor %}
