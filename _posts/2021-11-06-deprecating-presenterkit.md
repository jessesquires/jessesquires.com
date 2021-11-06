---
layout: post
categories: [software-dev]
tags: [ios, swift, uikit, open-source]
date: 2021-11-06T10:48:50-07:00
title: Deprecating PresenterKit
---

I've decided to deprecate one of my open source libraries, [PresenterKit](https://github.com/jessesquires/presenterkit). The library has been in a sort of "maintenance mode" for awhile now. It never really became what I hoped and anticipated. I think it implemented some neat ideas and helped removed some boilerplate from UIKit, but I don't think what it provided necessarily justified a library anymore &mdash; at least not given the lack of activity around the project.

<!--excerpt-->

The goal of PresenterKit was to streamline the view controller presentation APIs in iOS and provide some helpful extensions, as well as offer interesting and useful custom presentation controllers. Many of the extensions are still worthwhile, but can be easily added to a project directly &mdash; no need for a library. As for custom presentation controllers, I only ever had time to add one, a ["half modal" presentation controller](https://jessesquires.github.io/PresenterKit/Classes.html#/c:@M@PresenterKit@objc(cs)HalfModalPresentationController), which has essentially been obsoleted by the [new and more modular `UISheetPresentationController`](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller). Finally, with SwiftUI on the horizon, this kind of library had a limited lifespan already.

If you are using PresenterKit, there's honestly no need to be worried that it's now deprecated. It doesn't do anything complicated or unorthodox in UIKit. The code is straightforward and hasn't needed to change significantly for years. I expect it should continue to work fine &mdash; and without warnings or other issues for the foreseeable future. The deprecation is mostly a notice that this project is entering a new phase, namely that I won't be devoting any more time to it. If you are only using parts of the library, I would suggest that you just add them directly to your codebase.

The repo is still [available on GitHub](https://github.com/jessesquires/presenterkit), though now archived and read-only. A final release has been tagged on GitHub and pushed to CocoaPods to communicate the deprecation. If you have any questions, feel free to reach out.
