---
title: Switch between development and deployment mode
type: howto
topic: start
summary: Run Wicket in deployment mode on production servers, with a system property, a web.xml parameter or code, and check which mode is active.
since: 10
apis: [RuntimeConfigurationType, WebApplication, Application]
keywords: [production, DEPLOYMENT, DEVELOPMENT, wicket.configuration, configuration parameter, WARNING Wicket is running in DEVELOPMENT mode, getConfigurationType, usesDevelopmentConfig, context-param, init-param, system property]
order: 20
source: [maven/maven_1.adoc, helloWorld/helloWorld_2.adoc]
---

Switch to deployment mode before an application goes to a production server. Wicket starts in development mode unless you tell it otherwise. That mode shows full stack traces to visitors, polls markup files for changes and adds the Ajax debug window, so you do not want it in production. [Application settings]({{ site.baseurl }}/docs/configuration.html#development-and-deployment-defaults) lists every setting the mode changes.

You can recognize development mode by this warning on standard error when the application starts:

```
********************************************************************
*** WARNING: Wicket is running in DEVELOPMENT mode.              ***
***                               ^^^^^^^^^^^                    ***
*** Do NOT deploy to your live server(s) without changing this.  ***
*** See Application#getConfigurationType() for more information. ***
********************************************************************
```

## Set the mode with a system property

Start the JVM of the server with the system property `wicket.configuration`:

```shell
java -Dwicket.configuration=deployment ...
```

For Tomcat, put it in `CATALINA_OPTS`, for example in `bin/setenv.sh`. A system property overrides the parameters in `web.xml`, so the same WAR file runs in development mode on your machine and in deployment mode on the server. The value is not case-sensitive.

## Set the mode in web.xml

Add a `configuration` parameter to the Wicket filter:

```xml
<filter>
    <filter-name>wicket.myproject</filter-name>
    <filter-class>org.apache.wicket.protocol.http.WicketFilter</filter-class>
    <init-param>
        <param-name>applicationClassName</param-name>
        <param-value>com.mycompany.WicketApplication</param-value>
    </init-param>
    <init-param>
        <param-name>configuration</param-name>
        <param-value>deployment</param-value>
    </init-param>
</filter>
```

Or set it for the whole web application as a context parameter:

```xml
<context-param>
    <param-name>configuration</param-name>
    <param-value>deployment</param-value>
</context-param>
```

Both places also accept the name `wicket.configuration`. When Wicket finds more than one setting, it uses the first of: the system property, then `wicket.configuration` as filter and as context parameter, then `configuration` as filter and as context parameter.

## Set the mode in code

Override `getConfigurationType()` in your application class when the application decides for itself, for example from an environment variable:

```java
public class WicketApplication extends WebApplication {
    @Override
    public RuntimeConfigurationType getConfigurationType() {
        return "production".equals(System.getenv("APP_ENV"))
                ? RuntimeConfigurationType.DEPLOYMENT
                : RuntimeConfigurationType.DEVELOPMENT;
    }
}
```

The override replaces the lookup of the system property and the `web.xml` parameters. `WebApplication` also has `setConfigurationType()`, but you can call it only once, and only before Wicket initializes the application.

## Check which mode is active

When it starts, Wicket logs the mode at INFO level:

```
[wicket.myproject] Started Wicket version {{ site.wicket.version_11 | default: site.wicket.version_10 }} in DEPLOYMENT mode
```

In code, ask the application:

```java
if (getApplication().usesDevelopmentConfig()) {
    add(new DebugBar("debug"));
}
```

`DebugBar` comes from the `wicket-devutils` module. `usesDeploymentConfig()` is the opposite check. The `Start` class of the quickstart sets `wicket.configuration` to `development`, so an application you run from your IDE stays in development mode whatever `web.xml` says.
