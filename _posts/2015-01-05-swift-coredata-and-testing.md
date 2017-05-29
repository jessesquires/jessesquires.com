---
layout: post
title: Swift, Core Data, and unit testing
subtitle: Working around Swift's constraints to unit test models
redirect_from: /swift-coredata-and-testing/
---

[Core Data](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/cdProgrammingGuide.html) is probably loved as much as it is shunned by iOS developers. It is a framework of great power that often comes with great frustration. But it remains a popular tool among developers despite its pitfalls &mdash; likely because Apple continues to [invest](https://developer.apple.com/videos/wwdc/2014/?id=225) in it and encourages its adoption, as well as the availability of the [many](http://nshipster.com/core-data-libraries-and-utilities/) open-source [libraries](https://github.com/rosettastone/RSTCoreDataKit) that make Core Data easier to use. Consider unit testing, and Core Data gets a bit more cumbersome. Luckily, there are [established techniques](https://github.com/rosettastone/RSTCoreDataKit#unit-testing) to facilitate testing your models. Add [Swift](http://www.apple.com/swift/) to this equation, and the learning curve gets slightly steeper.

<!--excerpt-->

### Prefix managed object subclasses

Because Swift classes are namespaced, you must prefix the class name with the name of the module in which it is compiled. You can do this by opening your `.xcdatamodeld` file in Xcode, selecting an entity, and opening the model entity inspector.

<img class="img-thumbnail img-responsive center" src="{{ site.img_url }}/coredata_namespace.png" title="Core Data namespace" alt="Core Data namespace"/>
<small class="text-muted center">Using Swift namespaces with Core Data. Image taken from <a href="https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/WritingSwiftClassesWithObjective-CBehavior.html#//apple_ref/doc/uid/TP40014216-CH5-XID_56">Using Swift with Cocoa and Objective-C</a>.</small>

This is certainly easy to forget, and if you do, you'll see this error:

```
CoreData: warning: Unable to load class named 'Person' for entity 'Person'.
Class not found, using default NSManagedObject instead.
```

Not very helpful, is it? When I first saw this, it took me a few puzzling minutes to realize that I had forgotten to prefix my class names. And there's another catch. You must add the module name prefix **after** you generate the classes, otherwise Xcode will not create the classes properly (or at all). This is a bug.

### Implementing common managed object extensions

Most of the existing Objective-C Core Data libraries that you'll find implement the following helper methods in some way, if not verbatim. These methods mitigate the awkwardness of inserting new objects into Core Data and avoid [*stringly-typed* Objective-C](http://corner.squareup.com/2014/02/objc-codegenutils.html).

{% highlight swift %}

@implementation NSManagedObject (Helpers)

+ (NSString *)entityName
{
    return NSStringFromClass([self class]);
}

+ (instancetype)insertNewObjectInContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                         inManagedObjectContext:context];
}

@end

{% endhighlight %}

I have decided to use Swift for one of my side projects, and in designing the model layer of the app my first thought was to rewrite these methods in Swift. Let's see what that would look like.

{% highlight swift %}

extension NSManagedObject {

    class public func entityName() -> String {
        let fullClassName: String = NSStringFromClass(object_getClass(self))
        let classNameComponents: [String] = split(fullClassName) { $0 == "." }
        return last(classNameComponents)!
    }

    class public func insertNewObjectInContext(context: NSManagedObjectContext) -> AnyObject {
        return NSEntityDescription.insertNewObjectForEntityForName(entityName(), inManagedObjectContext: context)
    }

}

{% endhighlight %}

