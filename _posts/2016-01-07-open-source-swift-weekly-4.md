---
layout: post
categories: [software-dev]
tags: [swift, open-source]
date: 2016-01-07T10:00:00-07:00
title: "Open source Swift&#58; weekly brief #4"
subtitle: What's been happening on Swift.org?
---

Now that the holidays are over, things have started to pick up again on Swift.org. If you are following any of the repos on GitHub, you have probably noticed. I'm not sure how I missed this before, but this week I just discovered [SwiftExperimental.swift](https://github.com/apple/swift/blob/master/stdlib/internal/SwiftExperimental/SwiftExperimental.swift). For now, it defines a bunch of custom unicode operators for `Set`. It's really cool. I would love to see more APIs like this in the standard library. Anyway, here's the weekly brief!

<!--excerpt-->

### Commits and pull requests

[Austin Zheng](https://github.com/austinzheng) submitted a [pull request](https://github.com/apple/swift/pull/838) to remove to old mirror API.

[Andrew Naylor](https://github.com/argon) merged [changes](https://github.com/apple/swift-corelibs-foundation/pull/181) to speed up JSON parsing in corelibs-foundation. We all know how much the Swift community loves JSON parsing.

[Keith Smiley](https://github.com/keith) submitted a [pull request](https://github.com/apple/swift-corelibs-xctest/pull/25) to that adds support for the Swift package manager to corelibs-xctest.

Chris Lattner completely [redesigned](https://github.com/apple/swift/commit/7daaa22d936393f37176ba03975a0eec7277e1fb) the AST representation of parameters.

### Proposals

Matthew Johnson's [proposal](https://github.com/apple/swift-evolution/blob/master/proposals/0018-flexible-memberwise-initialization.md) to improve memberwise initializers is now [under review](https://lists.swift.org/pipermail/swift-evolution-announce/2016-January/000010.html). As Lattner [pointed out](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20151130/000518.html), there are a number of deficiencies with the current memeberwise initializer behavior in Swift. I have a good feeling this will be accepted.

The proposal to "require self for accessing instance members" has been (thankfully) [rejected](https://lists.swift.org/pipermail/swift-evolution-announce/2016-January/000009.html). Some of the main reasons for this decision were that it (1) introduces verbosity rather than clarity, (2) diminishes the use of `self.` as an indicator for possible retain cycles, and (3) teams wishing to adopt this usage could simply enforce it with a linter.

Doug Gregor has submitted a [proposal](https://github.com/DougGregor/swift-evolution/blob/generalized-naming/proposals/0000-generalized-naming.md) for *Generalized Naming for Any Function*. From the introduction: *"Swift includes support for first-class functions, such that any function (or method) can be placed into a value of function type. However, it is not possible to specifically name every function that is part of a Swift program &mdash; one cannot provide the argument labels when naming a function."* The lack of this feature is definitely a pain point in Swift, especially when working with Cocoa and Objective-C selectors. It's a short read!

### Mailing lists

Doug Gregor [notes](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20160104/005312.html) some surprising behavior when extending an `@objc` protocol &mdash; the members of the `extension` are not exposed to the Objective-C runtime. Luckily, I haven't run into this bug myself.

Finally, is `?.` the ["call-me-maybe" operator](https://twitter.com/uint_min/status/683532142677114880) in Swift? **That's it for this week!**
