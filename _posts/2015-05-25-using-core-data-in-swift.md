---
layout: post
title: Using Core Data in Swift
subtitle: Talk at Realm in San Francisco
redirect_from: /using-core-data-in-swift/
---

I recently gave a talk at the Swift Language User Group ([#SLUG](http://www.meetup.com/swift-language/events/220612410/)) meetup at [Realm](http://realm.io) in San Francisco. A [video of the talk](http://realm.io/news/jesse-squires-core-data-swift/) is now online over at Realm's blog, where it is synced up with my [slides](https://speakerdeck.com/jessesquires/using-core-data-in-swift). If you haven't already seen it, go check it out! Realm does an absolutely amazing job with posting these meetup talks &mdash; in addition to the video and slides, there's a full transcript and subtitles.

<!--excerpt-->

### Talk summary

Realm's notes and transcription are excellent, but I want to briefly to reiterate the main points of the talk here.

1. Put your model in its own framework. For example, `MyAppModel.framework`. This gives your models a clear namespace, makes your app modular, prepares your models for reuse elsewhere, and makes them easier to test. Do not add your models to the Test Target, `import MyAppModel` instead.

1. Write [designated initializers](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Initialization.html) for your `NSManagedObject` subclasses that use [dependency injection](http://en.wikipedia.org/wiki/Dependency_injection). In other words, your initializer should be parameterized to receive values for **all** of its properties. This prevents your models from bypassing Swift's strict initialization rules, because of `@NSManaged`. Without doing this, you could end up with an instance of a model that is **not** fully initialized. Further, provide default parameter values where possible.

1. Use Swift features. Make good use of optionals, `typealias`, and `enum` to make your models more clear. Remember, Xcode does not properly generate classes with optional properties.

1. Use [JSQCoreDataKit](https://github.com/jessesquires/JSQCoreDataKit)! :) I plan on improving and adding to the framework as I use it in my side projects. If you are building an app using Swift and Core Data, please consider using it &mdash; contributions are more than welcome!

1. I'm interested in bringing type-safety and functional paradigms to Core Data. Currently, this approach means eschewing much of Objective-C's dynamicism, which unfortunately leaves popular libraries like [Mantle](https://github.com/Mantle/Mantle) incompatible. This is mostly due to using designated initializers in Swift.

### Other notes

There was a comment about iterating through the [`NSManagedObjectModel`](https://developer.apple.com/library/prerelease/ios/documentation/Cocoa/Reference/CoreDataFramework/Classes/NSManagedObjectModel_Class/index.html). Details and discussion can be found at [this gist](https://gist.github.com/nevyn/d22c4684370fa07078dd).

Alejandro ([**@mephl**](https://twitter.com/mephl)) [pointed out](https://twitter.com/mephl/status/601003780700655616) that `NSBatchUpdateRequest` exists as of iOS 8. Awesome news! Anyone else feel like it is getting harder to keep track of all the changes and additions each year at WWDC?

### Radar, or GTFO

I've filed the following radars for the issues I've experienced using Core Data in Swift. Duplicates are encouraged! And don't forget to report anything else that you find.

* [rdar://21098460](https://openradar.appspot.com/radar?id=6747306682482688)
* [rdar://21098402](https://openradar.appspot.com/radar?id=5534736382427136)
* [rdar://21098433](https://openradar.appspot.com/radar?id=4963635386384384)
