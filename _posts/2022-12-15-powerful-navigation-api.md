---
layout: post
categories: [software-dev]
tags: [ios, uikit]
date: 2022-12-15T13:38:32-08:00
title: A powerful UINavigationController API that you might not know about
---

If you have ever worked on an iOS app, you have definitely used [`UINavigationController`](https://developer.apple.com/documentation/uikit/uinavigationcontroller). It has been around since iOS 2 and is a fundamental component in UIKit. Yet, there is one very powerful API that you might not know about.

<!--excerpt-->

A common scenario in iOS development is modifying the stack of view controllers in a navigation stack, which managed by `UINavigationController`. There are many reasons do to this. You might want to preload a set of view controllers, already drilled down to the Nth view controller. You might want to replace _previous_ view controllers on the stack. You might want to gracefully pop back to the Nth view controller without having pop each view controller off the stack one by one. Or, you might want to continually replace the top view controller to prevent the user from navigating back.

I've worked on many iOS projects over the years and I've seen a lot hacks to accomplish modifying a navigation stack of view controllers. Often developers will reach for the [`viewControllers` property](https://developer.apple.com/documentation/uikit/uinavigationcontroller/1621873-viewcontrollers). But this API performs an abrupt replacement that is visually jarring. I've seen hacks around attempting to animate this gracefully, as well as trying to swap out the underlying `viewControllers` after an artificial delay. Another approach is repeated calling `pushViewController(_:animated:)` or `popViewController(animated:)`.

However, there's one API that will gracefully handle all of the above for you and it has been around since iOS 3. What you want to use is [`setViewControllers(_:animated:)`](https://developer.apple.com/documentation/uikit/uinavigationcontroller/1621861-setviewcontrollers). The documentation reads:

> Use this method to update or replace the current view controller stack without pushing or popping each controller explicitly. In addition, this method lets you update the set of controllers without animating the changes, which might be appropriate at launch time when you want to return the navigation controller to a previous state.
>
> If animations are enabled, this method decides which type of transition to perform based on whether the last item in the items array is already in the navigation stack. If the view controller is currently in the stack, but is not the topmost item, this method uses a pop transition; if it is the topmost item, no transition is performed. If the view controller is not on the stack, this method uses a push transition. Only one transition is performed, but when that transition finishes, the entire contents of the stack are replaced with the new view controllers. For example, if controllers A, B, and C are on the stack and you set controllers D, A, and B, this method uses a pop transition and the resulting stack contains the controllers D, A, and B.

In other words, `setViewControllers(_:animated:)` essentially performs a diff and will animate a push or pop animation as appropriate. This results in the stack of view controllers being replaced entirely transparently to the user --- all they see is a normal push or pop animation, yet you have completely swapped out the underlying stack of view controllers.

I think this API is often overlooked --- especially in Objective-C --- because it looks like it is the same thing as the `viewControllers` property. Perhaps a better name for this API would be `replaceViewControllers(_:animated:)` or `applyDiffWith(viewControllers:animated:)`. If you ever find yourself in one of the scenarios above, now you know which API to use!
