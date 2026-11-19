---
title: Send a pull request to Wicket
type: howto
topic: wicket
summary: From an issue to a reviewed pull request against apache/wicket, for your first contribution or your fiftieth.
order: 20
---
{% assign next = site.data.releases.lines | where: "status", "boarding" | first %}
{% assign current = site.data.releases.lines | where: "status", "current" | first %}
{% assign lts = site.data.releases.lines | where: "status", "lts" | first %}

Wicket's code lives in [apache/wicket](https://github.com/apache/wicket) on GitHub. You change it in your own copy, send the change as a pull request, and a committer, a member of the project who can merge, reviews it. This page takes you through it in order; for a first time, the tutorial [Your first pull request]({{ site.baseurl }}/contribute/wicket-first-pull-request.html) goes through the same steps with a real issue. You need a GitHub account, Git, a JDK and Maven; [Build and test Wicket]({{ site.baseurl }}/contribute/wicket-build.html#what-you-need) says which versions. The rules a contribution follows are in [CONTRIBUTING.md](https://github.com/apache/wicket/blob/master/CONTRIBUTING.md) in the repository.

## 1. Pick or open an issue {#reportbug}

Every change starts from an issue in the [issue tracker](https://github.com/apache/wicket/issues). Issues labelled [`good first issue`](https://github.com/apache/wicket/issues?q=is%3Aissue%20state%3Aopen%20label%3A%22good%20first%20issue%22) are small and need little knowledge of Wicket.

Comment on the issue that you are working on it, so that nobody else starts the same change. A claim without a pull request lapses after two weeks; if you need more time, say so on the issue. Ask your questions there as well: what the expected behaviour is, where the code is, how to test it. The people who answer would rather spend five minutes on a question than review a pull request that went the wrong way.

For a bug you found yourself, [open an issue](https://github.com/apache/wicket/issues/new) first. Say which Wicket version you use, and add a [quickstart]({{ site.baseurl }}/start/quickstart.html), a small project that shows the bug. Issues from before 2026 are in the read-only [Jira archive](https://issues.apache.org/jira/browse/WICKET); search it too. A security problem never goes into an issue: report it [privately]({{ site.baseurl }}/community/#security).

## 2. Fork and clone

Fork apache/wicket on GitHub with the Fork button. Clone your fork and add the Wicket repository as `upstream`:

```shell
git clone https://github.com/<your-account>/wicket.git
cd wicket
git remote add upstream https://github.com/apache/wicket.git
```

## 3. Create a branch from master

Wicket has a branch for every release line, a major version that still gets releases:

| Branch | Release line | Pull requests |
|---|---|---|
| `master` | {% if next %}Wicket {{ next.series }}, not released yet ({{ next.when }}){% else %}The next major release{% endif %} | Send them here. |
{% if current %}| `wicket-{{ current.series }}.x` | Wicket {{ current.series }}, the current release | Committers copy fixes here. |
{% endif %}{% if lts %}| `wicket-{{ lts.series }}.x` | Wicket {{ lts.series }}, long-term support (LTS) | Committers copy fixes here. |
{% endif %}

Start from `master`, also when you found the bug in an older version. After the merge, the committers copy the fix to the older branches where it applies; this is called cherry-picking. Say in the issue which versions the bug affects. [Why fixes go to master first]({{ site.baseurl }}/contribute/wicket-master-first.html) explains the reasons. Branches of versions that no longer get releases are under `archive/`.

Give your branch a name that says what it does:

```shell
git fetch upstream
git checkout -b keep-url-fragment upstream/master
```

## 4. Build Wicket

Build everything once, without the tests. The first time, this downloads the libraries Wicket uses and takes a few minutes:

```shell
mvn install -DskipTests -Pfast
```

It ends with `BUILD SUCCESS`. [Build and test Wicket]({{ site.baseurl }}/contribute/wicket-build.html) explains the options and what to do when the build fails. To work in IntelliJ IDEA, Eclipse or NetBeans, see [Set up your IDE]({{ site.baseurl }}/contribute/wicket-ide.html).

## 5. Change the code and add a test {#change}

Make the change, and add a test that fails without it and passes with it. A bug fix without a test is rarely merged.

The test is often in a different module than the code. The tests for `wicket-core`, for example, are in `wicket-core-tests`. Find the existing test of a class by its name plus `Test`:

```shell
git ls-files "*/UrlRendererTest.java"
```

Run the test with Maven. Because the test is in another module, Maven uses the module you changed from your local Maven repository, so install the changed module first:

```shell
mvn install -DskipTests -Pfast -pl wicket-request
mvn verify -pl wicket-core-tests -Dtest=UrlRendererTest
```

Repeat both commands after every change. Without the first one, the test runs against your previous build and passes or fails for the wrong reason. [Run one test]({{ site.baseurl }}/contribute/wicket-build.html#run-one-test) has the details, and [Run the JavaScript tests]({{ site.baseurl }}/contribute/wicket-build.html#javascript-tests) covers changes to `.js` files.

Follow the [code conventions]({{ site.baseurl }}/contribute/wicket-conventions.html): the code format of the file you edit, the license header on every new file, `@since` on new public methods and classes, and a test class name that ends in `Test`.

## 6. Run the full build

Before you send the pull request, build and test everything the way GitHub does it for every pull request:

```shell
mvn clean verify -Pjs-test
```

This runs all tests, the JavaScript tests and the license header check, and takes longer: on a laptop, count on a quarter of an hour or more. It has to end with `BUILD SUCCESS`.

## 7. Commit

Commit your change with a message in this form:

```text
Keep the fragment in UrlRenderer.renderFullUrl

renderRelativeUrl kept the fragment of a URL, but renderFullUrl dropped
it, so a full URL to a page section pointed to the top of the page.
renderFullUrl now appends the fragment in the same way.

GitHub issue #<number>
```

The first line says what the change does, in a normal sentence, without the issue number or a prefix like `fix:`. After an empty line, the body says what was wrong, why, and what is different now. The last line refers to the issue. For an issue that came from Jira, keep its key, such as `WICKET-7165`, in the body.

If you used a generative AI tool to write the change, say so in a last line such as `Generated-by: <name of tool> <version>`, as the [ASF recommends](https://www.apache.org/legal/generative-tooling.html). You stay responsible for every line of it.

Check which files you changed, add them, and commit:

```shell
git status
git add wicket-request/src/main/java/org/apache/wicket/request/UrlRenderer.java
git add wicket-core-tests/src/test/java/org/apache/wicket/core/request/cycle/UrlRendererTest.java
git commit
```

`git commit` opens a text editor for the message. If it opens one you do not know, set your own with `git config --global core.editor`, or commit from the commit window of your IDE.

## 8. Open the pull request {#github}

Push the branch to your fork:

```shell
git push -u origin keep-url-fragment
```

GitHub does not accept your password here. Sign in with the [GitHub CLI or a personal access token](https://docs.github.com/en/get-started/git-basics/caching-your-github-credentials-in-git), or clone over SSH.

GitHub then shows a button to compare and open a pull request. Check that the base repository is `apache/wicket` and the base branch is `master`. Give the pull request the first line of your commit message as title, and in the description say what changed, how you tested it, and `Fixes #<number>` for the issue. If the work is not finished but you want early feedback, open it as a draft.

GitHub runs the same full build on several JDKs; the result shows at the bottom of the pull request. On your first pull request, a committer may have to approve that run before it starts.

## 9. Work with the review

A reviewer comments on the pull request. Committers are volunteers, so a review can take a few days. If nothing happens for a week, ask for a review in a comment or on the [developers list]({{ site.baseurl }}/community/#dev).

To answer a review, commit on the same branch and push again; the pull request updates itself. Do not rebase, amend or force-push a branch that is already in review: the reviewers have read your earlier commits, and [history is not rewritten]({{ site.baseurl }}/contribute/wicket-master-first.html#history-that-is-not-rewritten). To bring the branch up to date with `master`, merge it:

```shell
git fetch upstream
git merge upstream/master
git push
```

A committer merges the pull request when it is ready. The change goes out with the next {% if next %}Wicket {{ next.series }}{% else %}major{% endif %} release, and with the next release of every older line it was copied to.

## Ask questions {#questions}

Ask in the issue you work on, in [GitHub Discussions](https://github.com/apache/wicket/discussions), or on the developers list, [dev@wicket.apache.org](mailto:dev@wicket.apache.org). Questions about building Wicket, finding code or writing a test are normal there. To write to the list, subscribe first by sending a mail to [dev-subscribe@wicket.apache.org](mailto:dev-subscribe@wicket.apache.org); the [archive](https://lists.apache.org/list.html?dev@wicket.apache.org) shows earlier conversations.
