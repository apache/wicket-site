---
title: Wicket's security model
type: explanation
topic: wicket
summary: What Wicket as a framework protects against, what it leaves to the deployment, and why a suspected vulnerability is reported privately.
order: 90
---

The full policy is [SECURITY.md](https://github.com/apache/wicket/blob/master/SECURITY.md) in the repository. It says which lines receive security fixes, what a report needs, and in detail what Wicket trusts. This page explains the idea behind it.

## A framework, not an application

Wicket runs inside a servlet container, usually behind a proxy, as part of an application that someone deployed. Some protection only the framework can give, because it happens inside Wicket's own code. Other protection only the deployment can give, because only the deployment knows its host names, its proxies and its users. A security model draws the line between the two: what Wicket promises, and what it trusts the deployment to take care of.

## What Wicket protects

Wicket promises the things that are in its own hands. Text that a component renders from its model is escaped, so data from users does not become markup in the page; a component that writes model data unescaped by default is a bug in Wicket. Wicket does not serve every file on the classpath as a resource, only those that pass its resource guard. Where an application registers the resource isolation listener, a request from another site cannot invoke a link, a form or an Ajax behaviour on a page. A way around one of these promises is a vulnerability.

## What Wicket trusts

Other inputs Wicket takes as given. It trusts the host name and port the servlet container reports, because only the deployment knows its own names and can reject the wrong ones. It trusts the markup files of the application, because the developer wrote them, the same way a template engine trusts its templates. It trusts its own page store, because Java deserialization of data from an attacker is never safe. A report that only works when one of these trusted inputs is in an attacker's hands is a matter of deployment, not of the framework. If you think the model itself is wrong, that is worth reporting too.

Some code is outside the model entirely: deprecated code, which applications should stop using, and `wicket-examples`, which is teaching material and deliberately not hardened.

## Why reports are private

A vulnerability reported in public is known to attackers before a fixed release exists. So a suspected vulnerability goes to security@apache.org, never into an issue, a pull request, a commit message or a branch name, and stays private until the fix is released and announced. Everything else, such as hardening ideas or a problem in the examples, is welcome in public. When you are not sure which it is, report it privately.
