---
title: Inject EJBs
type: howto
topic: integration
summary: Inject session beans, JNDI resources and persistence units into Wicket components with @EJB, @Resource and @PersistenceUnit, through WicketStuff's javaee-inject module.
since: 10
apis: [JavaEEComponentInjector]
keywords: [Enterprise JavaBeans, EJB, session bean, Stateless, Stateful, JNDI, "java:global", "java:module", Resource, PersistenceUnit, EntityManagerFactory, Jakarta EE, TomEE, WildFly, GlassFish, Payara]
order: 30
source: [jee/jee_1.adoc]
---

Use this when your business logic lives in Enterprise JavaBeans on a Jakarta EE server and you want to inject them with `@EJB`. Wicket components are not managed by the server, so the server ignores these annotations on them. The module wicketstuff-javaee-inject from [WicketStuff]({{ site.baseurl }}/docs/wicketstuff.html) looks the beans up in JNDI when a component is constructed.

If your server supports CDI, as every Jakarta EE server does, you can also inject stateless and singleton session beans with `@Inject` through [wicket-cdi]({{ site.baseurl }}/docs/cdi.html), without an extra module.

## Add the dependency

```xml
<dependency>
    <groupId>org.wicketstuff</groupId>
    <artifactId>wicketstuff-javaee-inject</artifactId>
    <version>${wicketstuff.version}</version>
</dependency>
```

WicketStuff releases follow the Wicket version numbers: use the WicketStuff release that matches your Wicket version. The module is maintained by the WicketStuff community, not by the Apache Wicket project, so check that a release exists for your Wicket version.

## Register the injector

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();
    getComponentInstantiationListeners().add(new JavaEEComponentInjector(this));
}
```

## Inject a session bean

*OrderService.java*

```java
@Stateless
public class OrderService {
    public List<Order> openOrders() { /* ... */ }
}
```

*OrdersPage.java*

```java
public class OrdersPage extends WebPage {

    @EJB
    private OrderService orders;

    public OrdersPage() {
        add(new ListView<Order>("orders", () -> orders.openOrders()) {
            @Override
            protected void populateItem(ListItem<Order> item) {
                item.add(new Label("number", item.getModel().map(Order::getNumber)));
            }
        });
    }
}
```

The field holds a serializable proxy, not the bean, so the page can be stored between requests. The proxy looks the bean up again after deserialization.

The module also handles two other annotations:

| Annotation | Injects |
|---|---|
| `@EJB` | A session bean, looked up in JNDI. |
| `@Resource(name = "...")` | Any object bound in JNDI under *java:comp/env/* plus that name, such as a `DataSource`. |
| `@PersistenceUnit(unitName = "...")` | An `EntityManagerFactory` for the persistence unit, created with `Persistence.createEntityManagerFactory()`. |

## Choose the JNDI names

By default the injector looks up `@EJB` fields under *java:comp/env/* followed by the `name` of the annotation, or the fully qualified class name of the field type when the name is empty. Most servers bind session beans under the portable global names instead. Pass a naming strategy that builds those names:

```java
getComponentInstantiationListeners().add(
    new JavaEEComponentInjector(this, new ModuleJndiNamingStrategy()));
```

| Strategy | Looks up |
|---|---|
| `StandardJndiNamingStrategy` (default) | *java:comp/env/&lt;name or class name&gt;* |
| `ModuleJndiNamingStrategy` | *java:module/&lt;name or class name&gt;* |
| `AppJndiNamingStrategy(moduleName)` | *java:app/&lt;module&gt;/&lt;name or class name&gt;* |
| `GlobalJndiNamingStrategy(moduleName)` or `(appName, moduleName)` | *java:global/[&lt;app&gt;/]&lt;module&gt;/&lt;class name&gt;*, or *&lt;name&gt;!&lt;class name&gt;* when a name is given |

The strategies are in package `org.wicketstuff.javaee.naming` and its subpackage `global`. Your server logs the JNDI names of each session bean when it deploys the application; pick the strategy that matches them.

## Stateful session beans

A stateful session bean belongs to one user. The injector keeps one instance per HTTP session for fields whose type is annotated with `@Stateful`, or whose `@EJB` annotation has `description = "stateful"`.
