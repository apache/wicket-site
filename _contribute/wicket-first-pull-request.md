---
title: Your first pull request
type: tutorial
topic: wicket
summary: Fix a real bug in Wicket from start to end, with a failing test, the fix, the right way to run the tests, and the pull request.
order: 10
---

In this tutorial you fix [issue #1950](https://github.com/apache/wicket/issues/1950): `UrlRenderer#renderFullUrl` forgets the fragment of a URL, the part after `#`. You write a test that shows the bug, fix it with one line, and send the fix to the Wicket project as a pull request.

You need a GitHub account, Git, a JDK and Maven on the command line. [Build and test Wicket]({{ site.baseurl }}/contribute/wicket-build.html#what-you-need) says which versions, and how to check them. You do not need to know Wicket.

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

## 3. Build Wicket

Build every module once, without running the tests:

```shell
mvn install -DskipTests -Pfast
```

The first time, Maven downloads the libraries Wicket uses, which takes a few minutes. The build ends with `BUILD SUCCESS`. It has put a jar of every module in your local Maven repository, the folder `.m2/repository` in your home folder.

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
expected: <http://www.example.com:8888/one/four#section> but was: <http://www.example.com:8888/one/four>
```

This is the bug: the `#section` is gone.

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

## 6. Run the test again

Run the same test:

```shell
mvn verify -pl wicket-core-tests -Dtest=UrlRendererTest#renderFullUrlKeepsFragment
```

It still fails. You changed `wicket-request`, but you only built `wicket-core-tests`, so Maven used the `wicket-request` jar from your local repository: the one you built in step 3, without your fix. Install `wicket-request` first, then run the test:

```shell
mvn install -DskipTests -Pfast -pl wicket-request
mvn verify -pl wicket-core-tests -Dtest=UrlRendererTest#renderFullUrlKeepsFragment
```

Now the test passes. Run all tests of the class, to see that the fix breaks nothing else in it:

```shell
mvn verify -pl wicket-core-tests -Dtest=UrlRendererTest
```

## 7. Run the full build

Build and test everything, the way GitHub does it for every pull request:

```shell
mvn clean verify -Pjs-test
```

This takes a while: on a laptop, count on a quarter of an hour or more. It has to end with `BUILD SUCCESS`.

## 8. Commit

Add the two files and commit:

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

## 9. Open the pull request

Push your branch to your fork:

```shell
git push -u origin keep-url-fragment
```

The output of `git push` shows a link to create a pull request; open it. Check that the base repository is `apache/wicket` and the base branch is `master`. Write `Fixes #1950` in the description, with a sentence on how you tested the fix, and create the pull request.

GitHub now runs the full build for your pull request, and a committer reviews it. You have sent your first pull request to Wicket.

For your next change, [Send a pull request to Wicket]({{ site.baseurl }}/contribute/wicket-pull-request.html) has the same steps in short, with what to do during the review. [Why most tests live in another module]({{ site.baseurl }}/contribute/wicket-test-modules.html) explains what happened in step 6.
