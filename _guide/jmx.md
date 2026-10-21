---
title: Inspect and change settings with JMX
type: howto
topic: integration
summary: Add wicket-jmx to see a running application's settings and session counts in JConsole, clear the markup cache, and change some settings without a restart.
since: 10
apis: [ApplicationMBean, ApplicationSettingsMBean, DebugSettingsMBean, MarkupSettingsMBean, RequestLoggerMBean]
keywords: [Java Management Extensions, MBean, JConsole, VisualVM, monitoring, clearMarkupCache, clearLocalizerCache, hot fix markup, live sessions, management console]
order: 60
source: [advanced/advanced_5.adoc]
---

Use this when you want to look into a running Wicket application, or fix a typo in markup or a properties file in production without restarting it. Module wicket-jmx publishes the application's settings as JMX MBeans, which any JMX client can read and change.

## Add wicket-jmx

```xml
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-jmx</artifactId>
    <version>${wicket.version}</version>
</dependency>
```

There is nothing to configure. The module has an [initializer]({{ site.baseurl }}/docs/initializers.html) that registers the MBeans with the platform MBean server when the application starts.

To register them with another MBean server, set one of these system properties:

| Property | Selects |
|---|---|
| `wicket.mbean.server.agentid` | The MBean server with this agent id. |
| `wicket.mbean.server.class` | The first MBean server of this class. |

## Connect with JConsole

Start `jconsole`, which comes with the JDK, and connect to the process of your servlet container. For a server on another machine, start that JVM with the standard `com.sun.management.jmxremote` options and connect remotely. Open the *MBeans* tab. The Wicket MBeans are in the domain *org.apache.wicket.app.&lt;name&gt;*, where the name is the name of the Wicket filter, as returned by `Application.getName()`.

| MBean | Shows |
|---|---|
| `type=Application` | Application class, home page class, configuration type, Wicket version, size of the markup cache. |
| `type=Application,name=ApplicationSettings` | Error pages, unexpected exception display, default maximum upload size. |
| `type=Application,name=DebugSettings` | Ajax debug mode, component use check, component path attribute, development utilities. |
| `type=Application,name=MarkupSettings` | Automatic linking, whitespace compression, comment and Wicket tag stripping, markup encoding. |
| `type=Application,name=PageSettings` | Whether pages are versioned by default. |
| `type=Application,name=RequestCycleSettings` | Response buffering, request timeout, character encoding, exception retry count. |
| `type=Application,name=ResourceSettings` | Localizer, resource finders, string resource loaders, poll frequency, missing resource behavior. |
| `type=Application,name=SecuritySettings` | Authorization strategy, crypt factory, unauthorized instantiation listener. |
| `type=Application,name=SessionSettings` | Page factory and session store. |
| `type=Application,name=StoreSettings` | Maximum page store size per session, file store folder, asynchronous storing. |
| `type=RequestLogger` | Created, live and peak sessions, current and peak active requests. |

## Publish a markup or text fix without a restart

In deployment mode Wicket caches markup and localized texts and does not look at the files again. After you replace an HTML or properties file in the deployed application, run these operations on the `type=Application` MBean:

| Operation | Effect |
|---|---|
| `clearMarkupCache` | Wicket reads the markup files again when it next needs them. |
| `clearLocalizerCache` | Wicket looks up localized texts again. |

## Change a setting at runtime

Attributes with a setter can be changed from JConsole. For example:

| MBean | Attribute | Example value |
|---|---|---|
| `ApplicationSettings` | `DefaultMaximumUploadSize` | `20MB` |
| `DebugSettings` | `AjaxDebugModeEnabled` | `true` |
| `MarkupSettings` | `StripComments` | `true` |
| `RequestCycleSettings` | `Timeout` | `PT1M` (an ISO-8601 duration) |
| `ResourceSettings` | `ThrowExceptionOnMissingResource` | `false` |

The change lasts until the application restarts; put permanent settings in `init()`.

## See session and request counts

The `RequestLogger` MBean reads its numbers from Wicket's request logger, which is off by default. Turn it on in `init()`:

```java
getRequestLoggerSettings().setRequestLoggerEnabled(true);
```

Its `restart` operation restarts the request logger and `stop` turns it off.

Anyone who can connect to the JMX port can change these settings. Do not open it to untrusted networks.
