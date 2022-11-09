---
layout: default
title: Documentation
subtitle: All the things you want to know about Wicket but are afraid to ask
preamble: No matter how you want to learn about Wicket, there's something available for you. If you want a quick reference, use the User Guide. If you rather prefer a book, there's a couple waiting for you. And if you rather watch a video or presentation, we have that covered too.
---
<div class="l-button-table">
    <div class="l-two-third">
        <div class="button-bar">
        	<a class="button" href="#news"><i class="fa fa-newspaper-o"></i><br>News</a>
        	<a class="button" href="blogs.html"><i class="fa fa-rss"></i><br>Blogs</a>
        	<a class="button" href="https://cwiki.apache.org/WICKET"><i class="fa fa-users"></i><br>Wiki</a>
        </div>
        <div class="button-bar">
        	<a class="button" href="#guide"><i class="fa fa-file-text-o"></i><br>User Guide</a>
        	<a class="button" href="#javadoc"><i class="fa fa-code"></i><br>API docs</a>
        	<a class="button" href="books/index.html"><i class="fa fa-book"></i><br>Books</a>
        </div>
        <div class="button-bar">
        	<a class="button" href="#migrations"><i class="fa fa-history"></i><br>Migrations</a>
        	<a class="button" href="#presentations"><i class="fa fa-file-powerpoint-o"></i><br>Presentations</a>
        	<a class="button" href="#ides"><i class="fa fa-terminal"></i><br>IDEs</a>
        </div>
        
        <div class="button-bar">
        	<a class="button" href="#courses"><i class="fa fa-graduation-cap"></i><br>Online courses</a>
        	<div class="button"></div>
        	<a class="button" href="#examples"><i class="fa fa-life-ring"></i><br>Support &amp; Examples</a>
        </div>
    </div>
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


1.  Wicket 9.x
* [HTML (single page)](https://nightlies.apache.org/wicket/guide/9.x/single.html)
* [PDF](https://nightlies.apache.org/wicket/guide/9.x/single.pdf)

2.  Wicket 8.x
* [HTML (single page)](https://nightlies.apache.org/wicket/guide/8.x/single.html)
* [PDF](https://nightlies.apache.org/wicket/guide/8.x/single.pdf)

3.  Wicket 7.x
* [HTML (single page)](https://nightlies.apache.org/wicket/guide/7.x/single.html)
* [PDF](https://nightlies.apache.org/wicket/guide/7.x/single.pdf)

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

- [JavaDoc 9.x](https://nightlies.apache.org/wicket/apidocs/9.x/index.html)
- [JavaDoc 8.x](https://nightlies.apache.org/wicket/apidocs/8.x/index.html)
- [JavaDoc 7.x](https://nightlies.apache.org/wicket/apidocs/7.x/index.html)

---

## Migration Guides {#migrations}

When you upgrade your application from an older Wicket version to a
newer version you can run into all of the changes that were applied to
Wicket's API. We have done our best to document all the changes and
provide migration paths between the different Wicket versions.

Here's a list of the migration guides:
<div class="l-button-table">
    <div class="l-two-third">
        <div class="button-bar">
            <a class="button" href="https://s.apache.org/wicket9migration">
                Wicket 9<br>
        		migration guide
            </a>
            <a class="button" href="https://s.apache.org/wicket8migration">
                Wicket 8<br>
        		migration guide
            </a>
            <a class="button" href="https://s.apache.org/wicket7migrate">
                Wicket 7<br>
        		migration guide
            </a>
        </div>
    </div>
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

---

## Online courses {#courses}

- <a href="https://www.udemy.com/course/apache-wicket-kompakt/">Apache Wicket Kompakt</a> - A complete German-based course with many pratical examples.
- <a href="https://www.udemy.com/course/starting-with-apache-wicket-version-9x/?referralCode=C2A6EF19A72071AA2E22">Starting with Apache Wicket (version 9.x+)</a> - Get started with Apache Wicket 9.x+ with forms, components, MongoDB, GridFS and backed by SpringBoot.

---

## Presentations {#presentations}

New to Wicket and eager to learn it? This [presentation]({{ site.baseurl }}/learn/presentations/wicketIntroduction.pdf) is for you!

[migrate7]: https://s.apache.org/wicket7migrate
[migrate8]: https://s.apache.org/wicket8migrate
