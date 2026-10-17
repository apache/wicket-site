---
layout: section
title: Community
summary: Ask the people who build with Wicket, report what is broken, and help make it better.
---
<nav class="line-panels" aria-label="What brings you here">
    <ul>
        <li><a href="#questions"><span class="line-panel-name">Ask a question</span><span class="line-panel-role">Mailing list, Slack or Stack Overflow</span></a></li>
        <li><a href="#reportbug"><span class="line-panel-name">Report a bug</span><span class="line-panel-role">In the issue tracker, with a quickstart</span></a></li>
        <li class="is-security"><a href="#security"><span class="line-panel-name">Report a vulnerability</span><span class="line-panel-role">Privately, to the PMC</span></a></li>
        <li><a href="{{ site.baseurl }}/contribute/"><span class="line-panel-name">Contribute</span><span class="line-panel-role">Code, documentation or this site</span></a></li>
    </ul>
</nav>

## Ask a question {#questions}

The [documentation]({{ site.baseurl }}/docs/) answers most questions; its search finds a class, a task or an error message. When it does not, ask the people who build with Wicket every day:

- **The users list**, [users@wicket.apache.org](mailto:users@wicket.apache.org), is where most questions get answered, by users and committers alike. Subscribe first by mailing [users-subscribe@wicket.apache.org](mailto:users-subscribe@wicket.apache.org); only subscribers can post. Twenty years of answers are in [its archive](https://lists.apache.org/list.html?users@wicket.apache.org).
- **Slack**: the **#wicket** channel on the [ASF Slack](https://the-asf.slack.com/) is for a quicker conversation, though time zones can make it quiet. Committers sign in with their apache.org account; anyone else joins as a guest by invitation, so ask for one on the users list. The ASF's [Slack guidelines](https://infra.apache.org/slack.html) explain how guest access works.
- **Stack Overflow** has years of answered questions under the [`wicket` tag](https://stackoverflow.com/questions/tagged/wicket).

Include your Wicket and Java versions and what you tried. A question with a few lines of code and the full stack trace gets a better answer, sooner.

### Commercial support {#commercial}

Several companies offer training, consulting and development for Wicket applications. The wiki keeps a [list of service providers](https://cwiki.apache.org/confluence/display/WICKET/Companies+that+provide+services). The Wicket project does not endorse or rank them.

## Report a bug {#reportbug}

Report bugs in the [issue tracker on GitHub](https://github.com/apache/wicket/issues). A report the committers can reproduce gets fixed first:

1. **Search first.** Look for your problem in the [open and closed issues](https://github.com/apache/wicket/issues?q=is%3Aissue), and in the [JIRA archive](https://issues.apache.org/jira/browse/WICKET) for issues from before 2026.
2. **Try the latest release of your line.** Your bug may already be fixed. If your line is [out of service]({{ site.baseurl }}/versions/), it gets no more fixes; reproduce it on a line in service.
3. **Reproduce it in a quickstart.** Generate a small project with the [quick start]({{ site.baseurl }}/start/quickstart.html) and add only what shows the problem. Often this alone reveals the cause; otherwise it is the fastest way for a committer to see it.
4. **Open the issue** with the Wicket version, the Java version and servlet container, the steps to reproduce, what you expected, the full stack trace, and a link to your quickstart, for example as a GitHub repository.

A failing test with [WicketTester]({{ site.baseurl }}/docs/first-test.html), or a pull request with the fix, is better still: see [Contribute]({{ site.baseurl }}/contribute/).

## Report a vulnerability {#security}

Never report a security problem in the issue tracker or on a mailing list: both are public. Send it to **[private@wicket.apache.org](mailto:private@wicket.apache.org?subject=Security%20issue)**, the private list of the Wicket PMC. Describe the problem, the versions it affects, and how to reproduce it.

The PMC follows the [ASF's process for vulnerabilities](https://www.apache.org/security/): it confirms the problem, fixes it in the lines in service, and publishes an advisory with a CVE on the [blog]({{ site.baseurl }}/news/) and the announce list once a fixed release is out. Only security reports belong on this list; for anything else, use the users list or the issue tracker.

## Mailing lists {#lists}

The project's lists, with their archives on [lists.apache.org](https://lists.apache.org/list.html?wicket.apache.org). Subscribe to a list by sending an empty mail to its subscribe address; only subscribers can post.

<table class="community-lists">
    <thead>
        <tr><th scope="col">List</th><th scope="col">For</th><th scope="col">Subscribe</th><th scope="col">Archive</th></tr>
    </thead>
    <tbody>
        <tr id="user"><th scope="row">users@</th><td>Questions and answers about using Wicket.</td><td><a href="mailto:users-subscribe@wicket.apache.org">users-subscribe@</a></td><td><a href="https://lists.apache.org/list.html?users@wicket.apache.org">Archive</a></td></tr>
        <tr id="dev"><th scope="row">dev@</th><td>Wicket's development: plans, changes, releases and votes.</td><td><a href="mailto:dev-subscribe@wicket.apache.org">dev-subscribe@</a></td><td><a href="https://lists.apache.org/list.html?dev@wicket.apache.org">Archive</a></td></tr>
        <tr id="announce"><th scope="row">announce@</th><td>Releases and security advisories only; only the PMC posts.</td><td><a href="mailto:announce-subscribe@wicket.apache.org">announce-subscribe@</a></td><td><a href="https://lists.apache.org/list.html?announce@wicket.apache.org">Archive</a></td></tr>
        <tr id="commit"><th scope="row">commits@</th><td>Every commit and issue update, sent automatically. Read only.</td><td><a href="mailto:commits-subscribe@wicket.apache.org">commits-subscribe@</a></td><td><a href="https://lists.apache.org/list.html?commits@wicket.apache.org">Archive</a></td></tr>
    </tbody>
</table>

Releases and advisories also appear on the [blog]({{ site.baseurl }}/news/) and in its [Atom feed]({{ site.baseurl }}/atom.xml).

## Contribute {#contribute}

Wicket is built by the people who use it, and help is welcome at every level: answering a question, improving a page of the documentation, fixing a bug. [Contribute]({{ site.baseurl }}/contribute/) shows where to start.

## Built with Wicket {#built-with-wicket}

Many applications run on Wicket without saying so. Show yours on [Built with Wicket](https://builtwithwicket.tumblr.com/).

## The project {#project}

Apache Wicket is a project of the [Apache Software Foundation]({{ site.baseurl }}/apache/), run by its [Project Management Committee](https://projects.apache.org/committee.html?wicket) and developed in the open by its committers and contributors. Everyone taking part follows the ASF's [code of conduct](https://www.apache.org/foundation/policies/conduct).
