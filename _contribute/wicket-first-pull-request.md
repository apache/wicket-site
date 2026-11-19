---
title: Your first pull request
type: tutorial
topic: wicket
summary: Fix a real bug in Wicket from start to end, with a failing test, the fix, the right way to run the tests, and the pull request.
order: 10
---

In this tutorial you fix [issue #1950](https://github.com/apache/wicket/issues/1950): `UrlRenderer#renderFullUrl` forgets the fragment of a URL, the part after `#`. You write a test that shows the bug, fix it with one line, and send the fix to the Wicket project as a pull request.

You need a GitHub account, Git, a JDK and Maven on the command line. [Build and test Wicket]({{ site.baseurl }}/contribute/wicket-build.html#what-you-need) says which versions, and how to check them. You do not need to know Wicket.

After each command, this page shows what it prints, so you can check that you are on track. Your output differs in details such as times, folder names and commit ids. Lines with `…` are left out.

## 1. Claim the issue

Open [issue #1950](https://github.com/apache/wicket/issues/1950) and write a comment that you are working on it. If somebody else already claimed it less than two weeks ago, pick another [`good first issue`](https://github.com/apache/wicket/issues?q=is%3Aissue%20state%3Aopen%20label%3A%22good%20first%20issue%22) and follow the same steps with that issue.

## 2. Get the code

Fork apache/wicket on GitHub with the Fork button. Then clone your fork, add the Wicket repository as `upstream`, and create a branch from Wicket's `master`:

```shell
git clone https://github.com/<your-account>/wicket.git
cd wicket
git remote add upstream https://github.com/apache/wicket.git
git fetch upstream
git checkout -b keep-url-fragment upstream/master
```

`git fetch` lists every branch of the Wicket repository, and `git checkout` ends with:

```text
From https://github.com/apache/wicket
 * [new branch]            master                 -> upstream/master
 …
 * [new branch]            wicket-10.x            -> upstream/wicket-10.x
 * [new branch]            wicket-11.x            -> upstream/wicket-11.x
 …
Switched to a new branch 'keep-url-fragment'
branch 'keep-url-fragment' set up to track 'upstream/master'.
```

## 3. Build Wicket

Build every module once, without running the tests:

```shell
mvn install -DskipTests -Pfast
```

The first time, Maven downloads the libraries Wicket uses, which takes a few minutes. The build ends with a summary of every module:

```text
[INFO] Reactor Summary for Wicket Parent 12.0.0-SNAPSHOT:
[INFO]
[INFO] Wicket Parent ...................................... SUCCESS [  3.856 s]
[INFO] Wicket Util ........................................ SUCCESS [  3.260 s]
[INFO] Wicket Request ..................................... SUCCESS [  0.556 s]
[INFO] Wicket Core ........................................ SUCCESS [  5.454 s]
…
[INFO] Wicket Code Coverage ............................... SUCCESS [  0.183 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
```

It has put a jar of every module in your local Maven repository, the folder `.m2/repository` in your home folder.

## 4. Write a test that shows the bug

`UrlRenderer` is in the module `wicket-request`, but its test is in another module, `wicket-core-tests`. Open `wicket-core-tests/src/test/java/org/apache/wicket/core/request/cycle/UrlRendererTest.java` and add this method inside the class, below the method `renderFullUrlWithRelativeArgument`:

```java
	@Test
	void renderFullUrlKeepsFragment()
	{
		Url baseUrl = Url.parse("one/two/three");
		baseUrl.setProtocol("http");
		baseUrl.setHost("www.example.com");
		baseUrl.setPort(8888);
		UrlRenderer renderer = new UrlRenderer(new MockWebRequest(baseUrl));
		renderer.setBaseUrl(baseUrl);
		String fullUrl = renderer.renderFullUrl(Url.parse("../four#section"));
		assertEquals("http://www.example.com:8888/one/four#section", fullUrl);
	}
```

Wicket's code is indented with tabs, so use tabs here too. Run the new test:

```shell
mvn verify -pl wicket-core-tests -Dtest=UrlRendererTest#renderFullUrlKeepsFragment
```

The test fails, and Maven shows why:

```text
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running org.apache.wicket.core.request.cycle.UrlRendererTest
[ERROR] Tests run: 1, Failures: 1, Errors: 0, Skipped: 0, Time elapsed: 0.062 s <<< FAILURE! -- in org.apache.wicket.core.request.cycle.UrlRendererTest
[ERROR] org.apache.wicket.core.request.cycle.UrlRendererTest.renderFullUrlKeepsFragment -- Time elapsed: 0.049 s <<< FAILURE!
org.opentest4j.AssertionFailedError: expected: <http://www.example.com:8888/one/four#section> but was: <http://www.example.com:8888/one/four>
…
[INFO] BUILD FAILURE
```

This is the bug: the `#section` is gone. The lines `WARNING: Using incubator modules` and `SLF4J(W): No SLF4J providers were found` that appear around the test are normal; they come from the test setup, not from your change.

## 5. Fix the bug

Open `wicket-request/src/main/java/org/apache/wicket/request/UrlRenderer.java` and find the method `renderFullUrl`. For a relative URL, it resolves the URL against the base URL:

```java
			Url base = new Url(baseUrl);
			base.resolveRelative(url);
```

`resolveRelative` takes over the path and the query parameters of `url`, but not its fragment. Add a line that copies the fragment as well:

```java
			Url base = new Url(baseUrl);
			base.resolveRelative(url);
			base.setFragment(url.getFragment());
```

`git diff wicket-request` shows your change:

```diff
@@ -147,6 +147,7 @@ public class UrlRenderer
 		{
 			Url base = new Url(baseUrl);
 			base.resolveRelative(url);
+			base.setFragment(url.getFragment());
 			path = new StringBuilder(base.toString());
 		}
```

## 6. Run the test again

Run the same test:

```shell
mvn verify -pl wicket-core-tests -Dtest=UrlRendererTest#renderFullUrlKeepsFragment
```

It still fails, with the same message as in step 4:

```text
org.opentest4j.AssertionFailedError: expected: <http://www.example.com:8888/one/four#section> but was: <http://www.example.com:8888/one/four>
…
[INFO] BUILD FAILURE
```

You changed `wicket-request`, but you only built `wicket-core-tests`, so Maven used the `wicket-request` jar from your local repository: the one you built in step 3, without your fix. Install `wicket-request` first:

```shell
mvn install -DskipTests -Pfast -pl wicket-request
```

```text
[INFO] Installing …/wicket-request/target/wicket-request-12.0.0-SNAPSHOT.jar to …/.m2/repository/org/apache/wicket/wicket-request/12.0.0-SNAPSHOT/wicket-request-12.0.0-SNAPSHOT.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
```

Then run the test again:

```shell
mvn verify -pl wicket-core-tests -Dtest=UrlRendererTest#renderFullUrlKeepsFragment
```

Now it passes:

```text
[INFO] Running org.apache.wicket.core.request.cycle.UrlRendererTest
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.055 s -- in org.apache.wicket.core.request.cycle.UrlRendererTest
[INFO]
[INFO] Results:
[INFO]
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
…
[INFO] BUILD SUCCESS
```

Run all tests of the class, to see that the fix breaks nothing else in it:

```shell
mvn verify -pl wicket-core-tests -Dtest=UrlRendererTest
```

```text
[INFO] Tests run: 52, Failures: 0, Errors: 0, Skipped: 0
…
[INFO] BUILD SUCCESS
```

## 7. Run the full build

Build and test everything, the way GitHub does it for every pull request:

```shell
mvn clean verify -Pjs-test
```

This takes a while: on a laptop, count on a quarter of an hour or more. It ends with the same kind of summary as in step 3, every module with `SUCCESS`, and `BUILD SUCCESS`.

## 8. Commit

Check which files you changed:

```shell
git status
```

```text
On branch keep-url-fragment
Your branch is up to date with 'upstream/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   wicket-core-tests/src/test/java/org/apache/wicket/core/request/cycle/UrlRendererTest.java
	modified:   wicket-request/src/main/java/org/apache/wicket/request/UrlRenderer.java
```

These two files, and nothing else. Add them and commit:

```shell
git add wicket-request/src/main/java/org/apache/wicket/request/UrlRenderer.java
git add wicket-core-tests/src/test/java/org/apache/wicket/core/request/cycle/UrlRendererTest.java
git commit
```

Git opens a text editor. Write this message, save and close the editor:

```text
Keep the fragment in UrlRenderer.renderFullUrl

renderFullUrl dropped the fragment of a relative URL, while
renderRelativeUrl kept it, so a full URL to "page#section" pointed to
"page". The fragment is now copied to the resolved URL as well.

GitHub issue #1950
```

Git confirms the commit:

```text
[keep-url-fragment 188f9d8596] Keep the fragment in UrlRenderer.renderFullUrl
 2 files changed, 14 insertions(+)
```

## 9. Open the pull request

Push your branch to your fork:

```shell
git push -u origin keep-url-fragment
```

GitHub answers with a link to create the pull request:

```text
remote:
remote: Create a pull request for 'keep-url-fragment' on GitHub by visiting:
remote:      https://github.com/<your-account>/wicket/pull/new/keep-url-fragment
remote:
To https://github.com/<your-account>/wicket.git
 * [new branch]      keep-url-fragment -> keep-url-fragment
branch 'keep-url-fragment' set up to track 'origin/keep-url-fragment'.
```

Open the link. Check at the top that the base repository is `apache/wicket` and the base branch is `master`, and that the compare branch is `keep-url-fragment` of your fork. Use the first line of the commit message as title:

```text
Keep the fragment in UrlRenderer.renderFullUrl
```

and write a description like this one:

```markdown
`UrlRenderer#renderFullUrl` dropped the fragment of a relative URL, while
`renderRelativeUrl` kept it. It now copies the fragment to the resolved URL.

Fixes #1950

## Tested

- Added `UrlRendererTest#renderFullUrlKeepsFragment`. It fails without the
  fix and passes with it, after `mvn install -DskipTests -Pfast -pl wicket-request`.
- `mvn verify -pl wicket-core-tests -Dtest=UrlRendererTest`: 52 tests pass.
- `mvn clean verify -Pjs-test` passes.
```

`Fixes #1950` links the pull request to the issue, and closes the issue when the pull request is merged. Create the pull request.

GitHub now runs the full build for your pull request, and a committer reviews it. You have sent your first pull request to Wicket.

For your next change, [Send a pull request to Wicket]({{ site.baseurl }}/contribute/wicket-pull-request.html) has the same steps in short, with what to do during the review. [Why most tests live in another module]({{ site.baseurl }}/contribute/wicket-test-modules.html) explains what happened in step 6.
