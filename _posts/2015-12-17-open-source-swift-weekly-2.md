---
layout: post
categories: [software-dev]
tags: [swift, open-source]
date: 2015-12-17T10:00:00-07:00
title: "Open source Swift&#58; weekly brief #2"
subtitle: What's been happening on Swift.org?
---

The Swift.org community is finishing up its second full week of open source development. If you were hoping for a quiet week, you will definitely be disappointed. There is still a ton of activity with no signs of slowing down. The Swift team [continues](https://twitter.com/uint_min/status/675022507527684096) to work openly and to be [encouraging](https://github.com/apple/swift/pull/389#issuecomment-163851653) to contributors. This week brought more crash fixes and more Swift Evolution proposals. Let's get to it &mdash; the weekly brief!

<!--excerpt-->

### Community

Craig Federighi reflects on Swift's first week out in the open with John Gruber on [The Talk Show](http://daringfireball.net/thetalkshow/2015/12/07/ep-139). I really enjoyed listening to this episode and continue to be surprised by Apple's openness! The interview is only about 30 minutes. There is also a [transcript](http://daringfireball.net/thetalkshow/139/federighi-gruber-transcript) on Daring Fireball.

It looks like [@zhuowei](https://github.com/zhuowei) started a port for [Android](https://github.com/SwiftAndroid). I really hope this project takes off. Writing Android apps in Swift could be a huge win for mobile developers.

One clarification from last week &mdash; currying will not removed completely, [just the syntax](https://github.com/apple/swift-evolution/pull/43#issuecomment-163849233).

### Commits and pull requests

[Slava Pestov](https://github.com/slavapestov) pushed [a commit](https://github.com/apple/swift/commit/c258f991f64a431da57fc79b66e879e5062fba3b) that *fixed [91 percent](https://github.com/apple/swift/commit/c258f991f64a431da57fc79b66e879e5062fba3b#commitcomment-14971959) of the outstanding compiler crashers.*

[Dominique d'Argent](https://github.com/nubbel) introduced the first [unicode variable name](https://github.com/apple/swift-corelibs-foundation/pull/93#discussion_r47160608) in his implementation of `NSAffineTransform`. This is the only one that I've seen so far. I will happily buy a &#x2615; or &#x1F37A; for anyone who can successfully merge a pull request that uses &#x1F4A9;.

[Bill Abt](https://github.com/apple/swift/pull/413) and [David Grove](https://github.com/apple/swift-corelibs-libdispatch/pull/15) from IBM made significant contributions to Swift and the core libraries! As Federighi mentioned on The Talk Show, IBM *really* wants to use Swift on the server.

Chris Lattner [fixed](http://github.com/apple/swift/commit/a2d9b10b64c3115c2eed7b6baa8f641db9fc246e) [a few](https://github.com/apple/swift/commit/e28c2e2c6e4c7da665090f0acce4c68cbf4ebc15) [more](https://github.com/apple/swift/commit/7b323a8460540bbb9e9234ef3e3fb27f7cb117e3) [radars](https://github.com/apple/swift/commit/0bfacde2420937bfb6e0e1be6567b0e90ee2fb67).

[Daniel Duan](https://github.com/dduan) submitted a [pull request](https://github.com/apple/swift/pull/419) to optimize the `Set` collection type. The result is roughly a 42 percent speed improvement. [Whoa!](https://github.com/apple/swift/pull/419#issuecomment-164109613)

[@PracticalSwift](https://twitter.com/practicalswift) fixed [a ton](https://github.com/apple/swift/pull/561) of [typos](https://github.com/apple/swift/pull/526).

William Dillon [began support](https://github.com/apple/swift/pull/439) for ARMv7 hosts such as the Raspberry Pi, BeagleBone, and Nvidia Tegras.

Brian Gesiak [continued to pursue](https://github.com/apple/swift-corelibs-xctest/pull/14) testing the XCTest framework, and in terms of number of commits, he is now the [#3 contributor](https://github.com/apple/swift-corelibs-xctest/graphs/contributors) on corelibs-xctest.

### Proposals

The first independent Swift language evolution proposal has been [accepted](https://twitter.com/clattner_llvm/status/676472122437271552)! You can say goodbye to [C-style for-loops](https://github.com/apple/swift-evolution/blob/master/proposals/0007-remove-c-style-for-loops.md) and say thank you to [Erica Sadun](https://twitter.com/ericasadun). Beginning in Swift 2.2, you'll see warning if you use a C-style for-loop and it will be removed in the 3.0 release. *"For the most part, there was agreement that C-style for loops are quite rare in Swift code, and most of the existing uses would be better written as for-in loops."* Also be sure to note the two potential problems with this change as described in the [announcement](https://lists.swift.org/pipermail/swift-evolution-announce/2015-December/000001.html).

[Max Howell](https://github.com/mxcl), [Daniel Dunbar](https://github.com/ddunbar), and [Mattt Thompson](https://github.com/mattt) have prepared [a proposal](https://github.com/apple/swift-evolution/pull/51) to add testing support to the [Swift package manager](https://github.com/apple/swift-package-manager)! *"Testing is an essential part of modern software development. Tight integration of testing into the Swift Package Manager will help ensure a stable and reliable packaging ecosystem. We propose to extend our conventional package directory layout to accommodate test modules."*

Max Moiseev's [proposal](https://github.com/apple/swift-evolution/blob/master/proposals/0014-constrained-AnySequence.md) to constrain `AnySequence.init` is due for review this week. I don't see any reason why this would not be accepted. *"These constraints, in fact, should be applied to `SequenceType` protocol itself (although, that is not currently possible), as we expect every `SequenceType` implementation to satisfy them already."*

David Hart's [proposal](https://github.com/apple/swift-evolution/blob/master/proposals/0009-require-self-for-accessing-instance-members.md) to require `self` for accessing instance members is currently under review. If you haven't been following along, this would make `self` *always required* even when it can be inferred implicitly. For example, using `self.view` versus simply `view`. There's a ton of discussion on the [mailing list]((https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20151214/002407.html)) and [twitter](https://twitter.com/ashfurrow/status/676881928168017921). I'm not a fan, but I can understand some of the arguments to do this.

Erica Sadun also has a [great post](http://ericasadun.com/2015/12/16/the-evolution-will-be-televised-current-and-upcoming-proposal-reviews/) detailing some of the recent proposals.

### Mailing lists

There's [an interesting thread](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20151207/001948.html) on dynamic versus static method dispatch. From Chris Lattner: *"TL;DR: What I’m really getting at is that the old static vs dynamic trope is at the very least only half of the story.  You really need to include the compilation model and thus the resultant programmer model into the story, and the programmer model is what really matters."*

Fabian Ehrentraud started a [discussion](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20151207/001054.html) around improving crash-safety when importing Objective-C code without nullability attributes. Currently, un-annotated Objective-C members are bridged to Swift as implicitly unwrapped optionals (e.g., `view!`). This proposal suggests importing these members as optionals (`view?`) instead, which would encourage clients to handle possible `nil` values safely. Sounds great to me. Honestly, I'm not sure why implicitly unwrapped optionals exist to begin with, as they seem contrary to Swift's safety goals.

Colin Cornaby [suggested](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20151214/002324.html) removing semi-colons completely from Swift following the trend of removing C-style language features. As noted on the mailing list, while semi-colons are often syntactic noise, they do serve a stylistic purpose for grouping similar statements on the same line. I could go either way on this, but it doesn't seem like the idea is gaining enough traction to warrant a formal proposal.

<blockquote>
   <p>Stare long enough into the language design, and the language design stares back into you.</p>
   <footer><a href="https://twitter.com/jckarter/status/676939142790569986">Joe Groff</a></footer>
</blockquote>

**That's it for this week!** Stay tuned. And if you have suggestions for the next brief, [send me a link](https://twitter.com/jesse_squires).
