---
title: How a form is processed
type: explanation
topic: forms
summary: The order in which Wicket checks, converts, validates and stores submitted input, and why a form updates all its models or none.
since: 10
apis: [Form, FormComponent, IFormSubmitter, IFormValidator, IConverter, IValidator]
keywords: [form submission, onSubmit, onError, model update, validation order, conversion, raw input, process]
order: 10
source: [forms2/forms2_1.adoc]
---

A browser submits a form as a set of strings, one per field. Your code wants typed values in its models: a `LocalDate` in the order, an `Integer` in the quantity. Between the two, Wicket runs every field through the same stages in a fixed order, and it only touches your models when every field has passed.

## The stages of a form submit

When the request arrives, the `Form` first finds out what submitted it. That is a submitting component such as a `Button` or `SubmitLink` (an `IFormSubmitter`), or nothing when the user pressed Enter or clicked a plain `<input type="submit">` without a `wicket:id`. The submitter decides which form is processed, which matters for [nested forms]({{ site.baseurl }}/docs/nest-forms.html). Then the form is processed in four stages.

1. **Validation.** Every visible and enabled form component goes through three checks, in this order:
   - *Required.* If the component is required and the user left it empty, it gets the `Required` error and the other checks are skipped.
   - *Conversion.* The component converts its input string to the type of its model, usually through an `IConverter`. If that fails, it gets a conversion error and its validators are skipped.
   - *Validators.* The component's validators run on the converted value, in the order you added them, until one reports an error. Validators do not run when the value is `null`, unless they implement `INullAcceptingValidator`.

   After the components, the form runs its form validators (`IFormValidator`), which compare several fields, and then calls its own `onValidate()`. A form validator only runs when all the components it depends on passed their own checks.
2. **Decision.** If any component or validator reported an error, processing stops here. The submitter's `onError()` is called, then `onError()` of each form that has errors. No model is changed.
3. **Model update.** If nothing failed, every component writes its converted value to its model. After that the form calls `onValidateModelObjects()`, a late check that can look at the updated model objects. An error there still leads to `onError()`.
4. **Submit.** The submitter's `onSubmit()` runs, then `onSubmit()` of each processed form, then the submitter's `onAfterSubmit()`.

Nested forms are visited innermost first, both when validating and when calling `onSubmit()` and `onError()`. Inside a form, children are visited before their parents. That is why a [`FormComponentPanel`]({{ site.baseurl }}/docs/form-component-panel.html) can read the converted input of its inner fields in its own `convertInput()`: they have already been converted.

{% if site.wicket.version_11 %}
> Since Wicket 11, text fields render the HTML attributes `required` and `pattern` when they are required or have a `PatternValidator`. The browser then checks these before it sends the request. Wicket still runs every stage on the server, because a request does not have to come from your page.
{: .since}
{% endif %}

## Why a form updates all models or none

Wicket could store each valid field as soon as it passed its checks. It does not, for two reasons.

The first is your data. Form components are often bound to a live object: a `PropertyModel` on an entity, or a `CompoundPropertyModel` on the bean the form edits. If the start date of a booking is valid and the end date is not, storing only the start date leaves the booking in a state that neither the user nor your code asked for. If that object is shared, or flushed to a database at the end of the request, the half-edited state escapes. By holding back every update until the whole form is valid, Wicket keeps your objects as they were before the submit, or as the user wants them after.

The second is the user's input. When a field fails, the form is rendered again with the error. The user expects to see what they typed, including the mistake, not the old model value. Wicket keeps the raw input of every component until the form is valid. A component that has raw input renders that instead of its model value. When the form succeeds, the raw input is cleared and the components render their models again.

This has consequences for your code:

- In `onError()`, the models still hold the old values. To see what the user typed, call `getInput()` on the component, or `getConvertedInput()` if conversion succeeded.
- In `onSubmit()`, every model holds its new value. That is the place to save, call services and navigate.
- A validator never sees a half-converted form. It gets one typed value; a form validator gets the converted input of the components it depends on.

## Conversion before validation

Validators run after conversion so that they can work with your types. A `RangeValidator<Integer>` compares integers, a `RangeValidator<LocalDate>` compares dates. If conversion came after validation, every validator would have to parse the string itself, and each would do it slightly differently.

The type comes from the component: set it with `setType()`, or let the component take it from a model that knows its object class, such as `PropertyModel`. Without a type, the input stays a `String`. [Convert input to your types]({{ site.baseurl }}/docs/convert-input.html) shows how to plug in your own converter.

## The exception: late validation

`onValidateModelObjects()` runs after the models are updated, so it breaks the all-or-nothing rule on purpose. It exists for checks that need the complete object, such as class-level constraints in [Bean Validation]({{ site.baseurl }}/docs/bean-validation.html). If such a check fails, the model objects already contain the new values. Your `onError()` should then discard or reload them, for example by not saving and detaching a loadable model.

## Skipping the stages

Sometimes a submit should not validate anything. A "Cancel" button has to work even when required fields are empty. Call `setDefaultFormProcessing(false)` on the submitting component, and Wicket skips all four stages: it only calls the submitter's `onSubmit()` and `onAfterSubmit()`. The user's input is neither checked nor stored. See [Use more than one submit button]({{ site.baseurl }}/docs/submit-buttons.html).

Ajax narrows the stages instead of skipping them. An `AjaxFormComponentUpdatingBehavior` runs required check, conversion, validators and model update for the one component it is attached to, without touching the rest of the form. That lets you store a field as the user leaves it, at the price of the all-or-nothing guarantee for that field. See [Ajax behaviors]({{ site.baseurl }}/docs/ajax-behaviors.html).

## Where the messages come from

Every error in the stages above becomes a feedback message on the component that failed. The text is looked up in resource bundles by a key: `Required` for the required check, `IConverter` for a failed conversion, and the validator's class name for a validator. Wicket fills in variables such as `${label}` and `${input}`. [Validate input and show errors]({{ site.baseurl }}/docs/validate-input.html) shows how to display these messages and replace their text; [Validators and converters]({{ site.baseurl }}/docs/validators.html) lists the keys.
