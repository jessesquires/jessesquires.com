---
layout: post
categories: [software-dev]
tags: [macos, apps, github, open-source]
date: 2020-04-07T13:34:41-07:00
title: Open source libraries for building menu bar Mac apps
---

I've been working on two small libraries for building menu bar Mac apps and now they are both open source with initial 1.0 releases.

<!--excerpt-->

The first is [StatusItemController](https://github.com/hexedbits/StatusItemController), which encapsulates all of the basic setup and functionality required for working with your menu bar app. It owns an [`NSStatusItem`](https://developer.apple.com/documentation/appkit/nsstatusitem) and takes care of a lot of boilerplate. Think of it as a "view controller" for `NSStatusItem`.

The second is [AboutThisApp](https://github.com/hexedbits/AboutThisApp), which provides a standard, customizable "About This App" panel. AppKit provides a default "About This App" panel via [`NSApp.orderFrontStandardAboutPanel()`](https://developer.apple.com/documentation/appkit/nsapplication/1428479-orderfrontstandardaboutpanel), but customization is limited, so I made this component as a drop-in replacement. By design, it's very similar to what you get by default in a regular Mac app about panel, but you can more easily customize the content and UI styles.

Both of these components are used in my apps, [Lucifer](https://www.hexedbits.com/lucifer/) and [Red Eye](https://www.hexedbits.com/redeye/). In fact, these apps are the reason I made these two components. After writing the same code twice, I extracted these two libraries so I could use them again and reduce the maintenance burden for the app codebases.

If you are interested, check them out. Contributions are welcomed.
