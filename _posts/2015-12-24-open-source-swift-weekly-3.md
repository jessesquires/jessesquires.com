---
layout: post
categories: [software-dev]
tags: [swift, open-source]
date: 2015-12-24T10:00:00-07:00
title: "Open source Swift&#58; weekly brief #3"
subtitle: What's been happening on Swift.org?
---

As expected with the holiday season, [things are](https://lists.swift.org/pipermail/swift-corelibs-dev/Week-of-Mon-20151214/000179.html) [slowing down](https://lists.swift.org/pipermail/swift-dev/Week-of-Mon-20151221/000540.html) for a bit on Swift.org. I have been traveling for the holidays as well, so this issue will be shorter than usual. If you haven't already, be sure you take some time away from coding to enjoy the holidays and [avoid burnout](https://twitter.com/chriseidhof/status/679213894343200768). Now, the weekly brief!

<!--excerpt-->

### Commits and pull requests

[@tienex](https://github.com/tienex) submitted a [pull request](https://github.com/apple/swift/pull/608) for Linux/armv7 support.

[@practicalswift](https://github.com/practicalswift) added a ton of [test cases](https://github.com/apple/swift/pulls?q=is%3Apr+author%3Apracticalswift+is%3Aclosed+test+case). And as of this writing, there are still a few waiting to be merged.

[@masters3d](https://github.com/masters3d) merged a [pull request](https://github.com/apple/swift-evolution/pull/72/files) to swift-evolution that documents commonly proposed changes to Swift. This is a great idea to help reduce duplicate proposals. Don't forget to [check this list](https://github.com/apple/swift-evolution/blob/master/commonly_proposed.md) before suggesting a change on the mailing list!

Doug Gregor [implemented SE-0001](https://github.com/apple/swift/commit/c8dd8d066132683aa32c2a5740b291d057937367), which *"allows (most) keywords as argument labels"*. This is a great change. When Swift was initially released, one of my Objective-C libraries used `extension:` as a [parameter name](https://github.com/jessesquires/JSQSystemSoundPlayer/issues/8) (for a file extension string) and bridging to Swift caused all kinds of problems, thus I ended up having to rename it to `fileExtension:`. Glad to see I can revert this change in Swift 2.2! Note that the keywords `var`, `let`, and `inout` are excluded from this.

### Proposals

Oisin Kidney's [proposal (SE-0008)](https://github.com/apple/swift-evolution/blob/master/proposals/0008-lazy-flatmap-for-optionals.md), *Add a Lazy flatMap for Sequences of Optionals*, has been [accepted](https://lists.swift.org/pipermail/swift-evolution-announce/2015-December/000006.html) for Swift 2.2!

Kevin Ballard's [proposal (SE-0015)](https://github.com/apple/swift-evolution/blob/master/proposals/0015-tuple-comparison-operators.md), *Tuple comparison operators* has also been [accepted](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20151221/004423.html)! As of this writing, the status of the proposal on GitHub has not been updated to reflect this. Since this proposal should not affect existing code, I assume it will be included for Swift 2.2.

Joe Groff submitted [a proposal](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20151214/003148.html) to add property behaviors to Swift. You can find [draft](https://gist.github.com/jckarter/f3d392cf183c6b2b2ac3) on GitHub. Or if you prefer to receive information via [tweet](https://twitter.com/jckarter/status/677554831003791360), there's that too. In short, the proposal outlines an extensible framework for applying various behaviors to properties, similar to `atomic` or `copy` in Objective-C. Currently, Swift has some special-purpose hardcoded behaviors, for example,`lazy`, `@NSCopying`, and `willSet`/`didSet`. This proposal aims to generalize and unify these concepts such that they are implemented via the same underlying framework and can be easily extended. Clients could even implement their own behaviors. It sounds awesome. Some example behaviors include: lazy, memoization, delayed initialization, resettable, and synchronized. Definitely worth the read!

### Mailing lists

Andyy Hope started [a discussion](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20151221/003819.html) around adding an `.allValues` static variable to enums, which would return an array of all cases in the enum. Looks like there is a lot of support for the idea so far. [Jacob Bandes-Storch](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20151207/001233.html) also brought up this idea up a couple of weeks ago. I would definitely be in favor of this, as I've found myself writing this boilerplate multiple times.

Kevin Ballard [suggests](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20151221/004223.html) a more formal "This Week In Swift" newsletter. Maybe I should go ahead and setup swiftweekly.org?

**That's it for this week!** Cheers.
