---
layout: default
title: Meet Apache Wicket
---
By Jonathan Locke, original author of Wicket

## Why Wicket?

If you are looking to do web application programming in Java, you have a very
large number of choices these days. In fact, there are so many web
application frameworks now that it has become somewhat of a joke. One blog
site on the Internet poses the question: How many Java web frameworks can you
name? The answer they show looks like this:

## Frameworks, Frameworks Everywhere

<TABLE class="confluenceTable"><TBODY>
<TR>
<TD class="confluenceTd">Echo</TD>
<TD class="confluenceTd">Cocoon</TD>
<TD class="confluenceTd">Millstone</TD>
<TD class="confluenceTd">OXF</TD>
</TR>
<TR>
<TD class="confluenceTd">Struts</TD>
<TD class="confluenceTd">SOFIA</TD>
<TD class="confluenceTd">Tapestry</TD>
<TD class="confluenceTd">WebWork</TD>
</TR>
<TR>
<TD class="confluenceTd">RIFE</TD>
<TD class="confluenceTd">Spring MVC</TD>
<TD class="confluenceTd">Canyamo</TD>
<TD class="confluenceTd">Maverick</TD>
</TR>
<TR>
<TD class="confluenceTd">JPublish</TD>
<TD class="confluenceTd">JATO</TD>
<TD class="confluenceTd">Folium</TD>
<TD class="confluenceTd">Jucas</TD>
</TR>
<TR>
<TD class="confluenceTd">Verge</TD>
<TD class="confluenceTd">Niggle</TD>
<TD class="confluenceTd">Bishop</TD>
<TD class="confluenceTd">Barracuda</TD>
</TR>
<TR>
<TD class="confluenceTd">Action Framework</TD>
<TD class="confluenceTd">Shocks</TD>
<TD class="confluenceTd">TeaServlet</TD>
<TD class="confluenceTd">wingS</TD>
</TR>
<TR>
<TD class="confluenceTd">Expresso</TD>
<TD class="confluenceTd">Bento</TD>
<TD class="confluenceTd">jStatemachine</TD>
<TD class="confluenceTd">jZonic</TD>
</TR>
<TR>
<TD class="confluenceTd">OpenEmcee</TD>
<TD class="confluenceTd">Turbine</TD>
<TD class="confluenceTd">Scope</TD>
<TD class="confluenceTd">Warfare</TD>
</TR>
<TR>
<TD class="confluenceTd">JWAA</TD>
<TD class="confluenceTd">Jaffa</TD>
<TD class="confluenceTd">Jacquard</TD>
<TD class="confluenceTd">Macaw</TD>
</TR>
<TR>
<TD class="confluenceTd">Smile</TD>
<TD class="confluenceTd">MyFaces</TD>
<TD class="confluenceTd">Chiba</TD>
<TD class="confluenceTd">JBanana</TD>
</TR>
<TR>
<TD class="confluenceTd">Jeenius</TD>
<TD class="confluenceTd">JWarp</TD>
<TD class="confluenceTd">Genie</TD>
<TD class="confluenceTd">Melati</TD>
</TR>
<TR>
<TD class="confluenceTd">Dovetail</TD>
<TD class="confluenceTd">Cameleon</TD>
<TD class="confluenceTd">JFormular</TD>
<TD class="confluenceTd">Xoplon</TD>
</TR>
<TR>
<TD class="confluenceTd">Japple</TD>
<TD class="confluenceTd">Helma</TD>
<TD class="confluenceTd">Dinamica</TD>
<TD class="confluenceTd">WebOnSwing</TD>
</TR>
<TR>
<TD class="confluenceTd">Nacho</TD>
<TD class="confluenceTd">Cassandra</TD>
<TD class="confluenceTd">Baritus</TD>
<TD class="confluenceTd">Stripes</TD>
</TR>
<TR>
<TD class="confluenceTd">Click</TD>
<TD class="confluenceTd">GWT</TD>
<TD class="confluenceTd">&nbsp;</TD>
<TD class="confluenceTd">&nbsp;</TD>
</TR>
</TBODY></TABLE>


