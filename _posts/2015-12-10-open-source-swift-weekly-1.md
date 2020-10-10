---
layout: post
categories: [software-dev]
tags: [swift, open-source]
date: 2015-12-10T10:00:00-07:00
title: "Open source Swift&#58; weekly brief"
subtitle: What's been happening during the first full week on Swift.org?
---

It looks many developers in the community enjoyed my [previous post]({{ site.url }}{% post_url 2015-12-06-swift-open-source %}) detailing my thoughts and observations on the activity around the [Swift open source project](https://swift.org). So, I'm going to try to do this weekly &mdash; every Thursday, since the open source announcement was on a Thursday. Each week I'll provide a high-level summary of what's been happening, updates on interesting statistics, and links to interesting content. If you have any suggestions, please [let me know]({{ site.social_links.twitter }})! And now, the weekly brief!

<!--excerpt-->

### This week on Swift.org

- [Manav Gabhawala](https://twitter.com/ManavGabhawala) submitted an [interesting proposal](https://github.com/apple/swift-evolution/pull/37) to add implicit initializers to Swift. In particular, this would address the verbosity of converting between number types. However, as pointed out on the [mailing list discussion](https://lists.swift.org/pipermail/swift-evolution/2015-December/000352.html) there are safety and precision concerns.

- [Alex Denisov](https://twitter.com/1101_debian) submitted a [pull request](https://github.com/apple/swift/pull/295) that fixes 323 crashes.

- Not very good at [using git](https://github.com/apple/swift-evolution/pull/39)? Worry not! Lots of [cool people](https://github.com/apple/swift-evolution/pull/34#issuecomment-162693826) aren't that great at using it either. The message here: do not let this deter you from contributing!

- Chris Lattner tends to [fix](https://github.com/apple/swift/commit/4ebb461d634964f0399d63b3264d4090451c77fd) [radars](https://github.com/apple/swift/commit/5dded3f3523e9bd6ea45d0b6ffe5068a59d03a3f) late at night.

- [Brian Gesiak](https://twitter.com/modocache), creator of [Quick](https://github.com/Quick/Quick), asks [*who tests the tests?*](https://lists.swift.org/pipermail/swift-corelibs-dev/2015-December/000018.html) after noticing that the [xctest](https://github.com/apple/swift-corelibs-xctest) framework isn't itself tested. Testing a testing framework sounds funny, but some important [bugs](https://github.com/apple/swift-corelibs-xctest/commit/ce4c98bc58763d49db474703d005ba9c479cac3a) have already been found. [FIXME](https://github.com/apple/swift/blob/b53ff3b58053407f380d09770d2e2069e02d6ff5/utils/build-script-impl#L1957).

- In case you missed it, currying [will be removed](https://github.com/apple/swift-evolution/blob/master/proposals/0002-remove-currying.md) from Swift 3.0. ([What is currying](https://robots.thoughtbot.com/introduction-to-function-currying-in-swift)?)

- [David Owens](https://twitter.com/owensd) submitted a [proposal](https://github.com/apple/swift-evolution/pull/26) to add type annotations to `throws`. When Swift's error-handling model was first announced, the lack of explicit error types was a common criticism. There's a [good discussion](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20151207/001117.html) on the mailing list. You can also read the original [Error Handling Rationale and Proposal](https://github.com/apple/swift/blob/master/docs/ErrorHandlingRationale.rst).

- Swift now has almost 200 [contributors](https://github.com/apple/swift/graphs/contributors) and over 230 pull requests have been [merged](https://github.com/apple/swift/pulls?q=is%3Apr+is%3Amerged+).

- Last week I mentioned that [Foundation](https://github.com/apple/swift-corelibs-foundation) was largely [unimplemented](https://github.com/apple/swift-corelibs-foundation/search?q=NSUnimplemented). There's also some *really* surprising [bugs](https://github.com/apple/swift-corelibs-foundation/pull/89/files).

- [Andrew Naylor](https://github.com/argon) ambitiously implements [NSJSONSerialization](https://github.com/apple/swift-corelibs-foundation/pull/54).

- [Jacob Bandes-Storch](https://twitter.com/jtbandes) submitted a [proposal](https://github.com/apple/swift-evolution/pull/44) that aims to greatly improve the bridging of C APIs.

- There's an [interesting discussion](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20151207/000873.html) on the mailing lists to make classes and methods `final` by default. Anything that discourages or prevents subclassing is [fine by me](https://twitter.com/jesse_squires/status/664588682997964800).

- The Swift Programming Language iBook (ePub) is available for *direct download* on Swift.org (instead of only the iBook Store) and is now under a [Creative Commons Attribution 4.0 International (CC BY 4.0) License](https://swift.org/documentation/)! Translations [would be great](https://twitter.com/clattner_llvm/status/674454905449373696).

- Programming is little more than a ["nights and weekends" hobby](https://twitter.com/clattner_llvm/status/674254974629502976) for Chris Lattner.

**That's it for this week!** [Subscribe]({{ site.url }}{{ site.feeds.rss }}) or [follow me]({{ site.social_links.twitter }}) to stay up-to-date!
