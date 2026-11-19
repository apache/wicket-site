---
title: Build and test Wicket
type: howto
topic: wicket
summary: Build Wicket from source with Maven, run one test or all of them, run the JavaScript tests and the examples, and use your own build.
order: 20
---
{% assign next = site.data.releases.lines | where: "status", "boarding" | first %}
{% assign lts = site.data.releases.lines | where: "status", "lts" | first %}

Wicket is a Maven project of about 35 modules, one folder each, built together from the `pom.xml` in the root of the repository. You run every command on this page in that root folder, the `wicket` folder of your clone.

## What you need

- **JDK 21 or newer.** `master` and the current release line need Java 21{% if lts %}; `wicket-{{ lts.series }}.x` needs Java 17{% endif %}. GitHub tests with Java 21, 25 and 26.
- **Maven 3.9.** The Maven inside your IDE is not available on the command line, so [install Maven](https://maven.apache.org/install.html) as well.
- **Git**, and about 2 GB of free disk space for the clone, the build results and the downloaded libraries.

Check that Maven runs with the right Java:

```shell
mvn -v
```

The output names the Maven version and, on the line `Java version:`, the JDK. If that is older than 21, set the `JAVA_HOME` environment variable to the folder of your JDK 21.

## Build everything

```shell
mvn install -DskipTests -Pfast
```

`install` compiles every module, packages it as a jar and copies the jar to your local Maven repository, the folder `.m2/repository` in your home folder. `-DskipTests` skips the tests, and `-Pfast` skips the javadoc, the source jars and the license header check. The first build downloads about 450 MB of libraries and takes a few minutes; later builds take one to two minutes.

The build ends with `BUILD SUCCESS` and a list of the modules with their times. The jars are now in your local repository, version {% if next %}`{{ next.version }}-SNAPSHOT`{% else %}the `-SNAPSHOT` version in the root `pom.xml`{% endif %} on `master`. A snapshot is a version under development, not a release.

## Run one test {#run-one-test}

The tests of `wicket-core` are in a separate module, `wicket-core-tests`, and so are some tests of classes in other modules: `UrlRendererTest`, for `UrlRenderer` in `wicket-request`, is one. The test can also be in another package than the class, so search for it by name, as in [Send a pull request]({{ site.baseurl }}/contribute/wicket-pull-request.html#change). A test in another module uses the module you changed from your local Maven repository, not from your working folder. So install the changed module, then run the test:

```shell
mvn install -DskipTests -Pfast -pl wicket-request
mvn verify -pl wicket-core-tests -Dtest=UrlRendererTest
```

`-pl` (for "projects") limits the build to the modules you name, with their folder names. Install the changed module again after every change; otherwise the test runs against your previous build. When you changed more than one module, name them all, with quotes: `-pl "wicket-util,wicket-request"`.

When the test is in the same module as the code, as for most of `wicket-util` and `wicket-extensions`, one command is enough:

```shell
mvn verify -pl wicket-extensions -Dtest=AutoCompleteTest
```

To run one method of a test class, add its name: `-Dtest=UrlRendererTest#test1`. The [conventions]({{ site.baseurl }}/contribute/wicket-conventions.html#tests) say where a new test goes and how to name it.

Instead of installing first, `-am` ("also make") builds the modules the test module depends on from your working folder. It then looks for the test in each of those modules too, so it needs a second option:

```shell
mvn verify -pl wicket-core-tests -am -Dtest=UrlRendererTest "-Dsurefire.failIfNoSpecifiedTests=false"
```

## Run the JavaScript tests {#javascript-tests}

The JavaScript tests run in a headless Chrome and are off unless you ask for them with `-Pjs-test`:

```shell
mvn test -pl testing/wicket-js-tests -Pjs-test
```

The first run downloads Node.js into the `testing/wicket-js-tests` folder and Chrome into `.cache/puppeteer` in your home folder, which takes a while. On Linux, that Chrome needs the libraries of a normal Chrome installation; installing Google Chrome or Chromium is the easiest way to get them. The tests read the `.js` files from your working folder, so you do not need to install anything first.

The tests for the scripts of `wicket-core` are in `wicket-core/src/test/js/`, those for `wicket-extensions` in `wicket-extensions/src/test/js/`. A script without its own tests, such as `wicket-autocomplete.js`, is only checked by JSHint for mistakes. To add tests for it, add a `<name>-test.js` and a `<name>.html` page next to the existing ones in `wicket-extensions/src/test/js/`, and list them in `testing/wicket-js-tests/Gruntfile.js`: the test file under `extensionsTestsJs`, and the page in both URL lists of `qunit`, `all` and `vanilla`, like `veil.html`. [JAVASCRIPTTESTING.md](https://github.com/apache/wicket/blob/master/JAVASCRIPTTESTING.md) in the repository describes the test setup and how to run the tests faster without Maven.

## Run the examples

The `wicket-examples` module is a web application with an example of almost every component. To see your change in a browser, install the modules you changed and start the examples:

```shell
mvn install -DskipTests -Pfast
mvn jetty:run -pl wicket-examples
```

When the output shows a line with `Started oejs.Server`, open <http://localhost:8080>. Stop the server with Ctrl+C. To run the examples from your IDE, see [Set up your IDE]({{ site.baseurl }}/contribute/wicket-ide.html#examples).

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

- **`release version 21 not supported`**: Maven runs with an older Java. Check `mvn -v` and set `JAVA_HOME`.
- **`Counter(s) UNAPPROVED exceeded minimum or maximum values`**: a file you added has no license header. In `target/rat.txt` in the root folder, the files without one start with a `!`. Copy the header from a file of the same type.
- **A test fails that has nothing to do with your change**: check whether it also fails on `master`. The [build status of master](https://github.com/apache/wicket/actions?query=branch%3Amaster) shows whether it is broken there. If it is not, mention the failing test in your issue.
- **`No tests matching pattern`**: the test name after `-Dtest` does not exist in the modules you build. Check the module after `-pl` and the spelling of the class.
- **An error about the order of a `pom.xml`**: Wicket's build checks the order of sections and dependencies in every `pom.xml`. See the [conventions]({{ site.baseurl }}/contribute/wicket-conventions.html#poms).
