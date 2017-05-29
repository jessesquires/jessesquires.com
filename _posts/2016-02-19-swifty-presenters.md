---
layout: post
title: Swifty view controller presenters
subtitle: Talk at Realm in San Francisco
redirect_from: /swifty-presenters/
---

A few weeks ago, I spoke at [Realm](https://realm.io) in San Francisco at the Swift Language User Group ([#SLUG](https://www.meetup.com/swift-language/events/227833264/)) meetup. A [video of the talk](https://realm.io/news/slug-jesse-squires-swifty-view-controller-presenters/) is now online over at Realm's blog, where it is synced with my [slides](https://speakerdeck.com/jessesquires/swifty-view-controller-presenters). If you haven’t already seen it, go check it out!

<!--excerpt-->

### Thoughts

Realm's [transcript](https://realm.io/news/slug-jesse-squires-swifty-view-controller-presenters/) of the talk is excellent. They always do such an amazing job with these posts! 🙌

This talk examines the `UIPresentationController` API that was introduced in iOS 8 and explores ideas for making it more *swifty*. It isn't too technical, but these APIs are really interesting to me and can be really powerful. However, I feel like they are often overlooked. (Maybe this is because a lot of developers are still supporting iOS 7?) Where developers could utilize these APIs, they instead opt for view controller containment &mdash; which is often more cumbersome.

I'm formalizing these ideas from the talk (and possibly more!) in a new framework &mdash; [PresenterKit](https://github.com/jessesquires/PresenterKit). It is not quite finished, but when it is I will push it to [CocoaPods](https://cocoapods.org). Meanwhile, feel free to check it out. There is also an [example project](https://github.com/jessesquires/PresenterKit/tree/develop/Example), which includes all the code from the talk.

Overall, I think the talk was really well received. If you have any feedback, I would love to hear it. [Let me know!](https://twitter.com/jesse_squires) 😄

### Abstract

>One major shortcoming of UIKit is that view controllers have too many responsibilities. This talk focuses on one — presenting and dismissing view controllers — and how we can re-examine and redefine these common operations with a more Swifty API that reduces boilerplate and increases expressivity.

<img class="img-thumbnail img-responsive center" src="{{ site.img_url }}/yodawg-swifty-presenters.jpg" title="Swifty Presenters" alt="Swifty Presenters"/>
