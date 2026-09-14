---
layout: default
title: Download Apache Wicket
subtitle: Get the most recent version of Wicket in one source package
preamble: Wicket is released as a source archive, convenience binaries and through the Maven Central Repository. The most convenient way of getting Wicket is through the Maven dependency management system.
---

<div class="l-button-table">
    <div class="l-two-third">
        <div class="button-bar">
        	<a class="button" href="wicket-10.x.html">
        		<i class="fa fa-cloud-download"></i><br>
        		Apache Wicket 10.x
        	</a>
        	<a class="button" href="wicket-9.x.html">
        		<i class="fa fa-cloud-download"></i><br>
        		Apache Wicket 9.x
        	</a>
        </div>
        <div class="button-bar">
        	<a class="button" href="wicket-8.x.html">
        		<i class="fa fa-cloud-download"></i><br>
        		Apache Wicket 8.x
        	</a>
        	<a class="button" href="wicket-7.x.html">
        		<i class="fa fa-cloud-download"></i><br>
        		Apache Wicket 7.x
        	</a>
        </div>
    </div>
</div>
## Supported Versions

The following releases are supported by the Wicket team.

<table style="width:100%">
	<tr>
		<th style="width:30%">Version</th>
		<th style="width:30%">Latest release</th>
		<th style="width:40%">Status</th>
	</tr>
	<tr>
		<td><a href="wicket-10.x.html">Wicket 10.x</a></td>
		<td>{{site.wicket.version_10}}</td>
		<td>current, supported</td>
	</tr>
	<tr>
		<td><a href="wicket-9.x.html">Wicket 9.x</a></td>
		<td>{{site.wicket.version_90}}</td>
		<td>one final release, then end of life &mdash; upgrade to 10.x or 11.x</td>
	</tr>
	<tr>
		<td><a href="wicket-8.x.html">Wicket 8.x</a></td>
		<td>{{site.wicket.version_80}}</td>
		<td>one final release, then end of life &mdash; upgrade to 10.x or 11.x</td>
	</tr>	
</table>

However, if your application is not on the current branch, you should
consider upgrading at your earliest convenience.

---

## Release Policy

With the release of Wicket 11.0.0, in the first week of October 2026, Wicket moves to a
time-based release schedule: a new major release every three months, and every fourth
major release &mdash; once a year &mdash; is a long term support (LTS) release. The table
above describes the situation today; the schedule below takes effect when 11.0.0 is
released.

Two release lines are maintained at any time:

* the current **LTS** release, which receives security fixes and applicable bug fixes
  until the next LTS release;
* the current **quarterly** release, which receives fixes until the next quarterly
  release supersedes it. Fixes normally ride along with that next release; a serious
  issue may warrant a patch release, for example 13.0.1.

The support window applies to the release line, not to individual features. Features are
developed on `main` and carry over into every following release, so a feature introduced
in Wicket 11 is also present in 12, 13 and in the next LTS, Wicket 14.

Wicket 10 is the current LTS and stays supported until Wicket 14 is released in the first
week of July 2027. Wicket 8.x and 9.x each receive one final release and are then end of
life, and with them Wicket's support for the `javax.servlet` API.

<table style="width:100%">
	<tr>
		<th style="width:30%">Version</th>
		<th style="width:30%">Expected</th>
		<th style="width:40%">Line</th>
	</tr>
	<tr>
		<td>Wicket 11.0.0</td>
		<td>first week of October 2026</td>
		<td>quarterly</td>
	</tr>
	<tr>
		<td>Wicket 12.0.0</td>
		<td>January 2027</td>
		<td>quarterly</td>
	</tr>
	<tr>
		<td>Wicket 13.0.0</td>
		<td>April 2027</td>
		<td>quarterly</td>
	</tr>
	<tr>
		<td>Wicket 14.0.0</td>
		<td>first week of July 2027</td>
		<td>LTS, supported until Wicket 18</td>
	</tr>
</table>

The full announcement is in our news archive:
[A new release cadence for Apache Wicket]({{site.baseurl}}/news/2026/09/11/release-cadence.html).

---

## Unsupported Releases

The following releases are no longer supported by the Wicket team. You
should upgrade your project if it still depends on any of these
versions.

<table style="width:100%">
	<tr>
		<th style="width:30%">Version</th>
		<th style="width:30%">Latest release</th>
		<th style="width:40%">Status</th>
	</tr>
	<tr>
		<td><a href="wicket-7.x.html">Wicket 7.x</a></td>
		<td>{{site.wicket.version_70}}</td>
		<td>discontinued, upgrade to 9.x or 10.x</td>
	</tr>
	<tr>
		<td><a href="wicket-6.x.html">Wicket 6.x</a></td>
		<td>{{site.wicket.version_60}}</td>
		<td>discontinued, upgrade to 9.x or 10.x</td>
	</tr>
	<tr>
		<td><a href="wicket-1.5.x.html">Wicket 1.5.x</a></td>
		<td>{{site.wicket.version_15}}</td>
		<td>discontinued, upgrade to 9.x or 10.x</td>
	</tr>
	<tr>
		<td><a href="wicket-1.4.x.html">Wicket 1.4.x</a></td>
		<td>{{site.wicket.version_14}}</td>
		<td>discontinued, upgrade to 9.x or 10.x</td>
	</tr>
	<tr>
		<td><a href="wicket-1.3.x.html">Wicket 1.3.x</a></td>
		<td>{{site.wicket.version_13}}</td>
		<td>discontinued, upgrade to 9.x or 10.x</td>
	</tr>
	<tr>
		<td>Wicket 1.2.x</td>
		<td>1.2.5</td>
		<td>discontinued, upgrade to 9.x or 10.x</td>
	</tr>
	<tr>
		<td>Wicket 1.1.x</td>
		<td>1.1.0</td>
		<td>discontinued, upgrade to 9.x or 10.x</td>
	</tr>
	<tr>
		<td>Wicket 1.0.x</td>
		<td>1.0.0</td>
		<td>discontinued, upgrade to 9.x or 10.x</td>
	</tr>
</table>

---

## Release Archives

The Apache mirroring system only hosts the latest version of each actively supported branch.
When you need to download an older release you can find them in the archives.

Go to [the Apache archives](https://archive.apache.org/dist/wicket) to find your specific version.

---

## SNAPSHOT Repository

In order to use any SNAPSHOT versions mentioned in each download section of a specific Wicket version you have to configure the SNAPSHOT repository in your pom.xml.

{% highlight xml %}
<repository>
    <id>apache.snapshots</id>
    <name>Apache Development Snapshot Repository</name>
    <url>https://repository.apache.org/content/repositories/snapshots/</url>
    <releases>
        <enabled>false</enabled>
    </releases>
    <snapshots>
        <enabled>true</enabled>
    </snapshots>
</repository>
{% endhighlight xml %}

Beware that SNAPSHOT versions might be deleted after a while and that you should **not use** any of them to go live with.
