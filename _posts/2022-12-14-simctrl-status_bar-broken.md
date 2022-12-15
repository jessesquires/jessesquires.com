---
layout: post
categories: [software-dev]
tags: [ios, xcode, nine41]
date: 2022-12-14T15:36:51-08:00
title: "Workaround: simctrl status_bar broken for iOS 16 simulators"
---

Xcode 11 shipped with `simctl status_bar`, a tool to override the status bar values in the simulator so you can take perfect screenshots. I've written about this tool before [here]({% post_url 2019-09-26-overriding-status-bar-settings-ios-simulator %}), [here]({% post_url 2019-09-30-automating-simctl-status-bar %}), and [here]({% post_url 2020-04-13-fully-automating-perfect-status-bar-overrides-for-ios-simulators %}). Unfortunately, `simctl status_bar` is broken in Xcode 14 with the iOS 16 simulators.

<!--excerpt-->

I noticed this bug in Xcode 14 when attempting to use my utility, [Nine41](https://github.com/jessesquires/nine41) to prepare for taking screenshots for an app. The tool ran without reporting any issues, yet the status bars in the simulator did not update. I thought something might have changed in Xcode 14, so I invoked `simctl status_bar` manually --- still nothing happened. As an extra sanity check, I also tried using [Sim Genie](https://simgenie.app), which also failed.

This is a new regression with Xcode 14, but it only affects the iOS 16 simulators. I tested again with yesterday's release of [Xcode 14.2](https://developer.apple.com/documentation/xcode-release-notes/xcode-14_2-release-notes) and the issue has not been fixed. If you run your app using the iOS 15 or earlier simulators, then `simctl status_bar` (and [Nine41](https://github.com/jessesquires/nine41)) will work correctly. I have no idea what caused the regression, but perhaps it has something to do with the [Dynamic Island](https://developer.apple.com/documentation/widgetkit/dynamicisland) on iOS 16?

Luckily, you do not have to open Xcode 13 just to take screenshots. However, if your app's minimum deployment target is iOS 16, then you currently have no choice but to take screenshots with ugly status bars.
