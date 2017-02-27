---
layout: default
title: Servlet 3.x with Spring Framework
---

This example shows you how to configure Wicket to run without any XML definitions.
It requires to use the Servlet 3.x API and a container which is able to load the
web component definitions via annotations defined within this standard.

## Creating the web components

### MyFilter.java ###

First you have to configure the filter which was done within the web.xml in previous versions
of the Servlet specification. All initialization parameters are configured also via annotations.
The Application class is defined in the init param with the name applicationClassName.

{% highlight java %}
import javax.servlet.annotation.WebFilter;
import javax.servlet.annotation.WebInitParam;
import org.apache.wicket.protocol.http.WicketFilter;

@WebFilter(value = "/*", initParams = {
		@WebInitParam(name = "applicationClassName",
		value = "com.my.package.MyApplication"),
		@WebInitParam(name = "configuration", value = "development") })
public class MyFilter extends WicketFilter {}
{% endhighlight %}

### MyContextLoaderListener.java ###

Another important class is the ContextLoaderListener which in our case is going to initialize
the Spring Framework's context and effects a package scan for Spring components. Usually
those Spring components are initialized with specific annotations like @Component or @Service for
example. You have to place them into the scanned package or in sub packages. (com.my.package in this case)


{% highlight java %}
import javax.servlet.annotation.WebListener;
import org.springframework.web.context.ContextLoaderListener;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.AnnotationConfigWebApplicationContext;

@WebListener
public class MyContextLoaderListener extends ContextLoaderListener {

  public MyContextLoaderListener() {
    super(getWebApplicationContext());
  }

  private static WebApplicationContext getWebApplicationContext() {
    AnnotationConfigWebApplicationContext context
    	= new AnnotationConfigWebApplicationContext();
    context.scan("com.my.package");
    context.refresh();
    return context;
  }
}
{% endhighlight %}

### MyRequestContextListener.java ###

To configure Spring Framework to recognize the request context a RequestContextListener needs to be
defined. This listener enables the web project to use beans with a scope. So if you want a bean
to remain in the session as long as the user is surfing on your web page you can do this by adding the
annotation @SessionScope together with @Component.

{% highlight java %}
import javax.servlet.annotation.WebListener;
import org.springframework.web.context.request.RequestContextListener;

@WebListener
public class MyRequestContextListener extends RequestContextListener{}
{% endhighlight %}

### MySessionBean.java ###

This is a small example of a session scoped bean within the "com.my.package" package. It can be 
autowired by using the @SpringBean annotation in any wicket component like a WebPage or a Panel.

{% highlight java %}
import javax.annotation.PostConstruct;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.annotation.SessionScope;

@Component
@SessionScope
public class MySessionBean {
	
  @Autowired
  private HttpSession httpSession;

  @PostConstruct
  public void postConstruct() {
    // do something after the bean has been constructed
  }

  public HttpSession getHttpSession() {
    return httpSession;
  }
}
{% endhighlight %}

Here you can see the autowiring in the component class:

{% highlight java %}
import com.my.package.MySessionBean;
import org.apache.wicket.spring.injection.annot.SpringBean;
import org.apache.wicket.markup.html.WebPage;

public class HelloWorld extends WebPage {

  @SpringBean
  private MySessionBean mySessionBean;

  public HomePage() {
    // do something
  }
}
{% endhighlight %}

## Creating the web application class

Within our application class it is required to hand over the Spring's application context to the 
SpringComponentInjector so that beans are also injected into Wicket components. If you are interested in how to 
implement the home page and the corresponding HTML markup have a look at the corresponding 
example: [Hello World!](helloworld.html)

{% highlight java %}
import org.apache.wicket.Page;
import org.apache.wicket.protocol.http.WebApplication;
import org.apache.wicket.spring.injection.annot.SpringComponentInjector;
import org.springframework.web.context.support.WebApplicationContextUtils;
import com.my.package.HelloWorld;

public class MyApplication extends WebApplication {

  @Override
  public Class<? extends Page> getHomePage() {
    return HelloWorld.class;
  }

  @Override
  protected void init() {
    super.init();
    getComponentInstantiationListeners().add(new SpringComponentInjector(this,
      WebApplicationContextUtils.getRequiredWebApplicationContext(
        getServletContext())));
  }
}
{% endhighlight %}

## Summary

Since Servlet 3.x and the corresponding changes within the Spring Framework to configure web applications
without any XML definitions it is easily possible to increase the maintainability, because every configuration
is covered by the java compiler. Also you don't have to switch between various different initialization representations.
Required artifacts are: spring-web (required: >4.0), wicket-spring (recommend: >7.6.0), wicket-core (recommend: >7.6.0),
javax.servlet-api (required: >3.x)