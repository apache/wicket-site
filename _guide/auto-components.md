---
title: How markup becomes components
type: explanation
topic: components
summary: How Wicket loads, parses and caches markup, and how Wicket tags turn into auto components that you never add yourself.
since: 10
apis: [MarkupFactory, MarkupParser, IMarkupFilter, IComponentResolver, ComponentResolvers, MarkupCache, PageSettings, WicketTagIdentifier]
keywords: [auto component, autoAdd, component resolver, markup filter, markup parser, markup cache, wicket tags, enclosure hierarchy, isAuto, custom wicket tag]
order: 20
source: [internals/autocomponents.adoc]
---

You add components in Java and attach them to tags with `wicket:id`. Yet a rendered page contains components you never created: one for every `<wicket:message>`, every `<wicket:enclosure>`, every link inside `<wicket:link>`, every `<label wicket:for>`, and the `<head>` of the page. These are auto components. They come from two steps: parsing the markup, which turns the file into a list of tags Wicket understands, and resolving, which finds a component for each tag that needs one.

## Loading and caching markup

Wicket loads a component's markup the first time the component renders, not when it is created. The `MarkupFactory`, found in the application's markup settings, locates the file for the component's class, locale, style and variation, parses it and stores the result in the application-wide `MarkupCache`. Every later instance of the class, in any session, uses the cached markup. In development mode Wicket watches the files and drops a cache entry when its file changes, which is why editing HTML needs no restart.

Because markup is shared between all instances, it is read-only at runtime. Anything that differs per instance or per request, such as a value, an attribute or visibility, lives in components, not in the markup.

## Parsing: a chain of markup filters

The `MarkupParser` reads the file with an XML pull parser and passes every element through a chain of `IMarkupFilter`s. Each filter handles one concern and can change, mark or drop what passes through. Among the default filters:

| Filter | What it does |
|---|---|
| `WicketTagIdentifier` | Recognizes `wicket:id` attributes and tags in the Wicket namespace, and gives every Wicket tag without an id a generated one. Rejects unknown Wicket tags. |
| `WicketRemoveTagHandler` | Drops `<wicket:remove>` regions entirely. |
| `WicketLinkTagHandler` | Inside `<wicket:link>`, marks tags with a relative `href` or `src` as auto components. |
| `AutoLabelTagHandler` | Marks `<label wicket:for>` tags as auto components. |
| `WicketNamespaceHandler` | Reads the namespace prefix from `xmlns:...="http://wicket.apache.org"`. |
| `WicketMessageTagHandler` | Handles `wicket:message` attributes, on plain tags as well as component tags. |
| `HtmlHeaderSectionHandler` | In page markup, makes `<head>` (or `<wicket:header-items/>`) a component tag, and adds a `<head>` when the markup has a `<body>` but no `<head>`. |
| `EnclosureHandler`, `InlineEnclosureHandler` | Work out the controlling child of each enclosure. |

What comes out is a sequence of two kinds of elements: raw markup, which Wicket writes to the response as is, and component tags, which need a component. A tag becomes a component tag because it has a `wicket:id`, because it is a Wicket tag, or because a filter marked it.

The chain is open: a `MarkupFactory` subclass can add filters in `newMarkupParser`, and an application can register it with `getMarkupSettings().setMarkupFactory(...)`. Few applications need this.

Some Wicket tags never become components. `<wicket:remove>` is gone after parsing. `<wicket:child>` and `<wicket:extend>` serve to merge a parent's and a subclass's markup when it is loaded; see [Markup inheritance]({{ site.baseurl }}/docs/markup-inheritance.html). `<wicket:panel>` and `<wicket:border>` tell a panel or border which part of its file to use.

## Resolving: finding a component for each tag

When a container renders, it walks through its markup. For each component tag it looks for a child with the tag's id. For tags with a `wicket:id`, that child is normally the component you added. For a Wicket tag, there usually is none, so the container asks the component resolvers, the `IComponentResolver`s, to supply one. It asks in this order:

1. The container itself and its parents, up to the page, if they implement `IComponentResolver`. A `Border` resolves `<wicket:body>` this way, a `TransparentWebMarkupContainer` lets its parent's children render inside its tag, and an `Enclosure` finds the children in its markup.
2. The application-wide resolvers in `getPageSettings().getComponentResolvers()`, in the order they were registered.

The first resolver that returns a component wins. The default application-wide resolvers include `HtmlHeaderResolver` for `<head>` and `<wicket:head>`, `WicketMessageResolver` for `<wicket:message>`, `EnclosureHandler` and `InlineEnclosureHandler` for enclosures, `WicketContainerResolver` for `<wicket:container>`, and, in a web application, `AutoLinkResolver`, `AutoLabelResolver` and `AutoLabelTextResolver`. `ComponentResolvers.resolve` runs this lookup and is what you call if you write a component that renders unusual markup itself.

A resolved component is added to the container with `autoAdd` and marked as auto. Auto components are exempt from two rules that apply to your own components: they can be added while the page renders, and changes to them are not recorded in the page's version history. They are created from the markup, so treat them as stateless: whatever they need comes from the tag and from the components around them.

## Why enclosures are siblings, not parents

Resolving explains the one surprise in this mechanism. In the markup, `<wicket:enclosure>` contains the components inside it. In Java, it does not: the `Enclosure` is created by a resolver while its container renders, and is added to that same container, next to the components it encloses. The enclosure finds its controlling child by id in its parent and asks it whether it is visible.

So the markup hierarchy and the component hierarchy differ. When the enclosure is hidden, the components inside it are not hidden in Java: they are still configured, `onBeforeRender` may be called on them, and form components in a hidden enclosure are still validated when the form is submitted. WicketTester cannot see that they are hidden either.

Component queueing removes the difference. When you `queue` components instead of adding them, Wicket builds the hierarchy from the markup before rendering. When it meets a tag that has an auto component factory, such as an enclosure, it creates the component right there and places the queued components inside it. The enclosure becomes a real parent, and hiding it hides its children. See [Add components without repeating the markup hierarchy]({{ site.baseurl }}/docs/queue-components.html). Where you cannot queue, an `EnclosureContainer` that you add yourself gives the same result; see [Hide surrounding markup with wicket:enclosure]({{ site.baseurl }}/docs/use-enclosures.html).

## Your own tags

The same mechanism is available to applications. A class implementing `IComponentResolver`, registered with `getPageSettings().addComponentResolver(...)`, can supply components for tags that have no component in Java. A new tag name in the Wicket namespace also needs `WicketTagIdentifier.registerWellKnownTagName(...)`, or the parser rejects it.

This is a trade-off. A custom tag lets markup authors use a feature without touching Java, but it hides where the component comes from: someone reading the Java code does not see it, and someone reading the markup has to know the tag. Wicket's own tags are few for that reason, and most features that could be tags are components or behaviors instead. The complete list of tags is in [Wicket tags and attributes]({{ site.baseurl }}/docs/wicket-tags.html).
