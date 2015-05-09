---
layout: default
title: Ajax Counter
---

This example shows you how to use Wicket's Ajax behaviors and components by
building a simple counter that updates through Ajax link clicks.

In all the Wicket examples, you have to put all files in the same package
directory. This means putting the markup files and the java files next to one
another. It is possible to alter this behavior, but that is beyond the scope
of this example. The only exception is the obligatory `web.xml` file which
should reside in the `WEB-INF/` directory of your web application root
folder.

In this example we assume you already have read and understood the other
examples which give you information on the structure and nature of Wicket
applications. Specifically read and understand the [Hello, World
example](helloworld.html).

## Counter page

First we'll create a page that just counts the number of times a link has been clicked. In the following markup you'll see a link and a label.

{% highlight html %}
<html>
<head></head>
<body>
    <a href="#" wicket:id="link">click me</a>
    <p>
        Counter: <span wicket:id="counter">nr of times</span>
    </p>
</body>
</html>
{% endhighlight %}

The link component will refresh the page and the label will replace the text
'nr of times' with the count. Take a look at the following Java file to see
how it works on the Java side:

{% highlight java %}
package wicket.quickstart;

import wicket.Component;
import wicket.markup.html.basic.Label;
import wicket.markup.html.link.Link;
import wicket.model.Model;

public class Index extends QuickStartPage {
    public Index() {
        Model<Integer> model = new Model<Integer>() {
            private int counter = 0;

            public Integer getObject() {
                return counter++;
            }
        };
        add(new Link("link") {
            public void onClick() {
                // do nothing.
            }
        });
        add(new Label<Integer>("counter", model));
    }
}
{% endhighlight %}

In this class we created a `Model` subclass that increases its counter
everytime the `getObject` method gets called, and returns its value. We set
this model on the label component, so that each time the label gets rendered
the counter gets increased.

The link doesn't do anything, just listen to the requests and update the
page. If you run this code in your application (download the Quickstart
project and copy/paste the code in the homepage for a quick experience).

The page gets fully refreshed with each link click. That is not very web 2.0,
so let's make it more modern by adding some Ajax stuff.

## Adding Ajax

To make this a more modern UI we'll have to change a couple of things. First
we need to make the link an Ajax link. Wicket provides several types of Ajax
links, but the best one for our purposes is the `AjaxFallbackLink`, as it
provides a fallback to a normal request in case no Ajax is available.

{% highlight java %}
package wicket.quickstart;

import wicket.Component;
import wicket.ajax.AjaxRequestTarget;
import wicket.ajax.markup.html.AjaxFallbackLink;
import wicket.markup.html.basic.Label;
import wicket.model.Model;

public class Index extends QuickStartPage {
    public Index() {
        Model<Integer> model = new Model<Integer>() {
            private int counter = 0;

            public Integer getObject() {
                return counter++;
            }
        };
        add(new AjaxFallbackLink("link") {
            public void onClick(AjaxRequestTarget target) {
                // add the components that need to be updated to 
                // the target
            }
        });
        add(new Label<Integer>("counter", model));
    }
}
{% endhighlight %}

As you can see, the `Link` has been replaced with the `AjaxFallbackLink`, and the
`onClick` method now takes a new argument: the `AjaxRequestTarget`. If you want a
component to be updated in the Ajax request, you'll have to add them to the
target. So let's alter the file to make it possible to add the label to the
request target.

{% highlight java %}
package wicket.quickstart;

import wicket.Component;
import wicket.ajax.AjaxRequestTarget;
import wicket.ajax.markup.html.AjaxFallbackLink;
import wicket.markup.html.basic.Label;
import wicket.model.Model;

public class Index extends QuickStartPage {
    public Index() {
        Model<Integer> model = new Model<Integer>() {
            private int counter = 0;

            public Integer getObject() {
                return counter++;
            }
        };
        final Label<Integer> label = new Label<Integer>("counter", model);
        label.setOutputMarkupId(true);
        add(new AjaxFallbackLink("link") {
            public void onClick(AjaxRequestTarget target) {
                if (target != null) {
                    // target is only available in an Ajax request
                    target.addComponent(label);
                }
            }
        });
        add(label);
    }
}
{% endhighlight %}

We've moved the instantiation of the label to the beginning of the page
constructor and made a local, final variable. This way we can reference the
label in the event handler of the link component.

We also had to call `setOutputMarkupId(true)` on the label to be able to
update the component when the request is returned to the client browser. If
we don't, Wicket will not know how to update the markup in the client.

If you put this code into your page's class, then you'll have a working Ajax
updating counter.

## Summary

Working with Ajax and Wicket using the standard Wicket libraries doesn't
require a degree in JavaScript. Even better, you don't necessarily need to
update your markup file to work with Ajax. In this (simple) example we were
able to add Ajax behavior to the page without touching the markup file.

The most important lesson here is that in order to update components using
Ajax is that you need to add those components to the `AjaxRequestTarget` and
that the components that are to be updated in that request, should have
`setOutputMarkupId(true)`.
