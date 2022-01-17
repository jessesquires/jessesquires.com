---
layout: post
categories: [software-dev]
tags: [ios, apple, app-library, bugs]
date: 2022-01-11T16:16:03-08:00
title: iOS App Library is drunk
---

As I [wrote previously]({% post_url 2021-06-01-ios-14-app-library %}), I really like iOS App Library. Automatically organize all of my apps for me? Yes, please and thank you. However, I've recently experienced some bizarre bugs with it in iOS 15.

<!--excerpt-->

A common complaint about iOS App Library is that the categories are not alphabetical. This doesn't bother me --- for example, putting "Productivity" at the top and "Games" at the bottom --- I like this, as long as they are ordered consistently. But this has been a problem for me lately. Periodically, **the order of folders in App Library changes**. Why?! It is incredibly disorienting. I'm not sure if this is a bug or a "feature" where recently-used or most-used categories move toward the top? The order of category folders should always be fixed.

The second major issue I've seen lately: sometimes **apps change categories**. The other day, Duolingo suddenly moved from "Education" to "Other", along with a few other bizarre moves. This certainly seems like a bug, but I really don't understand how this could happen. Presumably, these categories are based on the App Store categories that developers select for their apps, and which are part of an app's metadata. Apps should only change categories if the developer changes the app metadata.

All of this moving around seems to defeat the entire purpose of App Library, no? Is it not intended to organize your apps in a coherent and easy-to-find way?

I think this feature has so much potential, it's a shame that it's so buggy. The good news is that pulling down to view all apps in a single alphabetical list works as expected, as does Spotlight search --- which is what I use most often. Despite the bugs, I still have no desire to return to manually organizing my apps into my own folders. _That_, to me, is even worse.
