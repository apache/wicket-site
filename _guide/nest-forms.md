---
title: Nest forms
type: howto
topic: forms
summary: Put a form inside another form, submit and validate the inner form on its own, and decide which forms take part in a submit.
since: 10
apis: [Form]
keywords: [nested form, inner form, subform, form in form, wantSubmitOnNestedFormSubmit, wantSubmitOnParentFormSubmit]
order: 80
source: [forms2/forms2_6.adoc]
---

You need this when part of a form must be submitted and validated on its own, such as an "Add address" section inside a customer form, or when you reuse a panel that contains its own form.

HTML does not allow a form inside a form. Wicket does: it renders the outer form as the only `<form>` and every nested form as a `<div>`, and keeps track of which form a submit belongs to.

## Put a form inside another form

Add the inner form to a component inside the outer form, and nest the markup the same way. Forms can be nested to any depth.

*CustomerPage.java*

```java
Form<Customer> customerForm = new Form<>("customerForm", customerModel) {
    @Override
    protected void onSubmit() {
        customerService.save(getModelObject());
    }
};
add(customerForm);
customerForm.add(new TextField<>("name",
    LambdaModel.of(customerModel, Customer::getName, Customer::setName)).setRequired(true));

IModel<Address> newAddress = Model.of(new Address());
Form<Address> addressForm = new Form<>("addressForm", newAddress);
customerForm.add(addressForm);
addressForm.add(new TextField<>("street",
    LambdaModel.of(newAddress, Address::getStreet, Address::setStreet)).setRequired(true));
addressForm.add(new Button("addAddress") {
    @Override
    public void onSubmit() {
        customerModel.getObject().addAddress(newAddress.getObject());
        newAddress.setObject(new Address());
    }
});
```

*CustomerPage.html*

```html
<form wicket:id="customerForm">
    <input type="text" wicket:id="name">
    <form wicket:id="addressForm">
        <input type="text" wicket:id="street">
        <button type="submit" wicket:id="addAddress">Add address</button>
    </form>
    <button type="submit">Save customer</button>
</form>
```

## Submit only the inner form

A button inside the inner form submits only that form. Wicket validates the inner form, updates its models and calls its `onSubmit()`. The outer form is not validated, so "Add address" works while the customer name is still empty. The browser does send the input of the whole page. Wicket shows what the user typed in the outer fields again, but does not validate or store it.

## Submit everything from the outer form

A button of the outer form, or a plain submit button, submits the outer form together with all nested forms. Every form is validated; if any field in any of them is invalid, no model is updated. When all are valid, `onSubmit()` is called on the innermost forms first and on the outer form last.

To leave a nested form out when its parent is submitted, override `wantSubmitOnParentFormSubmit()` in the nested form:

```java
Form<Address> addressForm = new Form<>("addressForm", newAddress) {
    @Override
    protected boolean wantSubmitOnParentFormSubmit() {
        return false;
    }
};
```

Without this, the "Save customer" button in the example would fail on an empty street field. With it, the address section is neither validated nor updated when the customer is saved.

## Submit the outer form along with the inner form

To make a submit of the inner form process the outer form as well, override `wantSubmitOnNestedFormSubmit()` in the outer form and return `true`. A submit from the nested form then processes the outermost form that wants it, together with all forms inside it.

## Show the messages of each form

A single `FeedbackPanel` shows the messages of both forms. To show them per form without duplicates, give each form a `FencedFeedbackPanel` with the form as fence:

```java
customerForm.add(new FencedFeedbackPanel("customerFeedback", customerForm));
addressForm.add(new FencedFeedbackPanel("addressFeedback", addressForm));
```

The outer panel then leaves out the messages that come from inside the address form.
