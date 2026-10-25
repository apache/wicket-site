---
layout: section
title: Releases
sign_action:
  text: Quick start
  url: /start/quickstart.html
summary: Wicket 10 is the long-term support (LTS) release. Each release line has its own page with Maven coordinates, downloads, what is new and documentation.
---

## Release lines {#lines}

{% include release-lines.html %}

Every release is announced on the [announce list]({{ site.baseurl }}/community/#announce), on the [blog]({{ site.baseurl }}/news/) and in its [Atom feed]({{ site.baseurl }}/atom.xml).

If your application runs on a line with its last release coming, or one past its end of life, plan the upgrade: the [upgrade paths](#upgrade-paths) show the route.

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
                <p class="connections-route">8.x &rarr; 9 (Java 11) &rarr; 10 LTS (Java 17)</p>
                <p>Both lines get one final release and then <a href="{{ site.baseurl }}/news/2026/10/21/wicket-8-and-9-end-of-life.html">reach end of life</a>, and with them Wicket's support for <code>javax.servlet</code>. Move to 10 LTS: it brings <code>jakarta.servlet</code> and is supported until July 2027. 9.x moves to 10 directly. 8.x takes the Wicket 9 step first, because each migration guide covers one major version.</p>
                <p>For the step to 10, the <a href="{{ site.baseurl }}/versions/wicket-10.x/#automatic-migration">OpenRewrite recipes of <code>wicket-migration</code></a> do the repetitive part: the <code>jakarta</code> imports, the Java 17 baseline and the moved Wicket classes. If you need help or more time, <a href="{{ site.baseurl }}/community/#commercial">companies that offer Wicket support</a> are listed on the wiki.</p>
            </td>
            <td>
                <ul class="connections-guides">
                    <li><a href="https://s.apache.org/wicket9migration">Migration to Wicket 9</a></li>
                    <li><a href="https://s.apache.org/wicket10migrate">Migration to Wicket 10</a></li>
                </ul>
            </td>
        </tr>
        <tr>
            <th scope="row">Wicket 10.x</th>
            <td>Stay on 10: it is the LTS, supported until July 2027.</td>
            <td><a href="{{ site.baseurl }}/news/2026/09/11/release-cadence.html">The new release cadence</a></td>
        </tr>
        <tr>
            <th scope="row">Starting out</th>
            <td>Start on 10 LTS.</td>
            <td><a href="{{ site.baseurl }}/start/quickstart.html">Quick start</a></td>
        </tr>
    </tbody>
</table>

## Release policy {#release-policy}

Wicket 10 is the current long-term support (LTS) release. It receives security fixes and applicable bug fixes until July 2027. Wicket 8.x and 9.x each receive one final release and then reach end of life, and with them Wicket's support for the `javax.servlet` API.

What end of life means for 8 and 9, and how to move, is in [Wicket 8 and 9 reach end of life soon]({{ site.baseurl }}/news/2026/10/21/wicket-8-and-9-end-of-life.html). The release schedule after that, with its new release model, is in [A new release cadence for Apache Wicket]({{site.baseurl}}/news/2026/09/11/release-cadence.html).

## End of life {#unsupported}

These release lines get no more releases, not even security fixes. If your application depends on one of them, upgrade to Wicket 10 LTS; the [upgrade paths](#upgrade-paths) show the route.

<table class="eol-table">
	<tr>
		<th scope="col">Version</th>
		<th scope="col">Latest release</th>
		<th scope="col">Status</th>
	</tr>
	<tr>
		<td><a href="{{ site.baseurl }}/versions/wicket-7.x/">Wicket 7.x</a></td>
		<td>{{site.wicket.version_70}}</td>
		<td><span class="tag tag-eol">End of life</span></td>
	</tr>
	<tr>
		<td><a href="{{ site.baseurl }}/versions/wicket-6.x/">Wicket 6.x</a></td>
		<td>{{site.wicket.version_60}}</td>
		<td><span class="tag tag-eol">End of life</span></td>
	</tr>
	<tr>
		<td><a href="{{ site.baseurl }}/versions/wicket-1.5.x/">Wicket 1.5.x</a></td>
		<td>{{site.wicket.version_15}}</td>
		<td><span class="tag tag-eol">End of life</span></td>
	</tr>
	<tr>
		<td><a href="{{ site.baseurl }}/versions/wicket-1.4.x/">Wicket 1.4.x</a></td>
		<td>{{site.wicket.version_14}}</td>
		<td><span class="tag tag-eol">End of life</span></td>
	</tr>
	<tr>
		<td><a href="{{ site.baseurl }}/versions/wicket-1.3.x/">Wicket 1.3.x</a></td>
		<td>{{site.wicket.version_13}}</td>
		<td><span class="tag tag-eol">End of life</span></td>
	</tr>
	<tr>
		<td>Wicket 1.2.x</td>
		<td>1.2.5</td>
		<td><span class="tag tag-eol">End of life</span></td>
	</tr>
	<tr>
		<td>Wicket 1.1.x</td>
		<td>1.1.0</td>
		<td><span class="tag tag-eol">End of life</span></td>
	</tr>
	<tr>
		<td>Wicket 1.0.x</td>
		<td>1.0.0</td>
		<td><span class="tag tag-eol">End of life</span></td>
	</tr>
</table>

---

## Release archives {#archives}

The Apache mirrors only carry the latest release of each line in service. Every older release is in [the Apache archives](https://archive.apache.org/dist/wicket).

---

## SNAPSHOT repository {#snapshots}

To try a SNAPSHOT version named on a line's page, add the Apache snapshot repository to your `pom.xml`:

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

Snapshots can be deleted at any time. Do not go live with one.
