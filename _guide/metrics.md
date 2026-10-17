---
title: Measure with Wicket metrics
type: howto
topic: integration
summary: Count requests and time component creation, rendering and model loading with the experimental wicket-metrics module, AspectJ and Dropwizard Metrics.
since: 10
apis: [WicketMetrics, WicketMetricsSettings, SessionCountListener]
keywords: [monitoring, performance, profiling, timing, Dropwizard, Codahale, AspectJ, load-time weaving, aop.xml, javaagent, Graphite, JMX, MetricRegistry]
order: 70
source: [monitoring.adoc, monitoring/monitoring_1.adoc, monitoring/monitoring_2.adoc, monitoring/monitoring_3.adoc, monitoring/monitoring_4.adoc]
---

Use this when you want numbers on what your Wicket application does: how many requests it serves, how long components take to construct and render, how often models load. The module wicket-metrics weaves measuring code into Wicket's classes with AspectJ and collects the results in a [Dropwizard Metrics](https://metrics.dropwizard.io) registry.

wicket-metrics is experimental: it lives in the wicket-experimental part of the Wicket build and may change or disappear in a later release. It is published with every Wicket release, with the same version number.

## Add the dependencies

```xml
<dependency>
    <groupId>org.apache.wicket.experimental.wicket10</groupId>
    <artifactId>wicket-metrics</artifactId>
    <version>${wicket.version}</version>
</dependency>
<dependency>
    <groupId>org.aspectj</groupId>
    <artifactId>aspectjrt</artifactId>
    <version>${aspectj.version}</version>
</dependency>
```

wicket-metrics brings Dropwizard's `metrics-core` and `metrics-jmx` along. AspectJ is licensed under the Eclipse Public License; include its license when you distribute it.

## Start the AspectJ weaver

The measurements are added while classes load, by the AspectJ weaver running as a Java agent. Download *aspectjweaver.jar* in the same version as `aspectjrt` and add it to the JVM options of your servlet container, for example in Tomcat's *setenv.sh*:

```
CATALINA_OPTS="$CATALINA_OPTS -javaagent:/opt/aspectj/aspectjweaver-1.9.x.jar"
```

## Choose the measurements

Create *src/main/resources/META-INF/aop.xml*. It tells the weaver which Wicket classes to weave and which aspects to apply. `WicketFilterInitAspect` is required; the others are optional:

```xml
<!DOCTYPE aspectj PUBLIC "-//AspectJ//DTD//EN" "http://www.eclipse.org/aspectj/dtd/aspectj.dtd">
<aspectj>
    <weaver options="-nowarn">
        <include within="org.apache.wicket..*"/>
    </weaver>
    <aspects>
        <aspect name="org.apache.wicket.metrics.aspects.WicketFilterInitAspect"/>
        <aspect name="org.apache.wicket.metrics.aspects.request.WicketFilterRequestCycleAspect"/>
        <aspect name="org.apache.wicket.metrics.aspects.component.ComponentCreateAspect"/>
        <aspect name="org.apache.wicket.metrics.aspects.component.ComponentOnRenderAspect"/>
        <aspect name="org.apache.wicket.metrics.aspects.model.LoadableDetachableModelLoadAspect"/>
    </aspects>
</aspectj>
```

The jar contains *wicket-metrics.template.xml* with every aspect. The aspects are in subpackages of `org.apache.wicket.metrics.aspects`:

