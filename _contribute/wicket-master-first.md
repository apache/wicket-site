---
title: Why fixes go to master first
type: explanation
topic: wicket
summary: Why every pull request targets master, how a fix reaches the release lines afterwards, and who decides which lines get it.
order: 70
---
{% assign next = site.data.releases.lines | where: "status", "boarding" | first %}
{% assign current = site.data.releases.lines | where: "status", "current" | first %}
{% assign lts = site.data.releases.lines | where: "status", "lts" | first %}

## Several lines at once

Wicket releases a new major version [every three months]({{ site.baseurl }}/versions/#release-policy), and keeps a long-term support line next to it. So at any time several versions get releases: {% if next %}Wicket {{ next.series }} is being developed on `master`, {% endif %}{% if current %}Wicket {{ current.series }} is the current release, maintained on `wicket-{{ current.series }}.x`, {% endif %}{% if lts %}and Wicket {{ lts.series }} is the LTS, maintained on `wicket-{{ lts.series }}.x`{% endif %}. A bug found in one of them is often in all of them.

## Newest first

A fix starts on `master` and is then copied down to the older branches it applies to. Copying a single commit from one branch to another is called cherry-picking.

The other direction goes wrong in a way nobody notices. A fix made on `wicket-{% if lts %}{{ lts.series }}{% else %}10{% endif %}.x` alone is gone again in the next major release, and the users who upgrade get the bug back. When every fix starts on `master`, the newest line has all of them by construction, and only the copies to older lines need checking.

That is also why GitHub runs the build only for pull requests against `master`: it is the branch every change passes through.

## Committers decide which lines get a fix

Whether a fix goes to the older lines is a decision, not a rule. A fix that changes behaviour applications may rely on can be right for the next major release and wrong for a patch release of the LTS, whose users expect an upgrade to change nothing but the bug. The code may also have moved: a fix on `master` sometimes does not apply to an older branch, or needs a different change there. And on the release branches the build refuses any change that breaks [API compatibility]({{ site.baseurl }}/contribute/wicket-api-compatibility.html), which `master` still allows.

So you send one pull request, against `master`, and say in the issue which versions have the bug. The committers decide which lines get the fix, and cherry-pick it after the merge.

## Wicket's branches are never rewritten

Once a commit is on `master` or a release branch, it does not change. A cherry-pick to an older branch is a new commit that often records the commit on `master` it came from, as `cherry picked from commit …` in its message, and issues and pull requests link to commits too. Rewriting `master` would turn those commits into new ones, and every reference would point to nothing. So the branches of apache/wicket refuse force pushes: `master`, the `wicket-*.x` release branches, and the `release/`, `rel/` and `archive/` branches.

This holds for Wicket's own branches, not for the branch of a pull request in your fork. Until it is merged, you can clean that branch up and force-push it, as [Send a pull request to Wicket]({{ site.baseurl }}/contribute/wicket-pull-request.html#9-work-with-the-review) describes.
