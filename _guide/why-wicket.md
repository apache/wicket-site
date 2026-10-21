---
title: Why component-oriented
type: explanation
topic: start
summary: What a component-oriented framework does differently from request-based MVC frameworks, what Wicket gains from it, and what it costs.
since: 10
apis: [Component, WebPage, MarkupContainer]
keywords: [component tree, component-based, MVC, action-based, request-based, server-side state, compare frameworks, JSF, Vaadin, Spring MVC, Thymeleaf, single-page application, plain HTML templates, Swing]
order: 10
source: [whyLearn.adoc, whyLearn/whyLearn_1.adoc, whyLearn/whyLearn_2.adoc, whyLearn/whyLearn_3.adoc, whyLearn/whyLearn_4.adoc, introduction.adoc]
---

Wicket is a component-oriented web framework: you build a web page the way you build a desktop window in Swing, as a tree of Java objects, and the framework turns that tree into HTML. Most Java web frameworks work the other way around. To understand the trade-off, it helps to look at what each approach makes you do yourself.

## Request-based frameworks

Frameworks such as Spring MVC, Jakarta MVC and Struts are request-based. A controller method handles one HTTP request: it reads request parameters, calls the business code, puts some values in a model map and names a template. The template, in Thymeleaf, JSP or FreeMarker, pulls the values out of that map with an expression language and produces HTML.

This maps directly onto HTTP, and that is its strength. Every request stands on its own, the server keeps nothing between requests unless you put it in the session, and URLs and parameters are under your control.

It also means the web is never hidden from you. A form that a user edits over three requests is three separate controller calls, and keeping the values in between is your job: in hidden fields, in the session, or in the URL. Converting the request parameters, which are strings, to your types and back is your job too, as is deciding which part of the page changes after an action. The page itself is not an object you can hold on to; it is the output of a template.

## A tree of components on the server

A component-oriented framework keeps a model of the page on the server. In Wicket, a page is an instance of a `WebPage` subclass. It contains components, such as labels, links, forms and text fields, and containers that hold other components. Together they form a tree. When a request comes in, Wicket finds or creates the page, lets the components handle the request, and then asks each component to render its part of the HTML.

You can think of this tree as a DOM that lives on the server: it exists before any HTML does, and the HTML is generated from it, not the other way around. A link is not a URL you construct, but a component with an `onClick()` method. A text field is not a request parameter, but an object that converts and validates its input and writes it to your Java object.

Wicket shares this idea with other component frameworks. Jakarta Faces builds a component tree from its view definitions, and Vaadin builds the whole user interface in Java and renders it with its own client-side widgets. Wicket's version keeps the HTML in plain HTML files and the behavior in plain Java classes.

## What you gain

**Pages are objects.** You write a page as a Java class, so everything you know about classes applies. A base class gives all pages the same layout, and Wicket extends that inheritance to the markup. A panel you write once is a component you use on any page, packaged with its markup, CSS and JavaScript in a jar if you like.

**State is ordinary Java state.** Because Wicket keeps the page between requests, a field on a page keeps its value. A wizard can hold the object it is building in a field, a list can remember its sort order, and a form shows the values the user typed after a validation error, without you storing anything in the session by hand. Wicket stores the pages for you, per user session.

**HTML stays HTML.** A Wicket template is an HTML file with `wicket:id` attributes on the tags that components fill in. It has no loops, no conditions and no expression language: those live in Java, where the compiler checks them and your IDE can refactor them. A designer can open the template in a browser, and you can put example content in it that Wicket replaces at run time.

**Data binding is built in.** Components read and write their values through models. A text field converts the submitted string to your type, validates it and sets it on your object, and shows the current value when it renders. You do not parse request parameters.

**You can test without a browser.** Since pages and components are objects, `WicketTester` can render them, click their links and submit their forms in a plain JUnit test, without a servlet container.

## What it costs

**Memory and serialization.** Keeping pages on the server has a price. Wicket keeps the most recent pages of each session in memory and writes pages to disk, which means everything a page refers to must be serializable and should be small. Models that load data per request and let it go at the end, detachable models, exist for this reason. [How pages are stored]({{ site.baseurl }}/docs/page-storage.html) describes the mechanism.

**Stateless pages take effort.** A page with a plain `Link` or `Form` is stateful: its URLs point to a stored page instance, and the page expires with the session. For pages that search engines index or that must survive a server restart, you choose stateless components and bookmarkable URLs deliberately. [Stateful and stateless pages]({{ site.baseurl }}/docs/stateful-stateless.html) explains when Wicket keeps a page and when it does not.

**HTTP is further away.** Wicket generates URLs, so readable URLs require mounting pages. A developer who knows request-based frameworks has to learn when a component's code runs, and that a page instance lives longer than one request.

**It is not a client-side framework.** Wicket renders HTML on the server, also for Ajax updates. It suits applications with many forms and much business logic: administration screens, line-of-business applications, portals. If your interface lives mostly in the browser and talks to the server through a JSON API, a JavaScript framework fits better, and Wicket can still [wrap JavaScript widgets as components]({{ site.baseurl }}/docs/integrate-javascript.html) when you need some of both.

## Why Wicket among component frameworks

Wicket has existed since 2004 and has been an Apache Software Foundation project since 2007, developed in the open under the Apache License 2.0. It is not tied to a company's product line or license changes. Its user list and issue tracker are open to anyone.

It also stays small in what it asks of you. There is no special template language and no XML configuration besides an optional `web.xml`: an application is a class with `getHomePage()` and an `init()` method, and pages are classes with HTML files next to them. Everything else is Java, which is where Wicket wants your application's logic to be.
