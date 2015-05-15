---
layout: default
title: Welcome to Apache Wicket
---
With proper mark-up/logic separation, a POJO data model, and a refreshing
lack of XML, Apache Wicket makes developing web-apps simple and enjoyable
again. Swap the boilerplate, complex debugging and brittle code for powerful,
reusable components written with plain Java and HTML.

* Check the [feature list](meet/features.html)
* Read some [Wicket buzz](meet/buzz.html), some [Wicket blogs](meet/blogs.html)
* Find out why you should [use Wicket](meet/introduction.html)
* Check out some selected [examples in detail](learn/examples) or see them and many more in [live action](http://www.wicket-library.com/wicket-examples/)
* Take a look at our live [component reference](http://www.wicket-library.com/wicket-examples/compref/)
* Go and [download Wicket](start/download.html)
* See what [extras are available](learn/projects)

Wicket is released under the [Apache License, Version
2.0](http://www.apache.org/licenses/LICENSE-2.0.html).

{% for post in site.posts limit:2 %}
# [{{ post.title}}]({{post.url}}) #
{{post.content}}
{% endfor %}

<h1>Older news items</h1>
<ul>
{% for post in site.posts limit:10 offset:2 %}

<li>
        <a href="{{post.url}}">{{post.title}}</a> - <span>{{post.date | date_to_string}}</span><br />
        {{ post.content | strip_html | truncatewords:25 }}
        <a href="{{post.url}}">more</a></li>
{% endfor %}
</ul>
# Books about Wicket

The following books are published regarding Apache Wicket (click a cover to
learn more about the book):

<a href="/learn/books/awc.html"><img src="/learn/books/awc.png" height="200px" /></a>
<a href="/learn/books/wia.html"><img src="/learn/books/wia.png" height="200px" /></a>
<a href="/learn/books/ewdww.html"><img src="/learn/books/ewdww.png" height="200px" /></a>
<a href="/learn/books/prowicket.html"><img src="/learn/books/prowicket.png" height="200px" /></a>
<a href="/learn/books/kwij.html"><img src="/learn/books/kwij.png" height="200px" /></a>
<a href="/learn/books/praxisbuchwicket.html"><img src="/learn/books/praxisbuchwicket.png" height="200px" /></a>
<a href="/learn/books/wicket-jp.html"><img src="/learn/books/wicket-jp.png" height="200px" /></a>
<a href="/learn/books/koda.html"><img src="/learn/books/koda.jpg" height="200px" /></a>