---
title: API compatibility
type: explanation
topic: wicket
summary: Which changes to Wicket's public API are allowed where, why the build checks them only on the release branches, and what a breaking change owes its users.
order: 80
---

## Applications compile against Wicket

Every public class, method and field of Wicket is API: some application calls it, extends it or overrides it. When a method changes its parameters or disappears, applications that use it no longer compile. Worse, an application that was compiled against the old version and runs with the new one fails only at runtime, with a `NoSuchMethodError` at the moment the code is reached. Such a change is called binary incompatible.

## Breaking changes wait for a major release

Within a release line, an upgrade must be safe: going from 11.0.0 to 11.1.0 must not break the code of an application. Changes that break the API are only made in a new major release, on `master`. With a major release [every three months]({{ site.baseurl }}/versions/#release-policy), a needed change does not wait long.

Allowed on `master` does not mean free. Every breaking change costs every application an edit when it upgrades. So a change to public API needs a reason in its commit message, and where the old method can stay next to the new one, the old one is deprecated with `@Deprecated` and removed in a later major release, instead of removed at once.

## japicmp checks the release branches

The build compares every module with the first release of its line, the `.0.0` release, using the [japicmp](https://siom79.github.io/japicmp/) plugin, and fails on a binary incompatible change. The version to compare with is derived from the version of the branch: on `wicket-11.x`, whose version is `11.x.y-SNAPSHOT`, it is `11.0.0`.

On `master`, that release does not exist yet: the first release of the line under development is the one being prepared. japicmp finds nothing to compare with and checks nothing. This is what allows the breaking changes of a new major release, and it means the build on `master` does not tell you when your change breaks the API. You find out when someone tries to cherry-pick it to a release branch, and the build there fails. A change that touches public API is therefore worth a question on the issue before you write it.

## A migration path for every break

A change that breaks code or changes what a running application does gets a section in the migration guide of the release, `migration-to-<major>.md` in the root of the repository, in the same pull request. Where the change is mechanical, such as a renamed method, it also gets an [OpenRewrite](https://docs.openrewrite.org/) recipe in the `wicket-migration` module, so that applications can apply it automatically. Users read the guide when they upgrade; it is how they learn about the change before their build or their application fails.