Hm. The `entityName()` function just became much less elegant. Remember, we have to prefix our Swift classes for Core Data which means their fully qualified names take the form `<ModuleName>.<ClassName>`. This means we must parse out the *entity name* which is the class name only. This seems fragile and probably isn't a good idea. Additionally, we have to use the `object_getClass()` function from the [Objective-C runtime library](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ObjCRuntimeRef/index.html), which feels dirty &mdash; *even in Objective-C*. I've always avoided using such [runtime](http://nshipster.com/associated-objects/) [voodoo](http://nshipster.com/method-swizzling/) as much as possible, opting for actual design patterns instead. Even `NSStringFromClass()` feels *wrong* in Swift. And generally speaking, *what do we gain by simply rewriting our __old__ Objective-C code*? **Not much.**

Despite these issues, I decided to let it be for the moment so that I could continue working and give some thought to a *swifter* design. I continued building out my model classes, standing up my core data stack, and writing unit tests. Much to my surprise, using the extension functions above crashed when running my unit tests. I ran the same code from the Application Target and everything was fine. After more investigation, I realized that I had just found a Swift compiler [bug](http://openradar.appspot.com/19368054). You can find an [example project](https://github.com/jessesquires/rdar-19368054) on GitHub that exhibits the bug. The issue is that the following function incorrectly returns `nil` in a project's Test Target.

{% highlight swift %}

class func insertNewObjectForEntityForName(_ entityName: String,
                    inManagedObjectContext context: NSManagedObjectContext) -> AnyObject

//  Example
//  Returns valid Person object in App Target
//  Returns nil in Test Target
let person = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: context) as? Person

{% endhighlight %}

So much for revisiting these functions later. I could continue using them in the Application Target, but I would still need to find a fix for initializing managed objects in the Test Target. This isn't ideal. I would rather have a single solution that works in both targets. Back to the drawing board.

### Rethinking and redesigning

Let's reiterate what we are trying to achieve. We want:

1. To find a convenient way to initialize managed objects by encapsulating the use of `NSEntityDescription`
* To workaround the bug in `NSEntityDescription.insertNewObjectForEntityForName(_, inManagedObjectContext:)`
* To avoid having to pass literal entity names, like `"Person"`, to the initializer
* To avoid the issues mentioned above (using `object_getClass()` and `NSStringFromClass()`)
* To conform to Swift paradigms and utilize Swift features

The solution that meets all the criteria above is a convenience initializer:

{% highlight swift %}

class Person: NSManagedObject {

    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entityForName("Person", inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }

}

{% endhighlight %}

This is very similar to the original class factory function in the extension. It receives a context and returns a managed object. Regarding (2), it is very clear how this addresses the problematic `NSEntityDescription` class function. In Swift, an initializer is guaranteed to return a non-nil, typed instance, whereas `insertNewObjectForEntityForName(_, inManagedObjectContext:)` returns `AnyObject`. We avoid having to cast the return value altogether.

As you've probably noticed, the entity name (`"Person"`) is hard-coded. And you are correct in concluding that this solution doesn't generalize. That is, **all** of your managed object subclasses would need to implement this convenience initializer and provide their own value for the entity name. You might consider tweaking this by moving the convenience initializer to a new extension and replacing the hard-coded string with an `entityName()` function that classes must override. Unfortunately, this [will not work](https://github.com/jessesquires/rdar-19368054#swift-extensions-will-not-work) due to Swift's [initializer delegation and two-phase initialization](https://developer.apple.com/library/mac/documentation/Swift/Conceptual/Swift_Programming_Language/Initialization.html#//apple_ref/doc/uid/TP40014097-CH18-XID_324) enforcements.

In the end, I think adding these 3 lines of code to each of your managed object subclasses is a worthwhile exchange for type-safety and a more pure, *more swift* design. Perhaps this could eventually be automated via [mogenerator](https://github.com/rentzsch/mogenerator) or a similar tool. Cocoa [may be dying](http://nshipster.com/the-death-of-cocoa/), but it certainly **isn't dead yet**. As we face these kinds of challenges with Swift, it is important to remember that the *Objective-C way* is not always the *Swift way*.

----------------------------------------

<span class="text-muted"><strong>There's one more thing.</strong> In trying to find ways around the `NSEntityDescription` bug, I found an odd way to get the aforementioned extension functions to work in the Test Target. We know that unit testing in Swift is [tricky](http://natashatherobot.com/swift-unit-testing-tips-and-tricks/) because of its [access control](https://developer.apple.com/library/mac/documentation/Swift/Conceptual/Swift_Programming_Language/AccessControl.html#//apple_ref/doc/uid/TP40014097-CH41-XID_29) implementation. The files in your Application Target aren't available to your Test Target because these are two different modules. The usual strategy is to add your files to both targets. If you do not do this, but instead make your managed object subclasses `public` and import them to your Test Target (`import <AppTargetName>`), then casting from `NSEntityDescription.insertNewObjectForEntityForName(_, inManagedObjectContext:)` succeeds.</span>
