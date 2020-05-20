---
layout: post
categories: [software-dev]
tags: [ios, macos, swift, uikit, swiftlint]
date: 2020-05-20T09:30:34-07:00
title: 'Swift tip: marking unused required initializers as unavailable'
---

Swift's [strict initialization rules](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html) are great. They help prevent an entire category of bugs that were especially common in Objective-C. However, when working with Objective-C frameworks, particularly `UIKit`, these rules can be frustrating.

<!--excerpt-->

When you subclass `UIViewController` and `UIView` and provide your own initializer, the compiler will prompt you to add the following `required` initializer:

```swift
required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
```

For view controllers, [`init(nibName:bundle:)`](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621359-init) is the designated initializer, but [`init(coder:)`](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621403-init) is required by the [`NSCoding`](https://developer.apple.com/documentation/foundation/nscoding) protocol. It must be implemented not only because of the protocol, but because this is the initializer that Interface Builder calls when automatically instantiating `UIViewController` subclasses from storyboards or xibs. The same applies to `UIView` subclasses.

However, if you do not use Interface Builder, then `init(coder:)` is irrelevant and will never be called. It is annoying boilerplate. But the real problem is that Xcode (and presumably other editors) will offer `init(coder:)` as an auto-complete option when initializing your view or view controller. That is not ideal, because it is not a valid way to initialize your custom view or view controller. Luckily, you can use Swift's [`@available` attribute](https://docs.swift.org/swift-book/ReferenceManual/Attributes.html) to prevent this, which also has the benefit of more clearly communicating that you should not use this initializer.

```swift
@available(*, unavailable)
required init?(coder: NSCoder) {
    fatalError("\(#function) has not been implemented")
}
```

Now, at compile-time, this initializer is inaccessible. Or technically, at "auto-complete while you type time".

You might have the idea of putting this in an extension or a protocol, so that you can avoid typing the boilerplate for every `UIView` and `UIViewController` subclass. Unfortunately, that is not possible because `required` initializers must be provided in subclass declarations. So, using `@available` is the best we can do.

**UPDATE:** Thanks to [JP for pointing out](https://twitter.com/simjp/status/1263202678663872513) that there's a [SwiftLint rule](https://realm.github.io/SwiftLint/unavailable_function.html) for exactly this. Unfortunately, it does not currently support autocorrect.

