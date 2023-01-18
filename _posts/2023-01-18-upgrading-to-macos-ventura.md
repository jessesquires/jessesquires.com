---
layout: post
categories: [software-dev]
tags: [macos, macos-ventura]
date: 2023-01-18T13:14:59Z
title: Upgrading to macOS Ventura
---

I finally upgraded to macOS Ventura recently --- about a month ago. As usual, I waited until the first point release, 13.1 (22C65). Although I have experienced few severe issues with upgrading over the past few years, a couple of bad experiences and others' reports of bugs leave me skeptical and apprehensive each year. I miss the old days of OS X when I would upgrade on day one without any concerns at all.

<!--excerpt-->

I made a backup before upgrading, just in case. However, installing Ventura went surprisingly smooth for me! I did not have any problems and nothing broke! I was pleasantly surprised and relieved. And, after about a month of usage, everything seems fine.

{% include break.html %}

One of the first things I do after upgrading is open "About This Mac" to check that the install succeeded. I was horrified by the new UI for this --- absolutely atrocious and a major regression from previous versions in my opinion.

The main reason I upgraded was to be able to turn on ["Advanced Data Protection for iCloud"](https://support.apple.com/en-us/HT202303#advanced), which enables end-to-end encryption for the majority of iCloud data. My iOS devices were already updated to iOS 16.2, but enabling this feature requires all devices to be on the latest OSes.

{% include break.html %}

MacRumors [has a great roundup of features and improvements](https://www.macrumors.com/guide/macos-ventura-features/), all of which I appreciate. The improvements to Mail.app, Messages.app, Photos.app, and Maps.app are all very welcome.

I like having the new Weather.app and Clock.app (a true _"finally!"_), even though they do not feel like native Mac apps. Generally, the built-in Mac Catalyst apps continue to be a major annoyance and extremely cumbersome to use. They do not behave like native AppKit apps and omit very basic features and functionality that typical users expect. For example, on Messages.app you **still cannot** use the `delete` key to delete a message thread. The inconsistency of these little quirks drives me fucking crazy.

Every time I take a video call, Continuity Camera would activate by default on my iPhone which is always nearby. I do not care to use this feature as the built-in webcam is fine for me, but I could not figure out how to disable this initially. Searching in System Settings provided no results. I eventually [figured out](https://allthings.how/how-to-disable-continuity-camera-between-your-iphone-and-mac/) that the setting to disable it is on iOS instead.

My biggest complaint is the new System Settings (née System Preferences) redesign, which is absolutely terrible. It is so slow and glitchy. More importantly, it is so difficult to use! There are so many regressions and usability issues I don't know where to begin. It feels like a half-baked intern project. Luckily, my friend Jeff Johnson covered all the problems in-depth [here](https://lapcatsoftware.com/articles/SystemSettings.html) and [here](https://lapcatsoftware.com/articles/SystemSettings2.html). I hope Apple eventually addresses all the problems, but I doubt they will.
