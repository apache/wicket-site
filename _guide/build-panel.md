---
title: Build a reusable panel
type: howto
topic: components
summary: Package a piece of user interface as a Panel, a Java class with its own HTML file, and use it on any page as often as you need.
since: 10
apis: [Panel, GenericPanel]
keywords: [wicket:panel, custom component, reusable component, partial, include, widget, fragment of page, component with markup]
order: 50
source: [layout/layout_2.adoc, layout/layout_3.adoc]
---

Use a panel when a piece of a page, with its markup and its components, appears in more than one place, or when a page gets too big to read. A panel is a component with its own markup file. Pages contain panels, panels contain other panels, and each one only knows its own markup.

## Write the panel class

Subclass `GenericPanel` when the panel shows one object, so the model is typed. Use `Panel` when it has no model of its own. Add the panel's components in the constructor, or in `onInitialize` when they need the page or the parent.

*AddressPanel.java*

```java
package com.example.customer;

public class AddressPanel extends GenericPanel<Address> {
    public AddressPanel(String id, IModel<Address> address) {
        super(id, address);
    }

    @Override
    protected void onInitialize() {
        super.onInitialize();
        add(new Label("street", getModel().map(Address::getStreet)));
        add(new Label("city", getModel().map(Address::getCity)));
        add(new Label("country", getModel().map(Address::getCountry)));
    }
}
```

`getModel().map(...)` derives a model for each field, so the labels always show the current address. See [Read and write data with lambda models]({{ site.baseurl }}/docs/lambda-models.html).

## Write the panel's markup

Give the HTML file the same name as the class, next to it in the same package: `com/example/customer/AddressPanel.html`. Wicket uses only what is inside `<wicket:panel>`. Use the rest of the file for a preview.

*AddressPanel.html*

```html
<!DOCTYPE html>
<html xmlns:wicket="http://wicket.apache.org">
<body>
  <wicket:panel>
    <address>
      <span wicket:id="street">Main Street 1</span><br>
      <span wicket:id="city">Springfield</span><br>
      <span wicket:id="country">USA</span>
    </address>
  </wicket:panel>
</body>
</html>
```

With Maven, put the HTML file either in `src/main/java` next to the class, if your build copies non-Java files from there, or in the same package under `src/main/resources`.

## Use the panel in a page

Give the panel a tag in the page and add it like any component:

*CustomerPage.html*

```html
<h2>Billing address</h2>
<div wicket:id="billing"></div>
<h2>Shipping address</h2>
<div wicket:id="shipping"></div>
```

*CustomerPage.java*

```java
IModel<Customer> customer = LoadableDetachableModel.of(() -> customers.find(customerId));
add(new AddressPanel("billing", customer.map(Customer::getBillingAddress)));
add(new AddressPanel("shipping", customer.map(Customer::getShippingAddress)));
```

The panel's markup replaces the content of its tag. The tag itself, `<div>` here, stays.

## Reach components inside a panel

From outside, refer to a panel's child by its path, the ids separated by colons:

```java
Component city = get("billing:city");
```

Prefer to give the panel a method or a constructor argument for what callers need to change. A path couples the caller to the panel's insides.

## Give the panel its own CSS

Ship the panel's styles with the panel, so every page that uses it gets them. Contribute a stylesheet from `renderHead`:

```java
@Override
public void renderHead(IHeaderResponse response) {
    super.renderHead(response);
    response.render(CssHeaderItem.forReference(
        new CssResourceReference(AddressPanel.class, "AddressPanel.css")));
}
```

Wicket adds the stylesheet once, however many panels are on the page. For a few lines you can also put a `<style>` inside `<wicket:head>` in the panel's markup file. See [Add CSS and JavaScript to a page]({{ site.baseurl }}/docs/add-css-javascript.html).

## Extend a panel

A panel can extend another panel and its markup, as pages do. Put `<wicket:child/>` in the base panel's markup inside `<wicket:panel>`, and the subclass's markup in `<wicket:extend>`. See [Markup inheritance]({{ site.baseurl }}/docs/markup-inheritance.html).

For a small block of markup that only one page needs, a [fragment]({{ site.baseurl }}/docs/use-fragments.html) saves you the class and the file.
