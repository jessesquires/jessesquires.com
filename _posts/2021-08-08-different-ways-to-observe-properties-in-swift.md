---
layout: post
categories: [software-dev]
tags: [ios, macos, swift, kvo, combine, property-observers]
date: 2021-08-08T17:16:14-07:00
title: Different ways to observe properties in Swift
---

After I [wrote and released Foil]({% post_url 2021-03-26-a-better-approach-to-writing-a-userdefaults-property-wrapper %}), my library for implementing a property wrapper for `UserDefaults`, one of the criticisms on Twitter was that a mechanism for observing such properties should have been included. I disagreed. In [the post]({% post_url 2021-03-26-a-better-approach-to-writing-a-userdefaults-property-wrapper %}) I argued that this was easy enough for clients to handle on their own, but more importantly that there are too many options for how to do this and I didn't think Foil should impose any one of them on clients.

<!--excerpt-->

Shortly after releasing Foil, [Basem Emara](https://github.com/basememara) opened [an issue](https://github.com/jessesquires/Foil/issues/4) to ask about observing property changes using [Combine](https://developer.apple.com/documentation/combine). No code changes were required for the library, and instead [we merged some updates to the documentation](https://github.com/jessesquires/Foil/pull/5) to explain how to use Foil and Combine together. This gave me confidence that I made the correct choice to omit observation in Foil.

Today, I want to review the various methods for observing properties in Swift. I will use Foil for the example code in this post. Consider the following snippet, where we define some settings for our app.

```swift
final class AppSettings {
    static let shared = AppSettings()

    @WrappedDefault(keyName: "flagEnabled", defaultValue: false)
    var flagEnabled: Bool
}
```

What are our options for observing the `flagEnabled` property?

### Swift property observers

The simplest but least flexible way to observe properties is built-in to the Swift language itself. We can add Swift's [property observers](https://docs.swift.org/swift-book/LanguageGuide/Properties.html#ID262) `willSet` and `didSet`.

```swift
@WrappedDefault(keyName: "flagEnabled", defaultValue: false)
var flagEnabled: Bool {
    willSet {
        print("will set")
    }

    didSet {
        print("did set")
    }
}
```

Observing changes this way would make the most sense if you decentralize your `@WrappedDefault` properties by defining them on classes that utilize them, rather than a shared `AppSettings` class. For example, you could add a `@WrappedDefault` property to a view controller. To make use of the property observers within a centralized class like `AppSettings`, you would need to pass in a closure to execute in the observers or post a `Notification` &mdash; neither of which are ideal.

### Key-Value Observing

The next option is to use [key-value observing](https://developer.apple.com/documentation/foundation/notifications/nskeyvalueobserving) from Foundation, which has [new and improved Swift APIs](https://developer.apple.com/documentation/swift/cocoa_design_patterns/using_key-value_observing_in_swift) that utilize [Key-Path expressions](https://docs.swift.org/swift-book/ReferenceManual/Expressions.html). This works well with a centralized `AppSettings` class. However, it requires inheriting from `NSObject` and making the properties that you wish to observe `@objc` and `dynamic`.

```swift
final class AppSettings: NSObject {
    static let shared = AppSettings()

    @WrappedDefault(keyName: "flagEnabled", defaultValue: false)
    @objc dynamic var flagEnabled: Bool
}
```

Then, from elsewhere in our code we can observe changes:

```swift
let observer = AppSettings.shared.observe(\.flagEnabled, options: [.new]) { settings, change in
    print("property changed")
}
```

### Combine

Similar to KVO, we can use a [Publisher](https://developer.apple.com/documentation/combine/publisher) if our app is using Combine.

```swift
var cancellable = Set<AnyCancellable>()

AppSettings.shared
    .publisher(for: \.flagEnabled, options: [.new])
    .sink { newValue in
        print("property changed")
    }
    .store(in: &cancellable)
```

### Third-party libraries

Finally, there are a handful of open source reactive extension libraries available for Swift that you may already be using. I won't dive into these, but the implementations and concepts would be similar to using Combine.

### Conclusion

These are the primary ways to observe property changes in Swift. I think I made the right decision to omit this feature from [Foil](https://github.com/jessesquires/foil) and instead allow clients to choose their own method of observation. It takes very little code to implement any of these methods, and you could streamline it even more with a few small extensions.
