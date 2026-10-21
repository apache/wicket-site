---
title: Glossary
type: reference
topic: start
summary: Plain-English definitions of the Wicket terms used in this guide, each compared with what other web frameworks call it.
since: 10
apis: [Application, Behavior, Border, Component, CompoundPropertyModel, IConverter, LoadableDetachableModel, FeedbackPanel, Form, Fragment, IModel, LambdaModel, ListView, Page, PageParameters, Panel, RequestCycle, IResource, ResourceReference, Session, WicketTester, AjaxRequestTarget, IRequestMapper, IValidator, HeaderItem]
keywords: [terminology, vocabulary, definitions, terms, concepts, compare frameworks, JSF, Spring MVC, React, Vue, Thymeleaf]
order: 40
source: []
---

The definitions use plain words first and the Wicket class second. "Similar to" names the closest idea in other frameworks; the comparison is never exact.

**[Ajax request target]({{ site.baseurl }}/docs/how-ajax-works.html)**
: The list of components to redraw in response to an Ajax request, plus any JavaScript to run. Ajax callbacks such as `onClick(AjaxRequestTarget)` receive one; `AjaxRequestTarget.add()` puts a component in it.
: *Similar to:* the `render` attribute of JSF's `<f:ajax>`, or out-of-band swaps (`hx-swap-oob`) in htmx.

**[Application]({{ site.baseurl }}/docs/configuration.html)**
: The object that represents your web application, one per deployment. You subclass `WebApplication` to name the home page and configure everything else in `init()`.
: *Similar to:* a Spring Boot application class with its configuration, or `faces-config.xml` in JSF.

**[Behavior]({{ site.baseurl }}/docs/add-behaviors.html)**
: An add-on you attach to a component to change its tag, contribute CSS or JavaScript, or react to browser events, without subclassing the component. Behaviors extend `Behavior`; Ajax behaviors extend `AbstractAjaxBehavior`.
: *Similar to:* attribute directives in Angular, custom directives in Vue.

**[Border]({{ site.baseurl }}/docs/use-borders.html)**
: A component that wraps markup around its children: the border provides the frame, and `<wicket:body>` marks where the children go.
: *Similar to:* a React component that renders its `children` inside a frame, or a layout decorator in Thymeleaf.

**Component**
: A Java object that renders one part of a page and handles the events for it, such as a label, a link or a text field. It is tied to a tag in the markup through `wicket:id`. All components extend `Component`.
: *Similar to:* a JSF `UIComponent`, a Vaadin component, or a React or Vue component rendered on the server.

**[Component tree]({{ site.baseurl }}/docs/auto-components.html)**
: The hierarchy of components that make up a page. Containers (`MarkupContainer`), such as pages, panels and forms, hold child components, and the hierarchy matches the nesting of the `wicket:id` tags in the markup.
: *Similar to:* the JSF component tree, or a DOM that lives on the server.

**[CompoundPropertyModel]({{ site.baseurl }}/docs/property-models.html)**
: A model for a container whose children use their own `wicket:id` as the name of the property they read and write on the model's object.
: *Similar to:* Spring MVC form binding with `th:field`, which binds inputs to bean properties by name.

**[Converter]({{ site.baseurl }}/docs/convert-input.html)**
: An object that turns submitted text into a Java value and a value back into text, for numbers, dates and the other types it knows. Converters implement `IConverter`; you register your own on the `ConverterLocator`.
: *Similar to:* a JSF `Converter`, or a Spring `Formatter`.

**Deployment mode, development mode**
: The two runtime configuration types of an application. Development mode adds checks, reloads changed markup and shows stack traces; deployment mode leaves those out for speed and safety. See [Switch between development and deployment mode]({{ site.baseurl }}/docs/deployment-mode.html).
: *Similar to:* the `Development` and `Production` project stages of JSF, or Spring profiles.

**Detach**
: The cleanup step at the end of every request, in which components and models drop data they can load again, before Wicket stores the page.
: *Similar to:* releasing request-scoped beans at the end of a request.

