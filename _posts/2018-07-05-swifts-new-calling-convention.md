---
layout: post
categories: [software-dev]
tags: [swift, open-source]
date: 2018-07-05T10:00:00-07:00
title: Swift's new calling convention
subtitle: From callee-owned to guaranteed
---

One of the major changes in Swift 4.2 is a change to the calling convention. But what exactly does that mean? Why is it important and why would you want to change it?

<!--excerpt-->

The calling convention specifies how subroutines (e.g., functions) should receive their arguments, the order of those arguments, and how they should return a result. It also specifies how to setup the registers and the call stack when calling a subroutine &mdash; where arguments are stored, how return values are passed back, and how to restore the state of the registers and memory when the function returns. There is plenty more to consider here, but this gives you the general idea of what a calling convention defines. All of this requires a specific contract between the caller and the callee, so that each knows which instructions it is responsible for executing. This is a key component to ensuring programs execute correctly.

At a higher level, the calling convention defines if and when parameters are pass-by-reference or pass-by-value. It also defines the ownership conventions about parameter values &mdash; in the case of Swift, who is responsible for retaining and releasing them, and when? The caller or the callee? *This* is what changed in Swift 4.2.

An aside: there's an in-depth [Calling Convention doc](https://github.com/apple/swift/blob/master/docs/CallingConvention.rst) in the main Swift that explores this topic in detail. While it has not been updated for 2 years, much of the information is still relevant. Be aware that there may be some errors in any sections that attempt to describe Swift's *current* behavior.

### What changed in Swift 4.2?

On [Swift Unwrapped](https://twitter.com/swift_unwrapped), we [discussed these changes with Ted](https://spec.fm/podcasts/swift-unwrapped/154699) in detail. You can also watch the talk from WWDC 2018, [What's New In Swift](https://developer.apple.com/videos/play/wwdc2018/401/).

Swift uses a reference-counted memory model and provides automatic memory management via [ARC](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html) like Objective-C. This means these changes to calling convention in Swift are totally hidden from the user, since the compiler inserts the calls needed to retain and release objects.

In the talk, Ted provides the following examples to illustrate the calling convention **prior** to Swift 4.2, "callee-owned".
When an object is created, it has a +1 reference count. However, when passed to a function call, it's the obligation of that function to release the object.

```swift
// Swift 4.1 and prior
// Calling Convention: "Callee-Owned" (+1 retain)

class X { ... }

func caller() {
    // 'x' created with +1 reference count
    let x = X()
    foo(x)
}

func foo(x: X) {
    let y = x.value
    ...
    // release x
}
```

In practice, we can see how this can produce a lot of superfluous, wasteful retain and release calls. (Note that the initial reference count is balanced by the final function call.)

```swift
func caller() {
    // 'x' created with +1 reference count
    let x = X()
    // retain x
    bar(x) // release x in callee
    // retain x
    baz(x) // release x in callee
    foo(x) // release x in callee

}
```



In Swift 4.2, the convention has changed to "Guaranteed".

```swift
// Swift 4.2
// Calling Convention: "Guaranteed" (+0 retain)
class X { ... }

func caller() {
    // 'x' created with a +1 reference count
    let x = X()
    bar(x)
    baz(x)
    foo(x)
    // release x
}
```

It is no longer the callee's responsibility to release the object. So, all of the superfluous retains and releases go away. Ted notes in the talk that this significant reduction in retain and release traffic results in a code size reduction as well as a runtime performance improvement, because all those calls have been removed.

### Calling non-inlinable functions in other modules

What's more interesting with this change is the case of calling non-inlinable functions across module boundaries. [Michael Gottesman](https://twitter.com/gottesmang/status/1006952128198217729) shared [this gist](https://gist.github.com/gottesmm/524fca6a4e9fb3d5736a1b9d6686c5e8) on Twitter to explain. I doubt many people saw that Tweet, so I wanted to highlight it. I've reproduced the gist below:

```swift
// # Why +0 is a better default than +1 for "normal function arguments".
//
// My intention here is to show why +0 is better default in a resilient
// word. Keep in mind that inside individual modules and with inlinable
// declarations, the optimizer can change conventions at will so from a defaults
// perspective, these are not interesting. The interesting case is calling
// non-inlinable functions in other modules.
//
// Consider a situation where I have a class Klass and a function foo that calls
// a function bar in a different module.

class Klass {}

func foo(_ k: Klass) {
  bar(k)
  bar(k)
  bar(k)
}

// Bar is in a different module and it is not inlinable so we can't inline or
// analyze its body. It is completely opaque beyond its declaration.
func bar(_ k: Klass) {
  // ...
}

//------------------------------------------------------------------------------

// Using "pseudo-swift" this lowers to the following retain traffic at +1.

class Klass {}

// k comes in at +1.
func foo(_ k: Klass) {
  // retain(k)
  bar(k) // release inside bar
  // retain(k)
  bar(k) // release inside bar
  // retain(k)
  bar(k) // release inisde bar.

  // release(k)
}

// Again bar is in a different module, so we can't see its body. Even so,
// convention wise we know that there must be a release at the end.
func bar(_ k: Klass) {
  // ...
  // release(k)
}

// Since we can not analyze or inline bar, we can not eliminate the releases
// in bar. We /could/ coalesce the retains into one large add to the refcount,
// but the releases are not able to be optimized, resulting in slower code.

//------------------------------------------------------------------------------

// Now let us consider the +0 world. In that case, we have the following
// pseudo-swift.

class Klass {}

// k comes in at +0.
func foo(_ k: Klass) {
  // retain(k)
  bar(k)
  // release(k)
  // retain(k)
  bar(k)
  // release(k)
  // retain(k)
  bar(k)
  // release(k)
}

func bar(_ k: Klass) {
  // ...
}

// Notice how since the retains/releases are all in the caller, the optimizer
// can eliminate /all/ the retain/release traffic and we can actually achieve optimal
// code without ref counts.
```

That's an edge case to which I hadn't given much thought. In the *old* convention ("callee-owned"), it was not possible to perform this retain/release traffic optimization across modules &mdash; there wasn't enough information, not to mention everyone needs to follow the convention. The result was slower code. But now that the retains and releases are the responsibility of the caller, not the callee, the optimizer can eliminate *all* of the retain/release traffic to produce optimal code.

I love reading about these kinds of performance improvements, and there are many in Swift 4.2.
