---
layout: section
title: Contribute
parent:
  title: Community
  url: /community/
summary: Wicket is built by the people who use it. Help with questions, bugs, the documentation, this site or the code.
---
{% assign site_pages = site.contribute | where: "topic", "site" | sort: "order" %}
{% assign wicket_pages = site.contribute | where: "topic", "wicket" | sort: "order" %}
<nav class="section-index" aria-label="On this page">
    <a href="#wicket">Wicket itself</a>
    <a href="#without-code">Without writing code</a>
    <a href="#site">The site and its documentation</a>
    <a href="#lists">Mailing lists</a>
</nav>

## Wicket itself {#wicket}

Wicket's code is in [apache/wicket](https://github.com/apache/wicket) on GitHub. Pick an [open issue](https://github.com/apache/wicket/issues), such as one labelled [`good first issue`](https://github.com/apache/wicket/issues?q=is%3Aissue%20state%3Aopen%20label%3A%22good%20first%20issue%22), or one you ran into yourself, and send the fix as a pull request against `master`. A committer reviews and merges it and copies a fix to the release lines it applies to. Since Wicket 11 a major release ships [every three months]({{ site.baseurl }}/versions/#release-policy), so a change merged today reaches users within a quarter. For a first contribution, start with the tutorial [Your first pull request]({{ site.baseurl }}/contribute/wicket-first-pull-request.html). The rules every contribution follows are in [CONTRIBUTING.md](https://github.com/apache/wicket/blob/master/CONTRIBUTING.md) in the repository.

{% include guide-list.html pages=wicket_pages kind=true %}

For committers, [Build a release]({{ site.baseurl }}/contribute/release.html) still describes the release process of Wicket 6 and older and needs an update.

## Without writing code {#without-code}

- Answer questions on the [users list]({{ site.baseurl }}/community/#user) or [Stack Overflow](https://stackoverflow.com/questions/tagged/wicket).
- Report a bug in the [issue tracker](https://github.com/apache/wicket/issues), with a [quickstart]({{ site.baseurl }}/start/quickstart.html) that shows it.
- Tell us where the [documentation]({{ site.baseurl }}/docs/) is unclear or wrong: every page has a link to improve it on GitHub.
- Show what you built on [Built with Wicket](https://builtwithwicket.tumblr.com/).

## The site and its documentation {#site}

This site and its documentation are Markdown files in [apache/wicket-site](https://github.com/apache/wicket-site). Start with the tutorial; the other pages cover the tasks that come up again.

{% include guide-list.html pages=site_pages kind=true %}

## Mailing lists {#lists}

The project discusses its plans, changes and releases on the [developers list]({{ site.baseurl }}/community/#dev), [dev@wicket.apache.org](mailto:dev@wicket.apache.org), with [its archive](https://lists.apache.org/list.html?dev@wicket.apache.org). Subscribe by sending a mail to [dev-subscribe@wicket.apache.org](mailto:dev-subscribe@wicket.apache.org).
