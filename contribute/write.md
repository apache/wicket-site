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
* [Check out from SVN](#checkout)
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

## Check out from SVN ## {#checkout}

Before you can edit the site, you need to check it out from SVN:

{% highlight console %}
svn co https://svn.apache.org/repos/asf/wicket/common/site/trunk wicket-site
{% endhighlight %}

## Generating the site ## {#generate}

You can regenerate the site in the checked out directory:

{% highlight console %}
./regenerate.sh
{% endhighlight %}

Note that this script restores Subversion (`.svn`) subfolders
inside `_site`, which are erased when Jekyll is generating the content.

## Run the site ## {#run}

You can run the website and edit it live:

{% highlight console %}
./liveedit.sh
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

Example preamble (includes the `---`):

{% highlight yaml %}
---
layout: default
title: Write documentation
---
{% endhighlight %}

### Syntax highlighting ###

If you have a need to render code in your templates and have it syntax
highlighted, surround the code with \{\% highlight java \%\} (substitute java
with the language you want highlighted.)

### Menu ###

If you want your page linked from every page, include the link in
`_includes/navigation.html`.

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
  publish? (Use `svn diff` to check)
* Did you restart Jekyll to generate the site?

If these things are OK, you can either [generate a patch](patch.html) when
you're not a committer, or just commit the changes. In the latter case, the
modifications are pushed immediately to the site and are live within a minute.
