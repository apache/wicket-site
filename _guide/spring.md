---
title: Inject Spring beans
type: howto
topic: integration
summary: Inject beans from a Spring application context into pages, components, behaviors and other objects with @SpringBean.
since: 10
apis: [SpringBean, SpringComponentInjector, SpringWebApplicationFactory, Injector]
keywords: [dependency injection, Spring Framework, ApplicationContext, AnnotationConfigApplicationContext, ContextLoaderListener, Spring Boot, autowire, Autowired, service, repository, proxy, NotSerializableException, Objenesis]
order: 10
source: [jee.adoc, jee/jee_2.adoc, jee/jee_5.adoc]
---

Use this when your services live in a Spring application context and your pages need them. Spring does not create Wicket components, so `@Autowired` has no effect in them. Module wicket-spring fills fields annotated with `@SpringBean` instead, as each component is constructed.

> Wicket 11 works with Spring 7; Wicket 10 with Spring 6.
{: .since}

## Add the dependencies

```xml
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-spring</artifactId>
    <version>${wicket.version}</version>
</dependency>
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-web</artifactId>
    <version>${spring.version}</version>
</dependency>
```

wicket-spring brings `spring-context` along; `spring-web` you add yourself.

## Register the injector

Add a `SpringComponentInjector` to the component instantiation listeners in `init()`. The simplest setup creates the Spring context there:

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();

    var context = new AnnotationConfigApplicationContext(AppConfig.class);
    getComponentInstantiationListeners().add(new SpringComponentInjector(this, context));
}
```

If something else already creates the Spring context for the web application, such as Spring's `ContextLoaderListener` in *web.xml* or Spring Boot, leave out the context. The injector then finds it in the servlet context:

```java
getComponentInstantiationListeners().add(new SpringComponentInjector(this));
```

The injector also injects behaviors, so `@SpringBean` works in a `Behavior` as well.

## Inject a bean

Annotate a field with `@SpringBean`. It is filled when the component's constructor runs, before the code of your subclass, so you can use it in the constructor:

*ProductPage.java*

```java
public class ProductPage extends WebPage {

    @SpringBean
    private ProductService products;

    public ProductPage(PageParameters parameters) {
        super(parameters);
        long id = parameters.get("id").toLong();
        add(new Label("name", () -> products.find(id).getName()));
    }
}
```

By default Wicket looks for the single bean of the field's type, generics included. When the context has more than one, it picks the one marked `@Primary`, then the one whose bean name equals the field name; otherwise it throws an `IllegalStateException` that lists the candidates. Name the bean to choose one yourself, and mark a dependency as optional to get `null` instead of an exception when no bean exists:

```java
@SpringBean(name = "archiveProductService")
private ProductService archive;

@SpringBean(required = false)
private AuditLog auditLog;
```

wicket-spring also understands `@jakarta.inject.Inject` with `@Named`; see [Inject with JSR-330 annotations]({{ site.baseurl }}/docs/jsr330.html).

## Inject into objects that are not components

Models, validators and other helpers are not created by Wicket, so nothing injects them. Call the injector yourself in their constructor:

```java
public class ProductModel extends LoadableDetachableModel<Product> {

    @SpringBean
    private ProductService products;

    private final long id;

    public ProductModel(long id) {
        this.id = id;
        Injector.get().inject(this);
    }

    @Override
    protected Product load() {
        return products.find(id);
    }
}
```

## Keep injected fields serializable

Wicket serializes pages between requests, and services are rarely serializable. So `@SpringBean` does not put the bean itself in the field but a small proxy that serializes to a reference and looks the bean up again after deserialization. Do not make injected fields `transient`: the proxy already takes care of it, and a transient field is `null` after the page comes back from the page store.

The proxy has limits:

- Injecting an interface type always works. For a class, Wicket generates a subclass, so the class cannot be `final`, and it needs a constructor without arguments unless you add [Objenesis](https://objenesis.org) to your dependencies.
- `String`, primitive wrappers and enums are injected directly, without a proxy.
- Pass `false` as the third constructor argument of `SpringComponentInjector` to inject the beans without proxies. Then the components must not be serialized with them.

## Let Spring create the application

To define the `WebApplication` itself as a Spring bean, so it can have its own dependencies injected by Spring, let the Wicket filter take it from the Spring context:

```xml
<filter>
    <filter-name>wicket</filter-name>
    <filter-class>org.apache.wicket.protocol.http.WicketFilter</filter-class>
    <init-param>
        <param-name>applicationFactoryClassName</param-name>
        <param-value>org.apache.wicket.spring.SpringWebApplicationFactory</param-value>
    </init-param>
</filter>
```

The factory takes the single `WebApplication` bean from the context created by `ContextLoaderListener`; with more than one, name it in the `applicationBean` init parameter. With a `contextConfigLocation` init parameter, the factory creates a separate context for the application as a child of that one. `AnnotationConfigSpringWebApplicationFactory` does the same, but reads `contextConfigLocation` as `@Configuration` classes instead of XML files.

To test pages that use Spring beans, see [Test with Spring]({{ site.baseurl }}/docs/test-with-spring.html).
