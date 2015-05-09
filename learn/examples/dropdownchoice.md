---
layout: default
title: Using the DropDownChoice component
---

One of the most problematic components for beginners of Wicket is the
`DropDownChoice` component. In this example we will work the component to
give a little more insight into its workings. This example requires that you
have some understanding of the Wicket component model (nothing fancy though,
but you might want to read the other examples first), and the Model concept
used in Wicket (you can read more on models
[here](https://cwiki.apache.org/confluence/display/WICKET/Working+with+Wicket+models)).

## The example domain

The `DropDownChoice` component is typically used _inside_ a form. This
example will expand on that usage. The component is particularly designed to
work with objects. So let's say we have a list of people and we want to
select the manager of an employee.

{% highlight java %}
public class Person {
    private Long id;
    private String name;
    private Person managedBy;

    // ... insert getters and setters

    /**
     * Used to display the person.
     */
    public String toString() {
        return name;
    }

    /**
     * Gets the list of possible managers from the database.
     */
    public static List<Person> getManagers() {
        // gets the managers from the database
    }
}
{% endhighlight %}

## The assign manager page

Next we want to create a page where we assign a manager to an employee. This
is how the page would look like in HTML:

{% highlight html %}
<html>
<body>
<form wicket:id="form">
<h1>Assign manager</h1>
<table>
<tr>
    <th>Name</th>
    <td wicket:id="name">Some employee</td>
</tr>
<tr>
    <th>Managed by</th>
    <td><select wicket:id="managedBy">
        <option>Some Person</option>
        <option>Some Other Person</option>
        </select>
    </td>
</tr>
<tr><td colspan="2"><input type="submit" value="Save"/></td></tr>
</table>
</form>
</body>
</html>
{% endhighlight %}

This page has three components:

* a form (needed to process the input),
* a label (to show the name of the employee) and 
* a select box for picking the manager.

We will focus on the select box, because that will be our `DropDownChoice`.
The `<option>` tags are there for preview, our component will replace them
with the generated choices.

Let's see how the page looks like from the Java side:

{% highlight java %}
public class AssignManagerPage extends WebPage {
    public AssignManagerPage(Person employee) {
        Form form = new Form("form");
        add(form);
        form.add(new Label("name", new PropertyModel<String>(employee, "name")));

        DropDownChoice<Person> ddc = 
            new DropDownChoice<Person>("name", 
                    new PropertyModel<Person>(employee, "managedBy"),
                    new LoadableDetachableModel<List<Person>>() {
                        @Override
                        protected Object load() { 
                            return Person.getManagers();
                        }
                    }
                );
        form.add(ddc));
    }
}
{% endhighlight %}

In this example you see that we add the `DropDownChoice` to the form, and
provide it with 3 parameters. The first is the component identifier. The
second is the item that needs to be updated, in this case the `managedBy`
field of the `employee`. The third parameter is a `LoadableDetachableModel`
that retrieves the list of available choices.

Note that the `DropDownChoice` component has many constructors, and that you
need to read the JavaDoc documentation to pick the right one for you.

This generates (basically) the following markup when the list of managers is
Kyle Brovlovski, Stan Marsh, Eric Cartman, and Kenny McCormick:

{% highlight html %}
<tr>
    <th>Managed by</th>
    <td>
        <select wicket:id="managedBy" name="managedBy">
            <option selected="selected" value="">Choose one</option>
            <option value="0">Kyle Brovlovski</option>
            <option value="1">Stan Marsh</option>
            <option value="2">Eric Cartman</option>
            <option value="3">Kenny McCormick</option>
        </select>
    </td>
</tr>
{% endhighlight %}

As you can see from this markup is that Wicket added the items of the
managers list and numbered the values of the options. These are the indices
of the items in the list. If the order of the list can change between
requests, _or_ if the list itself can change, then please use an
`IChoiceRenderer`.

## Selecting a choice

Now if a user selects a value and submits the form, Wicket will assign the
manager to the employee (the `PropertyModel` takes care of that). The
following list shows what basically happens:

1. create new Employee, with `null` for its manager
2. create AssignManagerPage with the employee
3. render page, selected value is `"Choose one"`
4. user selects "Eric Cartman" and submits form
5. Wicket assigns manager "Eric Cartman" to `managedBy` field of the employee

So there is no need for getting or setting the value from the drop down
component: Wicket binds directly to your domain objects if you use the
correct models.

## Selecting a default choice

If you want to select a default value for the manager, then all you need to
do is assign the default manager to the employee and Wicket will take care of
the rest:

{% highlight java %}
// some add new employee code
Employee manager = Employee.get("Eric Cartman"); // gets a manager
Employee newEmployee = new Employee();
newEmployee.setManagedBy(manager);

setResponsePage(new AssignManagerPage(newEmployee));
{% endhighlight %}

## Summary

This concludes the (small) example of using a `DropDownChoice` component
correctly. The ideas behind Wicket are perfectly reflected in this component:
work with your domain objects, bind them to your components and get on with
the rest of your application.
