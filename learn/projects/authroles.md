---
layout: default
title: Wicket Auth/Roles
---

This is mostly a technology demonstration implementing authorization and
authentication for the Apache Wicket web framework. The project supplies roles
based authorization and some simple authentication components.

## Contents ##

* [Introduction](#introduction)
* [Example](#example)
* [Installing](#installing)

## Introduction ##

Wicket Auth/Roles is a simplistic but useful security extension to the Wicket
framework. It is intended to be simplistic and not to be confused with a
framework. If you find this library useful, great. If you need more than is
supplied by this library, either look at [alternative security
integrations](#alternatives) or copy these classes and modify them at will
(this project **is** [open source](http://www.apache.org/licenses/) after
all.)

Like most if not all security solutions for Wicket, this project provides an
implementation for Wicket's `IAuthorizationStrategy`. When an authorization
strategy is installed in the security settings
(`WebApplication#getSecuritySettings`), Wicket will check for each component
(including pages) if instantiation is allowed and if rendering is allowed.

For more documentation use the following links:

* [Authentication API](http://wicket.apache.org/apidocs/1.5/org/apache/wicket/authentication/package-summary.html)
* [Authorization API](http://wicket.apache.org/apidocs/1.5/org/apache/wicket/authorization/package-summary.html)

Note that for the instantiation check Wicket will invoke the constructor
hierarchy of your component, but will throw an exception if the authorization
check fails.

### Authentication ###

As a basis, you should extend your web application class from
`AuthenticatedWebApplication`. When you create your class you'll be asked to
override the following methods:

* `newSession` - return a subclass of `AuthenticatedWebSession`
* `getSignInPageClass` - return the class for your login page (this one should
  not require authentication, otherwise you'll create an infinite loop)

Next you'll need to provide your custom session class-making it a subclass of
`AuthenticatedWebSession`. This class requires you to override the following
methods:

* `authenticate` - called when the user needs to be authenticated using a
  username and password
* `getRoles` - called after the users was authenticated and should provide the
  roles associated with the authenticated user.

You can use the provided `SignInPage`, which has been translated to a couple
of languages (see the source code for the actual translations), or roll your
own. When you roll your own, you can opt to use the provided `SignInPanel`
(which has been translated as well) so you don't have to create your own login
form.

### Authorization ###

Annotation for configuring what roles are allowed for instantiation the
annotated component or package. This annotation can be used for classes and
packages, and can be used like this:

{% highlight java %}
// only users with role ADMIN are allowed to create instances of this page, whether it is
// either bookmarkable or not
@AuthorizeInstantiation("ADMIN")
public class AdminAnnotationsBookmarkablePage extends WebPage
{% endhighlight %}

When someone who doesn't have the role ADMIN, Wicket will not allow the page
to be fully constructed and throw an authorization exception during the
construction of the page. This will result in an access denied page for the
user.

Enablng the annotations for role based authorization is done by setting the
`WebApplication#getSecuritySettings` value to
`AnnotationsRoleAuthorizationStrategy`. Then you can use the auth/roles
provided authorization annotations.

### Alternatives ###

More elaborate security solutions exist in the following projects:

 * [Wicket Shiro](https://github.com/wicketstuff/core/tree/core-1.5.x/jdk-1.5-parent/shiro-security) -
   integration between Apache Shiro and Wicket
 * [Wicket Security](https://github.com/wicketstuff/core/tree/core-1.5.x/jdk-1.5-parent/wicket-security-parent)
   - JAAS inspired, principal based security framework

If other security solutions are available for Wicket, [let us
know](https://issues.apache.org/jira/browse/WICKET).

## Example ##

The Wicket Examples project contains a [complete
example](http://wicket-library.com/wicket-examples/authorization) of limiting
access to pages and components using roles based authorization. It also contains
an [authentication
example](http://wicket-library.com/wicket-examples/authentication).

Click on the source links to see the related source code.

## Installing ##

Installing Wicket Auth/Roles can be done through adding a dependency in your
project's Maven pom, or by putting the wicket-auth-roles.jar and the required
dependencies in your projects classpath.

### Using Maven ###

Add the following dependency to your pom:

{% highlight xml %}
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-auth-roles</artifactId>
    <version>{{site.wicket.version}}</version>
</dependency>
{% endhighlight %}

### Required dependencies ###

Wicket Auth/Roles requires the following jar files to be on your classpath:

 * Wicket
 * Wicket Auth/Roles

