---
layout: default
title: Write documentation
---

We use [Jekyll](http://github.com/mojombo/jekyll) for writing our
documentation on our main website. Publishing new content is as simple as
regenerating the site and committing the changed files.

## Contents ##

* [Introduction](#introduction)
* [Install Jekyll](#install)
* [Clone wicket-site](#clone)
* [Run the site](#run)
* [Write some documentation](#write)
* [Update the site](#update)

## Introduction ## {#introduction}

The site is split into two parts: static content and the official Apache
Wicket blog. The static content contains all the documentation that is more
static (such as mailing lists, downloads, examples). The blog includes release
announcements, adding new committers and other important Wicket related news.

## Install Jekyll ## {#install}

Follow the instructions available on the [Jekyll
website](http://github.com/mojombo/jekyll). Basically it boils down to:

{% highlight console %}
gem install jekyll
{% endhighlight %}

You also need to install the Pygments Python module.

## Clone wicket-site ## {#clone}

Before you can edit the site, you need to clone it:

{% highlight bash %}
git clone git@github.com:apache/wicket-site.git
{% endhighlight %}

## Run the site ## {#run}

You can run the website and edit it live:

{% highlight console %}
jekyll serve -w
{% endhighlight %}

This not only runs the server, but watches for modifications and regenerates
any modified files.

You can check out the website running at [localhost, port 4000](http://localhost:4000).

## Write some documentation ## {#write}

Jekyll can render HTML from markdown syntax and textile syntax. **For our site
we use markdown**. 

### Page template ###

Each page needs to have a YAML preamble that specifies the rendered template
and other variables. If it doesn't include the YAML preamble, it won't be
rendered correctly.

The default layout supports a property to specify the main title for the page and 
another property for an additional subtitle.

For example: (the `---` must be included):

{% highlight yaml %}
---
layout: default
title: Main title
subtitle: Subtitle
---
{% endhighlight %}

A more advanced feature for the default layout is the ability to specify more files to include
in the final page. This can be done with property `additionalContents` where we can list additional files
with an id for their section tag and a value for the CSS class:

{% highlight yaml %}
---
layout: default
title: Welcome to Apache Wicket
subtitle: Discover why developers love Wicket!
additionalContents:
  -
   path: anotherPage.html
   sectionId: anotherPage
   cssClass: sectionClass
  -
   path: yetAnotherPage.html
   sectionId: yetAnotherPage
   cssClass: yetAnotherSectionClass
---
{% endhighlight %}

#### Additional conventions ####

The following conventions have been adopted for the templeates of the site pages:

* Any link to static resources (css, js, pictures, etc.) is prefixed with `site.baseurl` to support [GitHub free hosting](http://jekyllrb.com/docs/github-pages/#project-page-url-structure). However, to run the project locally you don't need to specify any baseurl.
* Site posts use custom tag `<!--more-->` as `excerpt_separator`.

### Syntax highlighting ###

If you have a need to render code in your templates and have it syntax
highlighted, surround the code with \{\% highlight java \%\} (substitute java
with the language you want highlighted.)

### Menu ###

If you want your page linked from every page, include the link in
`_includes/header.html`.

### Blog posts ###

For news items such as release announcements, new committers and other
happenings, it is appriorate to create a blog post. The blog post is
automatically added to the front page and the RSS feed.

The blog items are written using the normal Jekyll syntax. The filename needs
to be formatted as `yyyy-mm-dd-title.md` and the blog item should start with a
YAML preamble, similar to normal pages:

{% highlight yaml %}
---
layout: post
title: Wicket 1.4.7 released
---
{% endhighlight %}

## Update the site ## {#update}

When you're done with making your changes, please check the following:

* Do the modified files contain only those changes that you actually want to
  publish? (Use `git status` to check)
* Did you start Jekyll to generate the site?

If these things are OK, you can either create a pull request when
you're not a committer, or just commit the changes. In the latter case, the
modifications are pushed immediately to the site and are live within a minute.
