---
layout: default
title: Build a release
subtitle: How-to documentation for building Wicket releases
---

Learn how to build and release one of the Wicket branches.

## Contents ##

* [Releasing Apache Wicket 6.x](#release-60)
* [Releasing Apache Wicket 1.4.x+](#release-14)
* [Releasing Apache Wicket 1.3.x](#release-13)
* [Staging Releases using the Apache Nexus Repository](#nexus)
* [Announcing the release](#announcing)
* [Additional tasks](#additional)

## Releasing Apache Wicket 6.x ## {#release-60}

Per [Apache release policy](http://apache.org/dev/release.html) we need to build, vote on and release a source distribution. As a convenience to our users, we can also provide binary packages, that are uploaded to Maven Central, and a binary archive for folks that for whatever reason don't use Maven.

### Building the Release ###

#### Required software ####

This assumes running a unix-y environment (i.e. OS X, Linux) and that you have the necessary tools installed, such as recent Maven, Java 6, gpg (-agent).

#### Preparing

* Pull changes
* Checkout master
* Update changelog and commit them

#### Building

* Start gpg-agent as a daemon (OS X, using homebrew installation of gpg, gpg-agent, pinentry):

{% highlight console %}
    eval `gpg-agent --daemon --pinentry-program /usr/local/bin/pinentry`
{% endhighlight %}

* Create an environment variable such that you can copy/paste several of the following commands (substitute 6.0.0 with the number you're actually going to release):

{% highlight console %}
export NEWVERSION=6.0.0
{% endhighlight %}

* Sign pom.xml such that gpg-agent has enabled your key (and remove the .asc file). This triggers the pinentry program and sets the stage for gpg-agent:

{% highlight console %}
gpg --armor --detach-sign --use-agent --sign pom.xml
rm pom.xml.asc
{% endhighlight %}

* Create release branch: 

{% highlight console %}
mvn release:branch -DbranchName=build/wicket-$NEWVERSION
{% endhighlight %}

* Checkout the release branch: 

{% highlight console %}
git checkout build/wicket-$NEWVERSION
{% endhighlight %}

* Update archetypes/quickstart/src/main/archetype-resources/pom.xml to use NEWVERSION of Wicket and commit

* Use Maven to do the first steps of the release process by
  * Fill in NEWVERSION for all but the experimental submodules
  * New development version doesn't matter–just press enter, see next step
  * And running the following command:

{% highlight console %}
mvn release:prepare
{% endhighlight %}

* Remove last commit such that HEAD points to the NEWVERSION release, not the new development version

{% highlight console %}
git reset HEAD^ --hard
{% endhighlight %}

* Create source archive:

{% highlight console %}
git archive --format=tar.gz --prefix=apache-wicket-$NEWVERSION/ -o apache-wicket-$NEWVERSION.tar.gz wicket-$NEWVERSION
git archive --format=zip --prefix=apache-wicket-$NEWVERSION/ -o apache-wicket-$NEWVERSION.zip wicket-$NEWVERSION
{% endhighlight %}

* **NOTE 1** the trailing '/' after --prefix=NEWVERSION is vital for the tarball
* **NOTE 2** you can ignore the gpg generated messages telling 'You need a passphrase to unlock the secret key for', unless an error occurred&mdash;these messages are not error messages
* Sign the packages, the git tag and create the digests:


{% highlight console %}
gpg --armor --detach-sign --use-agent --sign apache-wicket-$NEWVERSION.tar.gz
gpg --armor --detach-sign --use-agent --sign apache-wicket-$NEWVERSION.zip
gpg --print-md SHA1 apache-wicket-$NEWVERSION.tar.gz > apache-wicket-$NEWVERSION.tar.gz.sha
gpg --print-md MD5  apache-wicket-$NEWVERSION.tar.gz > apache-wicket-$NEWVERSION.tar.gz.md5
gpg --print-md SHA1 apache-wicket-$NEWVERSION.zip > apache-wicket-$NEWVERSION.zip.sha
gpg --print-md MD5  apache-wicket-$NEWVERSION.zip > apache-wicket-$NEWVERSION.zip.md5
{% endhighlight %}

To sign the tag (overwrites the maven generated tag), execute:

{% highlight console %}
git tag -s --force wicket-$NEWVERSION
{% endhighlight %}

#### Staging the build

{% highlight console %}
ssh APACHE_ID@people.apache.org mkdir public_html/wicket-$NEWVERSION
scp apache-wicket-* APACHE_ID@people.apache.org:public_html/wicket-$NEWVERSION
{% endhighlight %}

**TODO** figure out how to let `release:perform` work from a local checkout, such that we can actually *stage* the build instead of having to push the tag to our git repo. 

The following steps are ONLY necessary as long as the above TODO has not been resolved.

{% highlight console %}
git push origin build/wicket-$NEWVERSION:refs/heads/build/wicket-$NEWVERSION
git push -tags origin
{% endhighlight %}

The step below uploads the artifacts to a staging area for Maven.
* assumes you have an Apache nexus account
* will checkout a fresh copy and build it (ask Maven for why)
* artifacts will have different signature than in previous release:prepare build (due to times changing)

{% highlight console %}
mvn release:perform
{% endhighlight %}

This will upload artifacts and signatures to Apache nexus in a staging repository.

#### Create a binary release

As we don't vote on binary packages, but do want to cater to developers not using Maven, it is very convenient to create a download for non-Maven users.

The binary distribution should contain the same jar files that are uploaded to Maven Central. Unfortunately the Maven build creates duplicate jar files, but with different manifests (due to the inclusion of date/time of build), and the jar files have different signatures. Therefore it is necessary to create a distribution of the artifacts generated by the `mvn release:perform` command.

Perform the following commands in the root of your Wicket checkout to create the binary release files.

{% highlight console %}
mkdir apache-wicket-$NEWVERSION
cd apache-wicket-$NEWVERSION
find ../target/checkout ! \( -type d -name "WEB-INF" -prune \) -regex ".*wicket-.*.[jw]ar" ! -name "*-sources*" ! -name "*-javadoc*" ! -name "*wicket-archetype-quickstart*" ! -name "wicket-common-tests*"  -type f -exec cp {} . \;
find ../target/checkout ! \( -type d -name "WEB-INF" -prune \) -regex ".*wicket-.*.[jw]ar\.asc" ! -name "*-sources*" ! -name "*-javadoc*" ! -name "*wicket-archetype-quickstart*" ! -name "wicket-common-tests*"  -type f -exec cp {} . \;
cp ../LICENSE .
cp ../README .
cp ../NOTICE .
cd ..
tar xfz apache-wicket-$NEWVERSION-bin.tar.gz apache-wicket-$NEWVERSION
zip apache-wicket-$NEWVERSION-bin.zip apache-wicket-$NEWVERSION
gpg --armor --detached-sig --use-agent --sign apache-wicket-$NEWVERSION-bin.tar.gz
gpg --armor --detached-sig --use-agent --sign apache-wicket-$NEWVERSION-bin.zip
gpg --print-md SHA1 apache-wicket-$NEWVERSION-bin.tar.gz > apache-wicket-$NEWVERSION-bin.tar.gz.sha
gpg --print-md MD5  apache-wicket-$NEWVERSION-bin.tar.gz > apache-wicket-$NEWVERSION-bin.tar.gz.md5
gpg --print-md SHA1 apache-wicket-$NEWVERSION-bin.zip > apache-wicket-$NEWVERSION.-binzip.sha
gpg --print-md MD5  apache-wicket-$NEWVERSION-bin.zip > apache-wicket-$NEWVERSION-bin.zip.md5
ssh APACHE_ID@people.apache.org mkdir public_html/wicket-$NEWVERSION/bin
scp apache-wicket-*bin.* APACHE_ID@people.apache.org:public_html/wicket-$NEWVERSION/bin
{% endhighlight %}

This binary release contains all required files to comply with the release policy, and the binary artefacts generated by our Maven release build, including the experimental modules and examples.

#### Vote the build

Start a vote on dev@ for this release. Allow for at least 72 hours, and ensure you take into account weekends.

#### Promoting the build

The following two steps are only necessary when the previous TODO is resolved (you can't push the tag twice).

{% highlight console %}
git push origin build/wicket-$NEWVERSION:refs/heads/build/wicket-$NEWVERSION
git push -tags origin
{% endhighlight %}

You only need to do them if you haven't done so yet.

See also [managing nexus](#nexus) for the steps needed to publish the artifacts to Maven Central. And don't forget to announce the release!

## Releasing Apache Wicket 1.4.x+ ## {#release-14}

### Building the Release ###

#### Preparing #####

* Ask the dev@ mailing list if there are any issues that still need to be in the release (looking at JIRA is a good start)
* [Release](https://issues.apache.org/jira/plugins/servlet/project-config/WICKET/versions) the version in JIRA
* Assuming there are none, and you are now in build mode, update the CHANGELOG-x.y file
(you can use JIRA for this list: go to "releases", and under "unreleased", next to your version, there's a release notes link)

Make sure your ```~/.m2/settings.xml``` contains the following definition

{% highlight console %}
<?xml version="1.0"?>
<settings>
<servers>
        <server>
            <id>apache.releases.https</id>
            <username>$your_apache_username</username>
            <password>$your_apache_password</password>
        </server>
</servers>
</settings>
{% endhighlight %}

* Make sure you have a GnuPG key which is added to [KEYS](https://svn.apache.org/repos/asf/wicket/common/KEYS).
Read the header of KEYS file to see how to add it.
* Copy release-igor.sh script and modify any commands which don't match your environment (e.g. mvn5)
* Run ./release-mine.sh and enter the required input (new version, gpg passphrase, etc.). The script
will create the build branch in Git, will upload the artifacts at Apache Nexus Staging repository and
will copy the assemblies to your people.apache.org account.
* Send vote message to dev@ mailing list.  Include link to the closed repository for testing against.
* Wait requisite 72 hours for the vote to pass (we hope)
* Copy release to apache mirrors
{% highlight console %}
ssh people.apache.org
mkdir /www/www.apache.org/dist/wicket/x.y.z
mv ~/public_html/wicket-x.y.z/dist/* /www/www.apache.org/dist/wicket/x.y.z
chown -R :wicket /www/www.apache.org/dist/wicket/x.y.z
{% endhighlight %}
* Login to [Apache Nexus Staging repo](https://repository.apache.org), select the closed repository and click **Release**.  It will be accessible immediately through the apache release repo and then within 1-2 hours through maven central.
* If the release is voted down you can **Drop** the staged release and then restage later after incorporating the necessary changes.
* Tag the release in Git:
{% highlight console %}
git checkout build/wicket-x.y.z
git tag release/wicket-x.y.z
git push --tags
{% endhighlight %}
* Wait until repo1.maven.org has picked up the release artifacts.
* Wait 24 hours until mirrors picked up release artifacts
* Announce (see [below](#announcing))

## Staging Releases using the Apache Nexus Staging Repository ## {#nexus}

The key to stage and manage repositories on [Apache Nexus Staging repo](https://repository.apache.org) are your Apache Commiter credentials.

### Staging Artifacts ###

**Note**: The steps below are part of release-igor.sh script!

When you run **mvn -P release deploy** the generated artifacts will be uploaded into a Nexus staging repository.

Maven sends a username/password when attempting to upload the artifacts.

The ```<id>``` of the staging repository is: **apache.releases.https**.

Place a ```<server>``` definition in your ```~/.m2/settings.xml``` file like this:

{% highlight console %}
<?xml version="1.0"?>
<settings>
<servers>
        <server>
            <id>apache.releases.https</id>
            <username>$username</username>
            <password>$password</password>
        </server>
</servers>
</settings>
{% endhighlight %}

This works if you can deploy artifacts into the repository.apache.org properly (i.e. you don't see failures mentioning 401 errors).

### Managing Staged Artifacts ###

By logging in with your Apache committer credentials to [Apache Nexus Staging repo](https://repository.apache.org) you can access the management interface for the staged artifacts.

The interface will allow you to:
* View the staging repositories.
* Close staging repositories.
* Release closed repository artifacts (into the release repo and after 1-2 hours into central as well).
* Drop open and closed staging repositories.

More information is available at: [Publishing Maven Artifacts](http://www.apache.org/dev/publishing-maven-artifacts.html#staging-maven)

## Announcing the release ## {#announcing}

Edit the \_config.yaml file. This file contains a site wide configuration
section specific to Wicket:

{% highlight yaml %}
wicket:
    version:    1.4.10
    released:   2010-08-11
    versions:   [1.3.7, 1.3-SNAPSHOT, 1.4.9, 1.4.10, 1.4-SNAPSHOT, 1.5-M1, 1.5-SNAPSHOT]
{% endhighlight %}

You'll need to edit this part: modify the version, update the released date,
and add the new version to the versions list (remove any stale releases,
typically just leave the previous release as well).

* Write an announcement in the \_posts directory
* Restart jekyll to regenerate the pages: it will automatically generate the
  correct links in the navigation menu, quickstart and downloads page. It will
  update the doap.rdf file, atom.xml rss feed and index.html file so that it
  contains your announcement.
* Send email to: users@wicket.apache.org, dev@wicket.apache.org, announce@wicket.apache.org, announce@apache.org
* Misc. websites like javalobby, serverside, onjava etc.

## Additional tasks ## { #additional }

* Commit the JavaDocs to
  [https://svn.apache.org/repos/asf/wicket/common/site/apidocs/1.4](https://svn.apache.org/repos/asf/wicket/common/site/apidocs/1.4)
  svnpubsub will push this directly to our website. (example script below)

{% highlight console %}
# do this in your locally-checked-out release branch (i.e. svn.../releases/wicket-1.4.13)
mvn javadoc:aggregate
# note that you may need to tweak these paths to fit your configuration:
cp -r target/site/apidocs/* ../wicket-common/site/apidocs/1.4/
cd ../wicket-common/
# call "svn add" for files that are new (there's probably an easier way to do this)
svn stat | grep -e '^?' | sed 's/\?\W*//' | xargs svn add
svn commit -m "changes to update javadocs to latest release"
{% endhighlight %}
