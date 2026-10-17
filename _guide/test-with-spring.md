---
title: Test with Spring
type: howto
topic: testing
summary: Test pages that use @SpringBean with WicketTester, either with mock beans in an ApplicationContextMock or against a real Spring test context.
since: 10
apis: [SpringComponentInjector, ApplicationContextMock, SpringBean, WicketTester]
keywords: [Spring, integration test, SpringJUnitConfig, SpringExtension, mock beans, Mockito, No WebApplicationContext found, ContextLoaderListener, Transactional, rollback]
order: 40
source: [testingspring.adoc, testingspring/testingspring_1.adoc, testingspring/testingspring_2.adoc, testingspring/testingspring_3.adoc]
---

You need this when your pages get their services through `@SpringBean` and you want to test them with `WicketTester`. The test has to give the `SpringComponentInjector` a Spring context: one filled with mock beans for a fast unit test, or a context from Spring's test support for an integration test. [Inject Spring beans]({{ site.baseurl }}/docs/spring.html) covers the setup of the application itself.

If the application creates its Spring context in `init()`, a test with `new WicketTester(new WicketApplication())` already runs against that context and needs nothing from this page. The rest is for applications that let the servlet container or Spring Boot create the context. In a test there is no container, so `new SpringComponentInjector(this)` fails with "No WebApplicationContext found: no ContextLoaderListener registered?".

## Let tests replace the injector

Create the injector in a method of its own, so that a test can pass in a context:

*WicketApplication.java*

```java
public class WicketApplication extends WebApplication {
    @Override
    protected void init() {
        super.init();
        getComponentInstantiationListeners().add(newSpringComponentInjector());
    }

    protected SpringComponentInjector newSpringComponentInjector() {
        // finds the context that the container or Spring Boot created
        return new SpringComponentInjector(this);
    }

    // getHomePage() and the rest of the application
}
```

## Test with mock beans

`ApplicationContextMock`, part of `wicket-spring`, is a Spring context you fill with bean instances yourself. Each test gets its own beans and starts in milliseconds:

*OrderPageTest.java*

```java
class OrderPageTest {
    private final ApplicationContextMock context = new ApplicationContextMock();
    private WicketTester tester;

    @BeforeEach
    void setUp() {
        context.putBean("orderService", new InMemoryOrderService(List.of(
            new Order(42, "Ada Lovelace"))));

        tester = new WicketTester(new WicketApplication() {
            @Override
            protected SpringComponentInjector newSpringComponentInjector() {
                return new SpringComponentInjector(this, context);
            }
        });
    }

    @AfterEach
    void tearDown() {
        tester.destroy();
    }

    @Test
    void showsOrder() {
        tester.startPage(OrderPage.class, new PageParameters().add("id", 42));
        tester.assertLabel("customer", "Ada Lovelace");
    }
}
```

`putBean(bean)` without a name uses the class name. A mock from Mockito works as well as a hand-written fake: `context.putBean("orderService", mock(OrderService.class))`. `@SpringBean` finds beans by type, or by name when the annotation has one.

## Test against a Spring test context

For an integration test, let Spring's TestContext framework build the context from your configuration and give it to the injector. Add `spring-test` with test scope, in the version of your Spring Framework.

> Wicket 11 is built against Spring 7 and JUnit 6, Wicket 10 against Spring 6.2 and JUnit 5. The annotations and the test code on this page are the same for both.
{: .since}

*OrderPageIT.java*

```java
@SpringJUnitConfig(TestConfig.class)
class OrderPageIT {
    @Autowired
    private ApplicationContext context;

    private WicketTester tester;

    @BeforeEach
    void setUp() {
        tester = new WicketTester(new WicketApplication() {
            @Override
            protected SpringComponentInjector newSpringComponentInjector() {
                return new SpringComponentInjector(this, context);
            }
        });
    }

    @AfterEach
    void tearDown() {
        tester.destroy();
    }

    @Test
    void savesOrder() {
        tester.startPage(NewOrderPage.class);
        FormTester form = tester.newFormTester("form");
        form.setValue("customer", "Grace Hopper");
        form.submit("save");

        tester.assertRenderedPage(OrderSavedPage.class);
    }
}
```

`TestConfig` can be your production configuration or a configuration for tests, for example with an in-memory database. Spring keeps the context between tests, while each test gets a new Wicket application. Do not hand a `WebApplication` bean from the context to the tester: every tester initializes its application, and one Spring bean would be initialized again by every test.

## Roll back database changes

`WicketTester` handles each request on the thread of the test, so Spring's test transactions cover what your pages do. Annotate the test method or class with `@Transactional`, with a transaction manager in the context, and Spring rolls back after each test:

```java
@Test
@Transactional
void savesOrder() {
    // ...
}
```

Pages that start their own transactions, through a service with `@Transactional(propagation = REQUIRES_NEW)` for instance, commit them as usual.
