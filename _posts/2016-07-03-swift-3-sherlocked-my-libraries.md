---
layout: post
title: Swift 3 sherlocked my library
subtitle: Many of our "Swifty" wrappers are no longer necessary
redirect_from: /swift-3-sherlocked-my-libraries/
---

What's my favorite thing about Swift 3? Not maintaining third-party libraries that make Cocoa more "Swifty".
Swift 3 [sherlocked](http://www.urbandictionary.com/define.php?term=sherlocked) my libraries, and I couldn't be happier.

<!--excerpt-->

### Deprecated

Among the many improvements included in Swift 3 are the *Swifty* API refinements to Foundation and libdispatch.

I have two Swift libraries that I'm officially deprecating today. The first is [JSQNotificationObserverKit](https://github.com/jessesquires/JSQNotificationObserverKit) which provided a generic `Notification` struct to wrap the [NSNotification](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSNotificationCenter_Class/index.html) APIs. It was sherlocked by proposal [SE-0069](https://github.com/apple/swift-evolution/blob/master/proposals/0069-swift-mutability-for-foundation.md): *Mutability and Foundation Value Types*. The second is [GrandSugarDispatch](https://github.com/jessesquires/GrandSugarDispatch) which provided *Swifty* syntactic sugar for [Grand Central Dispatch](https://developer.apple.com/library/ios/documentation/Performance/Reference/GCD_libdispatch_Ref/) (GCD). It was sherlocked by proposal [SE-0088](https://github.com/apple/swift-evolution/blob/master/proposals/0088-libdispatch-for-swift3.md): *Modernize libdispatch for Swift 3 naming conventions*.

As expected, there a few differences between my libraries and what Apple now provides. In particular, the `Notification` struct in Foundation is not generic. However, the differences are not significant enough to justify keeping my libraries around. Plus, as stated in SE-0069, it is much better for the community to have one canonical API whenever possible:

> We know from our experience with Swift so far that if we do not provide these value types then others will, often by wrapping our types. It would be better if we provide one canonical API for greater consistency across all Swift code. This is, after all, the purpose of the Foundation framework.

These libraries served their purpose during the pre-Swift 3 era &mdash; before [*The Great API Transformation*](https://swift.org/blog/swift-api-transformation/). But I'm ultimately very happy to see them go. In situations like this, it feels good to get sherlocked. It means that Apple are taking on this responsibility &mdash; it *shows us* once more that the Core Team are listening to the community and responding with solutions.

The more we can agree and settle on canonical APIs and libraries, the better it will be for all of us. Do you have any libraries that have been obsoleted by Swift 3? If so, deprecate them now then sit back and relax. 😄
