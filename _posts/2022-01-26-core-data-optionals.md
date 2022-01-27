---
layout: post
categories: [software-dev]
tags: [core-data, swift, ios, macos]
date: 2022-01-26T13:55:27-08:00
title: How to more gracefully handle non-optional Core Data properties in Swift
---

A recent [post from Tom Harrington](https://atomicbird.com/blog/clash-of-the-optionals/) explores the issues with optional and non-optional values in Core Data regarding how the framework interacts with Swift. It's a good overview. You should [read it](https://atomicbird.com/blog/clash-of-the-optionals/). The post shares some workarounds to improve the situation, but I want to share how I solve these issues in a more robust way.

<!--excerpt-->

To summarize the post, there is a distinction between the concept of optional and non-optional values in Swift and Core Data. In Swift, _the compiler_ enforces the presence or absence of a value, which gives you _compile-time guarantees_ about whether or not it is safe to expect a value. In Core Data, _the framework_ is responsible for this enforcement, which can only happen _at run-time_. In both cases, "optional" means you may not have a value and you should handle that potential absence accordingly. The difference between Swift and Core Data arises with "_not_ optional" values. In Swift, a non-optional property will never be `nil` after initialization. It may change if it is a `var`, but it will never become `nil`. The Swift compiler enforces this rule at compile-time. In Core Data, a non-optional property must not be `nil` when saving changes to your model but there is otherwise no enforcement of initialization. The Core Data framework enforces this rule at run-time with validation rules, namely [`validateForInsert()`](https://developer.apple.com/documentation/coredata/nsmanagedobject/1506683-validateforinsert) and [`validateForUpdate()`](https://developer.apple.com/documentation/coredata/nsmanagedobject/1506998-validateforupdate). If validation fails, you'll get an error --- or worse, crash.

Even if you mark properties as non-optional in your Core Data model, Xcode will generate your Swift `NSManagedObject` subclass with _optional_ properties. You can change them to non-optional and everything still works --- at least, so it seems. You can omit a proper Swift designated initializer and you can call the default `init()` without _actually_ initializing any of the properties. As [Tom notes](https://atomicbird.com/blog/clash-of-the-optionals/), this is because the special `@NSManaged` attribute informs the compiler that these property values will be provided by Core Data at run-time, and thus, Swift's strict initialization rules no longer apply. Only you, the programmer, can ensure everything gets initialized correctly --- or else, you'll crash.

{% include break.html %}

We do not want to give up and simply make every Core Data property optional. That places a massive burden on the rest of our codebase. So, the question is, how can we safely (or, as safely as we can) implement non-optional properties for `NSManagedObject` subclasses? The Swift compiler cannot help us with enforcement here, so we need to ensure we _always_ assign a value to non-optional properties in our code when initializing managed objects.

#### Provide default values in the model editor?

In the [model editor](https://developer.apple.com/documentation/coredata/creating_a_core_data_model), you can define default values for non-optional properties. This will work for simple cases, but there is often _not_ a good default for many values, especially if we are asking the user for the data. Even for a property like a timestamp, the model editor is insufficient. You can provide a specific default `Date` value, but if your object has a `dateCreated` property, then what you actually want is to initialize that property to [`Date.now`](https://developer.apple.com/documentation/foundation/date/3766590-now), which is not possible in the editor. Tom [suggests](https://atomicbird.com/blog/clash-of-the-optionals/) that we implement [`awakeFromInsert()`](https://developer.apple.com/documentation/coredata/nsmanagedobject/1506548-awakefrominsert) to accommodate scenarios like this. That approach works, but we can do better.

### Handling non-optional Core Data properties the right way

If we cannot provide default values for our non-optional properties, or if the model editor is insufficient for our needs, we can implement the following series of steps to workaround the shortcomings of using Core Data in Swift and make our model as robust as possible.

#### 1. Provide a single, designated initializer

Suppose we have an `Item` class where _all_ properties are non-optional. Some have default values, but others need input from the user. We can define our class like the so:

```swift
public final class Item: NSManagedObject {
    @NSManaged public private(set) var itemId: String
    @NSManaged public private(set) var dateCreated: Date
    @NSManaged public var name: String
    @NSManaged public var unitCost: NSDecimalNumber
    @NSManaged public var unitPrice: NSDecimalNumber
    @NSManaged public var stockCount: Int
}
```

Note:

1. The Swift compiler does not produce any initialization errors. It will if you remove `@NSManaged`.
1. Using `@NSManaged` requires a property to be a `var`. However, `itemId` and `dateCreated` should never change once we initialize and save an `Item`. It would be nice to mark them as `let`, but we can't. Instead, we can mark the setters as `private` to enforce this throughout the rest of our application code.
1. The Swift compiler will prevent us from setting any of these properties to `nil` --- that enforcement still works.

Now we can write a designated initializer that provides default values where possible.

```swift
public final class Item: NSManagedObject {
    // properties defined above

    public init(context: NSManagedObjectContext,
                itemId: String = UUID().uuidString,
                dateCreated: Date = Date.now,
                name: String,
                unitCost: NSDecimalNumber,
                unitPrice: NSDecimalNumber,
                stockCount: Int = 0) {
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)!
        super.init(entity: entity, insertInto: context)
        self.itemId = itemId
        self.dateCreated = dateCreated
        self.name = name
        self.unitCost = unitCost
        self.unitPrice = unitPrice
        self.stockCount = stockCount
    }

    @objc
    override private init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}
```

Note:

1. We must call the `super` implementation of [`init(entity:insertInto:)`](https://developer.apple.com/documentation/coredata/nsmanagedobject/1506357-init), which is the designated initializer for `NSManagedObject`.
2. We must override `init(entity:insertInto:)` to comply with Core Data's expectations, even though we are not using it directly. Otherwise, the framework will crash at run-time with the error: `Fatal error: Use of unimplemented initializer 'init(entity:insertInto:)' for class 'Item'`. This is because of all the Objective-C runtime manipulation that Core Data does under-the-hood. We mark it as `private` to prevent callers from using it.
3. We could omit initializing all of the properties here, and the compiler would not give us an error. Again, thanks to `@NSManaged`. However, we would crash at run-time. (We'll address this below.)

#### 2. Prevent invalid initializers from being called

At this point, we are almost finished. The next problem is that we can _still_ call two invalid initializers from elsewhere in our code.

1. The default `init()` inherited from `NSObject`
2. The convenience initializer [`init(context:)`](https://developer.apple.com/documentation/coredata/nsmanagedobject/1640602-init) inherited from `NSManagedObject`

Again, this is because Swift's initialization rules do not apply here thanks to `@NSManaged`. Simply remembering or telling our team to use only a specific initializer is prone to error. Luckily, we can prevent them from being called by marking them as unavailable. This will not only produce a compiler error if used, but it will also prevent them from appearing in Xcode's auto-complete.

```swift
public final class Item: NSManagedObject {
    // properties and designated init above

    @available(*, unavailable)
    public init() {
        fatalError("\(#function) not implemented")
    }

    @available(*, unavailable)
    public convenience init(context: NSManagedObjectContext) {
        fatalError("\(#function) not implemented")
    }
}
```

Now if you try to write `Item()` or `Item(context: moc)`, the compiler will produce an error that the initializer is unavailable.

#### 3. Write unit tests to help prevent future mistakes

The final step is to write unit tests to further validate all of our assumptions. Hopefully, you already have tests that round-trip your models through Core Data. If not, write those tests now!

Your managed object tests should:

1. Create your model and verify all properties manually.
1. Save your model and verify that the save succeeds.
1. If `NSManagedObjectContext.save()` throws an error, your test should fail.
1. Fetch your model after saving and verify its properties.
1. Fetch and modify your model's properties, save, then verify again.

With sufficient test coverage for each model in Core Data, we can be confident that we will catch most errors that might result from modifying our models later on. For example, if we forget to initialize a property during `init` (as mentioned above), validation will fail when saving, thus our tests will fail. Or, suppose we add a new non-optional property and correctly mark it as non-optional in the Core Data model editor but forget to add it to our designated initializer, our code will compile, but --- again --- validation will fail when saving, thus our tests will fail.

Now we have most of the usual protections in place --- however, there are some caveats.

#### 4. Caveats and Warnings

As mentioned, there's a lot of manual work here to enforce the rules that Swift usually enforces for us. When you modify your models in the Xcode editor and in code, you need to be sure their properties match in type and optionality, that you update the designated initializer correctly, and that you update your tests. This requires a lot of diligence, which can be especially difficult when working on a large team. Having complete unit test coverage is absolutely essential in this scenario, which also requires due diligence to maintain.

Also beware of bridging issues with Objective-C and Swift. In Objective-C, you can use the `NS_UNAVAILABLE` macro to mark initializers as unavailable like we did above for Swift. Further, you can utilize Objective-C's [nullablity annotations](https://developer.apple.com/documentation/swift/objective-c_and_c_code_customization/designating_nullability_in_objective-c_apis) to improve inter-op with Swift.

Finally, there is a risk of running into issues with [faulting](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/FaultingandUniquing.html). In my experience, this is mostly theoretical and does not present an issue in practice. However, it is something to take note of.

The [Core Data Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/FaultingandUniquing.html):

> Managed objects typically represent data held in a persistent store. In some situations a managed object may be a fault --- an object whose property values have not yet been loaded from the external data store. Faulting reduces the amount of memory your application consumes. A fault is a placeholder object that represents a managed object that has not yet been fully realized or a collection object that represents a relationship.
>
> [...]
>
> When a fault is fired, Core Data does not go back to the store if the data is available in its cache. With a cache hit, converting a fault into a realized managed object is very fast --- it is basically the same as normal instantiation of a managed object. If the data is not available in the cache, Core Data automatically executes a fetch for the fault object; this results in a round trip to the persistent store to fetch the data, and again the data is cached in memory.
>
> Whether or not an object is a fault simply means whether or not a given managed object has all its persistent attributes populated and is ready to use. If you need to determine whether an object is a fault, call its `isFault` method without firing the fault (without accessing any relationships or attributes).

I _think_ this means that it could be possible to fetch objects whose non-optional properties are _not_ initialized when fetched, which could crash when accessed from Swift. `NSFetchRequest` has a property to control this, [`includesPropertyValues`](https://developer.apple.com/documentation/coredata/nsfetchrequest/1506387-includespropertyvalues), which defaults to `true`. The [documentation](https://developer.apple.com/documentation/coredata/nsfetchrequest/1506387-includespropertyvalues) explains:

> A Boolean value that indicates whether, when the fetch is executed, property data is obtained from the persistent store. [...]
>
> You can set `includesPropertyValues` to `false` to avoid creating objects to represent property values and thereby reduce memory overhead. You typically should only do so, however, if you are sure that you will not need the actual property data [...]
>
> During a normal fetch (`includesPropertyValues` is `true`), Core Data fetches the object ID and property data for the matching records, fills the row cache with the information, and returns managed objects as faults (see `returnsObjectsAsFaults`). Although these faults are managed objects, all of their property data still resides in the row cache until the fault is fired. When the fault is fired, Core Data retrieves the data from the row cache --- there is no need to go back to the database.
>
> If `includesPropertyValues` is `false`, then Core Data fetches only the object ID information for the matching records --- it does not populate the row cache.

Under default behavior, Core Data will fetch all properties in your model. For a one-to-one relationship, the other model's properties will be cached and the fault will fire immediately when accessing that managed object. For one-to-many relationships, represented by collections, there is less of a worry, since an empty collection is not a crash risk. In other words, you _should_ be fine with regard to faulting, but you should double-check your fetch requests. Again, I have not experienced problems with this in practice, and unit tests should help find and prevent problems.

I hope this helps you improve your Core Data models!
