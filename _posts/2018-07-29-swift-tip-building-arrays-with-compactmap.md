---
layout: post
title: ! 'Swift tip: Building arrays with compactMap'
---

A common scenario in app development is to build up a list of objects, perhaps to display to the user or for another purpose. Maybe you're fetching data from a database to display, or constructing fields to display for an interface. Consider the iOS Calendar app, for example. When you add a new calendar event, the form displays all the fields you can fill-in &mdash; title, location, date and time, notes, etc. However, when viewing an existing event all you see are the completed fields while the uncompleted fields are hidden.

<!--excerpt-->

I was writing code for a similar scenario recently. In [PlanGrid](http://plangrid.com), we use [a library](https://github.com/plangrid/reactivelists) to declaratively build our user interfaces for tables and collections. You generate a list of view models from which the table or collection is constructed. For the calendar app, this might look like the following.

{% highlight swift %}
protocol ViewModelProtocol { /* ... */ }

func generateTitleViewModel() -> ViewModelProtocol { /* ... */ }

func generateStartDateViewModel() -> ViewModelProtocol { /* ... */ }

func generateEndDateViewModel() -> ViewModelProtocol { /* ... */ }

func allViewModels() -> [ViewModelProtocol] {
    return [
        generateTitleViewModel(),
        generateStartDateViewModel(),
        generateEndDateViewModel(),
        // ...
    ]
}
{% endhighlight %}

But what if some table cells are optional? For example, depending on the state of the Calendar app's "Event" view &mdash; whether or not you are creating a new event and viewing an existing one &mdash; you will optionally hide certain cells.

You may write something like this:

{% highlight swift %}
func generateLocationViewModel() -> ViewModelProtocol? { /* ... */ }

func generateAlertViewModel() -> ViewModelProtocol? { /* ... */ }

func generateNotesViewModel() -> ViewModelProtocol? { /* ... */ }

// Return type has to be an array of optionals
func allViewModels() -> [ViewModelProtocol?] {
    return [
        generateTitleViewModel(),
        generateStartDateViewModel(),
        generateEndDateViewModel(),
        generateLocationViewModel(),
        generateAlertViewModel(),
        generateNotesViewModel(),
        // ...
    ]
}
{% endhighlight %}

That's not optimal, because the resulting array is an array of optionals. We don't want that, because it introduces complexity deeper in our object graph. For example, `viewModels.count` would no longer be appropriate to use to compute the number of rows in the table. It's better to keep optionals as far to the edge of our object graph as possible. You might be inclined avoid this by checking for `nil` before appending to the array.

{% highlight swift %}
func allViewModels() -> [ViewModelProtocol] {
    var viewModels = [generateTitleViewModel()]

    if let locationModel = generateLocationViewModel() {
        viewModels.append(locationModel)
    }

    viewModels.append(generateStartDateViewModel())
    viewModels.append(generateEndDateViewModel())

    if let alertModel = generateAlertViewModel() {
        viewModels.append(alertModel)
    }

    if let notesModel = generateNotesViewModel() {
        viewModels.append(notesModel)
    }

    return viewModels
}
{% endhighlight %}

This is an improvement. We've removed the optionals. It works, but it has a few problems. It's very stateful and imperative. It's not very simple. You have to manage and mutate a variable array. Adding new fields or changing the optionality of existing ones makes this code difficult to maintain, and prone to error. Instead, we can declare a single array and use `compactMap()` to remove the optionals.

{% highlight swift %}
func allViewModels() -> [ViewModelProtocol] {
    return [
        generateTitleViewModel(),
        generateLocationViewModel(),
        generateStartDateViewModel(),
        generateEndDateViewModel(),
        generateAlertViewModel(),
        generateNotesViewModel(),
        ].compactMap { $0 }
}
{% endhighlight %}

This gives us a concise, declarative description of our models, in order. If any of the functions return a `nil` model, it will be removed via `compactMap()`. I find this much more elegant, readable, and easier to maintain. We've reduced all the previous code to a single statement, as well as reduced the cognitive overhead of understanding it. It's clear what the order of fields should be, there are no more `if-let` bindings, and you can change any of these functions to return optionals or non-optionals and this code never has to change.

Next time you find yourself writing code like the previous example, consider if you can use `compactMap()` to simplify it.
