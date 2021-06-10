---
layout: post
categories: [software-dev]
tags: [macos, apps, mac-app-store]
date: 2019-09-03T10:00:00-07:00
title: Introducing Red Eye
subtitle: Another menu bar app for macOS
image:
    file: redeye-app.jpg
    alt: 'Red Eye'
    half_width: false
---

I recently released a menu bar Mac app called [Red Eye](https://www.hexedbits.com/redeye/). It's free and you can [download it here](https://www.hexedbits.com/redeye/). It prevents your Mac from going to sleep. Yes, it is a clone of the beloved [Caffeine](http://lightheadsw.com/caffeine/). And yes, it is [the second menu bar app]({% post_url 2019-03-26-introducing-lucifer %}) that I've made recently. It is [notarized](https://developer.apple.com/documentation/security/notarizing_your_app_before_distribution) by Apple, so you shouldn't have any problems installing it. I hope you enjoy it!

<!--excerpt-->

{% include post_image.html %}

These menu bar app projects are relatively quick to execute. I love designing and writing a **good** app with a personality. I enjoy the whole process of refining the app itself, designing its icon, building its website, and releasing it. This and [Lucifer](https://www.hexedbits.com/lucifer/) were small weekend projects, but they taught me a lot about Mac development. More importantly, they were **fun**.

[Caffeine](http://lightheadsw.com/caffeine/) came first and I've used it for years, but it hasn't been updated since macOS 10.4 Tiger. I know there are a dozen other similar Mac apps out there. Aside from wanting to do this on my own, I thought I could do it better. I think most of these other apps are over-engineered. They have complicated menus, too many settings, and unnecessary scheduling options. I don't want any of that &mdash; only a simple on/off toggle, so that's what Red Eye does. I also think most of these other apps have boring or bad names and ugly icons.

{% include break.html %}

Unfortunately, Red Eye was rejected from the Mac App Store. I wanted to distribute there, as well as independently. The first reason was a [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/macos/overview/themes/) violation, because you have to right-click Red Eye in the menu bar to open the menu to quit the app, which reviewers said is "confusing to users". I think that's debatable. The second reason for rejection was for "duplicate functionality that already exists in the Mac App Store", which I think is bullshit and arbitrary. I counted three dozen Markdown editors in the Mac App Store before I got tired of scrolling through the search results. It is especially frustrating when the Mac App Store is still [full of fucking scams](https://www.howtogeek.com/281849/dont-be-fooled-the-mac-app-store-is-full-of-scams/).
