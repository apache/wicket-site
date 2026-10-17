---
title: Wicket modules
type: reference
topic: start
summary: The artifacts Wicket is released as, what each one contains, which Wicket modules it depends on, and which you need for testing and tooling.
since: 10
apis: [WicketTester, SpringComponentInjector, AuthenticatedWebApplication, WebSocketBehavior, DebugBar, VelocityPanel]
keywords: [artifact, jar, module list, wicket-core, wicket-extensions, wicket-spring, wicket-cdi, wicket-guice, wicket-tester, wicket-auth-roles, wicket-bean-validation, wicket-native-websocket, wicket-devutils, wicket-velocity, wicket-jmx, wicket-migration, wicket-metrics, distribution]
order: 10
source: [helloWorld/helloWorld_1.adoc]
---

All modules have the group id `org.apache.wicket` and share one version number, except the experimental modules. Use the same version for every Wicket module in a project. [Maven dependencies]({{ site.baseurl }}/docs/maven-setup.html) shows how to add them.

## Core modules

| Artifact | Contains | Depends on |
|---|---|---|
| `wicket-util` | General utilities: I/O, strings, collections, conversion, time, files, XML parsing and resource streams. | none |
| `wicket-request` | Request and response abstractions, URLs, request mappers and request handlers. | `wicket-util` |
| `wicket-core` | The framework: `Application`, `Component`, pages, panels, forms, models, links, repeaters, resources, Ajax, the page store, security settings and the content security policy. | `wicket-request`, `wicket-util` |
| `wicket` | No code. A POM that depends on `wicket-core`, for projects that want a single Wicket dependency. | `wicket-core` |

`wicket-core` is the module every application needs. It brings `wicket-request` and `wicket-util` along.

Some modules, among them `wicket-core`, `wicket-extensions`, `wicket-devutils`, `wicket-jmx` and `wicket-velocity`, configure themselves when the application starts, through an initializer listed in `META-INF/services/org.apache.wicket.IInitializer`. See [Configure a module with an initializer]({{ site.baseurl }}/docs/initializers.html).

## Component and feature modules

| Artifact | Contains | Depends on |
|---|---|---|
| `wicket-extensions` | More components: `DataTable` and its sortable, filterable variants, `ModalDialog`, tabs, the wizard, `Palette`, `AutoCompleteTextField`, `AjaxLazyLoadPanel`, `UploadProgressBar`, Ajax veils (Wicket 11), and more. | `wicket-core` |
| `wicket-auth-roles` | Sign-in and role-based authorization: `AuthenticatedWebApplication`, `AuthenticatedWebSession`, `SignInPanel`, `@AuthorizeInstantiation` and `@AuthorizeAction`. | `wicket-core` |
| `wicket-bean-validation` | Jakarta Bean Validation for form components: `PropertyValidator` and `BeanValidationConfiguration`. | `wicket-core` |
| `wicket-native-websocket-core` | WebSocket support independent of the container: `WebSocketBehavior`, `WebSocketResource`, pushing messages to clients. | `wicket-core` |
| `wicket-native-websocket-javax` | Runs `wicket-native-websocket-core` on a container's Jakarta WebSocket (JSR 356) implementation, with `WicketServerEndpointConfig`. Despite the name, it uses the `jakarta.websocket` API. | `wicket-native-websocket-core` |
| `wicket-devutils` | Tools for development: `DebugBar`, `InspectorPage` and the page, session and component inspectors. They work only in [development mode]({{ site.baseurl }}/docs/deployment-mode.html). | `wicket-core`, `wicket-extensions` |
| `wicket-velocity` | `VelocityPanel` and resources that render Apache Velocity templates. | `wicket-core` |
| `wicket-jmx` | Exposes the application and its settings as JMX MBeans. | `wicket-core` |
| `wicket-objectsizeof-agent` | `InstrumentationObjectSizeOfStrategy`, which measures object sizes, for example of pages and sessions, through a Java agent. | `wicket-core` |

