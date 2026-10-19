---
layout: section
title: Contribute
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

Wicket's code is in [apache/wicket](https://github.com/apache/wicket) on GitHub. Pick an [open issue](https://github.com/apache/wicket/issues) or one you ran into yourself, and send the fix as a pull request: a committer reviews and merges it, and it goes out with the next release of its line. Since Wicket 11 a major release ships [every three months]({{ site.baseurl }}/versions/#release-policy), so a change merged today reaches users within a quarter. New features go to `master`, the next major release; fixes the LTS needs go to `wicket-10.x` as well.

{% include guide-list.html pages=wicket_pages kind=true %}

- [Build from source]({{ site.baseurl }}/contribute/build.html): check out a branch, build it with Maven and use your own build.
- [Set up your IDE]({{ site.baseurl }}/contribute/ides.html): import the projects into Eclipse, IntelliJ IDEA or NetBeans, with the code format.
- [Fix a bug or add a feature]({{ site.baseurl }}/contribute/patch.html): from an issue to a pull request.
- For committers, [Build a release]({{ site.baseurl }}/contribute/release.html) still describes the release process of Wicket 6 and older and needs an update.

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
