---
layout: default
title: Using Fragments
---

This example shows you how to use fragments (Wicket 1.2 feature) to lessen
the burden on extra markup files. Fragments are 'inline panels' and are a
quick way of using panel type components in pages without having to create a
`Panel` markup file and class.

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

## Creating a Fragment

First things first, let's create a page that we can add our fragments to. We
will add a Loop that will repeat markup and choose a different Fragment for
each item in the loop.

{% highlight html %}
<html>
<head></head>
<body>
    <ul>
        <li wicket:id="list"><span wicket:id="panel"></span></li>
    </ul>
    <wicket:fragment wicket:id="fragment1">panel 1</wicket:fragment>
    <wicket:fragment wicket:id="fragment2">panel 2</wicket:fragment>
</body>
</html>
{% endhighlight %}

As you can see in this markup file, we already took care of adding the
fragment markup to the page in the `<wicket:fragment>` tags. Each fragment
can contain its own markup and components. Those components need to be added
to the Fragment instance in the Java file, just as you would do with a panel
and web markup container.

{% highlight java %}
package wicket.quickstart;

import wicket.markup.html.list.Loop;
import wicket.markup.html.panel.Fragment;

public class Index extends QuickStartPage {
    public Index() {
        Loop loop = new Loop("list", 5) {
            protected void populateItem(LoopItem item) {
                String fragmentId = "fragment" + (item.getIteration() % 2 + 1);
                item.add(new Fragment("panel", fragmentId, Index.this));
            }
        };
        add(loop);
    }
}
{% endhighlight %}

The Loop will render 5 items, and the `populateItem` method will be called
for each item. In each item we construct a fragment identifier that
corresponds to the identifier in the `<wicket:fragment>`. The `Fragment`
constructor takes the identifier of the markup it needs to attach to, and the
fragment identifier telling it where to find the specific markup in the file.

## Adding components to fragments

In the previous example we just showed different markup for each fragment,
but you can add components to the fragments as well. Let's add a label to
fragment 1.

{% highlight html %}
<html>
<head></head>
<body>
    <ul>
        <li wicket:id="list"><span wicket:id="panel"></span></li>
    </ul>
    <wicket:fragment wicket:id="fragment1">panel 1 <span wicket:id="label"></span></wicket:fragment>
    <wicket:fragment wicket:id="fragment2">panel 2</wicket:fragment>
</body>
</html>
{% endhighlight %}

In order to add the component to the first fragment we'll introduce a
subclass for fragment one to encapsulate the component.

{% highlight java %}
package wicket.quickstart;

import wicket.markup.html.basic.Label;
import wicket.markup.html.list.Loop;
import wicket.markup.html.panel.Fragment;

public class Index extends QuickStartPage {
    public class Fragment1 extends Fragment {
        public Fragment1(String id, String markupId) {
            super(id, markupId, Index.this);
            add(new Label("label", "Hello, World!"));
        }
    }

    public Index() {
        Loop loop = new Loop("list", 5) {
            protected void populateItem(LoopItem item) {
                int index = (item.getIteration() % 2 + 1);
                String fragmentId = "fragment" + index;
                if (index == 1) {
                    item.add(new Fragment1("panel", fragmentId));
                } else {
                    item.add(new Fragment("panel", fragmentId, Index.this));
                }
            }
        };
        add(loop);
    }
}
{% endhighlight %}

The class `Fragment1` adds the label to itself. In the loop's `populateItem`
we alternate the fragments type between `Fragment` and `Fragment1`. This
means that in the final page on one line you'll see `"panel 1 Hello, World!"`
and on the other line just `"panel 2"`.

## Summary

Fragments make a quick way to add encapsulated components without having to
resort to setting the visibility flag on a markup container. For fragments we
introduced a new Wicket tag: `<wicket:fragment>`.
