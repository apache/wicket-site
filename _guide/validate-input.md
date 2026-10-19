---
title: Validate input and show errors
type: howto
topic: forms
summary: Make fields required, check their values with validators, show the error messages and change their text.
since: 10
apis: [FormComponent, IValidator, ValidationError, FeedbackPanel, EqualPasswordInputValidator, StringValidator]
keywords: [required, error message, feedback, constraint, validation message, Required, setLabel, custom validator]
order: 10
source: [forms2/forms2_2.adoc]
---

You need this when a form must reject input before it reaches your model. Wicket checks each field when the form is submitted and calls `onSubmit()` only when every check passes; [How a form is processed]({{ site.baseurl }}/docs/form-processing.html) explains the order.

## Make a field required

Call `setRequired(true)`. An empty field then fails with the message "'${label}' is required."

*RegistrationPage.java*

```java
IModel<Registration> registration = Model.of(new Registration());
Form<Registration> form = new Form<>("form", registration) {
    @Override
    protected void onSubmit() {
        // only reached when every field is valid
        success("Your account has been created.");
    }
};
add(form);

TextField<String> username = new TextField<>("username",
    LambdaModel.of(registration, Registration::getUsername, Registration::setUsername));
username.setRequired(true);
username.setLabel(Model.of("Username"));
form.add(username);
```

`setLabel` gives the field the name that messages use for `${label}`. Without it, Wicket looks up a resource with the component id as key, and falls back to the id itself.

{% if site.wicket.version_11 %}
> Since Wicket 11, a required text field renders the `required` attribute, its label becomes the `placeholder`, and a `PatternValidator` becomes the `pattern` attribute. The browser then blocks an empty submit with its own message before Wicket sees the request. Add `novalidate` to the `<form>` tag if you want Wicket's messages only. In Wicket 10 you get these attributes by adding `HTML5Attributes` to the field.
{: .since}
{% else %}
To let the browser check the field as well, add the `HTML5Attributes` behavior to it. A required text field then renders the `required` attribute, its label becomes the `placeholder`, and a `PatternValidator` becomes the `pattern` attribute. The browser blocks an empty submit with its own message before Wicket sees the request.
{% endif %}

## Add a validator

Add one or more validators to the field. They run after the input has been converted, and only when the field is not empty.

```java
username.add(StringValidator.lengthBetween(3, 20));

EmailTextField email = new EmailTextField("email",
    LambdaModel.of(registration, Registration::getEmail, Registration::setEmail));
email.setRequired(true);
form.add(email);
```

`EmailTextField` already carries an `EmailAddressValidator`. [Validators and converters]({{ site.baseurl }}/docs/validators.html) lists all built-in validators with their messages.

## Show the error messages

Add a `FeedbackPanel`. It renders every message of the page as a list, with a CSS class per level such as `feedbackPanelERROR`.

```java
form.add(new FeedbackPanel("feedback"));
```

*RegistrationPage.html*

```html
<form wicket:id="form">
    <div wicket:id="feedback"></div>
    <label wicket:for="username">Username</label>
    <input type="text" wicket:id="username">
    <label wicket:for="email">Email</label>
    <input type="email" wicket:id="email">
    <button type="submit">Register</button>
</form>
```

A `<label wicket:for="...">` gets the class `error` while its field is invalid, and `required` when the field is required, so you can mark the field itself.

To show messages next to each field, give each field its own panel: `new FeedbackPanel("usernameFeedback", new ComponentFeedbackMessageFilter(username))`. When forms are nested, use `FencedFeedbackPanel` with the form as fence, so a message does not show up twice.

## Change the text of a message

Put the message key in the properties file of the page, the panel or the application. Wicket tries the key prefixed with the component id first, then the bare key.

*RegistrationPage.properties*

```properties
username.Required=Choose a username.
Required=Please fill in ${label}.
EmailAddressValidator='${input}' is not an email address.
```

Messages can use `${label}`, `${input}` (what the user typed) and `${name}` (the component id), plus the variables of the validator, such as `${minimum}`.

## Check two fields together

Rules that compare fields belong on the form. For a password and its confirmation, add an `EqualPasswordInputValidator`:

```java
PasswordTextField password = new PasswordTextField("password", Model.of());
PasswordTextField confirm = new PasswordTextField("confirm", Model.of());
form.add(password, confirm);
form.add(new EqualPasswordInputValidator(password, confirm));
```

For your own rule, extend `AbstractFormValidator`. Return the fields in `getDependentFormComponents()`; Wicket only calls `validate(Form)` when all of them are valid, so you can read their `getConvertedInput()` safely.

## Write your own validator

Implement `IValidator` and report an error on the `IValidatable`. `new ValidationError(this)` uses the class name as the message key.

*UniqueUsernameValidator.java*

```java
public class UniqueUsernameValidator implements IValidator<String> {
    @Override
    public void validate(IValidatable<String> validatable) {
        String name = validatable.getValue();
        if (UserDirectory.isTaken(name)) {
            validatable.error(new ValidationError(this)
                .setVariable("suggestion", name + "2"));
        }
    }
}
```

*RegistrationPage.properties*

```properties
UniqueUsernameValidator=The username '${input}' is taken. How about '${suggestion}'?
```

For a one-off check, `new ValidationError("Username is taken")` sets the text directly; it is used when no key matches.

## Report success

Every component can add its own messages with `success()`, `info()`, `warn()` and `error()`. Messages added in `onSubmit()` show up in the same `FeedbackPanel`. To show only one level in a panel, pass an `ExactLevelFeedbackMessageFilter(FeedbackMessage.SUCCESS)`.
