---
layout: post
date: 2026-10-26 11:00:00 +0100
title: Wicket 8 and 9 have reached end of life
description: With their final releases 9.25.0 and 8.20.0, Wicket 9 and 8 have reached end of life, and with them Wicket's support for javax.servlet. Move to Wicket 10 LTS, supported until July 2027, or to Wicket 11.
lines: ["9", "8"]
announces: end-of-life
---

Today, together with [Wicket 11.0.0]({{ site.baseurl }}/news/2026/10/26/wicket-11.0.0-released.html),
we released Apache Wicket 9.25.0 and 8.20.0: the final releases of both lines. Wicket 9 and 8
have now reached end of life. They get no more releases, not even security fixes, and
Wicket's support for the `javax.servlet` API ends with them. If your application runs on
Wicket 8 or 9, move to Wicket 10, our long-term support release, supported until July 2027,
or on to Wicket 11 for new features every quarter.

<!--more-->

What end of life means
----------------------

From today:

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
improving Wicket itself. Retiring 8 and 9 brings it back to two lines: the LTS and the
current quarterly release.

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

Once on Wicket 10, the step to [Wicket 11]({{ site.baseurl }}/versions/wicket-11.x/) is your
JDK and your container: it needs Java 21 and Jakarta Servlet 6.1.

Need help?
----------

Ask on the [users list]({{ site.baseurl }}/community/#user) when the migration raises
questions; include your Wicket and Java versions. If you need more hands or more time,
[several companies](https://cwiki.apache.org/confluence/display/WICKET/Companies+that+provide+services)
offer training, consulting and development for Wicket applications. The Wicket project
does not endorse or rank them.
