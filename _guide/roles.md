---
title: Restrict access by role
type: howto
topic: security
summary: Allow pages, components, actions and resources only for users with a given role, with annotations on classes and packages or in code.
since: 10
apis: [AuthorizeInstantiation, AuthorizeInstantiations, AuthorizeAction, AuthorizeActions, AuthorizeResource, AnnotationsRoleAuthorizationStrategy, MetaDataRoleAuthorizationStrategy, RoleAuthorizationStrategy, Roles, IAuthorizationStrategy]
keywords: [authorization, permissions, RBAC, access denied, package-info, admin page, hide for role, UnauthorizedInstantiationException, setAccessDeniedPage]
order: 20
source: [security/security_2.adoc]
---

You need this when some users may see or do more than others. The setup from [Log users in]({{ site.baseurl }}/docs/login.html) is assumed: an `AuthenticatedWebApplication` and a session whose `getRoles()` returns the roles of the current user. Roles are plain strings; `Roles.USER` and `Roles.ADMIN` are predefined.

`AuthenticatedWebApplication` installs a `RoleAuthorizationStrategy`, which combines an annotation-based and a metadata-based strategy. Both have to grant access. A class without any restriction is open to everyone.

## Give users their roles

*AppSession.java*

```java
@Override
public Roles getRoles() {
    if (!isSignedIn()) {
        return new Roles();
    }
    Roles roles = new Roles(Roles.USER);
    if (user.isAdministrator()) {
        roles.add(Roles.ADMIN);
    }
    return roles;
}
```

## Restrict a page to a role

*AdminPage.java*

```java
@AuthorizeInstantiation(Roles.ADMIN)
public class AdminPage extends WebPage {
}
```

The user needs at least one of the listed roles. An anonymous user is sent to the sign-in page; a signed-in user without the role gets the access-denied page. Several `@AuthorizeInstantiation` rules that must all hold go in `@AuthorizeInstantiations(ruleset = {...})`.

The annotation works on any component, not only on pages. Instantiating a restricted panel throws `UnauthorizedInstantiationException`.

## Hide or disable a component for a role

`@AuthorizeAction` restricts an action on every instance of a class. Wicket checks two actions: `RENDER` decides whether the component is rendered, `ENABLE` whether the user can use it.

*DeleteLink.java*

```java
@AuthorizeAction(action = Action.RENDER, roles = Roles.ADMIN)
public class DeleteLink extends Link<Void> {
    // ...
}
```

`deny` lists roles that are refused even when they also hold an accepted role. Use `@AuthorizeActions(actions = {...})` for more than one action on the same class.

To restrict a single instance instead of a class, use the metadata strategy:

```java
MetaDataRoleAuthorizationStrategy.authorize(deleteLink, Component.RENDER, Roles.ADMIN);
```

## Restrict a whole package

Put the annotation in the `package-info.java` of the package. The annotations come before the `package` line, the imports after it.

*com/example/admin/package-info.java*

```java
@AuthorizeInstantiation("ADMIN")
package com.example.admin;

import org.apache.wicket.authroles.authorization.strategies.role.annotations.AuthorizeInstantiation;
```

{% if site.wicket.version_11 %}
Wicket resolves the rules for a class like this:

- Annotations on a class replace the annotations on its package. They are not added to them.
- Annotations at the same level are combined with AND: each one has to grant access.
- Actions are resolved per action. A class that restricts only `ENABLE` keeps the `RENDER` rule of its package.
- A package annotation applies to that package only. Annotating `com.example` does not restrict `com.example.admin`.
- The `package-info.java` file must be compiled, shipped and loaded by the same class loader as the classes in the package.

> Since Wicket 11 every role annotation follows these rules. In Wicket 10 only `@AuthorizeInstantiation` does: `@AuthorizeAction` on a package is ignored, `@AuthorizeActions` and `@AuthorizeInstantiations` cannot be placed on a package, `@AuthorizeInstantiations` on a class does not replace the package rule, and `@AuthorizeResource` on a class and on its package must both grant access.
{: .since}
{% else %}
Wicket resolves `@AuthorizeInstantiation` for a class like this:

- An annotation on a class replaces the annotation on its package. It is not added to it.
- Annotations at the same level are combined with AND: each one has to grant access.
- A package annotation applies to that package only. Annotating `com.example` does not restrict `com.example.admin`.
- The `package-info.java` file must be compiled, shipped and loaded by the same class loader as the classes in the package.

The other role annotations do not follow these rules. `@AuthorizeAction` on a package is ignored, `@AuthorizeActions` and `@AuthorizeInstantiations` cannot be placed on a package, `@AuthorizeInstantiations` on a class does not replace the package rule, and `@AuthorizeResource` on a class and on its package must both grant access.
{% endif %}

### Exempt one class from its package

An annotation without roles allows everyone. Because it still replaces the package annotation, it opens up a single class:

*com/example/admin/AdminHelpPage.java*

```java
@AuthorizeInstantiation()
public class AdminHelpPage extends WebPage {
}
```

### Watch out for annotated superclasses

The role annotations are `@Inherited`. An annotation on a superclass counts as an annotation on the subclass, wherever the superclass lives, and so it replaces the annotation of the subclass's own package:

```java
// com/example/base/SecuredPage.java
@AuthorizeInstantiation("USER")
public class SecuredPage extends WebPage {
}

// com/example/admin/ReportPage.java, in the ADMIN package above
public class ReportPage extends SecuredPage {
}
```

`ReportPage` requires `USER`, not `ADMIN`. Moving a page into a restricted package has no effect when one of its superclasses is annotated. Annotate such a page explicitly.

## Restrict a resource

`@AuthorizeResource` works on `IResource` classes and their packages:

```java
@AuthorizeResource(Roles.ADMIN)
public class ExportResource extends AbstractResource {
    // ...
}
```

A refused request is passed to the `IUnauthorizedResourceRequestListener` in the security settings, which responds with 403 Forbidden by default.

## Grant access in code instead of with annotations

`MetaDataRoleAuthorizationStrategy` keeps the rules in application and component metadata. Set them up in `init()`:

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();
    MetaDataRoleAuthorizationStrategy.authorize(AdminPage.class, Roles.ADMIN);
}
```

Roles are given as a comma-separated string, such as `"ADMIN,AUDITOR"`. This strategy looks up the exact class: it has no package rules and nothing is inherited from superclasses.

## Show your own access-denied page

```java
getApplicationSettings().setAccessDeniedPage(AccessDeniedPage.class);
```

The page must be bookmarkable. To react differently when a signed-in user is refused a page, override `onUnauthorizedPage(Component)` in your `AuthenticatedWebApplication`; it throws `UnauthorizedInstantiationException` by default.

## Write your own authorization strategy

When roles do not fit, implement `IAuthorizationStrategy`. It has three checks: `isInstantiationAuthorized(Class)`, `isActionAuthorized(Component, Action)` and `isResourceAuthorized(IResource, PageParameters)`. Register it with `getSecuritySettings().setAuthorizationStrategy(...)`, and combine it with others in a `CompoundAuthorizationStrategy`. `IAuthorizationStrategy.AllowAllAuthorizationStrategy` allows everything and is a convenient base class. For the common case of "pages below this base class need a signed-in user" without `wicket-auth-roles`, extend `SimplePageAuthorizationStrategy` and implement `isAuthorized()`.