## Why "Reinvent the Wheel"?

In light of this, you may be wondering "What good is another web application
framework?" Indeed. Why "re-invent the wheel?" One snappy comeback to that
old saw is: because this time we could make it rounder!

But it was not simply a desire for higher quality that drove the creation of
Wicket. Even with so many options, there really is no web toolkit which fills
exactly the niche that Wicket fills. In fact, Wicket is quite unlike each of
the frameworks above.

Wicket's closest cousins are probably Tapestry and Echo, but even there the
likeness is very shallow. Like Tapestry, Wicket uses a special HTML attribute
to denote components, enabling easy editing with ordinary HTML editors. Like
Echo, Wicket has a first-class component model. But Wicket applications are
not like applications written in either Tapestry or Echo, because in Wicket
you get the best of both worlds. You get the benefits of a first-class
component model and a non-intrusive approach to HTML. In many situations,
this combination may prove to be a significant development advantage.

To understand why Wicket is so different, it may help to understand the
motivations that created it.

## Motivations

### Most existing web frameworks provide weak to non-existent support in managing server-side state ###

This normally means lots of ad-hoc code in web applications dealing with the
gory mechanics of state management. While Wicket will not allow you to stop
thinking about server state, it goes a long ways towards making it easy and
often transparent to manage that state.

In Wicket, all server side state is automatically managed. You will never
directly use an HttpSession object or similar wrapper to store state.
Instead, state is associated with components. Each server-side page component
holds a nested hierarchy of stateful components, where each component's model
is, in the end, a POJO (Plain Old Java Object). Wicket maintains a map of
these pages in each user's session. One purpose of this page map (and the
component hierarchy on each page) is to allow the framework to hide all
details of how your components and models are accessed. You deal with simple,
familiar Java objects and Wicket deals with things like URLs, session ids and
GET/POST requests.

You will also find that this well-structured server state makes it very easy
to deal with the dreaded "back button problem". In fact, Wicket has a generic
and robust solution which can identify and expire browser-cached pages that
have become stale due to structural changes to the model of a component on
the page.

Finally, Wicket has been designed to work with POJO persistence frameworks
such as JDO or Hibernate. This can make database driven web applications
quite easy to write.

For many applications, it will be worth trading off the increased server load
of extra server-side state for decreased development costs, lower maintenance
costs, quicker time-to-market and generally higher quality software. The
basic observation here is that software is expensive and complex while
servers from companies like E-machines and Dell are relatively dirt cheap.

In terms of efficiency versus productivity, perhaps Wicket is to JSP as Java
is to C. You can accomplish anything in Wicket in JSP. You may even do it
more efficiently in terms of memory or processor consumption. But it may take
you weeks or months longer to develop your application. And in the end, since
state management in JSP is ad-hoc, you are likely find security problems and
bugs popping up everywhere. Most of the other frameworks above will do only a
little more to help you.

### Most existing frameworks require special HTML code

JSP is by far the worst offender, allowing the embedding of Java code
directly in web pages, but to some degree almost all of the frameworks from
the list (except Tapestry) above introduce some kind of special syntax to
your HTML code.

Special syntax is highly undesirable because it changes the nature of HTML
from the kind of pure-and-simple HTML markup that web designers are familiar
with, to some kind of special HTML. This special HTML can be more difficult
to preview, edit and understand.

Wicket does not introduce any special syntax to HTML. Instead, it extends
HTML in a standards-compliant way via a Wicket namespace that is fully
compliant with the XHTML standard. This means that you can use Macromedia
Dreamweaver, Microsoft Front Page, Word, Adobe Go Live, or any other existing
HTML editor to work on your web pages and Wicket components. To accomplish
this, Wicket consistently uses a single id attribute in the Wicket namespace
("wicket:id") to mark HTML tags that should receive special treatment by the
toolkit. If you prefer not to render Wicket namespaced tags and attributes to
your end-users, Wicket has a simple setting to strip them all out, resulting
in ordinary, standards-compliant HTML.

