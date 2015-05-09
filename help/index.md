---
layout: default
title: Get help
---

There are two types of help available for Apache Wicket:

1. Support from the Apache Wicket open source project
2. Commercial Support

## Support From the Apache Wicket Open Source Project ##

If you are experiencing problems using Wicket please report your problem via
the Issue Tracker. You may also find it useful to discuss your issues with the
community on one of the Mailing Lists. Below are some resources to check
before asking for help:

* [Mailing Lists](email.html)
* [Issue Tracker](https://issues.apache.org/jira/browse/WICKET)
* [IRC](irc://irc.freenode.net/%23%23wicket)

Before asking for help with your issue, it's a very good idea to search for
your issue in the mailing list archives and the FAQ. The majority of issues
can be solved in this manner without having to send an email to the mailing
list. If you don't find an answer, use the guidelines below when writing the
e-mail.

### How to Get Help ###

Whenever you are reporting a problem, please be sure to include as much
information as possible; the more we know, the better the chance of a quicker
resolution.

* which version of the software
* what platform and JDK
* any particular JEE container being used - if so what version
* stack traces generally really help! If in doubt include the whole thing;
  often exceptions get wrapped in other exceptions and the exception right
  near the bottom explains the actual error, not the first few lines at the
  top. Its very easy for us to skim-read past unnecessary parts of a stack
  trace.
* log output can be useful too; sometimes enabling DEBUG logging can help your
  code & configuration files are often useful

### How to get help faster ###

We can help you much quicker if you try the following

* provide us with a JUnit test case that demonstrates your issue. e.g. if you
  think you've found a bug, can you create a test case to demonstrate the bug?
* submit a patch fixing the bug! (We also buy you beer when we meet you if you
  submit bug fixes for memory leaks or performance related issues, if you can
  run a profiler on your test case and attach the output as a file (or zipped
  file if its huge) to the JIRA we can normally fix things much faster. e.g.
  run JProfiler or YourKit on your code and send us the output. To find memory
  leaks its quicker to resolve if you can tell us what classes are taking up
  all of the RAM; we can normally figure out whats wrong from that.

## Commercial Support ##

The list of companies found at [this wiki
page](https://cwiki.apache.org/confluence/display/WICKET/Companies+that+provide+services)
provide commercial services for Wicket which ranges from training courses,
consultancy and even project development.

Being mentioned here is not an indication of official "endorsement" by the
Apache Software Foundation, but is instead provided as a public service. This
list is in no way a complete listing of the many organizations providing
either free or for cost support for ASF projects. If you would like to be
added to this list, or removed, sign up for the wiki and add yourself to the
list.
