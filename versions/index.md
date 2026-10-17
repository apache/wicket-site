---
layout: section
title: Release lines
summary: Wicket ships a long-term support release once a year for production, and a major release with new features every quarter. Each line has its own page with Maven coordinates, downloads, what is new and documentation.
---

{% include line-panels.html %}

{% include release-lines.html %}

If your application is not on a line in service, plan the upgrade: the [upgrade paths](#upgrade-paths) show the route. Every release line links to its own page.

---

## Upgrade paths {#upgrade-paths}

How to move an application to a line that stays supported.

<table class="connections-table">
    <thead>
        <tr>
            <th scope="col">You are on</th>
            <th scope="col">Your route</th>
            <th scope="col">Guide</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <th scope="row">Wicket 8.x or 9.x</th>
            <td>
                <p class="connections-route">8.x &rarr; 9 (Java 11) &rarr; 10 LTS (Java 17) &rarr; 14 LTS, July 2027</p>
                <p>Both lines get one final release and reach end of life when Wicket 11.0.0 ships, and with them Wicket's support for <code>javax.servlet</code>. Move to 10 LTS for production: it brings <code>jakarta.servlet</code>, is supported until July 2027, and hands over to 14, the next LTS. 9.x moves to 10 directly; 8.x takes the Wicket 9 step first.</p>
            </td>
            <td>
                <a href="https://s.apache.org/wicket9migration">Migration to Wicket 9</a><br>
                <a href="https://s.apache.org/wicket10migrate">Migration to Wicket 10</a>
            </td>
        </tr>
        <tr>
            <th scope="row">Wicket 10.x</th>
            <td>Stay on the LTS until Wicket 14, the next LTS, ships in July 2027. Wicket 11, the first quarterly release, brings new features and needs Java 21 and Jakarta Servlet 6.1.</td>
            <td><a href="{{ site.baseurl }}/news/2026/09/11/release-cadence.html">The new release cadence</a></td>
        </tr>
        <tr>
            <th scope="row">Starting out</th>
            <td>Start on 10 LTS. Once Wicket 11 is out, start on 11 instead if you want new features every quarter.</td>
            <td><a href="{{ site.baseurl }}/docs/create-project.html">Create a project</a></td>
        </tr>
    </tbody>
</table>

## Release policy {#release-policy}

With the release of Wicket 11.0.0, due in October 2026, Wicket moves to a time-based
release schedule: a new major release every three months, and every fourth major
release &mdash; once a year &mdash; is a long term support (LTS) release. The table
above shows the lines as they are today and the releases scheduled after them.

From then on, two release lines are maintained at any time:

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

The full announcement is in our news archive:
[A new release cadence for Apache Wicket]({{site.baseurl}}/news/2026/09/11/release-cadence.html).

## Unsupported releases {#unsupported}

The following releases are no longer supported by the Wicket team. You
should upgrade your project if it still depends on any of these
versions.

<table class="eol-table">
	<tr>
		<th scope="col">Version</th>
		<th scope="col">Latest release</th>
		<th scope="col">Status</th>
	</tr>
	<tr>
		<td><a href="{{ site.baseurl }}/versions/wicket-7.x/">Wicket 7.x</a></td>
		<td>{{site.wicket.version_70}}</td>
		<td><span class="tag tag-eol">End of life</span> upgrade to 10.x LTS</td>
	</tr>
	<tr>
		<td><a href="{{ site.baseurl }}/versions/wicket-6.x/">Wicket 6.x</a></td>
		<td>{{site.wicket.version_60}}</td>
		<td><span class="tag tag-eol">End of life</span> upgrade to 10.x LTS</td>
	</tr>
	<tr>
		<td><a href="{{ site.baseurl }}/versions/wicket-1.5.x/">Wicket 1.5.x</a></td>
		<td>{{site.wicket.version_15}}</td>
		<td><span class="tag tag-eol">End of life</span> upgrade to 10.x LTS</td>
	</tr>
	<tr>
		<td><a href="{{ site.baseurl }}/versions/wicket-1.4.x/">Wicket 1.4.x</a></td>
		<td>{{site.wicket.version_14}}</td>
		<td><span class="tag tag-eol">End of life</span> upgrade to 10.x LTS</td>
	</tr>
	<tr>
		<td><a href="{{ site.baseurl }}/versions/wicket-1.3.x/">Wicket 1.3.x</a></td>
		<td>{{site.wicket.version_13}}</td>
		<td><span class="tag tag-eol">End of life</span> upgrade to 10.x LTS</td>
	</tr>
	<tr>
		<td>Wicket 1.2.x</td>
		<td>1.2.5</td>
		<td><span class="tag tag-eol">End of life</span> upgrade to 10.x LTS</td>
	</tr>
	<tr>
		<td>Wicket 1.1.x</td>
		<td>1.1.0</td>
		<td><span class="tag tag-eol">End of life</span> upgrade to 10.x LTS</td>
	</tr>
	<tr>
		<td>Wicket 1.0.x</td>
		<td>1.0.0</td>
		<td><span class="tag tag-eol">End of life</span> upgrade to 10.x LTS</td>
	</tr>
</table>

---

## Release archives {#archives}

The Apache mirroring system only hosts the latest version of each actively supported branch.
When you need to download an older release you can find them in the archives.

Go to [the Apache archives](https://archive.apache.org/dist/wicket) to find your specific version.

---

## SNAPSHOT repository {#snapshots}

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
