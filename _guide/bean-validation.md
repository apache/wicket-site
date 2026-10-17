---
title: Validate with Bean Validation
type: howto
topic: forms
summary: Check form input against the Jakarta Bean Validation annotations on your domain classes with the wicket-bean-validation module.
since: 10
apis: [BeanValidationConfiguration, PropertyValidator, Property]
keywords: [JSR 303, JSR 380, Jakarta Validation, Hibernate Validator, NotNull, Size, annotations, constraints]
order: 30
source: [forms2/forms2_4.adoc]
---

You need this when your domain classes already carry Jakarta Bean Validation annotations such as `@NotNull` and `@Size`, and you want the form to enforce them instead of repeating each rule with Wicket validators.

## Add the dependencies

Add `wicket-bean-validation` and a Bean Validation provider. Wicket does not ship a provider; Hibernate Validator is the common choice. It also needs a Jakarta Expression Language implementation; its documentation names the one that matches your version.

*pom.xml*

```xml
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-bean-validation</artifactId>
    <version>${wicket.version}</version>
</dependency>
<dependency>
    <groupId>org.hibernate.validator</groupId>
    <artifactId>hibernate-validator</artifactId>
    <version>${hibernate-validator.version}</version>
</dependency>
```

## Turn it on in the application

*WicketApplication.java*

```java
@Override
protected void init() {
    super.init();
    new BeanValidationConfiguration().configure(this);
}
```

## Annotate the class

*Person.java*

```java
public class Person implements Serializable {
    @NotNull
    @Size(max = 50)
    private String name;

    @Email
    private String email;

    @Min(18)
    private int age;

    @Past
    private LocalDate birthday;

    @Pattern(regexp = "\\d{4}\\s?[A-Z]{2}", message = "{person.invalidPostcode}")
    private String postcode;

    // getters and setters
}
```

## Add a PropertyValidator to each field

A `PropertyValidator` finds the property behind the field and runs that property's constraints on the converted input. It reads the property from a `PropertyModel` or from an inherited `CompoundPropertyModel`:

*PersonPage.java*

```java
Form<Person> form = new Form<>("form", new CompoundPropertyModel<>(new Person()));
add(form);

form.add(new TextField<String>("name").add(new PropertyValidator<>()));
form.add(new TextField<String>("email").add(new PropertyValidator<>()));
form.add(new TextField<Integer>("age").add(new PropertyValidator<>()));
form.add(new TextField<LocalDate>("birthday").add(new PropertyValidator<>()));
form.add(new TextField<String>("postcode").add(new PropertyValidator<>()));
form.add(new FeedbackPanel("feedback"));
```

The validator also changes the field to match its constraints:

- `@NotNull` and `@NotEmpty` make the field required.
- `@Size(max = ...)` adds a `maxlength` attribute to the input.

## Validate a field bound to a lambda model

A lambda model does not tell which property it reads, so name it with a `Property`:

```java
TextField<String> name = new TextField<>("name",
    LambdaModel.of(person, Person::getName, Person::setName));
name.add(new PropertyValidator<>(new Property(Person.class, "name")));
```

## Change the message text

Wicket ships messages for the standard constraints, keyed by the constraint's message key, such as `jakarta.validation.constraints.NotNull.message`. They use `${label}` like the other form messages. Define the same key in a properties file of your page or application to replace one.

For a message of your own, put a key in braces in the annotation, as `{person.invalidPostcode}` above, and define that key:

*PersonPage.properties*

```properties
person.invalidPostcode=${label} must be a Dutch postcode, such as 1234 AB.
```

Wicket tries the key with the type of the rejected value appended first (`person.invalidPostcode.String`), then the key itself. The attributes of the annotation are available as variables, so a message for `@Size` can use `${max}`.

## Validate only some constraints

Put constraints in a group with a marker interface, and pass the group to the validator to check only the constraints in it:

```java
public interface OnSignup {}

@NotNull(groups = OnSignup.class)
private String email;
```

```java
emailField.add(new PropertyValidator<>(OnSignup.class));
```

Constraints without a group belong to `jakarta.validation.groups.Default`; pass it as well when you want those checked too.

## Constraints on the whole object

`PropertyValidator` checks one property at a time, before the model is updated. A constraint that compares properties, declared on the class, needs the updated object. Check it in `onValidateModelObjects()` of the form, which runs after the model update; see [How a form is processed]({{ site.baseurl }}/docs/form-processing.html#the-exception-late-validation) for what that means for your model.
