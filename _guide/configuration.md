---
title: Application settings
type: reference
topic: start
summary: How a Wicket application is started and configured, the settings objects with their main options and defaults, and what development and deployment mode change.
since: 10
apis: [WicketFilter, WicketServlet, Application, WebApplication, RuntimeConfigurationType, ApplicationSettings, DebugSettings, ExceptionSettings, FrameworkSettings, JavaScriptLibrarySettings, MarkupSettings, PageSettings, RequestCycleSettings, RequestLoggerSettings, ResourceSettings, SecuritySettings, StoreSettings, ContentSecurityPolicySettings]
keywords: [web.xml, init, getHomePage, applicationClassName, filterMappingUrlPattern, ignorePaths, WebFilter annotation, configuration, settings, defaults, getApplicationSettings, getMarkupSettings, error page, upload size, render strategy, init-param]
order: 30
source: [helloWorld/helloWorld_2.adoc]
---

## How the application starts

A Wicket application is a Jakarta web application. The servlet container starts a `WicketFilter`, which creates the application object, calls its initialization, and then handles every request mapped to the filter. `WicketServlet` does the same as a servlet, for containers or setups where a filter does not fit.

*web.xml*

```xml
<filter>
    <filter-name>wicket.myproject</filter-name>
    <filter-class>org.apache.wicket.protocol.http.WicketFilter</filter-class>
    <init-param>
        <param-name>applicationClassName</param-name>
        <param-value>com.mycompany.WicketApplication</param-value>
    </init-param>
</filter>
<filter-mapping>
    <filter-name>wicket.myproject</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

Without `web.xml`, annotate a subclass of `WicketFilter`:

*ProjectFilter.java*

```java
@WebFilter(value = "/*", initParams = {
        @WebInitParam(name = "applicationClassName", value = "com.mycompany.WicketApplication"),
        @WebInitParam(name = "filterMappingUrlPattern", value = "/*") })
