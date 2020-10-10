---
layout: post
categories: [software-dev]
tags: [swift, open-source]
date: 2015-12-06T10:00:00-07:00
title: Swift open source
subtitle: Let the revolution begin
image:
    file: swift-logo.png
    alt: Swift
    caption: null
    source_link: null
    half_width: false
---

It has only been a few days since the announcement of [Swift going open source](https://developer.apple.com/swift/blog/?id=34) and the activity around the project has been incredible. When Apple revealed that Swift would be open source at [WWDC](https://developer.apple.com/wwdc/) earlier this year, I do not think anyone anticipated a release like this.

<!--excerpt-->

{% include post_image.html %}

### Expectations

No one really knew what to expect. Was Swift going to be dumped on [opensource.apple.com](http://www.opensource.apple.com) and grow stale with the other projects? Would it be put on GitHub like [ResearchKit](https://github.com/ResearchKit)? Not only is Swift on [GitHub](https://github.com/apple/), but the Swift team will be [working completely in the open](http://arstechnica.com/apple/2015/12/craig-federighi-talks-open-source-swift-and-whats-coming-in-version-3-0/). Apple did a spectacular job with the release. Not only do we have the source code, but we have the [entire commit history](https://github.com/apple/swift/commits/master) for each project, a very detailed view into the Swift team's development process, and access to the [Swift evolution process](https://github.com/apple/swift-evolution). Everything you need to know is on [Swift.org](http://swift.org).

### Swift in the open

For the past few days I have been watching the repositories on [GitHub](https://github.com/apple/) and the Swift [mailing lists](https://swift.org/community/#mailing-lists). It is fascinating. The question is, what will Swift development look like moving forward? Here are some of the interesting things I have seen so far.

- Chris Lattner's [first commit](https://github.com/apple/swift/commit/18844bc65229786b96b89a9fc7739c0fc897905e) was on July 17, 2010.

- The main [Swift repo](https://github.com/apple/swift) surpassed 10,000 stars in the first 24 hours. It now has more than 19,000 stars along with over 2,000 forks. As of this writing, it is still in the #1 spot on GitHub's [trending](https://github.com/trending) page.

- There has been close to ~400 pull requests across all of the repos. Many of them accepted and merged.

- After the initial Swift announcement at [WWDC 2014](https://developer.apple.com/videos/play/wwdc2014-402/), I think we all noticed how active the Swift team was on twitter, answering questions and more &mdash; [Chris Lattner](https://twitter.com/clattner_llvm), [Joe Groff](https://twitter.com/jckarter), and [Jordan Rose](https://twitter.com/UINT_MIN) to name a few. Turns out some tweets [resulted](https://github.com/apple/swift/commit/666646fee95bc75ca81e1dc5131989d56bfb0742) in *immediate* bug fixes!

- Remember that [partnership](https://www.apple.com/pr/library/2014/07/15Apple-and-IBM-Forge-Global-Partnership-to-Transform-Enterprise-Mobility.html) with [Apple and IBM](http://www.apple.com/business/mobile-enterprise-apps/)? Then it should not be a surprise that IBM seems to be [very invested](https://developer.ibm.com/swift/2015/12/03/introducing-the-ibm-swift-sandbox/) in server-side Swift. It looks like there is growing momentum behind using Swift on the server.

- Chris Lattner is [merging pull requests](https://github.com/apple/swift/pull/166) at 10pm on Saturday.

- We know exactly [what to expect](https://github.com/apple/swift-evolution) for Swift 3.0! No more keynote surprises.

- The [++ and -- operators will be removed](https://github.com/apple/swift-evolution/blob/master/proposals/0004-remove-pre-post-inc-decrement.md) from Swift 3.0. And thanks to [Erica Sadun](https://twitter.com/ericasadun), so will [C-style for-loops](https://github.com/apple/swift-evolution/blob/master/proposals/0007-remove-c-style-for-loops.md). She submitted this proposal on day two!

- Chris Lattner [commits](https://github.com/apple/swift/commit/22c3aa0588d2df1a207dcbad85946bab7976894c) *"Pull some ancient history off an internal wiki page for possible historical interest."* What?! Yes please! Nerd alert.

- The collection of [swift-compiler-crashes](https://github.com/practicalswift/swift-compiler-crashes) from [@practicalswift](https://twitter.com/practicalswift) has been [part of the repo](https://github.com/apple/swift/commit/e5ca8be1a090335d401cd1d7dfcf9b2104674d5b) since September 2014.

- It looks like there's a [good chance](https://github.com/apple/swift-evolution/pull/33/files) that `typealias` will be replaced with `associated` for associated type declarations.

- [Jacob Bandes-Storch](https://twitter.com/jtbandes) has [submitted](https://github.com/apple/swift/pull/253) [two](https://github.com/apple/swift/pull/272) pull requests that fix a total of over 400 crashes.

- The Swift team seems [very keen](https://twitter.com/clattner_llvm/status/673162286127714304) on getting the community involved. No contribution is too small!

- Much of the [swift-corelibs-foundation](https://github.com/apple/swift-corelibs-foundation) framework is currently [unimplemented](https://github.com/apple/swift-corelibs-foundation/search?q=NSUnimplemented). There seems to be a lot of low hanging fruit. I wonder if this is intentional to encourage contributions, or if it is the result of a tight deadline?

- The [initial checkin](https://github.com/apple/swift/commit/afc81c1855bf711315b8e5de02db138d3d487eeb) from 2010 was actually revision 4 and imported from an internal SVN repo. "Swift SVN r4". You will notice the following in the header comments: *"This source file is part of the Swift.org open source project. Copyright (c) 2014 - 2015 Apple Inc."* I have three theories:
      1. Commit history was edited and cleaned up before being published on GitHub.
      2. In 2010, the Swift team's deadline was "2014-2015", *no matter what*. This seems like a very Apple thing to do and explains Swift's "rough around the edges" arrival.
      3. Chris Lattner is a wizard.

I think we're definitely off to a good start. The community is strong and excited, and Swift is *already* greatly improved in **only three days**. As Lattner says, *the revolution will be Swift!*

That's all I've got for now! If you enjoyed this article, [let me know](https://twitter.com/jesse_squires). Maybe I'll keep creeping and sharing what I find.