No "special sauce" in your HTML means designers can mock up pages that you
can use directly in development. Adding Java components to the HTML is as
simple as setting the component name attribute. And you can then give the
HTML back to your web designers knowing that they can change it with
confidence.

Wicket, more than any other framework gives you a separation of concerns. Web
designers can work on the HTML with very little knowledge of the application
code (they cannot remove the component name tags and they cannot arbitrarily
change the nesting of components, but anything else goes). Likewise, coders
can work on the Java components that attach to the HTML without concerning
themselves with what a given page looks like. By not stepping on each other's
toes, everyone can get more work done.

### Existing frameworks are not easy

Most of the existing toolkits have poorly defined or non-existent object
models. In some cases, the model is defined using special XML syntaxes. The
syntaxes may be so cumbersome that special tools are required to manipulate
all the configuration information. Since these toolkits are not simple Java
libraries you may or may not be able to use your favorite IDE tools such as
editors, debuggers and compilers.

Wicket is all about simplicity. There are no configuration files to learn in
Wicket. Wicket is a simple class library with a consistent approach to
component structure. In Wicket, your web applications will more closely
resemble a Swing application than a JSP application. If you know Java (and
especially if you know Swing), you already know a lot about Wicket.

### Existing frameworks inhibit reusability

Tapestry and JSF at least have component models that allow reuse, but you are
likely to find that it is not particularly trivial to do, at least when
compared with Wicket. Wicket has been explicitly designed to make it very,
very easy to create reusable components. It's surprisingly simple to extend
existing components and to make compound components such as a SignInPanel or
AddressForm. It is also relatively easy to create components that exploit new
features of browsers. Components in Wicket can be packaged up in JAR files
and reused by simply dropping them in your lib folder - no configuration
necessary!

### Web programming should be fun!

This is my most personal goal for writing Wicket . None of the existing
frameworks are appealing to me in terms of intuitiveness, quickness, ease of
development, etc. It is my hope that Wicket represents a significant step in
the direction of making web applications easy and fun to write.

## Goals

Coming from these motivations, the following goals for Wicket emerged:

* EASY (SIMPLE / CONSISTENT / OBVIOUS)
  * POJO-centric
  * All code written in Java ala Swing
  * Minimize "conceptual surface area"
  * Avoid overuse of XML configuration files
  * Fully solve back button problem
  * Easy to create bookmarkable pages
  * Maximum type safety and compile-time problem diagnosis
  * Maximum diagnosis of run-time problems
  * Minimum reliance on special tools
  * Components, containers and conventions should be consistent

* REUSABLE
  * Components written in Wicket should be fully reusable
  * Reusable components should be easily distributed in ordinary JAR files

* NON-INTRUSIVE
  * HTML or other markup not polluted with programming semantics
  * Only one simple tagging construct in markup
  * Compatible with any ordinary HTML editor
  * Easy for graphics designers to recognize and avoid framework tagging
  * Easy to add tagging back to HTML if designers accidentally remove it

* SAFE
  * Code is secure by default
  * Only explicitly bookmarkable links can expose state in the page or URL
  * All logic in Java with maximum type safety
  * Easy to integrate with Java security

* EFFICIENT / SCALABLE
  * Efficient and lightweight, but not at the expense of other goals
  * Clustering through sticky sessions preferred
  * Clustering via session replication is easy to accomplish and easy to tune by working with detachable models.

* COMPLETE

  * The Wicket team is committed to deliver a feature complete, ready-to-use
    framework for developing Java web applications. The core framework was
    written and contributed by the author of this introduction, Jonathan
    Locke. The current team consists of a group of experienced programmers,
    some of which were active on some of the other frameworks stated above,
    and all of which have extensive experience building large scale Java web
    applications. We eat our own dogfood, and will thus work on Wicket from a
    framework user's perspective.