public class ProjectFilter extends WicketFilter {
}
```

### Filter parameters

| Parameter | Meaning |
|---|---|
| `applicationClassName` | Fully qualified name of your `WebApplication` subclass. Read by the default application factory, `ContextParamWebApplicationFactory`. |
| `applicationFactoryClassName` | An `IWebApplicationFactory` that creates the application instead, such as `org.apache.wicket.spring.SpringWebApplicationFactory` to take the application from a Spring context. |
| `applicationBean` | With `SpringWebApplicationFactory`: the name of the application bean, if the context has more than one. |
| `filterMappingUrlPattern` | The URL pattern the filter is mapped to, such as `/*` or `/app/*`. Wicket reads it from this parameter first, then from `web.xml`, then from a `@WebFilter` annotation on the filter class. |
| `ignorePaths` | Comma-separated paths the filter passes on to the rest of the filter chain, such as `/static,/health`. |
| `configuration`, `wicket.configuration` | `development` or `deployment`. Also read as a context parameter. See [Runtime configuration type](#runtime-configuration-type). |
| `sourceFolder` | Development mode only: an extra folder in which Wicket looks for markup and resources. |

### Initialization order

When the filter starts, `Application.initApplication()` runs these steps:

| Step | What happens |
|---|---|
| `internalInit()` | Wicket's own defaults: error pages, resource finders, component resolvers, the settings for the runtime configuration type, and the strict content security policy. |
| Initializers | The `IInitializer` implementations listed in `META-INF/services/org.apache.wicket.IInitializer` of the jars on the classpath, such as the one of `wicket-jmx`. See [Configure a module with an initializer]({{ site.baseurl }}/docs/initializers.html). |
| `init()` | Your configuration. |
| Application listeners | `IApplicationListener.onAfterInitialized`. |
| `validateInit()` | Checks the configuration and installs the content security policy and the COOP and COEP listeners. |

Your `init()` runs after Wicket's defaults, so a setting you change there sticks.

## Application class

You extend `WebApplication` and override:

| Method | Required | Purpose |
|---|---|---|
| `Class<? extends Page> getHomePage()` | yes | The page shown at the root URL of the filter. |
| `void init()` | no | Configuration: settings, mounted pages and resources, listeners, injectors. Call `super.init()` first. |
| `void onDestroy()` | no | Cleanup when the container stops the application. |
| `Session newSession(Request, Response)` | no | Return your own `WebSession` subclass. |
| `RuntimeConfigurationType getConfigurationType()` | no | Decide between development and deployment mode in code. |

`Application.get()` returns the application of the current thread anywhere in request processing; `WebApplication.get()` returns it as a `WebApplication`.

## Settings objects

The application groups its settings in objects you get from getter methods, usually in `init()`:

```java
@Override
protected void init() {
    super.init();
    getMarkupSettings().setStripWicketTags(true);
    getApplicationSettings().setPageExpiredErrorPage(SessionExpiredPage.class);
}
```

Each setter returns its settings object, so calls on one object can be chained. The tables list the main options; see the Javadoc of each class for all of them.

### ApplicationSettings

`getApplicationSettings()`: error pages, uploads and class loading.

| Setting | Default | Meaning |
|---|---|---|
| `setPageExpiredErrorPage(Class)` | `PageExpiredErrorPage` | Page shown when a requested page is no longer stored. |
| `setInternalErrorPage(Class)` | `InternalErrorPage` | Page shown for an unexpected exception in deployment mode. |
| `setAccessDeniedPage(Class)` | `AccessDeniedPage` | Page shown when authorization denies access. |
| `setDefaultMaximumUploadSize(Bytes)` | `Bytes.MAX` | Largest upload a form accepts, unless the form sets its own. |
| `setUploadProgressUpdatesEnabled(boolean)` | `false` | Track upload progress, needed for `UploadProgressBar`. |
| `setClassResolver(IClassResolver)` | `DefaultClassResolver` | How Wicket loads classes by name, for example in OSGi. |
| `setFeedbackMessageCleanupFilter(IFeedbackMessageFilter)` | `DefaultCleanupFeedbackMessageFilter` | Which feedback messages are removed at the end of a request. |

### DebugSettings

`getDebugSettings()`: checks and aids for development.

| Setting | Default | Meaning |
|---|---|---|
| `setComponentUseCheck(boolean)` | `true` (mode) | Fail when a component added in Java has no tag in the markup. |
| `setAjaxDebugModeEnabled(boolean)` | `false` (mode) | Load the Ajax debug window in the browser. |
| `setDevelopmentUtilitiesEnabled(boolean)` | `false` (mode) | Allow the `wicket-devutils` components and pages. |
| `setOutputMarkupContainerClassName(boolean)` | `false` | Write the class of each container as an HTML comment in the output. |
| `setComponentPathAttributeName(String)` | none | Write each component's path in an attribute of this name, for example for UI tests. |
| `setLinePreciseReportingOnAddComponentEnabled(boolean)` | `false` | Record where components are added, for better error messages. Slow. |

"(mode)" marks a setting that the runtime configuration type overwrites, see [Development and deployment defaults](#development-and-deployment-defaults).

### ExceptionSettings

`getExceptionSettings()`: what happens on unexpected exceptions.

| Setting | Default | Meaning |
|---|---|---|
| `setUnexpectedExceptionDisplay(UnexpectedExceptionDisplay)` | `SHOW_EXCEPTION_PAGE` (mode) | `SHOW_EXCEPTION_PAGE` shows the stack trace, `SHOW_INTERNAL_ERROR_PAGE` the internal error page, `SHOW_NO_EXCEPTION_PAGE` only an HTTP 500. |
| `setAjaxErrorHandlingStrategy(AjaxErrorStrategy)` | `REDIRECT_TO_ERROR_PAGE` | On an exception in an Ajax request, redirect to the error page, or `INVOKE_FAILURE_HANDLER` to let client-side failure handlers react. |
| `setThreadDumpStrategy(ThreadDumpStrategy)` | `THREAD_HOLDING_LOCK` | Which stack traces to log when a request cannot get the lock on a page: `NO_THREADS`, `THREAD_HOLDING_LOCK` or `ALL_THREADS`. |
| `setNotRenderableErrorStrategy(NotRenderableErrorStrategy)` | `LOG_WARNING` | What to do when a component that renders no tag of its own, because of `setRenderBodyOnly(true)` or a `wicket:` tag, is asked for a markup id or placeholder tag: `LOG_WARNING` or `THROW_EXCEPTION`. |

### FrameworkSettings

`getFrameworkSettings()`: framework-wide hooks.

| Setting | Default | Meaning |
|---|---|---|
| `getVersion()` | | The Wicket version, read from the jar. |
| `setSerializer(ISerializer)` | `JavaSerializer` | How pages are serialized for the page store. |
| `setDetachListener(IDetachListener)` | none | Called each time a component detaches. |
| `add(IEventDispatcher)` | none | Extra dispatchers for Wicket events. |

### JavaScriptLibrarySettings

`getJavaScriptLibrarySettings()`: the JavaScript Wicket loads for Ajax.

| Setting | Default | Meaning |
|---|---|---|
| `setJQueryReference(ResourceReference)` | jQuery 3 in Wicket 10, jQuery 4 in Wicket 11 | The jQuery version Wicket loads. |
| `setWicketAjaxReference(ResourceReference)` | `WicketAjaxJQueryResourceReference` | Wicket's Ajax library. In Wicket 11, `WicketAjaxResourceReference` selects the implementation without jQuery. |

### MarkupSettings

`getMarkupSettings()`: how markup is read and written.

| Setting | Default | Meaning |
|---|---|---|
| `setStripWicketTags(boolean)` | `false` (mode) | Remove `wicket:` tags and attributes from the output. |
| `setStripComments(boolean)` | `false` | Remove HTML comments from the markup. |
| `setCompressWhitespace(boolean)` | `false` | Collapse whitespace in the markup. |
| `setDefaultMarkupEncoding(String)` | none, the encoding of the operating system | Encoding of markup files without an XML declaration. |
| `setAutomaticLinking(boolean)` | `false` | Treat every page that contains links as if surrounded by `wicket:link`. |
| `setMarkupIdGenerator(IMarkupIdGenerator)` | `DefaultMarkupIdGenerator` | How Wicket generates `id` attributes. |

### PageSettings

`getPageSettings()`: pages and their versions.

| Setting | Default | Meaning |
|---|---|---|
| `setVersionPagesByDefault(boolean)` | `true` | Store a new version of a page when it changes, so the back button returns to the earlier state. |
| `setRecreateBookmarkablePagesAfterExpiry(boolean)` | `true` | Create a new instance of a bookmarkable page instead of showing the page-expired error. |
| `setCallListenerAfterExpiry(boolean)` | `false` | After recreating an expired page, still run the link or form callback that was requested. |
| `addComponentResolver(IComponentResolver)` | | Resolve tags in markup to components that are not added in Java. |

### RequestCycleSettings

`getRequestCycleSettings()`: how requests are handled and responses written.

| Setting | Default | Meaning |
|---|---|---|
| `setRenderStrategy(RenderStrategy)` | `REDIRECT_TO_BUFFER` | Render after an action and redirect to the buffered result; `REDIRECT_TO_RENDER` and `ONE_PASS_RENDER` are the alternatives. See [Redirects after a request]({{ site.baseurl }}/docs/redirects.html). |
| `setResponseRequestEncoding(String)` | `UTF-8` | Encoding of requests and responses. |
| `setTimeout(Duration)` | 1 minute | How long a request waits for an earlier request on the same page to finish. |
| `setBufferResponse(boolean)` | `true` | Buffer the response, so headers can still change while rendering. |
| `setGatherExtendedBrowserInfo(boolean)` | `false` | Collect browser details, such as the time zone, with an extra round trip. |
| `addResponseFilter(IResponseFilter)` | | Post-process the rendered response. |
| `setExceptionRetryCount(int)` | 10 | How many times Wicket tries to render the error response for an exception before it gives up. |

### RequestLoggerSettings

`getRequestLoggerSettings()`: the request logger.

| Setting | Default | Meaning |
|---|---|---|
| `setRequestLoggerEnabled(boolean)` | `false` | Log every request with its handler and session. |
| `setRequestsWindowSize(int)` | 0 | Number of requests the logger keeps in memory. With 0 it only keeps totals per session. |
| `setRecordSessionSize(boolean)` | `false` | Measure and log the session size. Costly. |

### ResourceSettings

`getResourceSettings()`: markup, resources and resource bundles.

| Setting | Default | Meaning |
|---|---|---|
| `setResourcePollFrequency(Duration)` | 1 second in development, none in deployment (mode) | How often Wicket checks markup and resource files for changes. |
| `setUseMinifiedResources(boolean)` | `true`, `false` in development (mode) | Serve `.min.js` and `.min.css` variants of package resources when they exist. |
| `setJavaScriptCompressor(IJavaScriptCompressor)` | none, `DefaultJavaScriptCompressor` in deployment (mode) | Compress JavaScript package resources. |
| `setCssCompressor(ICssCompressor)` | none | Compress CSS package resources. |
| `setCachingStrategy(IResourceCachingStrategy)` | version in file name | How resource URLs carry a version so browsers can cache them: the last-modified time in development, a content digest in deployment. |
| `setDefaultCacheDuration(Duration)` | 365 days | How long browsers may cache resources. |
| `setPackageResourceGuard(IPackageResourceGuard)` | `SecurePackageResourceGuard` | Which files in Java packages may be served. |
| `getResourceFinders()` | web application root, `META-INF/resources` | Where Wicket looks for markup and resources besides the classpath. |
| `getStringResourceLoaders()` | | Where Wicket looks for localized texts. |
| `setThrowExceptionOnMissingResource(boolean)` | `true` | Fail when a text resource is missing. |
| `setUseDefaultOnMissingResource(boolean)` | `true` | Use a default value, if one is given, when a text resource is missing. |

### SecuritySettings

`getSecuritySettings()`: authorization, encryption and isolation headers.

| Setting | Default | Meaning |
|---|---|---|
| `setAuthorizationStrategy(IAuthorizationStrategy)` | `ALLOW_ALL` | Decides whether components may be created and rendered. |
| `setUnauthorizedComponentInstantiationListener(...)` | throws `UnauthorizedInstantiationException` | Called when a component may not be created. |
| `setEnforceMounts(boolean)` | `false` | Refuse requests for a mounted page through its generic bookmarkable URL instead of its mount path. |
| `setCryptFactory(ICryptFactory)` | key in session | Creates the objects that encrypt URLs. |
| `setCryptScheme(ICryptScheme)` | `AesGcmCryptScheme` | Wicket 11. The cipher for encrypted URLs and the page store. |
| `setWhitelistedCryptSchemes(Collection)` | the crypt scheme | Wicket 11. Schemes accepted for decryption. |
| `setRandomSupplier(ISecureRandomSupplier)` | `DefaultSecureRandomSupplier` | Source of secure random data. |
| `setCrossOriginOpenerPolicyConfiguration(...)` | `SAME_ORIGIN` | The `Cross-Origin-Opener-Policy` header. |
| `setCrossOriginEmbedderPolicyConfiguration(...)` | `REPORTING` | The `Cross-Origin-Embedder-Policy` header. |

[Encryption in Wicket]({{ site.baseurl }}/docs/crypt-schemes.html) describes the encryption settings of both release lines.

### StoreSettings

`getStoreSettings()`: where pages are kept between requests.

| Setting | Default | Meaning |
|---|---|---|
| `setMaxSizePerSession(Bytes)` | 10 MB | Disk space per session for stored pages. |
| `setFileStoreFolder(File)` | the container's temporary folder | Folder of the disk page store. |
| `setAsynchronous(boolean)` | `true` | Write pages to disk on a background thread. |
| `setAsynchronousQueueCapacity(int)` | 100 | Pages waiting to be written before writes become synchronous. |
| `setEncrypted(boolean)` | `false` | Encrypt pages before they are written. |
| `setCrypter(Supplier<ICrypter>)` | `DefaultCrypter` | Wicket 10 only. The cipher for encrypted pages; Wicket 11 uses the crypt scheme of the security settings. |

### Content security policy

`getCspSettings()` on `WebApplication` returns the `ContentSecurityPolicySettings`. `blocking()` and `reporting()` return the configuration of the enforced and the report-only header, to which you add directives. Wicket sets a strict policy with a nonce for scripts and styles by default. See [Configure the Content Security Policy]({{ site.baseurl }}/docs/csp.html).

### Listener collections

`Application` also holds collections of listeners, each with an `add` method:

| Getter | Listeners for |
|---|---|
| `getRequestCycleListeners()` | Start, end, exceptions and handlers of each request. |
| `getComponentInstantiationListeners()` | Every component constructor, used for dependency injection. |
| `getComponentInitializationListeners()` | `onInitialize` of every component. |
| `getComponentOnConfigureListeners()` | `onConfigure` of every component. |
| `getHeaderContributorListeners()` | Contributions to the `<head>` of every page. |
| `getSessionListeners()` | Creation and invalidation of sessions. |
| `getApplicationListeners()` | Initialization and destruction of the application. |

## Runtime configuration type

`RuntimeConfigurationType` has two values, `DEVELOPMENT` and `DEPLOYMENT`. `WebApplication.getConfigurationType()` takes the first value it finds:

1. The system property `wicket.configuration`.
2. The filter or servlet parameter `wicket.configuration`.
3. The context parameter `wicket.configuration`.
4. The filter or servlet parameter `configuration`.
5. The context parameter `configuration`.
6. `DEVELOPMENT`.

The value is not case-sensitive. An override of `getConfigurationType()` replaces this lookup. [Switch between development and deployment mode]({{ site.baseurl }}/docs/deployment-mode.html) shows each way.

## Development and deployment defaults

During initialization, Wicket sets these settings according to the runtime configuration type. A value you set in `init()` replaces them.

| Setting | Development | Deployment |
|---|---|---|
| `ResourceSettings.setResourcePollFrequency` | 1 second | none, files are not checked |
| `ResourceSettings.setJavaScriptCompressor` | none | `DefaultJavaScriptCompressor` |
| `ResourceSettings.setUseMinifiedResources` | `false` | `true` (the default) |
| Resource version in URLs | last-modified time | content digest |
| `MarkupSettings.setStripWicketTags` | `false` | `true` |
| `ExceptionSettings.setUnexpectedExceptionDisplay` | `SHOW_EXCEPTION_PAGE` | `SHOW_INTERNAL_ERROR_PAGE` |
| `DebugSettings.setComponentUseCheck` | `true` | `false` |
| `DebugSettings.setAjaxDebugModeEnabled` | `true` | `false` |
| `DebugSettings.setDevelopmentUtilitiesEnabled` | `true` | `false` |
| Response filter that logs empty `src` attributes, which make browsers request the page twice | added | not added |
| Content security policy violations | reported back to the application | not reported |
| Warning on standard error at startup | printed | not printed |
