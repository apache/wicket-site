---
title: Validators and converters
type: reference
topic: forms
summary: The built-in validators, form validators and converters, with their message keys, the variables in their messages and their default texts.
since: 10
apis: [IValidator, IFormValidator, StringValidator, RangeValidator, DateValidator, PatternValidator, EmailAddressValidator, UrlValidator, CreditCardValidator, EqualInputValidator, EqualPasswordInputValidator, AbstractFormValidator, CompoundValidator, ValidationError, IConverter, ConverterLocator, MaskConverter]
keywords: [validation messages, message keys, Application.properties, Required, IConverter, error text, constraint, built-in validators]
order: 20
source: [forms2/forms2_2.adoc, forms2/forms2_3.adoc, forms2/forms2_4.adoc]
---

Validators are in `org.apache.wicket.validation.validator`, form validators in `org.apache.wicket.markup.html.form.validation`, and converters in `org.apache.wicket.util.convert.converter` (module wicket-util). The default English texts are in `Application.utf8.properties` in the package `org.apache.wicket`.

## Validators

| Validator | Create with | Validates | Message key | Variables |
|---|---|---|---|---|
| `StringValidator` | `minimumLength(int)`, `maximumLength(int)`, `lengthBetween(int, int)`, `exactLength(int)` | the length of a `String` | `StringValidator.minimum`, `.maximum`, `.range`, `.exact` | `minimum`, `maximum`, `exact`, `length` |
| `RangeValidator` | `minimum(T)`, `maximum(T)`, `range(T, T)` | any `Comparable`, such as numbers and `java.time` values | `RangeValidator.minimum`, `.maximum`, `.range`, `.exact` | `minimum`, `maximum`, `exact` |
| `DateValidator` | `minimum(Date)`, `maximum(Date)`, `range(Date, Date)`, each also with a format pattern | a `java.util.Date` | `DateValidator.minimum`, `.maximum`, `.range` | `minimum`, `maximum`, `inputdate` |
| `PatternValidator` | `new PatternValidator(String)`, also with flags, a `Pattern` or a `MetaPattern`; `setReverse(true)` rejects matches instead | a `String` against a regular expression | `PatternValidator` | `pattern` |
| `EmailAddressValidator` | `getInstance()` | an email address of the form local-part@domain | `EmailAddressValidator` | `pattern` |
| `UrlValidator` | `new UrlValidator()`, also with allowed schemes and options | a URL; by default `http`, `https` and `ftp` | `UrlValidator` | |
| `CreditCardValidator` | `new CreditCardValidator()` | a credit card number by length, prefix and check digit | `CreditCardValidator` | |
| `CompoundValidator` | `new CompoundValidator<>()`, then `add(IValidator)` | runs several validators as one | the keys of its validators | |

A validator's message key is the simple name of its class, plus a variation for the range validators. A subclass of a validator therefore has its own key.

`UrlValidator` options, combined with `+`:

| Option | Effect |
|---|---|
| `ALLOW_ALL_SCHEMES` | accepts any scheme, ignoring the list of schemes |
| `ALLOW_2_SLASHES` | accepts `//` in the path |
| `NO_FRAGMENTS` | rejects URLs with a `#fragment` |

Validators run only on a non-`null` converted value, unless they implement `INullAcceptingValidator`.

`StringValidator` also writes `maxlength` and `minlength` on the `<input>` or `<textarea>` it validates, so the browser enforces the length as the user types.

> Since Wicket 11, a text field with a `PatternValidator` renders its regular expression as the `pattern` attribute, and the browser checks it before submitting. `EmailAddressValidator` is a `PatternValidator`, so `EmailTextField` gets the attribute too. In Wicket 10 only the `HTML5Attributes` behavior renders it.
{: .since}

## Form validators

Form validators are added to the `Form` with `add(IFormValidator)` and compare several form components.

| Validator | Create with | Validates | Message key | Variables |
|---|---|---|---|---|
| `EqualInputValidator` | `new EqualInputValidator(component1, component2)` | that two components have the same input | `EqualInputValidator` | `input0`, `input1`, `label0`, `label1`, `name0`, `name1` |
| `EqualPasswordInputValidator` | `new EqualPasswordInputValidator(component1, component2)` | as `EqualInputValidator`, without showing the input | `EqualPasswordInputValidator` | as `EqualInputValidator` |
| `AbstractFormValidator` | extend it | base class for your own form validators | the simple class name | set your own |

A form validator runs only when all components returned by `getDependentFormComponents()` are valid.

## Default messages

