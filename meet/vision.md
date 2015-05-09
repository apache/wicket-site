---
layout: default
title: The Wicket Vision
---

Designing and implementing any framework for use in the real world inevitably
involves compromises and some degree of complexity, and Wicket is no
exception. However, I believe you will find that Wicket is quite compact,
focused and powerful as a framework. If Wicket has these characteristics, it
is because it was designed to solve one very specific problem well:

> enabling component-oriented, programmatic manipulation of markup

Wicket does this and very little else, and that is a good thing.

I once heard Josh Bloch talk about the power to weight ratio of an API. The
highest compliment anyone could make of Wicket would be to suggest that
Wicket has a lot of power and not much conceptual surface area.

In art, negative space is the part that's not the subject. In music, negative
space is the rest. In software, negative space is all the code that you
managed to avoid writing. In all three disciplines, it's what separates what
is truly excellent from what is merely good.

Following this metaphor, if Wicket is our foreground object, it is defined in
a negative sense by all the things that it is not (by the background).

In other words, ideally, Wicket is a web UI framework that delegates as many
areas of responsibility as possible to other, more focused tools and
techniques. It recognizes that Hibernate is good at persistence; that Spring is
good at DI; that Java properties files are good for
localization; that sub-classing is good for creating component types; that
Dreamweaver is good at doing HTML layout; that Beans are good for structuring
properties; and so on.

The more ways that Wicket can find to offload responsibilities (both now and
in the future), the less it will be. And thus, the more it will be.

The difficulty moving forward with Wicket will be balancing all the
day-to-day needs people are going to be bringing up with this overall vision
of minimalism. There ultimately will be compromises, and the "trick" to
making the right compromises is simply to agonize over all the options for a
long time and then to only make the compromises that everyone agrees are
really essential to what Wicket needs to be and do.

A big part of this process of agonizing is to act like doctors and "first, do
no harm". If some issue isn't sitting well with everyone yet, there's
probably a reason for that. So, maybe the near-term solution is to simply do
nothing and let people use the existing functionality until the limits to
that approach (as well as competing ideas) are better understood.

It's easy to add features. It's often impossible to change or remove them.

Given this, the Wicket approach to the overall problem of evolving while
keeping a high power to weight ratio will be partitioning off all
controversial new ideas in a "wicket-stuff" package until they are broadly
accepted. This way people can experiment and code away and check in lots of
stuff without affecting the main codebase with untested ideas. Then, when
ideas pan out to everyone's satisfaction, the leads of the
project will move them into the core.
