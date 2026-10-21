---
title: Send a pull request to Wicket
type: howto
topic: wicket
summary: Fork apache/wicket, pick the branch of the line you change, and send your fix or feature as a pull request.
order: 10
---

Wicket's code lives in [apache/wicket](https://github.com/apache/wicket) on GitHub. Changes arrive as pull requests, and a committer reviews and merges them. For a bug, first [open an issue](https://github.com/apache/wicket/issues) that describes it, ideally with a [quickstart]({{ site.baseurl }}/start/quickstart.html) that shows it, and refer to the issue from your pull request.

## Fork and clone

Fork apache/wicket on GitHub, clone your fork, and add the Wicket repository as `upstream`:

```shell
git clone https://github.com/<your-account>/wicket.git
cd wicket
git remote add upstream https://github.com/apache/wicket.git
```

## Pick the branch

Every release line has a branch. Start from the branch of the line your change is for:
{% assign next = site.data.releases.lines | where: "status", "boarding" | first %}

| Branch | Line |
|---|---|
| `master` | The next major release{% if next %}, Wicket {{ next.series }}{% endif %}. New features go here. |
| `wicket-10.x` | Wicket 10, the LTS. Fixes that the LTS needs. |
| `wicket-9.x`, `wicket-8.x` | Wicket 9 and 8, until their end of life. |

When a fix is needed on more than one line, say which lines the bug affects in the pull request; the committers decide where it is merged and backported.

```shell
git fetch upstream
git checkout -b fix-dropdown-null upstream/master
```

## Build and test

Build Wicket with Maven and run the tests before you send the change:

```shell
mvn clean install
```

[Build from source]({{ site.baseurl }}/contribute/build.html) covers the build in more detail, and [Set up your IDE]({{ site.baseurl }}/contribute/ides.html) the code style.

## Send the pull request

Push your branch to your fork and open a pull request against the branch you started from. Describe what changes and why, and link the issue. The project discusses larger changes on the [developers list]({{ site.baseurl }}/community/#dev); a short mail there with a link to your pull request helps it get noticed.
