---
title: Repeat markup with RepeatingView
type: howto
topic: repeaters
summary: Render a tag once for every child you add in code, for menus, button bars and other short lists you build in the constructor.
since: 10
apis: [RepeatingView, WebMarkupContainer]
keywords: [loop, repeat, for each, dynamic number of components, newChildId, menu, tabs]
order: 10
source: [repeaters/repeaters_1.adoc]
---

Use `RepeatingView` when you build a small, fixed set of items in code: a menu, a row of buttons, a set of badges. You add one child per item, and each child renders with the repeater's tag. For items that come from a list or a database, use [ListView]({{ site.baseurl }}/docs/list-items.html) or a [data view]({{ site.baseurl }}/docs/paginate-data.html), which build the children for you.

## Repeat a single tag

Attach the repeater to the tag to repeat, and add children with ids from `newChildId()`:

*HomePage.html*
```html
<ul>
    <li wicket:id="colors"></li>
</ul>
```

*HomePage.java*
```java
RepeatingView colors = new RepeatingView("colors");
colors.add(new Label(colors.newChildId(), "green"));
colors.add(new Label(colors.newChildId(), "blue"));
colors.add(new Label(colors.newChildId(), "red"));
add(colors);
```

Output:

```html
<ul>
    <li>green</li>
    <li>blue</li>
    <li>red</li>
</ul>
```

The repeater itself writes no tag. Each child renders with the repeater's markup, `<li wicket:id="colors">`, as if it were its own. The ids only need to be unique within the repeater; `newChildId()` returns a new number each time.

## Repeat a fragment with components inside

When the repeated markup contains components, make each child a `WebMarkupContainer` and add the inner components to it:

*BasePage.html*
```html
<nav>
    <a wicket:id="menu">
        <span wicket:id="label"></span>
    </a>
</nav>
```

*BasePage.java*
```java
public BasePage() {
    RepeatingView menu = new RepeatingView("menu");
    addMenuItem(menu, "Home", HomePage.class);
    addMenuItem(menu, "Orders", OrdersPage.class);
    addMenuItem(menu, "Settings", SettingsPage.class);
    add(menu);
}

private static void addMenuItem(RepeatingView menu, String label,
        Class<? extends Page> page) {
    BookmarkablePageLink<Void> link = new BookmarkablePageLink<>(menu.newChildId(), page);
    link.add(new Label("label", label));
    menu.add(link);
}
```

Here the child is a link, which is itself a container. Any `MarkupContainer` can serve as the child, including a `Panel` or a `Fragment` when the items need different markup.

## Change the items later

`RepeatingView` keeps its children until you change them. It does not rebuild them when it renders, so the items stay as you added them for the life of the page. To change the list, call `removeAll()`, `remove(component)` or `add(component)`, for example in an event handler.

When the items depend on data that changes between requests, rebuilding them yourself gets tedious. A `ListView` or `RefreshingView` rebuilds its items on every render by default; see [Repeaters]({{ site.baseurl }}/docs/repeaters.html) for how each repeater treats its items.
