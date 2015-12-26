---
layout: default
title: Documentation
subtitle: All the things you want to know about Wicket but are afraid to ask
preamble: No matter how you want to learn about Wicket, there's something available for you. If you want a quick reference, use the User Guide. If you rather prefer a book, there's a couple waiting for you. And if you rather watch a video or presentation, we have that covered too.
---

<div class="button-bar">
	<a class="button" href="#news"><i class="fa fa-newspaper-o"></i><br>News</a>
	<a class="button" href="blogs.html"><i class="fa fa-rss"></i><br>Blogs</a>
	<a class="button" href="https://cwiki.apache.org/WICKET"><i class="fa fa-users"></i><br>Wiki</a>
</div>
<div class="button-bar">
	<a class="button" href="#guide"><i class="fa fa-file-text-o"></i><br>Guide</a>
	<a class="button" href="#javadoc"><i class="fa fa-code"></i><br>API docs</a>
	<a class="button" href="books/index.html"><i class="fa fa-book"></i><br>Books</a>
</div>
<div class="button-bar">
	<a class="button" href="#migrations"><i class="fa fa-history"></i><br>Migrations</a>
	<a class="button" href="#examples"><i class="fa fa-life-ring"></i><br>Support &amp; Examples</a>
	<a class="button" href="#ides"><i class="fa fa-terminal"></i><br>IDEs</a>
</div>

## News Archive {#news}

Every release is announced through our mailing lists and the official Apache announcements list.
We also publish a news item on our website with the announcement, and it is also published in our <a type="application/atom+xml" title="Atom 1.0 feed" href="{{site.baseurl}}/atom.xml">RSS feed</a> (handy for RSS readers).

Here are the most recent headlines:

{% for post in site.posts limit:3 %}
- [{{post.title}}]({{ site.baseurl }}{{post.url}}) <small>{{post.date | date_to_string}}</small>
{% endfor %}

The complete articles and all other news items are available in the [archives]({{ site.baseurl }}/news).

---

## Wicket User Guide {#guide}

Learn building web applications with Wicket from scratch reading its
200+ page user guide. The guide gradually introduces you to the various
features of the framework with many real-world examples. It covers
subjects such as models, behaviours, testing and integration with other
projects.

The guide is available as PDF or html file for the following versions:

1.  Wicket 8.x
* [HTML](http://ci.apache.org/projects/wicket/guide/8.x/)
* [HTML (single page)](http://ci.apache.org/projects/wicket/guide/8.x/guide/single.html)
* [PDF](http://ci.apache.org/projects/wicket/guide/8.x/guide/single.pdf)

2.  Wicket 7.x
* [HTML](http://ci.apache.org/projects/wicket/guide/7.x/)
* [HTML (single page)](http://ci.apache.org/projects/wicket/guide/7.x/guide/single.html)
* [PDF](http://ci.apache.org/projects/wicket/guide/7.x/guide/single.pdf)

3.  Wicket 6.x 
* [HTML](http://ci.apache.org/projects/wicket/guide/6.x/)
* [HTML (single page)](http://ci.apache.org/projects/wicket/guide/6.x/guide/single.html)
* [PDF](http://ci.apache.org/projects/wicket/guide/6.x/guide/single.pdf)

You can use the guide for older releases even though there will be
differences. We urge you however to upgrade your project to the latest
stable release rather than sticking on an older version.

---

## API Documentation {#javadoc}

Each release of Wicket comes with sources, including JavaDocs. When you
use Maven for dependency management, your IDE will automatically
download the source JARs and when you hover on a Wicket class or
method, show you the corresponding documentation.

For reference we also publish the API documentation online so you can
link to it from emails or websites:

- [JavaDoc 8.x](http://ci.apache.org/projects/wicket/apidocs/8.x/index.html)
- [JavaDoc 7.x](http://ci.apache.org/projects/wicket/apidocs/7.x/index.html)
- [JavaDoc 6.x](http://ci.apache.org/projects/wicket/apidocs/6.x/index.html)
- [JavaDoc 1.5.x](http://ci.apache.org/projects/wicket/apidocs/1.5.x/index.html)
- [JavaDoc 1.4.x](http://ci.apache.org/projects/wicket/apidocs/1.4.x/index.html)
- [JavaDoc 1.3.x](http://ci.apache.org/projects/wicket/apidocs/1.3.x/index.html)

---

## Migration Guides {#migrations}

When you upgrade your application from an older Wicket version to a
newer version you can run into all of the changes that were applied to
Wicket's API. We have done our best to document all the changes and
provide migration paths between the different Wicket versions.

Here's a list of the migration guides:
<div class="button-bar">
    <a class="button" href="http://s.apache.org/wicket8migration">
        Wicket 8<br>
		migration guide
    </a>
    <a class="button" href="http://s.apache.org/wicket7migrate">
        Wicket 7<br>
		migration guide
    </a>
    <a class="button" href="http://s.apache.org/wicket6migration">
        Wicket 6<br>
		migration guide
    </a>
</div>
<div class="button-bar">
    <a class="button" href="http://s.apache.org/wicket5migrate">
        Wicket 1.5<br>
		migration guide
    </a>
    <a class="button" href="http://s.apache.org/wicket4migrate">
		Wicket 1.4<br>
		migration guide
    </a>
    <a class="button" href="http://s.apache.org/wicket3migrate">
        Wicket 1.3<br>
		migration guide
    </a>
</div>

If you encounter a change that was not in the migration guide, don't
hesitate to notify us.

---

## Getting help {#support}

Stuck with a problem? See how you can find [support]({{ site.baseurl }}/help/index.html)!

---

## IDE Support {#ides}

Wicket is well supported by the three main Java IDEs (NetBeans, IntelliJ and Eclipse).
Find [here]({{ site.baseurl }}/contribute/ides.html) how to work with Wicket projects with your favourite IDE.

---
	
## Examples {#examples}

- <a href="{{ site.baseurl }}/learn/examples/index.html">Examples</a> - Browse a vast collection of examples in live action without having to install anything!
- <a href="http://examples6x.wicket.apache.org">Wicket 6 examples</a> / <a href="http://examples7x.wicket.apache.org">Wicket 7 examples</a> - A special subset of live examples to show you how to use Wicket components.

[migrate3]: http://s.apache.org/wicket3migrate
[migrate4]: http://s.apache.org/wicket4migrate
[migrate5]: http://s.apache.org/wicket5migrate
[migrate6]: http://s.apache.org/wicket6migrate
[migrate7]: http://s.apache.org/wicket7migrate
[migrate8]: http://s.apache.org/wicket8migrate
