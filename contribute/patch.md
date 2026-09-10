---
layout: default
title: Improve Wicket with fixes and new features!
---

# So you have found a bug... {#reportbug}

As developers we all strive to produce a flawless software. However, in
the real world we might find that our code contains errors or bugs.
Wicket tracks bugs and new features in [GitHub
Issues](https://github.com/apache/wicket/issues). If you think you have
found a bug follow these simple steps before opening a new issue:

* Test the very last version of Wicket to see if the bug was already
  fixed

* Search [our issues](https://github.com/apache/wicket/issues?q=is%3Aissue)
  and the mailing list to see if it's already been discussed. Issues
  reported before 2026 live in our read-only [JIRA
  archive](https://issues.apache.org/jira/browse/WICKET), which is worth
  searching too.

* Simply ask to the [devs](mailto:dev@wicket.apache.org) mailing list
  if you are unsure.

## Create an issue ##

Either you have spotted a bug or you want to propose a new feature, the
first thing to do is to create an issue with the following steps:

* Create a new [issue](https://github.com/apache/wicket/issues/new). The
  issue might already exist if you have found a regression.

* Write a short description of the issue. If this one is a bug, report
  the affected version as well.

* [Create a quickstart](../start/quickstart.html) that you can use for
  prototyping the feature or demonstrating the bug.

## Time for some coding ##

Wicket uses [Git](http://git-scm.com/) as versioning system, so you
need to have it properly installed and configured to start work on
Wicket code base. The repository lives on
[GitHub](https://github.com/apache/wicket), and contributions reach us
as pull requests against it.

**NOTE:** when you are working on Wicket code, please follow our code
format rules. You can find them inside wicket-core module as Eclipse code formatter profile.

**NOTE:** when you are using Eclipse IDE, please ensure that you have
installed "M2E Settings" from the Eclipse Marketplace in addition to
the format rules.

### Create a pull request {#github}

To create a pull request on GitHub follow the instructions you can find
[here](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork).
Mention the issue your work addresses in the description, so that the
pull request and the issue link up. Once you have finished to work on
your pull request, send us an email using the
[devs](mailto:dev@wicket.apache.org) mailing list.

All Pull Requests are automatically tested at 
[Github Actions](https://github.com/apache/wicket/actions) on AMD64 and
at [TravisCI](https://travis-ci.com/github/apache/wicket/) on ARM64 platform.
