---
layout: default
title: Improve Wicket with fixes and new features!
---

# So you have found a bug... {#reportbug}

As developers we all strive to produce a flawless software. However, in
the real world we might find that our code contains errors or bugs.
Wicket like many other Apache projects uses
[JIRA](https://issues.apache.org/jira/browse/WICKET) to track bugs and
new feature. If you think you have found a bug follow these simple
steps before opening a new issue on JIRA:

* Test the very last version of Wicket to see if the bug was already
  fixed

* Search [JIRA](https://issues.apache.org/jira/browse/WICKET) and the
  mailing list to see if it's already been discussed

* Simply ask to the [devs](mailto:dev@wicket.apache.org) mailing list
  if you are unsure.

## Create and set an issue on JIRA ##

Either you have spotted a bug or you want to propose a new feature, the
first thing to do is to create and set an issue on JIRA with the
following steps:

* Create a new [JIRA
  issue](https://issues.apache.org/jira/browse/WICKET). The issue might
  alredy exist if you have found a regression.

* Write a short description of the issue. If this one is a bug, report
  the affected version as well.

* [Create a quickstart](../start/quickstart.html) that you can use for
  prototyping the feature or demonstrating the bug.

## Time for some coding ##

Wicket uses [Git](http://git-scm.com/) as versioning system, so you
need to have it properly installed and configured to start work on
Wicket code base. The main git repository is hosted on [Apache git
server](https://git-wip-us.apache.org/repos/asf/wicket.git) but is
mirrored on [GitHub](https://github.com/apache/wicket). To work on
Wicket code you can decide to create a pull request forking the GitHub
mirror or you can clone the official repository and generate a patch
file.

**NOTE:** when you are working on Wicket code, please follow our code
format rules. You can find them [inside wicket-core
module](https://github.com/apache/wicket/blob/master/wicket-core/Eclipse
CodeFormat.xml) as Eclipse code formatter profile.

**NOTE:** when you are using Eclipse IDE, please ensure that you have
installed "M2E Settings" from the Eclipse Marketplace in addition to
the format rules.

### Create a pull request {#github}

To create a pull request on GitHub follow the instructions you can find
[here](https://help.github.com/articles/creating-a-pull-request/). Once
you have finished to work on you pull request, send us an email using
[devs](mailto:dev@wicket.apache.org) mailing list.

All Pull Requests are automatically tested at 
[Github Actions](https://github.com/apache/wicket/actions) on AMD64 and
at [TravisCI](https://travis-ci.com/github/apache/wicket/) on ARM64 platform.

### Create a patch ###

If you prefer to work on our main repository, [clone it with
Git](../start/download.html#snapshots-and-latest-bleeding-edge-code)
and when you have finished your work create a patch with the following
commands:

{% highlight console %}
git add any_files_you_created_modified_or_deleted
git diff --cached > /tmp/WICKET-NNNN.patch
{% endhighlight %}

where NNNN is the issue number. Finally, attach that file
(/tmp/WICKET-NNNN.patch) to the
[JIRA](https://issues.apache.org/jira/browse/WICKET)
