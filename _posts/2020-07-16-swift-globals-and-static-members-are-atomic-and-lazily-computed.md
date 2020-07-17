---
layout: post
categories: [software-dev]
tags: [swift, ios, macos, debugging, concurrency]
date: 2020-07-16T12:14:59-07:00
title: Swift globals and static members are atomic and lazily computed
---

While debugging some code the other day, I wanted to verify the behavior of global variables and static members in Swift. I vaguely remembered from the early days of Swift, that `static let` members and global constants were atomic and computed lazily &mdash; one of the many improvements over Objective-C.

<!--excerpt-->

This is easy enough to verify with some sample code and the debugger, but I also wanted to find the documentation to support it. The behavior is described in the [Swift Programming Language e-book](https://books.apple.com/us/book/the-swift-programming-language-swift-5-2/id881256329), which is now also conveniently [available on Swift.org](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html).

In the Properties chapter, there is a section on [Global and Local Variables](https://docs.swift.org/swift-book/LanguageGuide/Properties.html#ID263):

> Global constants and variables are always computed lazily, in a similar manner to Lazy Stored Properties. Unlike lazy stored properties, global constants and variables do not need to be marked with the lazy modifier.

There is also a section on [Type Properties](https://docs.swift.org/swift-book/LanguageGuide/Properties.html#ID264):

> Stored type properties are lazily initialized on their first access. They are guaranteed to be initialized only once, even when accessed by multiple threads simultaneously, and they do not need to be marked with the lazy modifier.

This essentially gives `static` members and globals the same behavior as using [`dispatch_once`](https://developer.apple.com/documentation/dispatch/1447169-dispatch_once) in Objective-C. And again, you can observe this quite easily in the debugger.

There is also a post on the [older, original (but now abandoned) Swift Blog](https://developer.apple.com/swift/blog/?id=7) on developer.apple.com. This post provides the rationale for implementing this behavior:

> Swift uses the third approach, which is the best of all worlds: it allows custom initializers, startup time in Swift scales cleanly with no global initializers to slow it down, and the order of execution is completely predictable.
>
> The lazy initializer for a global variable (also for static members of structs and enums) is run the first time that global is accessed, and is launched as `dispatch_once` to make sure that the initialization is atomic. This enables a cool way to use `dispatch_once` in your code: just declare a global variable with an initializer and mark it `private`.

(Thanks to [Fran Depascuali](https://twitter.com/FranDepascuali/status/1283619124938244102) for pointing this out on Twitter.)

### Atomicity and being thread-safe... or not?

Given this, there are a few important things to note. The concept of atomicity is distinct from the concept of thread-safety. Atomicity does not imply thread-safety, but if something is thread-safe it must be atomic.

Atomicity describes the integrity of reading and writing to a variable. From the [Programming with Objective-C archive documentation](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html):

> **Note:** Property atomicity is not synonymous with an object’s thread safety.
>
> Consider an `XYZPerson` object in which both a person’s first and last names are changed using atomic accessors from one thread. If another thread accesses both names at the same time, the atomic getter methods will return complete strings (without crashing), but there’s no guarantee that those values will be the right names relative to each other. If the first name is accessed before the change, but the last name is accessed after the change, you’ll end up with an inconsistent, mismatched pair of names.

Atomicity only guarantees that you will not read or write partial (garbage) values.

However, in the case of global _constants_ (`let`) or `static let` members on structs, enums, and classes in Swift, we **can** say that they are **thread-safe**, because they are atomic _and_ **immutable**.

Swift guarantees atomicity and a synchronized initialization for all globals and `static` members, but only those declared as `let` are thread-safe after initialization because they are immutable. (And we know that immutable values are safe to access across threads.) For global `var` declarations or `static var` members, we cannot claim that they are thread-safe because they could be mutated across threads after initialization.

(Thanks to [Joe Groff](https://twitter.com/jckarter/status/1283634305021796353) for confirming.)
