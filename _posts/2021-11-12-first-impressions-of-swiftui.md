---
layout: post
categories: [software-dev]
tags: [ios, macos, swiftui, swift]
date: 2021-11-12T10:57:01-08:00
title: First impressions of SwiftUI
---

I've spent this past week diving into [SwiftUI](https://developer.apple.com/xcode/swiftui/), seriously, for the first time. As you know, I've been [keeping my eye on it]({% post_url 2021-07-01-is-swiftui-ready %}) since it was released, but I've avoided it due to a combination of hesitancy, apprehension, and just being too busy with other projects and work. However, while taking some time off from contracting work, I decided to dive in.

<!--excerpt-->

I finally had an app idea for which SwiftUI would be well-suited. It's a small and simple utility app, essentially just a single view. It's multi-platform for iOS and macOS. I'm making it mostly for myself, but I do plan on releasing to both App Stores when finished. I thought this would be the perfect opportunity to experiment with SwiftUI. The risks are low. While I do consider this "a real app", the scope is incredibly narrow.

One of my objectives is to stay within the guard rails of SwiftUI, so to speak &mdash; stick with the defaults, do nothing fancy, avoid heavy UI customization, only use SF Symbols, no third-party dependencies, try to avoid UIKit unless absolutely necessary. Just a simple, vanilla app for both platforms. Another restriction is to deploy to the latest OS releases only &mdash; just iOS 15 and macOS 12 &mdash; to avoid all the potential issues with [previous versions of SwiftUI](https://jessesquires.github.io/TIL/apple_platform/swiftui.html#known-issues--workarounds).

I want to see what is possible with all of these constraints. That is, what can I achieve &mdash; and how fast &mdash; with this no-frills, vanilla development model? Firstly, I want to experience the unadulterated "happy path" of development, which I rarely encounter. Secondly, I want to see how far we've come since the earlier days of Xcode, iOS, and macOS. I started making apps in college with iOS 5 &mdash; it's been a decade!

Regarding the app, I will follow up with more posts in the coming weeks.

{% include break.html %}

Overall, it's been quite a pleasant experience. In fact, sometimes it feels like fucking magic. This is especially true when I realize I'm building _two_ apps at once for _two_ different platforms. I'm often delighted by how easy it is to build views, and how quickly I can build them &mdash; not just the static UI, but actual functionality as well. In UIKit, it's usually a two step process: (1) build a nice UI that does nothing, (2) hook it up to actually _do something_. In SwiftUI, this often becomes a single step because of [bindings](https://developer.apple.com/documentation/swiftui/binding), or at least the distinction between the two is blurred.

Some things in SwiftUI are so well done. Complex UI that used to be tedious to implement is suddenly effortless. I'm not just thinking about UIKit in its current state, which has improved and evolved tremendously over the years. I'm thinking about what it was like in iOS 5 as well. Take, for example, collapsible table view sections. That was not trivial to solve in iOS 5. In iOS 15, it is mostly effortless with [`UICollectionViewCompositionalLayout`](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout), but there is still a good amount of boilerplate. In SwiftUI, you merely need a [`DisclosureGroup`](https://developer.apple.com/documentation/swiftui/disclosuregroup). That really is incredible.

However, SwiftUI comes with caveats &mdash; [which I've covered previously]({% post_url 2021-07-01-is-swiftui-ready %}). There are some sharp corners and unexpected behaviors. The moment you wish to break away from the defaults and do any customization, you start to hit walls. (Thus, my constraints for this project.) However, I even face issues when trying to implement simple functionality that I've written in UIKit dozens or hundreds of times, only to discover that functionality is simply missing from SwiftUI.

{% include break.html %}

The other prominent aspect of working with SwiftUI is the learning curve. Sometimes it feels very odd coming from my very experienced background with UIKit. In UIKit, I'm a native speaker. SwiftUI is familiar enough that it's like learning a new grammar, but not _that new_. I find myself either surprised at how easy something was, or frustrated that it is simply missing from the API.

Unfortunately, API discoverability and documentation are a nightmare. With UIKit, you can typically type `.` after any instance, partially type the name of a member you are looking for, and find it quickly in the auto-complete list &mdash; or you can just browse what is available. This does not happen reliably with SwiftUI. Auto-complete is frequently populated with members and modifiers that simply don't work in the given context. Often documentation is sparse, and it is difficult to answer the question "How do I do `X` from UIKit in SwiftUI instead?" solely using Apple-provided resources. I am grateful for the [extensive resources provided by the community](https://jessesquires.github.io/TIL/apple_platform/swiftui.html).

{% include break.html %}

Despite these issues I find SwiftUI enjoyable to use overall and often find it easier than UIKit and AppKit &mdash; at least once I figure out the right way to do something in SwiftUI. But I think my feelings are heavily influenced by the constraints and simplicity of this specific project, namely, not having to worry about deploying to previous OS releases.

Ultimately, I agree with [Steve Troughton-Smith's advice](https://twitter.com/stroughtonsmith/status/1443692971187130373) that SwiftUI is great for auxiliary, non-critical UI layouts but beyond that it does not meet the bar for complex, reliable apps. Even with my small project, I have had to make a few UI/UX compromises that I would not have had to make in UIKit &mdash; and I would not have shipped these compromises in a more serious app. I have other app ideas and other apps in-progress for which I **will not** be using SwiftUI, not only because I want to deploy to earlier OS releases but because I also need more than what SwiftUI currently offers.

Still &mdash; after this week of SwiftUI development, it is clear to me that SwiftUI **will eventually** be _The Future&trade;_ &mdash; but it is not there yet. SwiftUI continues to trail far behind UIKit, but I am looking forward the day it catches up.