| Key | Default text |
|---|---|
| `Required` | '${label}' is required. |
| `IConverter` | The value of '${label}' is not a valid ${type}. |
| `StringValidator.minimum` | The value of '${label}' is shorter than the minimum of ${minimum} characters. |
| `StringValidator.maximum` | The value of '${label}' is longer than the maximum of ${maximum} characters. |
| `StringValidator.range` | The value of '${label}' is not between ${minimum} and ${maximum} characters long. |
| `StringValidator.exact` | The value of '${label}' is not exactly ${exact} characters long. |
| `RangeValidator.minimum` | The value of '${label}' must be at least ${minimum}. |
| `RangeValidator.maximum` | The value of '${label}' must be at most ${maximum}. |
| `RangeValidator.range` | The value of '${label}' must be between ${minimum} and ${maximum}. |
| `RangeValidator.exact` | The value of '${label}' must be exactly ${minimum}. |
| `DateValidator.minimum` | The value of '${label}' is less than the minimum of ${minimum}. |
| `DateValidator.maximum` | The value of '${label}' is larger than the maximum of ${maximum}. |
| `DateValidator.range` | The value of '${label}' is not between ${minimum} and ${maximum}. |
| `PatternValidator` | The value of '${label}' does not match pattern '${pattern}'. |
| `EmailAddressValidator` | The value of '${label}' is not a valid email address. |
| `UrlValidator` | The value of '${label}' is not a valid URL. |
| `CreditCardValidator` | The credit card number is invalid. |
| `EqualInputValidator` | '${input0}' from ${label0} and '${input1}' from ${label1} must be equal. |
| `EqualPasswordInputValidator` | ${label0} and ${label1} must be equal. |

Wicket ships translations of these texts for many languages.

## Variables in every message

| Variable | Value |
|---|---|
| `${label}` | the component's label model, else the resource with the component id as key, else the component id |
| `${input}` | the input as the user typed it |
| `${name}` | the component id |

## How a message is found

For an error with key `K` on a component with id `C`, Wicket asks the localizer for these keys in order and uses the first one found:

1. `C.K`
2. `K`

The localizer searches the properties files of the component, its parents and the page, then the application's, then Wicket's own. If no key is found, the error's own message is used, set with `new ValidationError(String)` or `setMessage(String)`. [Where Wicket looks for texts]({{ site.baseurl }}/docs/bundle-lookup.html) describes the search.

An error can carry several keys, added with `addKey(String)`; the first key that yields a text wins.

## Conversion errors

When a converter throws a `ConversionException`, the component reports an error with these keys, in this order:

1. the resource key set on the exception with `setResourceKey(String)`, if any;
2. `IConverter.<Type>`, for example `IConverter.Integer`;
3. `IConverter`.

The message has the variables `type` (the simple name of the target type), `exception`, `locale` if the exception has one, `format` for a `SimpleDateFormat`, and every variable set on the exception with `setVariable(String, Object)`.

## Converters

The `ConverterLocator` of the application has these converters. Number and date converters use the locale of the session.

| Type | Converter | Format |
|---|---|---|
| `boolean`, `Boolean` | `BooleanConverter` | `true`/`false`; also accepts `yes`, `on`, `y`, `1` and `no`, `off`, `n`, `0` |
| `byte`, `Byte` | `ByteConverter` | localized number |
| `char`, `Character` | `CharacterConverter` | one character |
| `double`, `Double` | `DoubleConverter` | localized number |
| `float`, `Float` | `FloatConverter` | localized number |
| `int`, `Integer` | `IntegerConverter` | localized number |
| `long`, `Long` | `LongConverter` | localized number |
| `short`, `Short` | `ShortConverter` | localized number |
| `BigDecimal` | `BigDecimalConverter` | localized number |
| `BigInteger` | `BigIntegerConverter` | localized number |
| `java.util.Date` | `DateConverter` | `DateFormat.SHORT` date of the locale |
| `java.sql.Date` | `SqlDateConverter` | localized date |
| `java.sql.Time` | `SqlTimeConverter` | localized time |
| `java.sql.Timestamp` | `SqlTimestampConverter` | localized date and time |
| `Calendar` | `CalendarConverter` | as `DateConverter` |
| `LocalDate` | `LocalDateConverter` | `FormatStyle.SHORT` date of the locale |
| `LocalDateTime` | `LocalDateTimeConverter` | `FormatStyle.MEDIUM` date and time of the locale |
| `LocalTime` | `LocalTimeConverter` | ISO time, such as `14:30:00` |
| `ZonedDateTime` | `ZonedDateTimeConverter` | `FormatStyle.MEDIUM` date and `FormatStyle.FULL` time of the locale |

`MaskConverter` in `org.apache.wicket.util.convert` is not registered by default. It converts with a `javax.swing.text.MaskFormatter` mask such as `(###) ###-####`; use it from `createConverter` on a component.

Choice components such as `DropDownChoice` do not use converters; their `IChoiceRenderer` maps option ids back to objects.

## Validation with Bean Validation

The wicket-bean-validation module adds `PropertyValidator`, which checks the Jakarta Bean Validation constraints of a bean property. Its messages are keyed by the constraint's message key, such as `jakarta.validation.constraints.NotNull.message`. See [Validate with Bean Validation]({{ site.baseurl }}/docs/bean-validation.html).
