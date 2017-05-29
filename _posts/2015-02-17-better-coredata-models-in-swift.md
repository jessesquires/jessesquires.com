---
layout: post
title: Better Core Data models in Swift
subtitle: How Swift can bring clarity and safety to your managed objects
redirect_from: /better-coredata-models-in-swift/
---

As I continue my work with [Core Data](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/cdProgrammingGuide.html) and [Swift](http://www.apple.com/swift/), I have been trying to find ways to make Core Data **better**. Among my goals are clarity and safety, specifically regarding types. Luckily, we can harness Swift's optionals, enums, and other features to make managed objects more robust and more clear. But even with the improvements that Swift brings, there are still some drawbacks and limitations with Xcode's current toolset.

<!--excerpt-->

### A great case for optionals

There's been plenty of [feedback](http://owensd.io/2014/10/18/optionals-beware.html) in the community about [optionals](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-ID330) and how they are often [cumbersome](http://natashatherobot.com/unit-testing-optionals-in-swift-xctassertnotnil/) to use. However, this relatively simple construct brings a welcoming clarity to managed objects when working with Core Data. When defining entities in Core Data, it is possible to set some basic validation rules for an entity's attributes in the Data Model Inspector.

<img class="img-thumbnail img-responsive center" src="{{ site.img_url }}/coredata_inspector.jpg" title="Core Data Model Inspector" alt="Core Data Model Inspector"/>
<small class="text-muted center">Data Model Inspector for Core Data managed objects.</small>

You can define minimum and maximum values, provide default values, mark attributes as optional, and more. This is nothing new. But in Objective-C, the optionality of a property on a managed object could only be discovered by opening the `.xcdatamodeld` file in Xcode, then selecting the entity, then selecting the attribute, and then opening the Data Model Inspector in the sidebar. Or, at runtime you find out that your `NSManagedObjectContext` fails to save because of `Cocoa error 1570`. Neither of these experiences are enjoyable.

For example, imagine we have the following `Employee` class. What fields are required for a save to succeed?

{% highlight objc %}

@interface Employee : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSDate * dateOfBirth;
@property (nonatomic, retain) NSString * email;

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * middleName;

@property (nonatomic, retain) NSDecimalNumber * salary;
@property (nonatomic, retain) NSNumber * status;

@end

{% endhighlight %}

By contrast, when using Swift we immediately know what properties are optional simply by looking at the code.

{% highlight swift %}

class Employee: NSManagedObject {

    @NSManaged var address: String?
    @NSManaged var dateOfBirth: NSDate
    @NSManaged var email: String?

    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var middleName: String?

    @NSManaged var salary: NSDecimalNumber
    @NSManaged var status: Int32
}

{% endhighlight %}

<span class="text-muted"><strong>Note:</strong> Xcode does not generate Swift classes accurately when they have optional attributes. You must manually add the `?` for optional values. Further, though <em>The Swift Programming Language</em> guide <a href="https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-ID317">recommends</a> using `Int` for all integer variables, Core Data recommends using specific integer sizes and complains if you attempt to do otherwise, thus the use of `Int32` for the `status` property.</span>

This seems like a minor detail, but it's a huge win &mdash; especially when you begin to work with your models throughout the rest of your app. As with optionals in general, you will need to explicitly handle `nil` (which I think is a positive side effect). But even with the [*pyramid of doom*](http://www.scottlogic.com/blog/2014/12/08/swift-optional-pyramids-of-doom.html) behind us, this may not be pleasant if you have a lot of optionals. If this is the case, hopefully it will encourage you to *reconsider your design*. Is this field *really* necessary? Could this property be derived from other data? Should this property be *required* instead? These are questions one should always be asking when designing model classes, but perhaps the leniency of Objective-C allowed them to be dismissed before. **Optionals complicate your model**, which is a great motivation to use as few as possible and keep things simple.

Given this, let's review our `Employee` class. Is `middleName` important? No, let's remove it. Suppose that we know that all employees have an email address with the form: `<firstName><LastName>@<companyName>.com`. Do we really need to store it? No, we can write a function or computed property to generate that. Finally, let's assume that employees should be required to have an `address`. Ahh, this is looking much better now.

{% highlight swift %}

class Employee: NSManagedObject {

    @NSManaged var address: String
    @NSManaged var dateOfBirth: NSDate

    @NSManaged var firstName: String
    @NSManaged var lastName: String

    @NSManaged var salary: NSDecimalNumber
    @NSManaged var status: Int32
}

{% endhighlight %}

### Taking advantage of `typealias`

Another Swift feature we can use is a [type alias declaration](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Declarations.html#//apple_ref/doc/uid/TP40014097-CH34-ID361), which allows a new name to refer to an existing type. For an `Employee`, it could be very helpful to work with a `Salary` type instead of an `NSDecimalNumber` type. In the depths of the codebase, there may be operations on `NSDecimalNumber` values where it is not clear what those values represent. A `typealias` makes our model much more descriptive and allows us to operate on values of a much more expressive `Salary` type.

{% highlight swift %}

class Employee: NSManagedObject {
    // other properties...

    typealias Salary = NSDecimalNumber

    @NSManaged var salary: Salary
}

{% endhighlight %}

We can then write functions that receive and return an `Employee.Salary` type. Such functions can retain their brevity, while maximizing their clarity.

{% highlight swift %}

func computeRaise(salary: Employee.Salary) -> Employee.Salary

{% endhighlight %}

As noted in [objc.io](http://www.objc.io), *we can take this one step further* by using a [wrapper type](http://www.objc.io/snippets/8.html). To do this with an `NSManagedObject` subclass, we'll need to do some wrapping and unwrapping (no pun intended). First, the original property in Core Data should be marked as `private`. Then we can use a computed property for the new wrapper type that transforms the private property value to and from the wrapper value. This is a bit of work, but the clarity and safety we receive in return are well worth it.

{% highlight swift %}

struct Salary {
    let amount: NSDecimalNumber
}

class Employee: NSManagedObject {
    // other properties...

    @NSManaged private var salaryAmount: NSDecimalNumber

    var salary: Salary {
        get {
            return Salary(amount: self.salaryAmount)
        }
        set {
            self.salaryAmount = newValue.amount
        }
    }
}

// Usage
employee.salary = Salary(amount:10000.0)

{% endhighlight %}

Unfortunately, for fetch requests you still need to use the underlying private property name, `salaryAmount`. This is because Core Data doesn't know about the `salary` computed property, nor the `Salary` type. However, I think the naming conventions used here minimize confusion. That is, `salary.amount` corresponds to the private `salaryAmount`.

### Using Swift enumerations

It is not uncommon for a model object to encode some type of state as an `enum`. With Objective-C, you could define an `NS_ENUM` and store an integer property in your managed object. But an `enum` in Objective-C is little more than a glorified integer. By adopting an approach similar to the wrapper type above, we can get all the power of a Swift `enum` directly in our managed object. This is incredibly useful.

Let's see what this would look like for the `status` property in the `Employee` class.

{% highlight swift %}

enum EmployeeStatus: Int32 {
    case ReadyForHire, Hired, Retired, Resigned, Fired, Deceased
}

class Employee: NSManagedObject {
    // other properties...

    @NSManaged private var statusValue: Int32

    var status: EmployeeStatus {
        get {
            return EmployeeStatus(rawValue: self.statusValue)!
        }
        set {
            self.statusValue = newValue.rawValue
        }
    }
}

// Usage
employee.status = .Hired

{% endhighlight %}

<span class="text-muted"><strong>Note:</strong> Just as in the previous example, for fetch requests you would still need to use the private property name, `statusValue`.</span>

Furthermore, this is not limited to integers. You can apply this strategy with an enumeration of **any** type that Core Data supports. For example, for an `Employee` there could be fixed salary amounts that correspond to an employee's role. With slightly more effort, you can even support an enumeration with [associated values](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Enumerations.html#//apple_ref/doc/uid/TP40014097-CH12-ID148). I'll leave that as an exercise for the reader.

### Clarity, or something slightly less terrible

Swift has a lot of potential to improve Core Data, but it does require more effort for developers and has some inconvenient workarounds and shortcomings. While I think it's worth the time, the wrapping and unwrapping of values described above can be tedious to implement. And having to use the underlying private property names for fetch requests feels dirty. On the bright side, we get optionals and type aliases for free &mdash; a great step forward.

In any case, I do think this is better than what we had before. Sometimes it seems like Swift is bringing out the worst in Cocoa and Objective-C. Here's to hoping the toolset will improve &mdash; and when Cocoa finally [dies](http://nshipster.com/the-death-of-cocoa/), I'll be cheering for a Swift re-implementation of Core Data.