**[Detachable model]({{ site.baseurl }}/docs/detachable-models.html)**
: A model that loads its object when it is first asked for it in a request, and forgets it when the request ends, so the stored page keeps only what it needs to load it again, such as an id. `LoadableDetachableModel` is the usual base class.
: *Similar to:* loading an entity by id in every Spring MVC request instead of keeping it in the session.

**[Enclosure]({{ site.baseurl }}/docs/use-enclosures.html)**
: A `<wicket:enclosure>` tag around markup that is shown only when a chosen child component is visible, so its label and surrounding tags disappear with it.
: *Similar to:* `th:if` in Thymeleaf or `v-if` in Vue on a wrapping element.

**[Feedback message, FeedbackPanel]({{ site.baseurl }}/docs/validate-input.html)**
: A message for the user, such as a validation error or a confirmation, with a level: error, warning, info, success. Components record them with `error()`, `info()` and similar methods, and a `FeedbackPanel` shows them.
: *Similar to:* `<h:messages>` in JSF, or flash messages in Spring MVC.

**[Form]({{ site.baseurl }}/docs/form-processing.html)**
: A component for an HTML `<form>` that runs the submit: it converts and validates the input of its form components, updates their models, and calls `onSubmit()` or `onError()`.
: *Similar to:* `<h:form>` in JSF, or a Spring MVC form with its `@PostMapping` handler.

**[Form component]({{ site.baseurl }}/docs/form-components.html)**
: A component that takes user input, such as `TextField`, `CheckBox` or `DropDownChoice`. Form components extend `FormComponent`.
: *Similar to:* JSF input components such as `<h:inputText>`.

**[Fragment]({{ site.baseurl }}/docs/use-fragments.html)**
: A piece of markup defined inside the markup file of a page or panel with `<wicket:fragment>`, and shown by a `Fragment` component, so small variations need no file of their own.
: *Similar to:* a `th:fragment` defined in the same Thymeleaf template, or a named template block.

**[Header item]({{ site.baseurl }}/docs/header-items.html)**
: A reference to CSS, JavaScript or other content for the `<head>` of a page, which a component contributes in `renderHead()`. Wicket includes each item once, in dependency order. `HeaderItem` is the base class.
: *Similar to:* `<h:outputScript>` in JSF.

**[LambdaModel]({{ site.baseurl }}/docs/lambda-models.html)**
: A model built from a getter and a setter, often two method references such as `Person::getName` and `Person::setName`. The compiler checks it, unlike a property expression in a string.
: *Similar to:* a computed property with a getter and setter in Vue.

**Markup**
: The HTML file of a page, panel or border, kept next to its Java class. It is plain HTML with `wicket:id` attributes and a few `wicket:` tags.
: *Similar to:* a Thymeleaf template or a JSF Facelets file, without an expression language.

**[Markup id]({{ site.baseurl }}/docs/markup-ids.html)**
: The `id` attribute Wicket writes on a component's tag when you call `setOutputMarkupId(true)`. Ajax needs it to find the tag to replace.
: *Similar to:* the generated client id of a JSF component.

**[Markup inheritance]({{ site.baseurl }}/docs/markup-inheritance.html)**
: A page or panel subclass inherits the markup of its parent class. The parent marks one place with `<wicket:child/>`, and the subclass fills it with the content of its `<wicket:extend>` tag.
: *Similar to:* template inheritance with the Thymeleaf Layout Dialect, or a Facelets template with `<ui:composition>`.

**[Model]({{ site.baseurl }}/docs/about-models.html)**
: The object a component asks for the value it shows, and hands a new value to when the user submits one. Models implement `IModel`, which has `getObject()` and `setObject()`. Because `IModel` has only one abstract method, a lambda is a read-only model.
: *Similar to:* a property in JavaFX, or a computed property with a getter and setter in Vue.

**[Mount]({{ site.baseurl }}/docs/mount-pages.html)**
: Giving a page or resource a fixed, readable URL path in `init()`, for example `mountPage("/products/${id}", ProductPage.class)`.
: *Similar to:* `@GetMapping("/products/{id}")` in Spring MVC.

**[Package resource]({{ site.baseurl }}/docs/package-resources.html)**
: A file, such as CSS, JavaScript or an image, stored in a Java package next to the component that uses it, and served by Wicket with a URL that changes when the file does.
: *Similar to:* a resource library in `META-INF/resources` in JSF.

