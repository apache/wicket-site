---
layout: default
title: Create a Wicket Quickstart 
---

There are two really good reasons to create a Wicket quickstart.  The first is if 
you just want to get started using Wicket quickly.  The quickstart will set up a
ready-to-use project in under a minute (depending on your bandwidth).  Another 
great reason to create a quickstart is to accompany a bug report.  If you report
a bug in JIRA or on the mailing list, the core developers may not be able to 
recreate it easily.  In most cases, you'll be told "please create a quickstart and
attach it to a JIRA issue".  If you don't know how to do that, don't worry - just
follow the instructions below.  (If you are submitting a quickstart for an issue 
report, please be sure to read the subheading below - "Submitting a quickstart 
for an issue report"

Quickstarts are made from a Maven archetype.  So, you will need to have
[Maven 2](http://maven.apache.org) installed and working (from the command line)
before following this.

Creating a quickstart provides only a very basic starting point for your Wicket
project.  If you are looking for examples of how to use Wicket and its various 
features, please refer to the *wicket-example* projects instead!

## Creating the project - with Maven

To create your project, copy and paste the command line generated after
typing in the groupId, artifactId and version.

<style>	
	#mvncmd {
		padding-left: 25px;
	}
	#mvncmd label {
		font-weight: bold;
		width: 100px;
		display: inline-block;
	}
	#mvncmd input, #mvncmd select, #mvncm span { width: 180px; margin-bottom: 5px;}
	#mvncmd textarea { width: 400px; height: 100px; }
	#mvncmd br { clear: left; }	
	#mvncmd div { clear:both; padding-left: 25px; vertical-align:top;}
</style>
<script type="text/javascript">
	function changeIt()
	{
		var groupId = document.getElementById("groupId").value;
		var artifactId = document.getElementById("artifactId").value;
		var version = document.getElementById("version").value;
		var appserver = document.getElementById("appserver").value;
		var cmd;
		if(version.match(/^1\.[34]/))
			cmd = 'mvn archetype:create -DarchetypeGroupId=org.apache.wicket -DarchetypeArtifactId=wicket-archetype-quickstart -DarchetypeVersion=' + version + ' -DgroupId=' + groupId + ' -DartifactId=' + artifactId;						
		else
			cmd = 'mvn archetype:generate -DarchetypeGroupId=org.apache.wicket -DarchetypeArtifactId=wicket-archetype-quickstart -DarchetypeVersion=' + version + ' -DgroupId=' + groupId + ' -DartifactId=' + artifactId;						

		if (version.match(/.*SNAPSHOT/))
			cmd += ' -DarchetypeRepository=https://repository.apache.org/content/repositories/snapshots/';
		else
			cmd += ' -DarchetypeRepository=https://repository.apache.org/';

		if (appserver === 'wildfly')
			cmd += ' -Dlog4j.properties=wildfly-doesnt-need-log4j.properties';

		cmd += ' -DinteractiveMode=false'; 
		document.getElementById("cmdLine").value = cmd;
	}
</script>
<div id="mvncmd">
	<div>
		<label for="groupId" title="Base Package">GroupId:</label>
		<input type="text" id="groupId" value="com.mycompany" onkeyup="changeIt();" /><span title="Base Package">&nbsp;(?)</span><br/>
	</div>
	<div>
		<label for="artifactId" title="Project Name">ArtifactId:</label> 
		<input type="text" id="artifactId" value="myproject" onkeyup="changeIt();" /><span title="Project Name">&nbsp;(?)</span><br/>
	</div>
	<div>
		<label for="version" title="Wicket Version">Version:</label>
		<select id="version" onchange="changeIt();">
{% for version in site.wicket.versions reversed %}
		{% if version == site.wicket.version %}
			<option value="{{version}}" selected="selected">{{version}}</option>
		{% else %}
			<option value="{{version}}">{{version}}</option>
		{% endif %}
{% endfor %}
		</select><span title="Wicket Version">&nbsp;(?)</span>
	</div>
	<div>
		<label for="appserver" title="Server to deploy on">Server:</label>
		<select id="appserver" onchange="changeIt();">
			<option value="any" selected="selected">Any but Wild Fly</option>
			<option value="wildfly" >Wild Fly (JBoss 8.x)</option>
		</select><span title="Web/App Server">&nbsp;(?)</span>
	</div>
	<div>
		<label for="cmdLine" id="cmdLabel">Command Line:</label>
		<textarea id="cmdLine" onfocus="this.select();">
		</textarea>
		<script>changeIt();</script>
	</div>
	<br />
