---
layout: default
title: Hello World!
category: learnmore
---

HelloWorld demonstrates the basic structure of a web application in Wicket. A
Label component is used to display a message on the home page for the
application.

In all the Wicket examples, you have to put all files in the same package
directory. This means putting the markup files and the java files next to one
another. It is possible to alter this behavior, but that is beyond the scope
of this example. The only exception is the obligatory web.xml file which
should reside in the WEB-INF/ directory of your web application root folder.

If you wish to start building this example, you may want to take a look at the
Wicket Quickstart project, which provides a quick way of getting up and
running without having to figure things out yourself. The Quickstart project
contains the necessary build files (Ant and Maven), libraries, minimal set of
Java and markup files and an embedded Jetty server to run your application
without having to go through the whole build-deploy cycle.

### HelloWorldApplication.java ###

Each Wicket application is defined by an Application object. This object
defines what the home page is, and allows for some configuration.

{% highlight java %}
import org.apache.wicket.protocol.http.WebApplication;

public class HelloWorldApplication extends WebApplication {
    public HelloWorldApplication() {
    }

    /**
     * @see org.apache.wicket.Application#getHomePage()
     */
    @Override
    public Class getHomePage() {
        return HelloWorld.class;
    }
}
{% endhighlight %}

Here you can see that we define `wicket.examples.helloworld.HelloWorld` to be
our home page. When the base URL of our application is requested, the markup
rendered by the HelloWorld page is returned.

### HelloWorld.java ###

{% highlight java %}
import org.apache.wicket.markup.html.WebPage;
import org.apache.wicket.markup.html.basic.Label;

public class HelloWorld extends WebPage {
    public HelloWorld() {
        add(new Label("message", "Hello World!"));
    }
}
{% endhighlight %}

The Label is constructed using two parameters:

1.	"message"

2.	"Hello World!"

The first parameter is the component identifier, which Wicket uses to identify
the `Label` component in your HTML markup. The second parameter is the message
which the `Label` should render.

### HelloWorld.html ###

The HTML file that defines our Hello World functionality is as follows:

{% highlight html %}
<html>
<body>
    <span wicket:id="message">Message goes here</span>
</body>
</html>
{% endhighlight %}

In this file, you see two elements that need some attention:

* the component declaration `<span wicket:id="message">`

* the text `Message goes here`

The component declaration consists of the Wicket identifier `wicket:id` and the
component identifier `message`. The component identifier should be the same as
the name of the component you defined in your `WebPage`. The text between
the `<span>` tags is removed when the component renders its message. The final
content of the component is determined by your Java code.

### web.xml ###

In order to deploy our HelloWorld program, we need to make our application
known to the application server by means of the web.xml file.

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE web-app
      PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
      "http://java.sun.com/dtd/web-app_2_3.dtd">

<web-app>
    <display-name>Wicket Examples</display-name>
    <filter>
        <filter-name>HelloWorldApplication</filter-name>
        <filter-class>org.apache.wicket.protocol.http.WicketFilter</filter-class>
        <init-param>
          <param-name>applicationClassName</param-name>
          <param-value>org.apache.wicket.examples.helloworld.HelloWorldApplication</param-value>
        </init-param>
    </filter>
    <filter-mapping>
        <filter-name>HelloWorldApplication</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
</web-app>
{% endhighlight %}

In this definition you see the Wicket filter defined, which handles all
requests. In order to let Wicket know which application is available, only the
applicationClassName filter parameter is needed.

Also, notice the url-mapping to /\*. The Wicket filter will only process
requests that are Wicket requests. If a request is not Wicket related, the
filter will pass the request on to the chain. This ensures that (static)
resources outside the realm of the Wicket application, such as style sheets,
JavaScript files, images and so forth will be served by the container.

## Ready to deploy ##

That's it. No more configuration necessary! All you need to do now is to
deploy the web application into your favorite application server. Point your
browser to the url: `http://<servername>/<warfilename>/`, substituting
servername and warfilename to the appropriate values, such as
http://localhost:8080/helloworld/.

As you can see: no superfluous XML configuration files are needed to enable a
Wicket application. Only the markup (HTML) files, the Java class files and the
required web.xml were needed to create this application.
