---
layout: post
title: Wicket 8 and 9 reach end of life soon
description: Wicket 8.x and 9.x each get one final release and then reach end of life, and with them Wicket's support for javax.servlet. Move to Wicket 10 LTS, supported until July 2027.
lines: ["9", "8"]
announces: end-of-life
---

Apache Wicket 8.x and 9.x each get one final release, and then reach end of life. After
that they get no more releases, not even security fixes, and Wicket's support for the
`javax.servlet` API ends with them. We announce the final releases on the
[announce list]({{ site.baseurl }}/community/#announce) and here on the blog. If your
application runs on Wicket 8 or 9, plan the move to Wicket 10 now: it is our long-term
support release, supported until July 2027.

<!--more-->

What end of life means
----------------------

Until their final release, 8.x and 9.x are supported as they are today. After it:

 * no new 8.x or 9.x release ships, for bugs or for vulnerabilities;
 * every release stays available: on Maven Central, and in the
   [Apache archives](https://archive.apache.org/dist/wicket);
 * the [users list]({{ site.baseurl }}/community/#user) still helps with questions, but a
   fix for a problem in 8 or 9 only ships in the lines we still support.

Why we stop
-----------

We announced this with the [new release cadence]({{ site.baseurl }}/news/2026/09/11/release-cadence.html).
Every security report has to be assessed, fixed, backported and released for each line we
support. With four lines that work is done four times, and that is time not spent on
improving Wicket itself. Retiring 8 and 9 ends that.

Wicket 8 and 9 are also the last lines on `javax.servlet`. The Java world moved to the
`jakarta` namespace, and Wicket 10 moved with it.

How to move to Wicket 10
------------------------

Wicket 10 requires Java 17 and Jakarta Servlet 5.0 or newer, and its integrations move
along: Spring 6, Guice 7 and Commons FileUpload 2.

 * **From Wicket 9**, move to 10 directly with the
   [migration guide to Wicket 10](https://s.apache.org/wicket10migrate). The
   [OpenRewrite recipes of `wicket-migration`]({{ site.baseurl }}/versions/wicket-10.x/#automatic-migration)
   do the repetitive part: the `jakarta` imports, the Java 17 baseline and the moved Wicket
   classes.
 * **From Wicket 8**, take the Wicket 9 step first, with the
   [migration guide to Wicket 9](https://s.apache.org/wicket9migration) and Java 11. Each
   migration guide covers one major version, so the step to 10 follows from there.

The [upgrade paths]({{ site.baseurl }}/versions/#upgrade-paths) on the releases page show
the route, and the pages of [Wicket 9]({{ site.baseurl }}/versions/wicket-9.x/) and
[Wicket 8]({{ site.baseurl }}/versions/wicket-8.x/) carry it as well.

Need help?
----------

Ask on the [users list]({{ site.baseurl }}/community/#user) when the migration raises
questions; include your Wicket and Java versions. If you need more hands or more time,
[several companies](https://cwiki.apache.org/confluence/display/WICKET/Companies+that+provide+services)
offer training, consulting and development for Wicket applications. The Wicket project
does not endorse or rank them.
