---
layout: post
categories: [software-dev]
tags: [ios, xcode, debugging, uikit]
date: 2023-02-20T09:27:59-08:00
title: How to find and fix premature view controller loading on iOS
image:
    file: viewdidload-breakpoint.jpg
    caption: Symbolic breakpoint on viewDidLoad()
    alt: Symbolic breakpoint on viewDidLoad()
    half_width: true
---

While working on a very large iOS client project, I was investigating the causes for our slow app launch time. We had a hypothesis that _part_ of the problem was that too many view controllers were getting loaded in memory, in particular, ones that were not even being presented to the user during app startup. What could cause view controllers to load too early? How might you discover this happening? And how do you fix it? Let's find out.

<!--excerpt-->

### The view controller lifecycle

A [`UIViewController`](https://developer.apple.com/documentation/uikit/uiviewcontroller) is a fundamental component of iOS development ([doc archive](https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/index.html#//apple_ref/doc/uid/TP40007457-CH2-SW1)). In order to debug our problem, we need to understand the view controller lifecycle. If you unintentionally (or deliberately) interfere with it, bad things&trade; can happen.

The (simplified) sequence of events and state transitions is:

1. `init()` --- Initializes the view controller.
1. The initialized view controller gets presented via one of the presentation methods, like [`present(_:animated:completion:)`](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621380-present).
1. `loadView()` --- The view gets created and loaded into memory.
1. `viewDidLoad()` --- Called after the view is loaded.
1. `viewWillAppear(_:)` --- Called before the view appears.
1. `viewDidAppear(_:)` --- Called after the view is presented.
1. `viewWillDisappear(_:)` --- Called before the view disappears.
1. `viewDidDisappear(_:)` --- Called after the view is dismissed.

If you have ever worked on an iOS app, you have implemented most of these methods. And you probably have a good idea about what types of tasks should or shouldn't go in each one.

It is important to emphasize that the view owned by the view controller (i.e., `self.view`) is **not** loaded until **after** a presentation is initiated. At least, that is how it is _supposed_ to work. Unfortunately, there is one tiny mistake you could make that changes the sequence of events above: accessing `self.view` from within `init()`. Doing this prematurely begins the view lifecycle events. The [documentation](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621460-view) for `self.view` reads:

> If you access this property when its value is `nil`, the view controller automatically calls the `loadView()` method and returns the resulting view.

When finished, `loadView()` then triggers a call to `viewDidLoad()`. Note that the remaining appearance methods _will not_ be called early as well, but only when the actual presentation occurs. The result is that immediately after initialization `loadView()` and `viewDidLoad()` will be called --- **before** a presentation is ever initiated.

1. `init()` (accessing `self.view` by mistake)
1. `loadView()`
1. `viewDidLoad()`
1. At a later time, presentation occurs via `present(_:animated:completion:)`, etc.
1. `viewWillAppear(_:)`
1. `viewDidAppear(_:)`
1. ....

### The problem with early view loading

Accessing `self.view` from within a view controller `init()` is a mistake because it will initiate the view lifecycle too early, calling `loadView()` and `viewDidLoad()`. This can be terrible for performance, because now the main thread is busy building an entire view hierarchy for something that is not even on screen. Because `viewDidLoad()` is typically the place to initiate various important tasks, like subscribing to notifications or sending network requests or loading data from disk, performance can degrade even further. Depending on the complexity of your `viewDidLoad()` implementation, this could be quite detrimental.

You might be wondering why this matters at all if we are about to present the view controller anyway. Well, that is not always the case! There are many situations in which you might initialize --- _but not immediately present_ --- a collection of view controllers. The most common cases are when using container view controllers like `UITabBarController` or `UINavigationController`. With `UITabBarController`, for example, all view controllers are initialized but only the controller in first selected tab has its view _presented_. The remaining view controllers get presented for the first time when the user first navigates to those tabs. Until then, their views are not loaded. The same goes for a navigation stack, where you might be configuring a stack of view controllers for deep-linking. Only the top-most view controller will have its view loaded.

If you access `self.view` via `init()` in all of the view controllers owned by a `UITabBarController` or a `UINavigationController`, then all of them will load their views during initialization, triggering `viewDidLoad()` and thus potentially triggering responses to notifications, sending network requests, loading data from disk, etc. As a result, you might see some strange and unexpected behavior as those network requests finish or those subscriptions start firing --- because you'll be responding to these events and updating a view that isn't even on screen. This creates unnecessary work, consumes valuable resources, and wastes precious time on the main thread.

In large, complex codebases small issues like this grow over time and multiply. Accidentally loading a single view controller too early will probably go unnoticed. But what if you have a dozen or more?

### Finding and fixing the bug

Manually checking every view controller in your codebase is not feasible. There are likely hundreds, if not thousands, depending on the size of your app. This is a perfect use case for symbolic breakpoints. We can create a symbolic breakpoint on `-[UIViewController viewDidLoad]`. Then we need to add a couple of actions so that we can see what's happening --- a "Log Message" action with `%B` to print the breakpoint name, and a "Debugger Command" action with `po $arg1` which will print the instance of the view controller. Finally, we need to tell the debugger to continue after evaluating the actions.

{% include post_image.html %}

Now we can build and run our app. Do not interact with the app at all, only allow it to fully launch. The console logs will look something like this:

```bash
-[UIViewController viewDidLoad]
<MyFirstViewController: 0x7f9d52886c00>

-[UIViewController viewDidLoad]
<MySecondViewController: 0x7f9d42858800>

-[UIViewController viewDidLoad]
<MyThirdViewController: 0x7f9d43095740>

-[UIViewController viewDidLoad]
<MyFourthViewController: 0x7f9d431de9d0>
```

What this is showing is every single view controller that gets loaded during our app launch. We have a list of every view controller whose `viewDidLoad()` was called during app startup --- how convenient! All that is left to do is to check each of these view controllers and verify whether or not they should be loaded. Are they being presented and visible to the user? Or are they prematurely accessing `self.view`?

What I discovered in this project was many instances of `self.view.backgroundColor = UIColor.customColor` happening during `init()`. Moving this line to `viewDidLoad()` solved the problem. Unfortunately, there were also much more complicated situations that were triggering `viewDidLoad()` too early. In some cases, another component was accessing the `view` property of the view controller. In others, `self.view` was being accessed through a chain of function calls that began within `init()`. So, beware that solving these bugs may not always be obvious.
