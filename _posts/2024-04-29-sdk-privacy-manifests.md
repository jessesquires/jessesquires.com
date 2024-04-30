---
layout: post
categories: [software-dev]
tags: [xcode, apple, ios, app-store, privacy]
date: 2024-04-29T13:37:26-07:00
date-updated: 2024-04-30T09:53:30-07:00
title: The curious case of Apple's third-party SDK list for privacy manifests
---

At last year's WWDC, Apple [introduced privacy manifests](https://developer.apple.com/videos/play/wwdc2023/10060/). They recently sent out [a reminder](https://developer.apple.com/news/?id=pvszzano) that the deadline for complying with these new requirements is May 1. Privacy manifests expand on the previously introduced [privacy "nutrition labels"](https://www.theverge.com/2020/11/5/21551926/apple-privacy-developers-nutrition-labels-app-store-ios-14) that are self-reported by developers and displayed on the App Store. Developers must start including a privacy manifest in their apps by the aforementioned deadline, but what's more interesting is that Apple is, for the first time, imposing these new privacy rules on third-party SDKs as well. Even more interesting is [the list of SDKs](https://developer.apple.com/support/third-party-SDK-requirements/) that Apple has published, which, upon inspection is quite bizarre.

<!--excerpt-->

Historically, Apple has rarely, if ever, explicitly acknowledged _any_ third-party SDK or library. It took years for them to even acknowledge community tools like CocoaPods in Xcode's release notes (usually when they made a change that broke it). Thus, it is interesting to see which SDKs they have deemed important or concerning enough to explicitly mandate a privacy manifest. And, in typical Apple fashion, I'm pretty sure SDKs authors were _not_ notified about this in advance. We all learned which SDKs need privacy manifests at the same time --- _when the list was published_.

The first few entries in the list make sense:

- [Abseil](https://github.com/abseil/abseil-cpp), a low-level C++ library.
- [AppAuth](https://github.com/openid/AppAuth-iOS), an SDK for communicating with OAuth 2.0 and OpenID Connect providers.
- [AFNetworking](https://github.com/AFNetworking/AFNetworking) and it's successor [Alamofire](https://github.com/Alamofire/Alamofire), networking libraries that wrap Apple's APIs, which almost every iOS developer has encountered.
- [BoringSSL](https://github.com/google/boringssl), a fork of OpenSSL maintained by Google.

I can see how these libraries could be concerning with regard to user privacy, they are all dealing with networking, authentication, and security (except for Abseil) --- these are common vectors for privacy-related issues. Abseil is the exception, but I could see an argument for why a low-level C++ library _might_ be a concern. There are also a lot of SDKs from Google and Facebook on the list --- neither of those companies have a particularly good reputation when it comes to user privacy. It makes sense for those to be included.

But then... you see that the list contains UI libraries that haven't seen significant updates or any activity for multiple years, like [SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD). Why does a library that provides a single UI component need a privacy manifest? Is it as concerning and as potentially privacy invasive as the Facebook SDK? Some of the UI-only SDKs on the list haven't seen significant updates (or any updates at all) within the last 4-5 years. Furthermore, even AFNetworking hasn't had an update in **4 years** because it was deprecated long ago after being supplanted by Alamofire. The [AFNetworking repo on GitHub](https://github.com/AFNetworking/AFNetworking) has been archived and read-only for **over a year**! Who's going to bother adding a privacy manifest to that?

And then... there are some entries that are simply obscure and absurd: connectivity_plus, image_picker_ios, video_player_avfoundation, file_picker. What the hell are those?! They don't even sound like SDK or library names. I have never heard of any of these, and I've been involved in the iOS open source community for a decade.

And then... you know what's _even more_ bizarre about [this list](https://developer.apple.com/support/third-party-SDK-requirements/)? There are no links! **There are no links to the SDK project homepages or GitHub repos.** It is a plain text list of names, and in some cases, seemingly random names like "file_picker". Ok LOL. SDK and library names are not _necessarily_ unique. How are you supposed to know exactly which SDKs they are referencing with so little information? Searching for "file_picker" or "image_picker_ios" or any of the other obscure names on both [CocoaPods](https://cocoapods.org) and the [Swift Package Index](https://swiftpackageindex.com) returns **no results**!

Finally, wouldn't you expect some sort of reason or justification for each of these SDKs being on the list? We don't need a 10-page essay but a brief explanation of a few sentences explaining _why_ each of these SDKs is on the list would be helpful in understanding the logic and reasoning behind it.

Nothing about [this list](https://developer.apple.com/support/third-party-SDK-requirements/) makes any sense.

{% include updated_notice.html
date="2024-04-30T09:53:30-07:00"
message="
As many readers have pointed out, there are also a number of popular SDKs that really _should_ be on this list if Apple is concerned about privacy. For example, the [TikTok SDK](https://developers.tiktok.com/doc/getting-started-ios-download/), [GoogleAds](https://developers.google.com/admob/ios/download), and the [Unity Ads SDK](https://docs.unity.com/ads/en-us/manual/InstallingTheiOSSDK) are all missing from [the list](https://developer.apple.com/support/third-party-SDK-requirements/), just to name a few. How strange!

And apparently, all of the obscure SDK names like \"file_picker\" are actually [Flutter](https://flutter.dev) packages. Again, what an odd list!
" %}

{% include break.html %}

For a company that has positioned itself as a staunch privacy advocate, this list of SDKs is slapdash at best. The lack of attention to detail, like simply including links to SDK homepages, makes the list appear like it was assembled hastily and carelessly. It makes you wonder, _how was this list compiled?_ What was the criteria for including or excluding an SDK from this list?

I was venting about the list on Mastodon, and the general consensus is that it was most likely just a script dump from a static analysis of app binaries on the app store, with the sole criterion being "what are the most popular libraries" used across all apps, with some minimum threshold for inclusion. It is quite clear from the list that no one at Apple really put much thought into it. &#x1F921;

If we operate under the hypothesis that this list is merely the output of a script that someone at Apple wrote to check off the line item _"determine which third-party SDKs should be required to included privacy manifests"_, then it all starts to make more sense. This list is ultimately the result of a popularity contest, not a thoughtful analysis of SDKs that have meaningful implications for user privacy. They couldn't even bother to link to the projects or provide brief explanations. There's literally an entry titled "file_picker" with no other explanation. Did anyone at Apple even look into any of these libraries? Did anyone at Apple even read through this list after some script vomited it out?

When Apple imposes new privacy regulations in such a slipshod manner, how are we, as developers and as users, supposed to take this seriously? This feels like more bureaucratic security and privacy theater. Let's all take off our shoes and throw away sealed bottles of water we purchased at the airport before we proceed through the TSA security checkpoint --- meanwhile doors and wheels are falling off the damn plane.