**Page**
: A component that is a complete HTML document, with its own markup file. Every rendered HTML page in a Wicket application is an instance of a `Page` subclass, usually `WebPage`.
: *Similar to:* a JSF view, or a Spring MVC controller method together with its template.

**[Page parameters]({{ site.baseurl }}/docs/page-parameters.html)**
: The named and indexed values in the URL of a bookmarkable page, which the page receives as `PageParameters` in its constructor.
: *Similar to:* `@PathVariable` and `@RequestParam` in Spring MVC, or view parameters in JSF.

**[Page store]({{ site.baseurl }}/docs/page-storage.html)**
: Where Wicket keeps the stateful pages of each session between requests: the most recent ones in memory, and serialized pages on disk.
: *Similar to:* server-side view state in JSF.

**[Panel]({{ site.baseurl }}/docs/build-panel.html)**
: A reusable component with its own markup file, inside a `<wicket:panel>` tag. Panels are the usual way to build your own components.
: *Similar to:* a JSF composite component, or a React or Vue component with its own template.

**[Repeater]({{ site.baseurl }}/docs/repeaters.html)**
: A component that renders its markup once for each item in a collection: `RepeatingView`, `ListView`, `DataView` and others.
: *Similar to:* `th:each` in Thymeleaf, `v-for` in Vue, or `<ui:repeat>` in JSF.

**[Request cycle]({{ site.baseurl }}/docs/request-cycle.html)**
: The processing of one request, from mapping the URL to a handler to writing the response and detaching. `RequestCycle.get()` returns the current one.
: *Similar to:* the JSF lifecycle, or what Spring's `DispatcherServlet` does for one request.

**[Request mapper]({{ site.baseurl }}/docs/request-mappers.html)**
: An object that translates a URL into a request handler and the other way around, used for mounted pages and resources. Mappers implement `IRequestMapper`.
: *Similar to:* handler mappings in Spring MVC.

**[Resource]({{ site.baseurl }}/docs/about-resources.html)**
: Anything Wicket serves that is not a page: a stylesheet, an image, a download, a generated PDF or a JSON response. Resources implement `IResource`.
: *Similar to:* a Spring MVC handler that returns a `ResponseEntity` with bytes, or a static resource handler.

**Resource reference**
: A named, serializable pointer to a resource, which Wicket turns into a URL and resolves when the URL is requested.
: *Similar to:* a JSF resource identified by library and name.

**[Session]({{ site.baseurl }}/docs/use-session.html)**
: The Wicket object for one visitor, kept in the HTTP session once something needs to be remembered: the locale, the signed-in user, feedback messages, and the visitor's stateful pages. You can subclass `WebSession` for typed fields.
: *Similar to:* a session-scoped bean in Spring or CDI.

**[Stateful page, stateless page]({{ site.baseurl }}/docs/stateful-stateless.html)**
: A stateful page is stored after it renders, so later requests, such as link clicks and form submits, go to the same page object. A stateless page is created anew for every request and needs no session. Wicket makes a page stateful as soon as one of its components needs that.
: *Similar to:* JSF views with view state versus transient views; every Spring MVC page is stateless.

**[Validator]({{ site.baseurl }}/docs/validators.html)**
: An object that checks the converted input of a form component and records an error when it fails, such as `StringValidator` or `EmailAddressValidator`. Validators implement `IValidator`.
: *Similar to:* a JSF `Validator`, or a Spring `Validator`.

**[WicketTester]({{ site.baseurl }}/docs/wicket-tester.html)**
: A test helper that runs your application in memory, so a JUnit test can render pages, click links, submit forms and check the result without a browser or server.
: *Similar to:* Spring's `MockMvc`.

**[wicket:id]({{ site.baseurl }}/docs/wicket-tags.html)**
: The attribute that ties a tag in the markup to the component with the same id in Java. Each component added in Java needs a tag with its id, at the same place in the hierarchy.
: *Similar to:* the `id` that binds a Facelets tag to a JSF component, or a `th:` attribute in Thymeleaf, but without an expression.
