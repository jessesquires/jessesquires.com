---
layout: post
categories: [software-dev]
tags: [app-store, mac-app-store, ios, macos, apple, screenshots, wwdc]
date: 2024-07-04T11:55:25-07:00
title: Our App Store screenshot nightmare is (almost) over
---

I previously wrote about how the requirements for [screenshots on the App Store have become increasingly burdensome over the years]({% post_url 2024-01-16-app-store-screenshot-requirements %}). It is truly a nightmare. But today I have good news to share! Our nightmare is coming to an end, as changes to screenshot requirements were announced at WWDC24 this year.

<!--excerpt-->

App Store Connect is getting an update and **only one set of screenshots will be required** for iPhone and iPad! This news was somewhat buried toward the end of the session, [_What’s new in App Store Connect_](https://developer.apple.com/wwdc24/10063). Unfortunately, it was only a brief bullet point with no extra details --- but I'll take it. It's not clear _which_ devices will be allowed for a single set of screenshots, but it will likely be one of the larger device sizes for both iPhone and iPad from the latest models.

It also is not clear _when_ these changes will take effect in App Store Connect. Currently, the old requirements remain. I suspect that App Store Connect updates will coincide with the final releases of iOS 18 and macOS 15 later this year. So, we've got a few months to wait.

What about macOS screenshots? There are [problems there, too]({% post_url 2024-01-16-app-store-screenshot-requirements %}) --- specifically the allowed sizes and aspect ratios. Unfortunately, it looks like the existing requirements for macOS screenshots will remain. At least we made progress on iOS.

{% include break.html %}

There were some other welcome changes announced in [_What’s new in App Store Connect_](https://developer.apple.com/wwdc24/10063).

- More opportunities to get your app discovered via "Featuring Nominations"
- TestFlight is getting an updated invitation experience and criteria for public links that allow you to restrict invites to things like specific devices and operating systems
- Deep links to custom product pages
- A new "Promote Your App" feature to help you generate marketing assets
- Notifications when your app gets featured on the App Store (another _"finally!"_)
