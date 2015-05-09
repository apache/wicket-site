---
layout: default
title: Features
---
## POJO Component Model ##

Pages and Components in Wicket are real Java objects that support
encapsulation, inheritance and events.

## Ease of Development ##

Because Wicket is Java and HTML, you can leverage what you know about Java or
your favorite HTML editor to write Wicket applications.

## Separation of Concerns ##

Wicket does not mix markup with Java code and adds no special syntax to your
markup files. The worlds of HTML and Java are parallel and associated only by
Wicket ids, which are attributes in HTML and Component properties in Java.
Since Wicket HTML is just HTML and Wicket Java is just Java, coders and
designers can work independently to a large degree and without relying on any
special tools.

## Secure ##

Wicket is secure by default. URLs do not expose sensitive information and all
component paths are session-relative. Explicit steps must be taken to share
information between sessions. Furthermore URL encryption allows highly secure web sites.

## Transparent, Scalable Clustering Support ##

All Wicket applications will work on a cluster automatically and without
additional work. Once bottlenecks are understood, Wicket enables tuning of
page state replication. The next version of Wicket will support client-side
models for zero-state scalability.

## Transparent Back Button Support ##

Wicket supports configurable page version management. When users submit a
form or follow a link from a page they accessed with the back button in their
browser, Wicket is able to revert the page object to the state it was in when
the page was originally rendered. This means you can write web applications
that support the back button with very little work.

## Multi-tab and multi-window support ##

Wicket provides an easy way to write application that supports multi-window
and multi-tab usage allowing developer to react properly when users open new
browser window or tab

## Reusable Components ##

Reusable components in Wicket are particularly easy to create. Not only can
you extend existing components with the Java extends keyword, but you can
also create Panel components which associate a group of components as a
reusable unit.

## Simple, Flexible, Localizable Form Validation ##

It is trivial to write and use validators in Wicket. It is also quite easy to
customize and localize the display and content of validation error messages.

## Typesafe Sessions ##

Wicket eliminates the need to manage HttpSession attributes by hand. Page and
component objects are transparently stored in the session and your
application can create a custom session subclass with typesafe properties as
well. All objects stored in the session can automatically participate in
clustering replication.

## Factory Customizable ##

Wicket is very extensible. Most operations are customizable through factories
or factory methods.

## Detachable Models ##

Model objects in Wicket can be very lightweight in terms of memory and
network use in a cluster. When a model is used, it can "attach", populating
itself with information from persistent storage. When the model is no longer
in use, transient information can be reset, reducing the size of the object.

## Border Components ##

Wicket Border components enable the decoration of pages in a reusable
fashion. This is especially useful for inheritance of common navigational
structures or layout.

## Support for All Basic HTML Features ##

Wicket supports image tags, links, forms and everything else that you're used
to using in your web application development.

## Programmatic Manipulation of Attributes ##

Wicket Components can programmatically change any HTML tag attribute.

## Automatic Conversions ##

Once a Form validates, the model can be updated using Wicket converters. Most
ordinary conversions are built-in and it is easy to write new converters.

## Dynamic Images ##

Wicket makes image use, sharing and generation very easy. Dynamic images can
be created by simply implementing a paint method.

## Pageable ListView ##

ListViews in Wicket are extremely powerful. You can nest any kind of
component in a ListView row, even other ListViews. PageableListView supports
navigation links for large lists.

## Tree Component ##

Out of the box tree component for navigating and selecting nodes.

## Localization ##

HTML pages, images and resource strings can all be localized.

## Examples ##

Wicket has numerous examples showcasing all of the above features.