| Aspect | Metric | Measures |
|---|---|---|
| `request.WicketFilterRequestCycleAspect` | `core/application/requestCycle` | Time per request. |
| `request.WicketFilterRequestCycleUrlAspect` | `core/application/request/…` | Time per request, by URL. |
| `requesthandler.IRequestHandlerRespondAspect` | `core/requesthandler/respond` | Time per request handler response. |
| `requesthandler.IRequestHandlerDetachAspect` | `core/requesthandler/detach` | Time per request handler detach. |
| `component.ComponentCreateAspect` | `core/component/create` | Time to construct each component class. |
| `component.ComponentOnInitializeAspect` | `core/component/initialize` | Time spent in `onInitialize()`. |
| `component.ComponentOnConfigureAspect` | `core/component/configure` | Time spent in `onConfigure()`. |
| `component.ComponentOnRenderAspect` | `core/component/render` | Time spent in `onRender()`. |
| `component.ComponentOnDetachAspect` | `core/component/detach` | Calls of `onDetach()`. |
| `component.ComponentSetResponsePageAspect` | `core/component/redirect` | Calls of `setResponsePage()`. |
| `model.LoadableDetachableModelLoadAspect` | `core/model/loadabledetachablemodel/load` | Time spent in `load()`. |
| `behavior.BehaviorCreateAspect` | `core/behavior/create` | Behaviors created. |
| `resource.IResourceCreateAspect` | `core/resource/resource/create` | Resources created. |
| `resource.ResourceReferenceCreateAspect` | `core/resource/reference/create` | Resource references created. |
| `markup.WicketTagCreateAspect` | `core/tags/wicket/create` | Wicket tags created. |
| `ajax.IPartialPageRequestHandlerAddAspect` | `core/ajax/add` | Components added to Ajax responses. |
| `ajax.IPartialPageRequestHandlerAppendJavaScriptAspect` | `core/ajax/appendJavaScript` | Calls of `appendJavaScript()`. |
| `ajax.IPartialPageRequestHandlerPrependJavaScriptAspect` | `core/ajax/prependJavaScript` | Calls of `prependJavaScript()`. |
| `session.SessionCountListenerAspect` | `core/session/count` | Live sessions. |

Each metric name starts with the name of the Wicket filter and, where it measures a class, ends with that class name.

The session count also needs the servlet listener `org.apache.wicket.metrics.aspects.session.SessionCountListener`. It is annotated with `@WebListener`, so the container finds it, unless your *web.xml* is `metadata-complete="true"`; then declare it in *web.xml*. The count starts at 0 when the server starts, so clear persisted sessions when you restart, or the number is off.

wicket-metrics supports one Wicket filter per web application.

## Read the measurements in JMX

Publish the registry as JMX MBeans in your application's `init()`, then open them in JConsole or VisualVM:

```java
@Override
protected void init() {
    super.init();
    WicketMetrics.getSettings().startJmxReporter();
}
```

Timers show count, minimum, maximum, mean and percentiles; meters show counts and rates.

## Send the measurements elsewhere

`WicketMetrics.getMetricRegistry()` returns the Dropwizard `MetricRegistry`, so every Dropwizard reporter works. To send the numbers to Graphite every five seconds, add `io.dropwizard.metrics:metrics-graphite` in the version that wicket-metrics uses, and start a reporter:

```java
private GraphiteReporter reporter;

@Override
protected void init() {
    super.init();
    var graphite = new Graphite(new InetSocketAddress("graphite.example.com", 2003));
    reporter = GraphiteReporter.forRegistry(WicketMetrics.getMetricRegistry())
        .prefixedWith("webapps")
        .convertRatesTo(TimeUnit.SECONDS)
        .convertDurationsTo(TimeUnit.MILLISECONDS)
        .build(graphite);
    reporter.start(5, TimeUnit.SECONDS);
}

@Override
protected void onDestroy() {
    reporter.stop();
    super.onDestroy();
}
```

## Turn measuring off

```java
WicketMetrics.getSettings().setEnabled(false);
```

The woven code stays in place but stops recording. To remove it entirely, start the JVM without the weaver agent.

## Measure your own code

An aspect that extends `WicketMetrics` can use its `measureTime()`, `mark()` and `count()` methods:

```java
@Aspect
public class CheckoutAspect extends WicketMetrics {

    @Around("execution(* com.example.shop.CheckoutPage.onSubmit(..))")
    public Object aroundSubmit(ProceedingJoinPoint joinPoint) throws Throwable {
        return measureTime("shop/checkout/submit", joinPoint);
    }
}
```

Add the aspect to *aop.xml*, and add your package to the weaver: `<include within="com.example.shop..*"/>`.
