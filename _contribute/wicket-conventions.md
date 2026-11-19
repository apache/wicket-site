---
title: Code conventions
type: reference
topic: wicket
summary: The rules a change to Wicket's code follows, from the code format and license header to tests, Javadoc and commit messages.
order: 40
---
{% assign next = site.data.releases.lines | where: "status", "boarding" | first %}

These are the rules a reviewer checks a change to Wicket against. The repository has its own guide for contributors, [CONTRIBUTING.md](https://github.com/apache/wicket/blob/master/CONTRIBUTING.md).

## Code format

| Rule | Value |
|---|---|
| Indentation | Tabs, shown as 4 spaces |
| Braces | On a line of their own, for classes, methods and blocks |
| Line length | At most 100 characters |
| Imports | One per class, no `*`, except static imports in tests |
| Formatter | `wicket-eclipse-settings/files/org.eclipse.jdt.core.prefs`; see [Set up your IDE]({{ site.baseurl }}/contribute/wicket-ide.html#the-code-format) |

The build does not check the format. Match the file you edit, and do not reformat lines you did not change.

## License header

Every new file starts with the Apache License header, as a comment in the syntax of the file: Java, JavaScript, CSS, HTML, `.properties`, `pom.xml`. Copy it from a file of the same type. The full build checks the headers with Apache RAT and fails on a file without one.

## Language

Everything is in English: names, comments, Javadoc, messages, commit messages and branch names. A new message key goes into the default bundle, such as `Application.utf8.properties`; the translated bundles, such as `Application_nl.utf8.properties`, are written by native speakers.

## Tests {#tests}

- A test class name ends in `Test`, such as `UrlRendererTest`. Maven runs only classes named `*Test.java`: a class named `UrlRendererTests` or `TestUrlRenderer` compiles but never runs.
- A module with a `-tests` companion keeps its tests there: the tests of `wicket-core` are in `wicket-core-tests`, those of `wicket-cdi` in `wicket-cdi-tests`. Other modules, such as `wicket-util` and `wicket-extensions`, keep their tests in their own `src/test/java`. Follow the module you work in, and put a new test next to the existing test of the same class.
- The HTML markup of a test page sits next to its Java class in `src/test/java`, not in `src/test/resources`.
- Tests use JUnit 5. For pages and components, extend `WicketTestCase`, which gives you a `WicketTester` as `tester`.
- JavaScript tests are QUnit tests in `src/test/js/` of `wicket-core` and `wicket-extensions`; see [Run the JavaScript tests]({{ site.baseurl }}/contribute/wicket-build.html#javascript-tests).

## Javadoc and comments

- Public classes and methods have Javadoc that says what they do with the values they get, not only what they return.
- A new public class, method or field gets an `@since` tag with the first release it appears in: {% if next %}`@since {{ next.version }}` on `master`{% else %}the version of `master` without `-SNAPSHOT`{% endif %}.
- Comments explain why, not what. Most code needs none; the reasoning for a change goes into the commit message.

## Changes to the API

A change to a public class or method can break applications that use it. On `master`, it needs a reason in the commit message, and where the old method can stay next to the new one, deprecate the old one with `@Deprecated` instead of removing it. On the release branches, such as `wicket-11.x`, the build fails on a change that breaks compatibility. A change that applications must react to also gets a section in `migration-to-<version>.md` in the root of the repository.

## poms {#poms}

The build checks the order in every `pom.xml`: sections in the standard Maven order, and dependencies sorted by scope, then group id, then artifact id. A module `pom.xml` names no versions; they are set as properties in the root `pom.xml`.

## Commit messages

| Part | Content |
|---|---|
| First line | What the change does, as a plain sentence. No issue number and no prefix like `fix:`. |
| Body | What the behaviour was, why that was wrong, what it is now, and what an application that relied on the old behaviour notices. |
| Issue | `GitHub issue #<number>` on a line of its own; a Jira key such as `WICKET-7165` for an issue from Jira. |
| Tools | `Generated-by: <name of tool>` when a generative AI tool wrote part of the change, as the [ASF asks](https://www.apache.org/legal/generative-tooling.html). |

A commit that is already pushed is not changed: no amend, rebase or force-push. Correct it with a new commit, and bring a branch up to date by merging `master` into it.

## Security

A suspected vulnerability goes to security@apache.org, never into an issue, pull request, commit message or branch name. [SECURITY.md](https://github.com/apache/wicket/blob/master/SECURITY.md) describes what counts as a vulnerability in Wicket.
