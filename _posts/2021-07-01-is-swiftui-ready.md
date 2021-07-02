---
layout: post
categories: [software-dev]
tags: [swift, swiftui, wwdc, uikit, ios, macos]
date: 2021-07-01T17:31:30-07:00
title: Is SwiftUI ready?
---

I've been following what's going on with [SwiftUI](https://developer.apple.com/xcode/swiftui/) since it was released with iOS 13 at [WWDC 2019](https://developer.apple.com/videos/wwdc2019) and have even [taken extensive notes](https://jessesquires.github.io/TIL/apple_platform/swiftui.html), but I have avoided using it. As I [wrote before]({% post_url 2021-04-07-resources-for-learning-swiftui %}), I mainly wanted to avoid dealing with bugs and workarounds that might make me less productive compared to using UIKit, which I know quite well. I'm very interested in learning and using it, I'm just hesitant given some of Apple's history, like early years of Swift. I have no doubt that SwiftUI will be the future of Apple platform development, the question is when that future will arrive. This year the framework is debuting its third major release in iOS 15. How far has SwiftUI come, and is it ready for building serious apps?

<!--excerpt-->

### Poll results

I decided to ask the Apple developer community on Twitter for their thoughts. [In a poll](https://mobile.twitter.com/jesse_squires/status/1409641586313469978), I asked folks who have experience with SwiftUI if they thought the framework was ready for building entire apps &mdash; for serious projects, not hobby projects. I broke it down between macOS and iOS, since the API coverage is different per platform. Here are the results, with 737 people participating:

- Yes, SwiftUI is _absolutely_ ready on both platforms: **30.7%**
- SwiftUI is ready for iOS only: **23.1%**
- SwiftUI is ready for macOS only: **0.5%**
- SwiftUI is _not ready_ to use: **45.7%**

In hindsight, I probably should not have had the platform-specific options, since most Apple platform developers _only_ develop for iOS. In any case, it feels like a decent gut check for how the community views the state of the framework. I also acknowledge that Twitter polls are not very scientific and not everyone uses Twitter. Given all of that, I think it is fair to say that the conclusion is roughly 50-50. Half of developers are onboard with using SwiftUI, the other half would prefer to avoid it.

_Thank you to everyone who participated in the poll and discussion on Twitter, I really appreciate it!_

### What should you expect?

There was also a lot of discussion [on the Twitter thread](https://mobile.twitter.com/jesse_squires/status/1409641586313469978), which I will attempt to distill and summarize here, along with other comments and resources from the community.

{% include break.html %}

The overwhelming consensus seems to be that SwiftUI is not quite mature enough to write entire apps with it &mdash; that is, _100% pure SwiftUI™_. The reason is two-fold. First, the APIs might be missing, and thus you have to walk across the bridge to UIKit. Second, you may find bugs or occasional performance issues that require going back to UIKit. Despite this, for the scenarios and use cases in which SwiftUI works well, it works **very well** &mdash; it _shines_.

SwiftUI can make development significantly faster. The trade-offs are worth it.

You will definitely have to be comfortable with mixing SwiftUI and UIKit. Apps written in 100% SwiftUI are likely a few years away.

{% include break.html %}

The multi-platform capabilities seems even less ready, specifically the macOS APIs appear to get less attention. In my experience with multi-platform example apps, some APIs did not behave as I expected on macOS, producing some odd results.

{% include break.html %}

One of the largest barriers for adoption (or for increasing one's existing adoption) is the yearly release cycle of SwiftUI. It is difficult to wait an entire year for new APIs and bug fixes. It sounds like iOS 13 was particularly difficult for SwiftUI, but iOS 14 significantly refined it, and in iOS 15 [there are _a ton_ of new APIs](https://developer.apple.com/videos/play/wwdc2021/10018/).

[Steve Troughton-Smith](https://mobile.twitter.com/stroughtonsmith/status/1404169506063360004):
> It feels hard to justify SwiftUI’s yearly cycle when it’s just exposing pre-existing capabilities in UIKit & AppKit, and it makes the lack of back-deployment really painful. [...] Take something like the new sheet style added in iOS 15: it’s not currently exposed to SwiftUI [...]

There's a good breakdown and comparison of APIs between SwiftUI and UIKit at [Fucking SwiftUI](https://fuckingswiftui.com), by [Sarun Wongpatcharapakorn](https://sarunw.com).

{% include break.html %}

What approach should you take in architecting your app? After discussing [with Noah Gilmore](https://mobile.twitter.com/noahsark769/status/1409733170736492548), it sounds like a good idea is to write your App Delegate in UIKit, as well as handle navigation in UIKit. In other words, you have a UIKit shell and SwiftUI core &mdash; or at least use SwiftUI where possible. [Noah also suggests](https://mobile.twitter.com/noahsark769/status/1409858095816138757) trying to build a view in SwiftUI first, then fall back to UIKit if it doesn't work out. Most of the time, it works out fine.

The "UIKit shell" approach seems like the best of all worlds to me. I know the frameworks are intended to interoperate, but something about starting with a UIKit App Delegate (or Scene Delegate) seems like a more reliable foundation. If anything, it is certainly more comforting. It's like you have the maturity and familiarity of UIKit without feeling entirely committed to SwiftUI from the start. Intuitively, having a "UIKit shell" sounds like it would make it much easier to back out of SwiftUI when necessary.

One idea I had was to start writing table view or collection view cells in SwiftUI. That seemed like a reasonable, controlled way to start introducing SwiftUI code into a code base. It turns out, this can be [tricky to do](https://noahgilmore.com/blog/swiftui-self-sizing-cells/) and then SwiftUI cells cannot provide all the same functionality as using UIKit. This might be ok, depending on your needs. Otherwise, you may want to either fully commit to SwiftUI's `List` or UIKit's `UITableView` for certain features in your app.

{% include break.html %}

You should expect to [hack around corners and rough edges](https://jessesquires.github.io/TIL/apple_platform/swiftui.html#known-issues--workarounds). You should expect that you need to drop into UIKit a non-trivial amount. Particularly problematic, buggy, or lacking APIs seem to center around application lifecycle and navigation.

[`App`](https://developer.apple.com/documentation/swiftui/app) does not support the same amount of power and flexibility as `UIApplicationDelegate`. However, you are able to use these two components together, [as John Sundell points out](https://www.swiftbysundell.com/tips/using-an-app-delegate-with-swiftui-app-lifecycle/).

The [`NavigationView`](https://developer.apple.com/documentation/swiftui/navigationview) and [`NavigationLink`](https://developer.apple.com/documentation/swiftui/navigationlink) APIs are limited and fall short of what UIKit provides. Omar's post on [Abstracting Navigation in SwiftUI](https://obscuredpixels.com/abstracting-navigation-in-swiftui) provides a good overview of the issues, and provides some techniques for how to wrap the API and provide your own navigation layer.

The [`LazyVGrid`](https://developer.apple.com/documentation/swiftui/lazyvgrid) and [`LazyHGrid`](https://developer.apple.com/documentation/swiftui/lazyhgrid) APIs seem quite lacking compared to the power of [UICollectionViewCompositionalLayout](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout), based on example code I've seen from Apple and the documentation. However, there are [techniques for composing complex interfaces](https://developer.apple.com/tutorials/swiftui/composing-complex-interfaces).

{% include break.html %}

There is a significant lack of documentation. I'm not talking about API documentation, as much as conceptual documentation. See Howard Oakley's post, [The elephant at WWDC](https://eclecticlight.co/2021/06/13/last-week-on-my-mac-the-elephant-at-wwdc/):

> But trying to grok major topics like Attributed Text simply isn’t possible by referring to individual functions within the API. You first need to get your head around how sub-systems are designed and function, the conceptual information which Apple was once so good at providing. Good conceptual documentation is structured and written quite differently from that for classes and functions with an API, as Apple well knows.

Howard is discussing Apple's [documentation problem](https://nooverviewavailable.com) as a whole. However, the lack of conceptual documentation for a framework like SwiftUI is particularly detrimental. And we currently have to rely on [individual investigations and experimentation](https://www.objc.io/blog/2020/11/10/hstacks-child-ordering/) to derive information on how it works internally.

{% include break.html %}

Finally, SwiftUI still has a long way to go in some respects. It will be chasing UIKit for years to come.

Transcripts are available from the [SwiftUI Q&A lounges at WWDC](https://roblack.github.io/WWDC21Lounges/) that you can read through. (Thanks [Emin Roblack](https://github.com/roblack/WWDC21Lounges) and [Marcos Griselli](https://github.com/marcosgriselli/wwdc21-lounges).)

[Steve Troughton-Smith](https://mobile.twitter.com/benjamincrozat/status/1404168247444914176):

> These Q&As this year are a great resource, though some of the exchanges really highlight how far SwiftUI has still to go.
>
> No ability to set table background color, no way to change the status bar style, none of the new sheet styles, no customizing interval of time pickers...

These API limitations will start to diminish eventually, but the yearly release cycle makes it more difficult for SwiftUI to catch up to UIKit.

{% include break.html %}

I hope this was helpful for folks who are, like me, trying to consider if and how much you should start using SwiftUI. If you are targeting iOS 14 and above, or especially iOS 15, it sounds like now is a great time to start experimenting. Let me know if I should add anything else to this post!
