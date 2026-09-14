---
layout: post
title: A new release cadence for Apache Wicket
---

Starting with Apache Wicket 11.0, due in the first week of October 2026, Wicket moves to
time-based releases: a new major release every three months, and an LTS release once a
year. We will do one more release of the 8.x and 9.x branches and then stop supporting
those versions entirely, and with them the `javax.servlet` API. Wicket 10 is our current
LTS and remains supported until the release of Wicket 14, expected in the first week of
July 2027.

Nothing changes before 11.0 is out. Until then, 10.x, 9.x and 8.x are supported as they
are today.

<!--more-->

Why we are changing this
------------------------

Wicket has been around for over twenty years. Where it used to have a very vibrant and
active community, development and contributions have slowed down over the past ten years.
Partly this is because Wicket has a stable and solid core that simply doesn't need that
much maintenance, but it is also caused by the world moving more to JavaScript-heavy,
client-side frameworks. That slowdown also slowed the release cadence, which in turn made
it less attractive to contribute, causing even more slowdown.

Over the past six months we have seen a sharp rise in LLM-generated security reports. This
helps improve security, but dealing with CVEs takes a lot of time, and that time is
currently multiplied by four because of the old versions we support. Time spent on
backporting, releasing and documenting those old versions is time not spent on improving
Wicket itself.

At the same time, LLMs allow us to perform cleanups and improvements at a larger scale.
With major versions years apart, our promise of semantic versioning makes it impossible to
deliver those changes to our community in a timely manner.

The new cadence
---------------

One major release every three months, each bringing new features. Every fourth major
release — once a year — is an LTS release with bugfix and security support until the next
LTS. This means we only need to support two active versions at the same time.

In practice that gives the following schedule:

 * Wicket 11.0.0 — first week of October 2026
 * Wicket 12.0.0 — January 2027
 * Wicket 13.0.0 — April 2027
 * Wicket 14.0.0 — first week of July 2027, our second LTS release, supported
   until Wicket 18

Wicket 10 is our first LTS release line and stays supported until Wicket 14 is released.
Wicket 8 and Wicket 9 each get one more release, after which both are end of life, and
with them our support for the `javax.servlet` API. Applications on 8.x or 9.x should plan
their move to 10.x or 11.x now; the [migration guide](https://s.apache.org/wicket10migrate)
covers the step to Wicket 10.

What "supported until the next major release" means
---------------------------------------------------

A question from the user list, worth answering here as well: if there is a major release
every quarter, is a feature introduced in one quarter supported for only three months?

No. The support period applies to the release line, not to individual features. New
features are developed on `main` and will normally remain part of subsequent releases, so
a feature introduced in Wicket 11 will also be present in 12, 13 and eventually in the
next LTS release, Wicket 14. What changes is which release lines receive fixes.

We will develop on `main` and on the current LTS branch. The LTS branch receives security
fixes and applicable bug fixes until the next LTS release. For the quarterly non-LTS
releases, only the latest release receives fixes: when Wicket 12 is released we will no
longer release fixes for Wicket 11, and when Wicket 13 is released the same applies to
Wicket 12.

Bug fixes and security fixes on `main` will normally be included in the next quarterly
release. If an issue is serious enough that it cannot wait, we may do a patch release for
the current non-LTS version, for example 13.0.1.

So at any point we expect to maintain at most two release lines: the current LTS and the
current quarterly release.

Stability
---------

A large number of applications build on the stability of the Wicket API. This is no
different for our community than it is for the team of core developers. That stability is
important to the entire Wicket ecosystem and something we do not take lightly. For some
changes we do need to break the API, but it is something we will only do if it is really
needed. Where possible we will keep the old API as a deprecated alternative for some time
to ease migration. API changes are documented in our migration guide.

— The Apache Wicket PMC
