---
layout: default
title: How to Get Help for Apache Wicket
subtitle: When the documentation and google are not enough
preamble: >
  Apache Wicket has a very helpful community with over 10 years of
  development and thousands of developers working day in and out
  building great Wicket applications. As they have received help from
  other developers, many want to return the favour and answer your
  questions. This document helps you find the various venues of asking
  your question and helping others, reporting a security problem and
  reporting a bug.
---
<div class="l-button-table">
    <div class="l-two-third">
      <div class="button-bar">
        <a class="button" href="#security"><i class="fa fa-lock"></i><br>Security</a>
        <a class="button" href="#reportbug"><i class="fa fa-bug"></i><br>Report a bug</a>
      </div>
      <div class="button-bar">
        <a class="button" href="#questions"><i class="fa fa-question-circle"></i><br>Get help</a>
        <a class="button" href="#commercial"><i class="fa fa-ambulance"></i><br>Commercial support</a>
      </div>
    </div>
</div>  

## We are here to Help {#questions}

There are a lot of venues to ask questions about Wicket. The most
obvious one is of course asking a search engine. But when you can't
find an answer or are unable to ask the right question, discussing it
with a human being is really the way to go.

The following list gives you the options for asking your questions (and
maybe even answer a couple) about Wicket:

- [Our mailing lists](email.html) provide a quick and easy way to ask
  questions to our grander community. Many Wicket developers have
  subscribed to our User list and want to help you!

- [Our IRC channel](irc.html) **##wicket** at _irc.freenode.net_
  provides a more direct discussion platform. Note that time zones can
  make it difficult to find activity in the channel.

- <a href="http://stackoverflow.com/questions/tagged/wicket" 
  rel="nofollow" title="Goes to Stackoverflow website">Stackoverflow</a> provides a
  modern Q&amp;A experience with a helpful community.

Whichever you choose, remember to [ask your questions the right
way](http://www.catb.org/esr/faqs/smart-questions.html).

---

## Report A Security Problem {#security}

{% capture security %}{% include security.md %}{% endcapture %}
{{ security | markdownify }}

---

## Report a Bug for Apache Wicket {#reportbug}

If you are experiencing problems using Wicket please report your
problem via the [Issue
Tracker](https://issues.apache.org/jira/browse/WICKET). You may also
find it useful to discuss your issues with the community on one of the
Mailing Lists. 

Before asking for help with your issue, it's a very good idea to search
for your issue in the mailing list archives and the FAQ. The majority
of issues can be solved in this manner without having to send an email
to the mailing list. If you don't find an answer, use the guidelines
below when writing the e-mail.

### Checklist for Reporting a Bug

Please use the following checklist before reporting a bug:

- Search for a reported, existing bug
- Use the latest release of your Wicket version
- Use compatible versions of supporting libraries
- Try reproducing it in a quick start
- Create a report in our issue tracker

While not mandatory, we will ask you these questions in your bug report
anyway, so you might as well get them out of the way.

### Search for a Reported, Existing Bug {#searchbug}

A lot of developers use Wicket, and chances are someone already
encountered your issue. So please search for some keywords of your
problem using a search engine,
[stackoverflow](http://stackoverflow.com/questions/tagged/wicket) and our
[issue tracker](https://issues.apache.org/jira/browse/WICKET).

If someone already found your bug, look at how the bug was resolved. If
it wasn't resolved, note what they already tried and add your own
experience to it, possibly including a [quick start](#bugquickstart).

### Using the Latest Release of Wicket {#latestrelease}

Wicket releases new versions on a regular basis. Chances are that your
bug has been solved in a recent version. So if for instance you
discover a bug in Wicket 6.2.0, it might be fixed in a newer version
(the current version of Wicket 6.x is {{ site.wicket.version_60}}).

So we ask you to try the latest version of the branch of Wicket you are
working on. If the bug still remains,  

Check if your version is no longer maintained on our download page. If
your version is no longer maintained we kindly ask you to upgrade your
project to a newer, maintained version of Wicket. For example if you
have a project that depends on Wicket 1.3.7, please consider upgrading
to Wicket {{site.wicket.version}}. 

### Using Compatible Versions of Supporting Libraries {#compatible}

If you are using a supporting library from either the Wicket project,
Wicket Stuff or another project, please ensure that the version you use
is compatible with your Wicket version.

You can't use Wicket 1.5.x libraries with Wicket 6.x, Wicket 7.x or Wicket 8.x. It
should be safe to use a library compatible with Wicket 6.0 with
{{site.wicket.version_60}}

For example:

- wicket-extensions-1.5.12.jar is not compatible with wicket-core-{{site.wicket.version_60}}

Possible, but not advisable:

- wicket-extensions-6.10.0 should be compatible with wicket-core-{{site.wicket.version_60}}

Advised:

- Use wicket-extensions-{{site.wicket.version_60}} with wicket-core-{{site.wicket.version_60}}

This also holds true for release of our sister project _Wicket Stuff_.

### Provide a Quick Start {#bugquickstart}

When you encounter an unexpected behavior this can be a bug in Wicket.
But to be certain it is not caused by something else we kindly ask you
to try to reproduce your bug in a Quick Start project.

A Quick Start project is generated using our [online commandline
generator](../start/quickstart.html) that creates a Maven project with a simple Wicket
application. This is a very minimal setup ideal to try to reproduce
your problem in an isolated way.

The benefits for having your problem reproduced in a minimal Quick
Start application are many:

- while trying to reproduce the issue you might discover it is caused
  by something completely different, not related to Wicket

- you can easily provide instructions to reproduce the problem instead
  of having to give the Wicket developers a manual to your application

- an isolated application that shows your problem makes it easier for
  Wicket developers to debug the issue without having to reproduce your
  particular development/test/production environment
  
- a small, focused application lets Wicket developers read the code at
  hand much easier without having to wade through thousands lines of
  code

Providing a Quick Start with your problem helps us resolve the bug much
quicker.

### Create a Report in our Issue Tracker {#createreport}

Whenever you are reporting a problem, please be sure to include as much
information as possible; the more we know, the better the chance of a
quick resolution.

* The version of Wicket and the libraries you use
* Which operating system and JDK
* Any particular JEE container being used - if so what version
* Stack traces generally really help! If in doubt include the whole
  thing; often exceptions get wrapped in other exceptions and the
  exception right near the bottom explains the actual error, not the
  first few lines at the top. Its very easy for us to skim-read past
  unnecessary parts of a stack trace.
* Log output can be useful too; sometimes enabling DEBUG logging can
  help your code & configuration files are often useful

### How to Get Help Faster {#faster}

We can help you much quicker if you try the following

* Provide us with a JUnit test case that demonstrates your issue. e.g.
  if you think you've found a bug, can you create a test case to
  demonstrate the bug?
* Submit a patch fixing the bug! (We also buy you beer when we meet you
  if you submit bug fixes for memory leaks or performance related
  issues, if you can run a profiler on your test case and attach the
  output as a file (or zipped file if its huge) to the JIRA we can
  normally fix things much faster. e.g. run JProfiler or YourKit on
  your code and send us the output. To find memory leaks its quicker to
  resolve if you can tell us what classes are taking up all of the RAM;
  we can normally figure out whats wrong from that.

Help us help you!

When you want more direct support, you can consider hiring commercial
support.

---

{% include support.md %}

