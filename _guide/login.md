---
title: Log users in
type: howto
topic: security
summary: Add a sign-in page with wicket-auth-roles, send anonymous users there when a page needs a signed-in user, and sign them out again.
since: 10
apis: [AuthenticatedWebApplication, AuthenticatedWebSession, AbstractAuthenticatedWebSession, UsernamePasswordPanel, UsernamePasswordPage, RestartResponseAtInterceptPageException]
keywords: [authentication, sign in, login form, logout, sign out, signIn, continueToOriginalDestination, intercept page, session fixation, SignInPanel, remember me, IAuthenticationStrategy]
order: 10
source: [security/security_1.adoc]
---

You need this when some pages may only be seen by a user who has signed in. The `wicket-auth-roles` module gives you a session that knows whether the user is signed in, an application class that sends anonymous users to a sign-in page, and a ready-made sign-in form.

## Add wicket-auth-roles

*pom.xml*

```xml
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-auth-roles</artifactId>
    <version>${wicket.version}</version>
</dependency>
```

## Check the credentials in the session

Extend `AuthenticatedWebSession`. Wicket calls `authenticate` when the user signs in; return `true` when the username and password are valid. `getRoles` returns what the user may do, and is what restricted pages are checked against.

*AppSession.java*

```java
public class AppSession extends AuthenticatedWebSession {
    private String username;

    public AppSession(Request request) {
        super(request);
    }

    @Override
    protected boolean authenticate(String username, String password) {
        // check against your own user store, never against a plain-text password
        if (userStore().verify(username, password)) {
            this.username = username;
            return true;
        }
        return false;
    }

    @Override
    public Roles getRoles() {
        return isSignedIn() ? new Roles(Roles.USER) : new Roles();
    }

    public String getUsername() {
        return username;
    }
}
```

The session class needs a public constructor that takes a `Request`. When `authenticate` succeeds, `signIn` gives the session a new id and binds it, so a session id planted before the sign-in is useless afterwards.

## Configure the application

Extend `AuthenticatedWebApplication` and name the session class and the sign-in page.

*WicketApplication.java*

```java
public class WicketApplication extends AuthenticatedWebApplication {
    @Override
    public Class<? extends Page> getHomePage() {
        return HomePage.class;
    }

    @Override
    protected Class<? extends AbstractAuthenticatedWebSession> getWebSessionClass() {
        return AppSession.class;
    }

    @Override
    protected Class<? extends WebPage> getSignInPageClass() {
        return SignInPage.class;
    }

    @Override
    protected void init() {
        super.init();
        // your own configuration
    }
}
```

Always call `super.init()`: that is where the application installs its authorization strategy.

## Require a signed-in user on a page

Annotate the page, or a base class of all protected pages, with the role every signed-in user has:

*AccountPage.java*

```java
@AuthorizeInstantiation(Roles.USER)
public class AccountPage extends WebPage {
}
```

When an anonymous user requests the page, the application remembers the requested URL and redirects to the sign-in page. A user who is signed in but lacks the role gets the access-denied page instead. [Restrict access by role]({{ site.baseurl }}/docs/roles.html) covers roles, actions and whole packages.

## Add the sign-in page

`UsernamePasswordPanel` contains a feedback panel and a stateless form with a username and a password field. On success it continues to the page the user originally asked for, or to the home page if there was none. On failure it shows the message with the resource key `signInFailed`.

*SignInPage.java*

```java
public class SignInPage extends WebPage {
    public SignInPage() {
        add(new UsernamePasswordPanel("signIn"));
    }
}
```

*SignInPage.html*

```html
<!DOCTYPE html>
<html xmlns:wicket="http://wicket.apache.org">
<body>
    <h1>Sign in</h1>
    <div wicket:id="signIn"></div>
</body>
</html>
```

If the default layout is good enough, return `UsernamePasswordPage.class` from `getSignInPageClass()` and skip your own page.

> `UsernamePasswordPanel` and `UsernamePasswordPage` exist since Wicket 10.11.0. Wicket 10 also has `SignInPanel` and `SignInPage`, whose "remember me" option stores the username and password in a cookie. They are deprecated in 10.11.0 and removed in Wicket 11, together with `IAuthenticationStrategy`, its implementations and `SecuritySettings.get/setAuthenticationStrategy()`; signing out no longer clears a remember-me cookie. A persistent login needs your own random, revocable token per device.
{: .since}

## Write your own sign-in form

Call `signIn` on the session and continue to the original destination. `continueToOriginalDestination()` does not return when there is a remembered URL, so the line after it only runs when there was none.

*SignInPage.java*

```java
public class SignInPage extends WebPage {
    private String username;
    private String password;

    public SignInPage() {
        add(new FeedbackPanel("feedback"));

        var form = new StatelessForm<Void>("form") {
            @Override
            protected void onSubmit() {
                if (AuthenticatedWebSession.get().signIn(username, password)) {
                    continueToOriginalDestination();
                    setResponsePage(getApplication().getHomePage());
                } else {
                    error("Unknown username or password.");
                }
            }
        };
        form.add(new RequiredTextField<>("username",
            LambdaModel.of(() -> username, value -> username = value)));
        form.add(new PasswordTextField("password",
            LambdaModel.of(() -> password, value -> password = value)));
        add(form);
    }
}
```

A `StatelessForm` keeps the sign-in page stateless, so showing it does not create a session. [Build a stateless form]({{ site.baseurl }}/docs/stateless-forms.html) explains why that matters.

## Sign the user out

`signOut()` marks the user as signed out and invalidates the session at the end of the request.

```java
add(new Link<Void>("signOut") {
    @Override
    public void onClick() {
        AuthenticatedWebSession.get().signOut();
        setResponsePage(getApplication().getHomePage());
    }
});
```

`wicket-auth-roles` also has a `SignOutPage` that invalidates the session when it is rendered.

## Send the user to another page first

The redirect to the sign-in page is an intercept: Wicket stores the requested URL, shows another page, and returns to the URL when that page calls `continueToOriginalDestination()`. You can use the same mechanism for other pages, such as accepting new terms of use, with `redirectToInterceptPage(page)` on any component or by throwing `RestartResponseAtInterceptPageException`. Both end the current request handling, so code after them does not run.