</div>

### Results

This will produce the following project structure/files:

<div style="margin-left: 3em; border: 1px solid black">
<pre>
    .\myproject
        |   pom.xml
        |
        \---src
            +---main
            |   +---java
            |   |   \---com
            |   |       \---mycompany
            |   |               HomePage.html
            |   |               HomePage.java
            |   |               WicketApplication.java
            |   |
            |   +---resources
            |   |       log4j.properties
            |   |
            |   \---webapp
            |       \---WEB-INF
            |               web.xml
            |
            \---test
                \---java
                    \---com
                        \---mycompany
                                Start.java
</pre>
</div>

### Using Maven quickstart with a specific IDE

Maven has an integration with many IDEs.  If you want to use your new Maven-based
Wicket quickstart with your favorite IDE, see one of these instructions:

#### Eclipse

Change directory into the project that you just created.  Now, run 
`mvn eclipse:eclipse`.  This will set up the .project, .settings, and .classpath
files that Eclipse requires.  

Note that your workspace will have to have the classpath variable M2_REPO set to point to the directory where your local Maven repository exists.  You can see this page for how to do that with Eclipse: <http://maven.apache.org/plugins/maven-eclipse-plugin/usage.html>

Now, in Eclipse, you can choose "File" (menu), then "Import", then "Existing project".
Navigate to the folder where your project exists and let Eclipse import it.  The classpath should
be fully configured.

Alternatively install the [m2eclipse](http://m2eclipse.codehaus.org/) or
[Eclipse IAM](http://www.eclipse.org/iam/) plugin and add the project
directly.

#### IDEA ####

From within IDEA, just use "File/Import Project", choose the project directory and specify that this is a Maven project.

#### NetBeans ####

To create a NetBeans project, just open the pom.xml directly.

### More examples

Many more information and examples can be found on our Wiki or
[here](http://www.ralfebert.de/blog/wicket/wicket_eclipse_setup/)

## Using your new project

Wicket quickstart projects include a file named Start.java.  If you open this file in
your IDE (after configuring the project in your IDE), you can run it as a Java application.
It will run an embedded Jetty instance that will run your app on <http://localhost:8080>
Navigate your browser to that address to see your app running.

### Using the Jetty Plugin

The Jetty plugin is also enabled by default in the quickstart.  If you are using Maven,
you can change directory into the project and run the "mvn jetty:run" command.  This will
compile the project and deploy it to an embeded instance of the Jetty servlet engine, 
which will run on port 8080, by default. As a result, once running, your application will be available at <http://localhost:8080>.

See the [Jetty plugin](http://www.mortbay.org/maven-plugin/index.html)
documentation for configuration options, etc.

## Submitting a quickstart for an issue report

### Reproduce the problem

Assuming you have followed the instructions above, the quickstart is now created and ready for you to develop.  Now comes the "duplicate the problem" part.  Try to create pages or components that reproduce the problem you were trying to report.  You can run the Start.java class from your
IDE and go to <http://localhost:8080> to see your test application.  If you run the Start.java class
in your IDE's debug mode, you should be able to attach breakpoints and have automatic class and 
markup reloading.

If you can't reproduce the problem - start looking at your own code.  Keep adding pieces from
your code until either you reproduce the problem, or else you've found the bug in your own code.
A lot of times, you will find the bug in your code just by trying to create a quickstart that
demonstrates the bug in ours.  

### Clean up the quickstart and submit it

Once you have reproduced the desired behavior in your quickstart, it would be best to make it as small as possible before submitting.  The best way to do this is to run the "mvn clean" command from the project directory.  Then zip (or tar and gzip) the whole directory up and submit the zip (or tgz) file.  (The mvn clean command removes all of the compiled classes and generated artifacts, generally in your "target" directory, leaving only the actual source.)

