---
layout: post
categories: [software-dev]
tags: [swift, xcode, compilers, clang]
date: 2025-10-28T14:12:34-04:00
title: "Workaround: how to silence individual deprecation warnings in Swift"
subtitle: null
---

The [Swift compiler](https://www.swift.org) has fine-grained controls for compiler warnings. As of Swift 6.2, you can even [configure these warnings in Swift Packages](https://useyourloaf.com/blog/treating-warnings-as-errors-in-swift-packages/). Unfortunately, this is an all-or-nothing approach with no flexibility, unlike the piecemeal control provided by the [Clang compiler](https://clang.llvm.org/get_started.html) via [`#pragma` directives](https://nshipster.com/pragma/).

<!--excerpt-->

Like Objective-C, in Swift you can treat all warnings as errors, suppress all warnings, or treat only specific diagnostic groups as warnings or errors. However, in Objective-C --- that is, with the Clang compiler --- rather than only configure these settings for the entire project, you can [control diagnostics via pragmas](https://clang.llvm.org/docs/UsersManual.html#controlling-diagnostics-via-pragmas). This allows you to piecemeal disable warnings for specific sections of source code. Despite being over a decade old, Swift still has no equivalent.

### Treating warnings as errors

In nearly every team I have ever worked on --- honestly, probably **every** team --- we treat all warnings as errors. The motivation is to avoid accumulating an excessive amount of (maybe mundane and minor) warnings that everyone ignores, which later risks not noticing a warning of serious importance. If all warnings are errors, they must be addressed immediately. A project with zero warnings and zero errors is a wonderful thing.

There is one exception to this rule --- deprecations. Sometimes, we have no choice but to continue using deprecated APIs. This could be due to legacy code that is too difficult to refactor, a lack of adequate replacement APIs, project priorities, etc.

What we **do not** want to do is treat all deprecation warnings as errors. That would prevent us from building. We also **do not** want to suppress _all_ deprecation warnings via global compiler settings. This would allow new violations to go unnoticed. What we want to do is silence individual deprecated API usage _at the call site_ on a case-by-case basis. This gives us the best of both worlds: all warnings are treated as errors, and in specific scenarios we allow using deprecated APIs.

### Using Clang `#pragma` directives

Let's look at an example using everyone's favorite APIs for dealing with everyone's favorite iOS UI element: the status bar.

With Clang and Objective-C, we can use `#pragma clang diagnostic` to modify warning flags.

```objc
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
[[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationFade];
#pragma clang diagnostic pop
```

In this example, we are using the deprecated API [`setStatusBarHidden:withAnimation:`](https://developer.apple.com/documentation/uikit/uiapplication/setstatusbarhidden(_:with:)?language=objc). Prior to the call, we save the diagnostic state using `clang diagnostic push`, then ignore the warning for deprecated declarations (which would actually be treated as an error). After the call, we restore the previous diagnostic state using `clang diagnostic pop`.

### Swift workaround

Disappointingly, Swift has no equivalent to [Clang `#pragma` directives](https://nshipster.com/pragma/). Fortunately, we can do some hacky things with protocols to achieve the same results. (Credit is due to the [StackOverflow user who offered this workaround](https://stackoverflow.com/questions/31540446/how-to-silence-a-warning-in-swift/45743766#45743766). This blog post serves to elaborate more on what, why, and how.)

Alternatively, instead of using this Swift workaround, you can simply use Objective-C and Clang `#pragma` and take advantage of the interoperability between the two languages. This hack is for folks that do not want to introduce Objective-C into their Swift-only codebase.

First, we define a new protocol that offers the same APIs as the deprecated ones. You need to name the protocol members slightly differently than the original APIs. I recommend using a traditional Objective-C three-letter prefix. (In this example, I'm using "deprecated_".)

```swift
protocol DeprecatedStatusBarMethods {
    func deprecated_setStatusBarHidden(_ hidden: Bool, with animation: UIStatusBarAnimation)
}
```

Next, have the type that owns the deprecated APIs conform to this protocol. The implementation will simply call the deprecated method. In this case, [`setStatusBarHidden:withAnimation:`](https://developer.apple.com/documentation/uikit/uiapplication/setstatusbarhidden(_:with:)?language=objc).

```swift
extension UIApplication: DeprecatedStatusBarMethods {

    // tell compiler this is deprecated, too.
    // this would otherwise produce a warning.
    @available(*, deprecated)
    func deprecated_setStatusBarHidden(_ hidden: Bool, with animation: UIStatusBarAnimation) {
        // call the original deprecated method
        self.setStatusBarHidden(hidden, with: animation)
    }
}
```

Note that you must mark the protocol implementation in the extension as `@available(*, deprecated)` to silence the compiler deprecation warning. Without this annotation, you would see a warning when calling the original deprecated API.

With those pieces in place, we can call the deprecated API by first casting the type to the protocol type we just defined. This successfully calls the deprecated API and produces no warnings or errors, despite using the Swift compiler flag `-warnings-as-errors` to treat all warnings as errors.

```swift
// no warnings!
(UIApplication.shared as DeprecatedStatusBarMethods).deprecated_setStatusBarHidden(isHidden, with: .fade)
```

This is obviously very verbose. To mitigate this, you could wrap this in a helper method.

```swift
extension UIApplication {
    func myApp_setStatusBarHidden() {
        (self as DeprecatedStatusBarMethods).deprecated_setStatusBarHidden(true, with: .fade)
    }
}

// usage:
UIApplication.shared.myApp_setStatusBarHidden()
```

Importantly, you cannot directly call the implementation method --- the one we annotated with `@available(*, deprecated)`. Doing this results in the compiler producing a warning, as you would expect.

```swift
// warning: deprecated API usage
UIApplication.shared.deprecated_setStatusBarHidden(isHidden, with: .fade)
```

### How does this even work?

I am not a Swift compiler expert, but here is my best attempt at an explanation. Hopefully everything up until the call site makes sense, but I will cover that too.

1. In the implementation of the protocol, we annotate the API using `@available(*, deprecated)`. Without this annotation, the compiler produces a warning at the call site of the original deprecated API. Explicitly annotating the outer declaration `func deprecated_setStatusBarHidden(_:with:)` as deprecated silences the deprecation warning inside the method implementation. Because this is explicit, the compiler does not need to warn us.

2. Calling a deprecated method produces a deprecation warning. As noted above, when we call the newly added deprecated method directly on `UIApplication.shared`, we see warning. This is expected, the method is annotated with `@available(*, deprecated)`.

3. When we write `(UIApplication.shared as DeprecatedStatusBarMethods)`, we are hiding the concrete type. Then, we are allowed to call the method on the protocol type without any warnings because _that_ method has no annotations. The compiler will lookup the method in the protocol witness table rather than directly in the concrete type. Essentially, we have performed a kind of "type erasure" and are hiding our deprecated code behind the protocol witness table.

### Is this practical?

This workaround is rather verbose and somewhat obscure (and kind of obtuse) --- but it works. If your project already has a mix of Objective-C and Swift, you are probably better off silencing deprecation warnings using Clang pragmas. If you want to avoid adding Objective-C, this is a viable alternative. However, if your project is using a lot of deprecated APIs, I can see this workaround being quite cumbersome. Of course, the best solution is to stop using deprecated APIs altogether --- but, like many aspects of software development, we do not always have that luxury.
