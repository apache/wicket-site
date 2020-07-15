---
layout: default
title: Download Apache Wicket
subtitle: Get the most recent version of Wicket in one source package
preamble: Wicket is released as a source archive, convenience binaries and through the Maven Central Repository. The most convenient way of getting Wicket is through the Maven dependency management system.
---

<div class="l-button-table">
    <div class="l-two-third">
        <div class="button-bar">
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
        <div class="button-bar">
        	<a class="button" href="wicket-6.x.html">
        		<i class="fa fa-cloud-download"></i><br>
        		Apache Wicket 6.x
        	</a>
        	<a class="button" href="wicket-1.5.x.html">
        		<i class="fa fa-cloud-download"></i><br>
        		Apache Wicket 1.5.x
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
		<td><a href="wicket-9.x.html">Wicket 9.x</a></td>
		<td>{{site.wicket.version_90}}</td>
		<td>current, supported</td>
	</tr>
	<tr>
		<td><a href="wicket-8.x.html">Wicket 8.x</a></td>
		<td>{{site.wicket.version_80}}</td>
		<td>supported</td>
	</tr>
	<tr>
		<td><a href="wicket-7.x.html">Wicket 7.x</a></td>
		<td>{{site.wicket.version_70}}</td>
		<td>security fixes only, upgrade to 8.x or 9.x</td>
	</tr>	
</table>

However, if your application is not on the current branch, you should
consider upgrading at your earliest convenience.

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
		<td><a href="wicket-6.x.html">Wicket 6.x</a></td>
		<td>{{site.wicket.version_60}}</td>
		<td>discontinued, upgrade to 8.x or 9.x</td>
	</tr>
	<tr>
		<td><a href="wicket-1.5.x.html">Wicket 1.5.x</a></td>
		<td>{{site.wicket.version_15}}</td>
		<td>discontinued, upgrade to 8.x or 9.x</td>
	</tr>
	<tr>
		<td><a href="wicket-1.4.x.html">Wicket 1.4.x</a></td>
		<td>{{site.wicket.version_14}}</td>
		<td>discontinued, upgrade to 8.x or 9.x</td>
	</tr>
	<tr>
		<td><a href="wicket-1.3.x.html">Wicket 1.3.x</a></td>
		<td>{{site.wicket.version_13}}</td>
		<td>discontinued, upgrade to 8.x or 9.x</td>
	</tr>
	<tr>
		<td>Wicket 1.2.x</td>
		<td>1.2.5</td>
		<td>discontinued, upgrade to 8.x or 9.x</td>
	</tr>
	<tr>
		<td>Wicket 1.1.x</td>
		<td>1.1.0</td>
		<td>discontinued, upgrade to 8.x or 9.x</td>
	</tr>
	<tr>
		<td>Wicket 1.0.x</td>
		<td>1.0.0</td>
		<td>discontinued, upgrade to 8.x or 9.x</td>
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
