---
layout: post
categories: [essays]
tags: [ios, apple, app-library]
date: 2021-06-01T12:07:38-07:00
title: iOS 14 App Library
---

I think [App Library](https://support.apple.com/en-us/HT211345) is one of the best features added to iOS in the past few years. I'm not being sarcastic, I know some folks dislike it. However, I absolutely loathe trying to organize apps on my phone into folders, because many apps do not have a singular, definitive category.

<!--excerpt-->

Do I put Calculator.app in my "Productivity" folder or in my "Utilities" folder? Does Slack belong in the "Social" folder or my "Work" folder? If I create a "Music" folder for Music.app, Spotify, and Bandcamp then should I also include Podcasts and NPR One &mdash; or should I create a generic "Audio" folder for all of the above? Does Voice Memos belong in the "Audio" folder or the "Productivity" folder? Do I put GarageBand in "Audio" or "Creativity"? Or instead, should I organize everything alphabetically? Or, god forbid, [organize apps by color](https://www.pinterest.com/pin/139330182196857288/)?

For me, this is a fucking nightmare. I'm sure I'm not the only person who finds this kind of "digital organization" overwhelming. And ironically, I almost always search for apps instead of tapping around in folders. So what's the point to begin with?! Well, I also cannot stand the chaos of having pages and pages and pages of apps _not organized_ into folders in _some way_.

And that's why I love and have fully embraced App Library &mdash; the apps are organized for me in a system that is coherent (enough) for me to not care too much about it. I now have a single page of apps that I use the most. Everything else goes to App Library. It is glorious.

I operate this way with most digital things. I would rather _search_, not _organize_. For example, I do not use folders or tags in email. Every email is either in my inbox, in the archive, or in the trash. No exceptions. Ain't nobody got time for that. If I need to find an email, I search.

### Improvements

App Library certainly solves a problem for me, but there is room for improvement for other users. A few months back, [Chris Hynes wrote some sarcastic, though fair, criticisms](https://techreflect.net/2021/01/09/is-app-library-ios-for-me/). As [Michael Tsai points out](https://mjtsai.com/blog/2021/01/11/is-ios-14s-app-library-for-me/), App Library does "break some rules" in terms of established UI paradigms &mdash; but it works well in practice. I think most of Chris's criticisms could be addressed with a few user-configurable options:

1. Let users define their own categories, or use the defaults
2. Provide an option for sorting: either "by relevancy" (the current default), or alphabetically
3. Let users choose to show or hide "Suggestions" and "Recently Added", perhaps with an option to show 8 Siri suggestions if "Recently Added" is turned off

I only have one major complaint about the existing folders &mdash; why is there no "Developer" category? Currently, App Store Connect and TestFlight are placed in "Utilities" while the Apple Developer (née WWDC) app is in "Information & Reading". Furthermore, non-App Store apps (ad-hoc, side-loaded, etc.) are categorized under the developer account name. For example, if I'm working on an app it gets placed in a "Jesse Squires" folder. I understand why that's happening, but it makes no sense. All of these apps should be placed in a "Developer" folder in App Library.

Finally, why is App Library still not available on iPad? App Library is essentially the iOS equivalent of Launchpad on macOS. As the iPad continues to evolve into a more desktop-like experience, it is baffling that App Library is iPhone-only. (And the same goes for home screen widgets, which are also missing on iPad.)

### Bugs

There's one main bug I continue to encounter: phantom notification badges. A folder in App Library will have a notification badge, but when I tap to open the folder, none of the apps have a badge. In this scenario, none of the apps on my home screen have badges either, so it makes it hard to figure out which app is causing the problem. It seems like there is an inconsistency with badge settings between the home screen and App Library, namely that App Library doesn't fully respect the settings. If I can correctly guess which app is causing the badge to appear, I can open and close it, and then the badge is removed from the folder in App Library. I hope this gets fixed.

Lastly, there is a very bizarre bug that I have only experienced twice: when navigating to App Library suddenly all of my third-party apps were placed in "Other" while only the built-in iOS apps were correctly categorized. I had to reboot my phone to fix it. However, I have not seen it recently, so maybe a recent iOS update fixed it.
