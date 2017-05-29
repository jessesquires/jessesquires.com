---
layout: post
title: Swift failable initializers
subtitle: When failable becomes fallible, and how to avoid it
redirect_from: /swift-failable-initializers/
---

Swift is still young and ever-changing. With each release, we have seen dozens of tweaks, additions, and deletions. And there is no reason for us to think that this rapid evolution will decline anytime soon. To remind us of exactly that, the latest [post](https://developer.apple.com/swift/blog/?id=17) on Apple's [Swift Developer Blog](https://developer.apple.com/swift/) introduces a new feature in Swift 1.1 in [Xcode 6.1](https://developer.apple.com/xcode/downloads/) &mdash; *failable initializers*.

<!--excerpt-->

#### Failable initializers

The idea is simple &mdash; sometimes objects fail to successfully initialize and we need a way to handle this. If you have ever read the iOS or OS X [documentation](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSObject_Class/index.html#//apple_ref/occ/instm/NSObject/init) for the Cocoa frameworks, then you have often had the pleasure of reading method descriptions similar to the following:

>**Return Value** <br />
>An initialized object, or `nil` if an object could not be created for some reason that would not result in an exception.

This is commonplace in Objective-C. When instantiating classes in the Cocoa frameworks, many of them may return `nil` instead of an initialized object. We are used to this. But Swift is different. Swift guarantees that instances will not be `nil`, with the exception of [optionals](https://developer.apple.com/library/mac/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-XID_467). The syntactic difference for a failable initializer &mdash; from `init()` to `init?()` &mdash; is much more subtle than its implications.

In **pure** Swift, there should not be a need for a *failable* initializer. However, this is a great feature that streamlines and simplifies Swift's interoperability with Cocoa and Objective-C. But that is where it stops being so great. The problem with failable initializers is, ironically, `nil`. In Objective-C, it is usually safe to pass `nil` around, or send messages to `nil`. Then you accidentally try to insert `nil` into an array or a dictionary at runtime. We all loathe that embarassment. But Swift comes to the rescue with optional types, right? Yes, but I think most would prefer to avoid the optional unwrapping dance as much as possible. And generally speaking, we must [use optionals with care](http://owensd.io/2014/10/18/optionals-beware.html).

The issue with failable initializers in Swift is the same issue with [overloaded or custom operators](http://nshipster.com/swift-operators/) and [literal convertibles](http://nshipster.com/swift-literal-convertible/) &mdash; potential abuse.

#### Be failable, not fallible

"Too young for conventions" is the language's latest tagline, which is probably as frightening to some as it is empowering to others. In this unique situation, we have the opportunity to influence what are considered Swift's best practices. Using failable initializers in Swift should be done sparingly and carefully.

Apple's [article](https://developer.apple.com/swift/blog/?id=17) provides an example of initializing an `NSImage` object. Putting Cocoa and Objective-C aside, I think this is an excellent use case. When you are trying to load an asset or other resource, it makes sense to fail and return `nil` in the situation that the resource is... well, `nil`.

However, failable initializers might seduce you into doing something bad. Suppose we have a blog post object. It requires the body text, the date it was written, and an image. To "simplify" construction of a post, you decide to pass the name of an image, instead of a `UIImage` object.

{% highlight swift %}

class MyPost {

    let text: String
    let date: NSDate
    let image: UIImage

    init?(text: String, date: NSDate, nameOfImage: String) {
        self.text = text
        self.date = date

        if let image = UIImage(named: nameOfImage) {
            self.image = image
        }
        else {
            return nil
        }
    }
}

{% endhighlight %}

If the image cannot be constructed, then the initialization of `MyPost` fails. What have we done by designing our `init?` this way? We have disregarded the [SOLID](http://en.wikipedia.org/wiki/SOLID_(object-oriented_design)) principles, specifically [single responsibility](http://en.wikipedia.org/wiki/Single_responsibility_principle) and [dependency inversion](http://en.wikipedia.org/wiki/Dependency_inversion_principle). The `MyPost` object is for storing blog post data. It should not be initializing an image. The dependency on `UIImage` is now obfuscated. And finally, we have to do our optional unwrapping dance every time we instantiate a post.

We can fix these issues by passing a non-optional image to our initializer.

{% highlight swift %}

class MyBetterPost {

    let text: String
    let date: NSDate
    let image: UIImage

    init(text: String, date: NSDate, image: UIImage) {
        self.text = text
        self.date = date
        self.image = image
    }
}

{% endhighlight %}

Clean and deterministic again. But you're probably thinking, *we still have to handle an optional image __somewhere__*. That's true. When constructing a `UIImage`, the initializer `init(named name: String) -> UIImage?` could return `nil`, but the point is that this should be happening *outside* of this class, and definitely **not** in `init`. There's no good reason to dirty up this class with optionals.

This example is extremely simple, but hopefully you can see how things could get out of hand and just plain shameful with failable initializers if we aren't careful. Imagine if `MyPost` had several properties to construct that could fail.

#### A fallible place to be failable

Here is where we arrive at the core of the problem: failable initializers misplace responsibilities in your architecture, or at least encourage you to do so. Specifically, they misplace the point of failure. An initializer should construct an instance. It should be as simple as possible. It should provide appropriate default values when feasible. It should not be processing or parsing data, as those responsibilities are for functions or instance methods. And most importantly, it should succeed. Of course, there will be exceptions but they should be few.

So where should we fail in the example above? One great solution would be a validator class, `MyBetterPostValidator`, whose single responsibility is validating data. This class would also **not** have a failable intializer, but instead it would have a method that receives the data for a post. If that data is validated successfully, then a `MyBetterPost` gets instantiated.

#### It's optional

Failable initializers do address some of our problems, namely interoperability with Objective-C and Cocoa, and resource loading. But we should be aware of the potential issues that they introduce into our design. Failable initializers feel a lot like Objective-C, and I'm not sure who wants to feel that anymore. If we rely on them too much, we risk simply *re-implementing* our *old* Objective-C code in Swift. Instead, we should strive to take advantage of Swift's new features (enums, tuples, generics, etc.) and completely *re-think* how we design our classes and systems.

In a way, before failable initializers, Swift helped enforce the [SOLID](http://en.wikipedia.org/wiki/SOLID_(object-oriented_design)) principles during initialization. But now, we must enforce them ourselves. This is the part where I say, "with great power comes great responsibility", but I won't.
