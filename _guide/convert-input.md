---
title: Convert input to your types
type: howto
topic: forms
summary: Tell a field which type its input becomes, write a converter for your own type and register it for one field or the whole application.
since: 10
apis: [IConverter, ConverterLocator, IConverterLocator, ConversionException, FormComponent]
keywords: [converter, type conversion, setType, not a valid, parse, format, newConverterLocator, createConverter]
order: 20
source: [forms2/forms2_3.adoc]
---

You need this when a field holds something other than a `String` and the default conversion does not do what you want, or does not know your type. Conversion runs after the required check and before the validators; [How a form is processed]({{ site.baseurl }}/docs/form-processing.html) explains why.

## Tell the field its type

A field converts its input to its *type*. It finds the type in this order:

1. The type you pass to the constructor or set with `setType(Class)`.
2. The object class reported by the model. `PropertyModel` and `CompoundPropertyModel` know the type of their property; `Model` knows the class of its current object, if it has one.
3. Otherwise the input stays a `String`.

Lambda models do not report a type, so pass it yourself:

```java
TextField<Integer> quantity = new TextField<>("quantity",
    LambdaModel.of(order, Order::getQuantity, Order::setQuantity), Integer.class);
```

Without `Integer.class`, Wicket would try to put a `String` into an `Integer` property. Setting a primitive type such as `int.class` also makes the field required.

Wicket converts the common types out of the box: numbers, `Boolean`, `Character`, `BigDecimal`, `BigInteger`, `java.util.Date`, `Calendar`, the `java.sql` date types, `LocalDate`, `LocalDateTime`, `LocalTime` and `ZonedDateTime`. [Validators and converters]({{ site.baseurl }}/docs/validators.html#converters) lists them with their formats.

## Write a converter

Implement `IConverter` with both directions: from the input string to your object, and from your object to the string shown in the field. Throw a `ConversionException` when the input cannot be read.

*YearMonthConverter.java*

```java
public class YearMonthConverter implements IConverter<YearMonth> {
    private static final DateTimeFormatter FORMAT = DateTimeFormatter.ofPattern("MM/yyyy");

    @Override
    public YearMonth convertToObject(String value, Locale locale) {
        try {
            return YearMonth.parse(value, FORMAT);
        } catch (DateTimeParseException e) {
            throw new ConversionException(e)
                .setResourceKey("YearMonthConverter")
                .setVariable("format", "MM/yyyy");
        }
    }

    @Override
    public String convertToString(YearMonth value, Locale locale) {
        return FORMAT.format(value);
    }
}
```

An empty text field becomes `null` before your converter is called, so `convertToObject` only sees real input. Both methods get the locale of the session, for types whose format depends on the language.

## Register the converter for the whole application

Override `newConverterLocator()` in your application. Start from a `ConverterLocator`, which already holds the default converters, and add yours:

*WicketApplication.java*

```java
@Override
protected IConverterLocator newConverterLocator() {
    ConverterLocator locator = new ConverterLocator();
    locator.set(YearMonth.class, new YearMonthConverter());
    return locator;
}
```

Every component whose type is `YearMonth` now uses it, both for input and for display. A `Label` with a `YearMonth` model renders as `03/2027` too.

## Use a converter for one field

Override `createConverter` on the component. Return `null` for types you do not handle, so the application's converters still apply.

```java
TextField<YearMonth> expiry = new TextField<>("expiry",
        LambdaModel.of(card, Card::getExpiry, Card::setExpiry), YearMonth.class) {
    @Override
    protected IConverter<?> createConverter(Class<?> type) {
        return YearMonth.class.equals(type) ? new YearMonthConverter() : null;
    }
};
```

## Change the conversion error message

A failed conversion reports the message with key `IConverter`: "The value of '${label}' is not a valid ${type}." Wicket first tries `IConverter.<Type>`, so you can word it per type. A resource key set on the `ConversionException` is tried before both. Put the keys in a properties file of the page or application:

*WicketApplication.properties*

```properties
YearMonthConverter=Enter ${label} as ${format}, for example 03/2027.
IConverter.Integer=${label} must be a whole number.
```

Variables you set on the exception, such as `${format}` above, are available in the message, next to `${label}`, `${input}` and `${type}`.

## Choices convert differently

`DropDownChoice`, `RadioChoice` and the other choice components do not use converters. They map the submitted option id back to one of their choices with their `IChoiceRenderer`. See [Let the user pick from a list]({{ site.baseurl }}/docs/dropdown-choice.html).
