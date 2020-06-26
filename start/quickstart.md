---
layout: default
title: Create a Wicket Quickstart 
subtitle: With the quickstart you’ll be up and running in seconds
preamble: Use the following wizard to generate a Quick Start Project using Maven. Paste the generated command line into a shell (DOS prompt or unix shell) and create a project with Wicket in a jiffy.
pageclasses: quickstart
atitlePicture:
  - title: Ready, set, go!
    src: ../img/getstarted.png
    alt: .oO
---
<script type="text/javascript" charset="utf-8" src="{{ site.baseurl }}/javascript/ZeroClipboard-1.1.7.min.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
      
      ZeroClipboard.setDefaults( { moviePath: '{{ site.baseurl }}/javascript/ZeroClipboard-1.1.7.swf' } );
      var clip = new ZeroClipboard(document.getElementById("cmdLineCopy"));
      clip.on( 'noflash', function ( client, args ) {
        document.getElementById("cmdLineCopy").style.display = 'none';
      });
      clip.on( 'wrongflash', function ( client, args ) {
        document.getElementById("cmdLineCopy").style.display = 'none';
      });
      $(document).resize(function() {
        clip.reposition();
      });
    });

    function changeIt()
    {
		var groupId = document.getElementById("groupId").value;
		var artifactId = document.getElementById("artifactId").value;
		var version = document.getElementById("version").value;
		var appserver = document.getElementById("appserver").value;
		var cmd;
				
		if(version.match(/^1\.[34]/))
			cmd = 'mvn archetype:create -DarchetypeGroupId=org.apache.wicket -DarchetypeArtifactId=wicket-archetype-quickstart -DarchetypeVersion=' + version + ' -DgroupId=' + groupId + ' -DartifactId=' + artifactId;						
		else if(version.match(/.*SNAPSHOT/))
			cmd = 'mvn org.apache.maven.plugins:maven-archetype-plugin:2.4:generate -DarchetypeGroupId=org.apache.wicket -DarchetypeArtifactId=wicket-archetype-quickstart -DarchetypeVersion=' + version + ' -DgroupId=' + groupId + ' -DartifactId=' + artifactId;		
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

## Before you start

The Quick Start Wizard uses [Apache Maven](http://maven.apache.org) to
make it really fast to get started. You should have Maven installed and
working before you can use the Quick Start wizard.

## 5 small steps to a web application

Use the following steps to quickly generate a project to get you
started:

1.  Fill in the Maven coordinates for your project in the wizard and 
    select the appropriate Wicket version
2.  Copy the generated commandline to your clipboard and paste it in a 
    terminal (or a DOS box)
3.  Open the project in your IDE of choice
4.  Start the `Start` class in the *src/test/java* folder
5.  Open your browser to <a target="_blank" href="http://localhost:8080">http://localhost:8080</a>

And you're done!

## Quick Start Wizard

Fill in your project details in the wizard below and copy the generated
command line to your clipboard.

  <div class="l-two-third">
    <div class="quickstart-wizard">
      <div>
        <label title="Base Package" for="groupId">Group ID</label>
        <input type="text" value="com.mycompany" onkeyup="changeIt();" id="groupId">
      </div>
      <div>
        <label title="Project Name" for="artifactId">Artifact ID</label>
        <input type="text" value="myproject" onkeyup="changeIt();" id="artifactId">
      </div>
      <div>
        <label title="Wicket Version" for="version">Wicket Version</label>
        <select onchange="changeIt();" id="version">
    {% for version in site.wicket.versions reversed %}
    {% if version == site.wicket.version %}
    	<option value="{{version}}" selected="selected">{{version}}</option>
    {% else %}
    	<option value="{{version}}">{{version}}</option>
    {% endif %}
    {% endfor %}
        </select>
      </div>
      <div>
    <label for="appserver" title="Server to deploy on">Server to deploy on</label>
    <select id="appserver" onchange="changeIt();">
    	<option value="any" selected="selected">Any but Wild Fly</option>
    	<option value="wildfly" >Wild Fly (JBoss 8.x)</option>
    </select>
    </div>
      <div>
        <label id="cmdLabel" for="cmdLine">generated command line</label>
        <textarea onfocus="this.select();" id="cmdLine" style="resize: vertical;"></textarea>
        <script>changeIt();</script>
      </div>
      <div>
        <button data-clipboard-target="cmdLine" class="clip_button" id="cmdLineCopy">copy to clipboard</button>
      </div>
    </div>
  </div>
<br/>

With the generated command line on your clipboard open up a terminal
window (or DOS box) and navigate to where you want the project to be
generated (e.g. for Eclipse users this would be your workspace folder).
Paste the command line into your terminal window and press «enter» to
execute the command.


#### Result of the Maven command

Executing the Maven command line will result the following directory
structure:

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

It might be different depending on your settings (and version of
Wicket), but this is basically the standard layout for web projects.

## Import the Quick Start in your IDE

The Wicket Quick Start uses Apache Maven to make it really fast to get
started. You should have Maven installed and working before you can use
the Quick Start wizard.

### Eclipse

Eclipse has native support for Maven projects. To import the project you
select "Import existing Maven project" from the File menu, and select the
folder of your generated Quick Start project.

### IntelliJ IDEA

IntelliJ IDEA has native support for Maven projects. You just point the
open project dialog to the place where you generated the Quick Start
project and open the pom.xml file. IDEA will then open the project as
any other Java project.

### Netbeans

Netbeans has native support for Maven projects. You just point the open
project dialog to the place where you generated the Quick Start project
and open the pom.xml file. Netbeans will then open the project as any
other Java project.