`wicket-velocity` renders a template as markup without escaping it, and does not escape the values it interpolates either. A Velocity template can call methods on the objects in its context, so only use templates written by developers, never templates built from user input.

## Dependency injection modules

| Artifact | Contains | Depends on |
|---|---|---|
| `wicket-ioc` | The shared base for injection: lazy, serializable proxies for injected beans (`LazyInitProxyFactory`) and the field injection that `wicket-spring` and `wicket-guice` build on. | `wicket-core` |
| `wicket-spring` | Spring integration: `SpringComponentInjector`, the `@SpringBean` annotation and `SpringWebApplicationFactory`. Wicket 10 works with Spring 6, Wicket 11 with Spring 7. | `wicket-core`, `wicket-ioc` |
| `wicket-cdi` | Jakarta CDI integration: `CdiConfiguration` injects CDI beans into components, behaviors and sessions. Wicket 10 builds against CDI 4.0 (tested with Weld 5), Wicket 11 against CDI 5.0 (Weld 7). | `wicket-core` |
| `wicket-guice` | Google Guice integration: `GuiceComponentInjector`. | `wicket-core`, `wicket-ioc` |

## Test modules

Add these with `<scope>test</scope>`.

| Artifact | Contains | Depends on |
|---|---|---|
| `wicket-tester` | `WicketTester`, `FormTester`, `TagTester` and `WicketTesterExtension` for JUnit 5. | `wicket-core` |
| `wicket-extensions-tester` | Test helpers for `wicket-extensions`, such as `AjaxLazyLoadPanelTester`. | `wicket-core`, `wicket-extensions`, `wicket-tester` |
| `wicket-native-websocket-tester` | `WebSocketTester`, to test WebSocket behaviors and resources without a container. | `wicket-native-websocket-core`, `wicket-tester` |

`wicket-tester` brings JUnit Jupiter and AssertJ along. In Wicket 10 that is JUnit 5; Wicket 11 builds against JUnit 6.

## Tooling and experimental modules

| Artifact | Contains |
|---|---|
| `wicket-migration` | OpenRewrite recipes for upgrades: `org.apache.wicket.MigrateToWicket10`, `org.apache.wicket.BestPractices` and, in Wicket 11, `org.apache.wicket.MigrateToWicket11`. You run it with the `rewrite-maven-plugin`; it is not a dependency of your application. |
| `wicket-archetype-quickstart` | The Maven archetype for new projects. See [Create a project from the quickstart archetype]({{ site.baseurl }}/docs/create-project.html). |
| `wicket-metrics` | Experimental. Measures Wicket internals with Dropwizard Metrics and AspectJ. Its group id is `org.apache.wicket.experimental.wicket10` in both Wicket 10 and Wicket 11. See [Measure with Wicket metrics]({{ site.baseurl }}/docs/metrics.html). |

## Third-party libraries the core modules use

| Library | Used by | Needed |
|---|---|---|
| SLF4J API | all modules | Always. Add an SLF4J back end, such as `slf4j-simple` or Logback, to see log output. |
| Jakarta Servlet API | `wicket-core` | Provided by the servlet container. Wicket 10 needs Servlet 5.0 or newer, Wicket 11 needs Servlet 6.1. |
| Apache Commons FileUpload, Commons IO, Commons Collections | `wicket-util` | Always; they come along with `wicket-util`. |
| OpenJSON, jdk-serializable-functional | `wicket-core` | Always; they come along with `wicket-core`. |
| Bouncy Castle (`org.bouncycastle:bcprov-jdk18on`) | `wicket-core` | Optional. Only for the AES-GCM-SIV encryption: `GCMSIVCrypter` in Wicket 10, `AesGcmSivCryptScheme` in Wicket 11. See [Encryption in Wicket]({{ site.baseurl }}/docs/crypt-schemes.html). |
| Jackson databind | `wicket-extensions` | Optional. Only for `JsonRequestLogger`. Wicket 10 uses Jackson 2 (`com.fasterxml.jackson.core`), Wicket 11 uses Jackson 3 (`tools.jackson.core`). |
