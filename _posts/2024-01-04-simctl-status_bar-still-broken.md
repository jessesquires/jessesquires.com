---
layout: post
categories: [software-dev]
tags: [series-perfect-status-bars, ios, xcode]
date: 2024-01-04T12:50:38-08:00
title: "Workaround: Xcode simctl status_bar is still broken for iOS 17 simulators"
---

While working on updating iOS screenshots for the App Store recently, I discovered that `simctl status_bar` is [**still broken**]({% post_url 2022-12-14-simctrl-status_bar-broken %}). And unfortunately, I do not expect it to be fixed any time soon.

<!--excerpt-->

I've written before about [automating perfect status bar overrides]({% post_url 2020-04-13-fully-automating-perfect-status-bar-overrides-for-ios-simulators %}) for the iOS simulator using my utility, [Nine41](https://github.com/jessesquires/Nine41). The current bug in `simctl status_bar` not only prevents Nine41 from working, but also breaks every third-party tool like [fastlane](https://fastlane.tools), [SimGenie](https://simgenie.app), etc. that offer a status bar override feature --- because those all use `simctl status_bar` under-the-hood.

{% include break.html %}

[Previously]({% post_url 2022-12-14-simctrl-status_bar-broken %}), I realized you could still use the iOS 16.0 simulators and earlier. However, if your app is targeting iOS 17 and above --- my current situation since dropping iOS 16 --- then this workaround will no longer suffice because your app no longer runs on iOS 16.

The only workaround I have found is to use our good old friend, [SimulatorStatusMagic](https://github.com/shinydevelopment/SimulatorStatusMagic) --- which [Dave wrote](https://github.com/daveverwer) _years ago_ before `simctl status_bar` existed. (It is now maintained by [other great folks](https://github.com/shinydevelopment/SimulatorStatusMagic/graphs/contributors).) In my earlier post, I tried to guess (incorrectly) what might have caused the breakage in `simctl status_bar`, but the project's [README](https://github.com/shinydevelopment/SimulatorStatusMagic/blob/master/README.md) explains the problem:

> **1) Injecting into Springboard (Required on iOS 17+)**
>
> **tl;dr** Running `build_and_inject.sh booted` will apply a default status bar to the running simulator. Replace "booted" with a simulator UDID to target a specific simulator.
>
> As of iOS 17, the API used by `SimulatorStatusMagic` is not accessible to processes other than Springboard. So, in iOS 17+ we need to inject `SimulatorStatusMagic` into the Springboard process itself, which we do by building it as a dynamic library, and then updating Springboard's launchd configuration to load our dynamic library.
>
> Running `build_and_inject.sh` will do all of this for you. If you want to change anything about the values used in the status bar, you will need to update `DynamicLibrary/main.m`.

And there's our answer: _"As of iOS 17, the API used by SimulatorStatusMagic is not accessible to processes other than Springboard."_ Presumably, this is why `simctl status_bar` no longer works. From the outside, it sometimes feels like teams within Apple have little to no communication with each other, resulting in bugs like this. Or, perhaps this is just the typical dysfunction that manifests with very large organizations.

{% include break.html %}

Luckily, the status bar overrides applied using SimulatorStatusMagic **will persist across simulator launches**. Thus, you only need to run `build_and_inject.sh booted` once for each simulator. I decided to just do this for all of my simulators so that I never have to worry about this. (Honestly, there's really no reason for them to ever show the current date and time.)

If you fully reset a simulator using `Erase All Content and Settings...`, then you will need to re-run the script for that simulator. Once you apply the overrides to the simulators, you can use whatever screenshot automation tools you prefer (Xcode UITests, fastlane snapshot, etc.) and the status bar overrides will remain. If you need this functionality on a CI service, you are in for a bit more work, but it is possible.

This is far from ideal, but at least we have a workaround that allows us to continue creating great screenshots.
