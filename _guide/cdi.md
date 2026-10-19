---
title: Inject CDI beans
type: howto
topic: integration
summary: Configure wicket-cdi so pages, components, behaviors and the session get CDI beans with @Inject, and choose beans that survive serialization.
since: 10
apis: [CdiConfiguration, NonContextual, ConversationPropagation, ConversationalComponent]
keywords: [Jakarta CDI, contexts and dependency injection, Weld, Inject, BeanManager, Jakarta EE, ApplicationScoped, SessionScoped, ConversationScoped, passivation capable, Tomcat, Jetty, beans.xml]
order: 20
source: [jee/jee_3.adoc, jee/jee_5.adoc]
---

Use this when your application runs with a CDI container, on a Jakarta EE server or on a servlet container with Weld, and your pages need CDI beans. Module wicket-cdi injects every component, behavior and session that Wicket creates, so fields annotated with `@Inject` work as they do in CDI beans.

{% if site.wicket.version_11 %}
> Wicket 11 is built against CDI 5.0 and tested with Weld 7; Wicket 10 against CDI 4.0 and Weld 5.
{: .since}
{% else %}
Wicket 10 is built against CDI 4.0 and tested with Weld 5.
{% endif %}

## Add wicket-cdi

```xml
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-cdi</artifactId>
    <version>${wicket.version}</version>
</dependency>
```

A Jakarta EE server provides the CDI container. On Tomcat or Jetty, add Weld and start it with its servlet listener in *web.xml*:

```xml
<dependency>
    <groupId>org.jboss.weld.servlet</groupId>
    <artifactId>weld-servlet-core</artifactId>
    <version>${weld.version}</version>
</dependency>
```

```xml
<listener>
    <listener-class>org.jboss.weld.environment.servlet.Listener</listener-class>
</listener>
```

Mark the jar or war with your beans as a bean archive with a *beans.xml* in *META-INF* (or *WEB-INF* for a war):

```xml
<beans xmlns="https://jakarta.ee/xml/ns/jakartaee"
       version="4.0"
       bean-discovery-mode="annotated" />
```

## Configure the application

Call `CdiConfiguration.configure()` in `init()`:

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();
    new CdiConfiguration().configure(this);
}
```

From then on Wicket injects the application itself, every session, every component and every behavior when it is created.

## Inject a bean

Use `@Inject`, with qualifiers if you need them:

```java
@ApplicationScoped
public class ProductService {
    public Product find(long id) { /* ... */ }
}
```

```java
public class ProductPage extends WebPage {

    @Inject
    private ProductService products;

    public ProductPage(PageParameters parameters) {
        super(parameters);
        long id = parameters.get("id").toLong();
        add(new Label("name", () -> products.find(id).getName()));
    }
}
```

The field is filled in the `Component` constructor, so you can use it in the constructor of your page.

To inject an object that Wicket does not create, such as a model, use `NonContextual`:

```java
public ProductModel(long id) {
    this.id = id;
    NonContextual.of(this).inject(this);
}
```

## Inject only beans that survive serialization

Wicket serializes pages, and with them the injected fields. wicket-cdi does not wrap beans in proxies of its own, as the Spring and Guice integrations do. It relies on CDI, which guarantees serializable references only for passivation capable beans:

- beans with a normal scope (`@ApplicationScoped`, `@SessionScoped`, `@ConversationScoped`, `@RequestScoped`): CDI injects a serializable client proxy that finds the bean again after deserialization;
- `@Dependent` beans that are themselves serializable;
- stateless and singleton session beans;
- resources declared through a producer field with `@Resource`, `@EJB`, `@PersistenceContext`, `@PersistenceUnit` or `@WebServiceRef`;
- built-in beans such as `BeanManager`, `Instance` and `Event`.

Give services a normal scope, usually `@ApplicationScoped`. The container also fills fields annotated with `@EJB`, `@PersistenceContext` or `@Resource` directly, but those references are not guaranteed to be serializable.

For anything else, make the field `transient` or keep it out of the component. wicket-cdi does not inject a component again after it is deserialized, so a transient field is `null` when the page comes back from the page store, and the component may only use it during the request in which it was constructed.

## Find the BeanManager

wicket-cdi looks up the `BeanManager` in JNDI under *java:comp/BeanManager*, then under *java:comp/env/BeanManager*, then through `CDI.current()`. When none of these work in your environment, pass it in:

```java
new CdiConfiguration()
    .setBeanManager(beanManager)
    .configure(this);
```

`setFallbackBeanManager()` sets one that is used only when every lookup fails.

## Keep a conversation across pages

wicket-cdi propagates the CDI conversation from page to page. The `ConversationPropagation` mode decides when:

| Mode | The conversation follows |
|---|---|
| `NONBOOKMARKABLE` (default) | Links and redirects to page instances, such as `setResponsePage(new NextPage())`. |
| `ALL` | Those and links to bookmarkable pages. |
| `NONE` | Nothing; turn propagation off. |

```java
new CdiConfiguration()
    .setPropagation(ConversationPropagation.ALL)
    .configure(this);
```

Start a long-running conversation with `conversation.begin()` on an injected `Conversation`. To let Wicket begin and end it for you, let a component on the page implement the marker interface `ConversationalComponent`: Wicket begins the conversation when such a page renders and ends it when the user reaches a page without one.
