---
layout: default
title: Servlet 3.x with Spring Framework
---

This example shows you how to configure Wicket to run without any XML definitions.
It requires to use the Servlet 3.x API and a container which is able to load the
web component definitions via annotations defined within this standard.

## Creating the web components

### MyFilter.java ###

First you have to configure the filter which was done within the web.xml in previous
of the Servlet specification. All initialization parameters are configured also via annotations.
The Application class is defined in the init param with the name applicationClassName.

{% highlight java %}
@WebFilter(value = "/*", initParams = {
		@WebInitParam(name = "applicationClassName",
		value = "com.my.package.MyApplication"),
		@WebInitParam(name = "configuration", value = "development") })
public class MyFilter extends WicketFilter {}
{% endhighlight %}

### MyContextLoaderListener.java ###

Another important class is the ContextLoaderListener which in our case is going to initialize
the Spring Framework's context and effects a package scan for other Spring components. Usually
those Spring components are initialized with specific annotations like @Component or @Service for
example. You have to place in all your Spring Components in the scanned package or in subpackages
(com.my.package in this case)


{% highlight java %}
@WebListener
public class MyContextLoaderListener extends ContextLoaderListener {

  private static AnnotationConfigWebApplicationContext context;

  static {
    context = new AnnotationConfigWebApplicationContext();
    context.scan("com.my.package");
    context.refresh();
  }

  public MyContextLoaderListener() {
    super(context);
  }

  public static AnnotationConfigWebApplicationContext getContext() {
    return context;
  }

  public static void setContext(
    AnnotationConfigWebApplicationContext context) {
      MyContextLoaderListener.context = context;
  }
}
{% endhighlight %}

### MyRequestContextListener.java ###

To configure Spring Framework to recognize the request context a RequestContextListener needs to be
defined. This listener enables the web project to define beans with a scope. So if you want a bean
to remains in the session as long as the user is surfing on your web page you can do this by adding the
annotation @SessionScope together with @Component.

{% highlight java %}
@WebListener
public class MyRequestContextListener extends RequestContextListener{}
{% endhighlight %}

## Creating the web application class

Within our application class it is required to hand over the Spring's application context to the 
SpringComponentInjector so that beans are also injected into Wicket components - this can be done by using the 
@SpringBean annotation. If you are interested in how to implement the home page have a look at the 
corresponding example: [Hello World!](helloworld.html)

{% highlight java %}
public class MyApplication extends WebApplication {

	@Override
	public Class<? extends Page> getHomePage() {
		return HelloWorld.class;
	}

	@Override
	protected void init() {
		super.init();
		getComponentInstantiationListeners().add(
			new SpringComponentInjector(this,
				MyContextLoaderListener.getContext()));
	}
}
{% endhighlight %}

## Summary

Since Servlet 3.x and the corresponding changes within the Spring Framework to configure web applications
without any XML definitions it is easily possible to increase the maintainability, because every configuration
is covered by the java compiler. Also you don't have to switch between various different initialization representations.
Required artifacts are: spring-web (required: >4.0), wicket-spring (recommend: >7.6.0), wicket-core (recommend: >7.6.0),
javax.servlet-api (required: >3.x)