---
layout: post
title: A security policy for Apache Wicket
description: Wicket now documents how to report a vulnerability, what is in scope, and which inputs the framework trusts, in a SECURITY.md on every supported branch.
lines: ["10", "9", "8"]
---

Apache Wicket now has a security policy. The [SECURITY.md](https://github.com/apache/wicket/blob/master/SECURITY.md)
in the Wicket repository describes how to report a vulnerability, what we do and do not
assess, and the security model the framework works from: which inputs Wicket treats as
trusted, and which boundaries it promises to enforce. It is on `master` and on the
`wicket-10.x`, `wicket-9.x` and `wicket-8.x` branches, so it applies to every line we
support.

<!--more-->

## Why now

Over the past months the number of security reports has grown sharply, many of them
produced with tooling or language models. Some point at real problems. Others point at code
that does not exist, at versions we no longer support, or at behaviour that depends on a
deployment trusting something it should not. Each one costs the same to triage. Writing
down what the framework claims, and what it leaves to the application and the operator,
lets reporters check their finding before they send it, and lets us answer consistently.

## How to report

Report a suspected vulnerability privately to **security@apache.org**, the ASF security
team, who forward it to the Wicket PMC. Never use GitHub issues, pull requests, discussions
or the public mailing lists: they disclose the problem before a fix is available.

A useful report names the affected versions and module, the class and method, how an
attacker reaches that code and what the attacker controls, the impact, and ideally a failing
test. We assess a report against the current tip of a supported branch, so verify it there
first and say which commit you tested. How you found it does not matter to us, by hand, with
tooling or with a model; whether the code you describe exists does.

## What is out of scope

Three kinds of code inside the supported lines are not handled as vulnerabilities:

- **Deprecated code** that an application has to use deliberately. The remedy is to stop
  using it, and the javadoc says what to do instead.
- **`OriginResourceIsolationPolicy`**, the fallback that compares `Origin` and `Referer`
  headers. `FetchMetadataResourceIsolationPolicy` is the supported cross-origin defence.
- **`wicket-examples`**, which is teaching material and deliberately not production code.
  We still want to hear about problems in it, and fix them in the open.

## What Wicket trusts, and what that means for your application

The security model is worth reading if you run Wicket in production. A few points in it ask
something of the deployment:

- **The host comes from the container.** Wicket builds absolute URLs and redirects from the
  scheme, host and port the servlet container reports, and does not check the `Host`
  header itself. Configure the container or proxy to reject unexpected `Host` values.
- **`X-Forwarded-*` headers are ignored** unless you enable `XForwardedRequestWrapperFactory`,
  and should only be enabled behind a proxy that sets them.
- **Run production in `DEPLOYMENT` mode** and do not deploy `wicket-devutils`.
- **The page store and the session store are trusted storage.** An encrypted page store
  is tamper-evident; anything else that holds serialized Wicket data must not be writable by
  untrusted parties.
- **Model data is escaped by default; markup files and message bundles are trusted.**
  Turning off `escapeModelStrings` makes the content your responsibility, and so does
  placing a value in a JavaScript context.
- **Cross-origin listener calls are only refused when you register
  `ResourceIsolationRequestCycleListener`.** Wicket does not do this by default.
- **`CryptoMapper` is not authorization.** Encrypted URLs make URLs harder to forge; who
  may see a page is decided by your `IAuthorizationStrategy`.

## Tell us when the model is wrong

The security model describes what Wicket intends to enforce. If the code falls short of it,
that is a vulnerability and we want to hear about it. If you think the model itself is
wrong, that is just as useful to report: say so, and we discuss the model instead of a
single code path. Findings that are real but not vulnerabilities, such as hardening
suggestions, are welcome as public issues or pull requests.

— The Apache Wicket PMC
