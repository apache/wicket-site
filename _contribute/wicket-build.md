---
title: Build and test Wicket
type: howto
topic: wicket
summary: Build Wicket from source with Maven, run one test or all of them, run the JavaScript tests and the examples, and use your own build.
order: 30
---
{% assign next = site.data.releases.lines | where: "status", "boarding" | first %}

Wicket is a Maven project of about 35 modules, one folder each, built together from the `pom.xml` in the root of the repository. You run every command on this page in that root folder, the `wicket` folder of your clone.

## What you need

- **A JDK** of at least the Java version that [README.md](https://github.com/apache/wicket/blob/master/README.md#javaapplication-server-requirements) names under "Java/Application server requirements"; newer is fine. The build uses the version set in `maven.compiler.release` in the root `pom.xml`, and the GitHub workflow, [`.github/workflows/maven.yml`](https://github.com/apache/wicket/blob/master/.github/workflows/maven.yml), lists the JDKs it tests with.
- **Maven** on the command line. The Maven inside your IDE is usually not available there, so [install Maven](https://maven.apache.org/install.html) as well, a current release; the GitHub workflow names the version it uses.
- **Git**, and about 2 GB of free disk space for the clone, the build results and the downloaded libraries.

Check that Maven runs with the right Java:

```shell
mvn -v
```

The output names the Maven version and, on the line `Java version:`, the JDK. If that JDK is too old, set the `JAVA_HOME` environment variable to the folder of a newer one.

## Build everything

```shell
mvn install -DskipTests -Pfast
```

`install` compiles every module, packages it as a jar and copies the jar to your local Maven repository, the folder `.m2/repository` in your home folder. `-DskipTests` skips the tests, and `-Pfast` skips the javadoc, the source jars and the license header check. The first build downloads several hundred MB of libraries and takes a few minutes; later builds are faster.

The build ends with `BUILD SUCCESS` and a list of the modules with their times. The jars are now in your local repository, version {% if next %}`{{ next.version }}-SNAPSHOT`{% else %}the `-SNAPSHOT` version in the root `pom.xml`{% endif %} on `master`. A snapshot is a version under development, not a release.

## Run one test {#run-one-test}

The tests of `wicket-core` are in a separate module, `wicket-core-tests`, and so are some tests of classes in other modules: `UrlRendererTest`, for `UrlRenderer` in `wicket-request`, is one. The test can also be in another package than the class, so search for it by name, as in [Send a pull request]({{ site.baseurl }}/contribute/wicket-pull-request.html#change). A test in another module uses the module you changed from your local Maven repository, not from your working folder. So install the changed module, then run the test. [Why most tests live in another module]({{ site.baseurl }}/contribute/wicket-test-modules.html) explains this.



```shell
mvn install -DskipTests -Pfast -pl wicket-request
mvn verify -pl wicket-core-tests -Dtest=UrlRendererTest
```

`-pl` (for "projects") limits the build to the modules you name, with their folder names. Install the changed module again after every change; otherwise the test runs against your previous build. When you changed more than one module, name them all, with quotes: `-pl "wicket-util,wicket-request"`.

When the test is in the same module as the code, as for most of `wicket-util` and `wicket-extensions`, one command is enough:

```shell
mvn verify -pl wicket-extensions -Dtest=AutoCompleteTest
```

To run one method of a test class, add its name: `-Dtest=UrlRendererTest#renderFullUrlWithRelativeArgument`. The [conventions]({{ site.baseurl }}/contribute/wicket-conventions.html#tests) say where a new test goes and how to name it.

Instead of installing first, `-am` ("also make") builds the modules the test module depends on from your working folder. It then looks for the test in each of those modules too, so it needs a second option:

```shell
mvn verify -pl wicket-core-tests -am -Dtest=UrlRendererTest "-Dsurefire.failIfNoSpecifiedTests=false"
```

## Run the JavaScript tests {#javascript-tests}

The JavaScript tests run in a headless Chrome and are off unless you ask for them with `-Pjs-test`:

```shell
mvn test -pl testing/wicket-js-tests -Pjs-test
```

The tests read the `.js` files from your working folder, so you do not need to install anything first. The first run downloads the tools the tests need and takes a while; on Linux, the browser needs some system libraries.

[JAVASCRIPTTESTING.md](https://github.com/apache/wicket/blob/master/JAVASCRIPTTESTING.md) in the repository is the reference for these tests: what it downloads and which libraries it needs, where the tests are, how to add a test page, and how to run the tests faster without Maven. Every script is checked by JSHint, also the scripts without tests of their own, such as `wicket-autocomplete.js`. When you fix such a script, say in the pull request how you tested the fix.

## Run the examples

The `wicket-examples` module is a web application with an example of almost every component. To see your change in a browser, install the modules you changed and start the examples:

```shell
mvn install -DskipTests -Pfast
mvn jetty:run -pl wicket-examples
```

When Jetty reports that the server started, open <http://localhost:8080>. Stop the server with Ctrl+C, and install again after each change. To run the examples from your IDE, without installing, see [Set up your IDE]({{ site.baseurl }}/contribute/wicket-ide.html).

## Run the full build

Before you send a pull request, build and test everything the way GitHub does:

```shell
mvn clean verify -Pjs-test
```

`clean` removes all earlier build results, `verify` compiles and runs every test, and `-Pjs-test` adds the JavaScript tests. The full build also checks that every file has the ASF license header. It takes much longer than the fast build: on a laptop, count on a quarter of an hour or more.

While you work, build as little as you need: `-Pfast` and `-DskipTests` to leave things out, `-pl` with the modules you need, and `-o` (offline) so that Maven does not check the internet for newer snapshots. Save the full build for the end.

## Use your own build in an application

After `mvn install`, an application on the same computer can use your build. Set the Wicket version in its `pom.xml` to the snapshot version from the root `pom.xml` of your clone:

```xml
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-core</artifactId>
    <version>{% if next %}{{ next.version }}-SNAPSHOT{% else %}<!-- the version in Wicket's root pom.xml -->{% endif %}</version>
</dependency>
```

This is a quick way to check a fix in a [quickstart]({{ site.baseurl }}/start/quickstart.html) or in your own application.

## When the build fails

- **`release version … not supported`**: Maven runs with an older Java than the build needs. Check `mvn -v` and set `JAVA_HOME`.
- **`Counter(s) UNAPPROVED exceeded minimum or maximum values`**: a file you added has no license header. In `target/rat.txt` in the root folder, the files without one start with a `!`. Copy the header from a file of the same type.
- **A test fails that has nothing to do with your change**: check whether it also fails on `master`. The [build status of master](https://github.com/apache/wicket/actions?query=branch%3Amaster) shows whether it is broken there. If it is not, mention the failing test in your issue.
- **`No tests matching pattern`**: the test name after `-Dtest` does not exist in the modules you build. Check the module after `-pl` and the spelling of the class.
- **An error about the order of a `pom.xml`**: Wicket's build checks the order of sections and dependencies in every `pom.xml`. See the [conventions]({{ site.baseurl }}/contribute/wicket-conventions.html#poms).
