---
title: Why most tests live in another module
type: explanation
topic: wicket
summary: Why wicket-core's tests are in wicket-core-tests, and why a test run with Maven can use an old build of the code you changed.
order: 60
---

## Tests need WicketTester, and WicketTester needs wicket-core

Most of Wicket's tests render a page or click a link, and for that they use `WicketTester`. Applications use `WicketTester` too, for their own tests, so it is not test code: it ships as a module of its own, `wicket-tester`. That module depends on `wicket-core`, because it drives Wicket's request cycle.

A test of `wicket-core` that uses `WicketTester` would make `wicket-core` depend on `wicket-tester`, which already depends on `wicket-core`. Maven does not allow such a cycle. So the tests of `wicket-core` live in a module after both, `wicket-core-tests`, which depends on `wicket-core` and `wicket-tester`. The module is never released; it only holds tests.

Until Wicket 9, `WicketTester` was part of `wicket-core` itself. It moved out in Wicket 10, and the tests of `wicket-core` moved with it. `wicket-cdi` has a companion `wicket-cdi-tests` as well. Modules that `wicket-tester` does not depend on, such as `wicket-extensions` and `wicket-auth-roles`, can use it in their own tests, and keep those in their own `src/test/java`. So does `wicket-util`, whose tests need nothing of `wicket-core`.

The tests in `wicket-core-tests` are not only about `wicket-core`. `wicket-request` comes before `wicket-core` in the build, so its own tests cannot use anything from `wicket-core`. A test of a `wicket-request` class that needs a mock request or a page lives in `wicket-core-tests` instead. `UrlRendererTest` is one: it tests `UrlRenderer` from `wicket-request` with the `MockWebRequest` of `wicket-core`.

## Maven builds only what you ask for

Maven builds the modules you name, and the modules they need come from somewhere else. With `-pl wicket-core-tests`, Maven builds `wicket-core-tests` only. The `wicket-request`, `wicket-core` and `wicket-tester` it depends on come from your local Maven repository, the jars that the last `mvn install` put there.

So when you change `wicket-request` and run a test in `wicket-core-tests`, the test runs against the `wicket-request` you installed last, not against the code in your working folder. A test of a bug fix then fails although the fix is right, or passes although the fix is wrong. Maven does not warn about it, because from its point of view nothing is wrong.

There are two ways around it. Install the changed module before the test run, so that the local repository holds your change. Or add `-am` ("also make"), so that Maven builds the modules the test module depends on from your working folder as well. `-am` builds more, and applies the test selection to every module it builds, so it needs `-Dsurefire.failIfNoSpecifiedTests=false` too. [Build and test Wicket]({{ site.baseurl }}/contribute/wicket-build.html#run-one-test) has the commands.

## Why the IDE does not have this problem

IntelliJ IDEA, Eclipse and VS Code read the Maven modules, but compile them themselves. When a module depends on another module of the same project, the IDE uses that module's classes from your working folder instead of the jar in the local repository. A test you run from these IDEs therefore sees your change at once. A full Maven build, `mvn clean verify`, also builds every module from source. Only the run with `-pl` and without `-am` takes the shortcut through the local repository.
