---
layout: post
categories: [software-dev]
tags: [macos, time-machine, catalina, bugs]
date: 2020-07-17T13:54:23-07:00
title: Time Machine error 45
image:
    file: time-machine-fail.png
    alt: "Time Machine backups failing"
    half_width: true
---

This is a brief follow-up to [the post I wrote about Time Machine failing]({% post_url 2020-01-10-time-machine-failing-on-macos-catalina %}) on macOS Catalina.

<!--excerpt-->

{% include post_image.html %}

I recently [upgraded my 6-year-old MacBook Pro]({% post_url 2020-07-08-best-touch-bar-configuration-for-people-who-hate-the-touch-bar %}), and one of the things I was most excited about was to see how many odd, random bugs and quirks would magically fix themselves by having the latest hardware, a clean install of macOS, and a clean install of all of my apps. I did not migrate or restore from Time Machine to specifically have a fresh start.

As expected, a lot of random issues have disappeared &mdash; Bluetooth flakiness, random UI glitches, etc. This new machine has been running smoothly. And yes, even Time Machine has been automatically backing up without issues. No more "error 45".

Until now. After a few weeks with zero issues, Time Machine automatic backups are failing again with "error 45" like before. I still have no clue what is causing this issue, but now I know it is a bug in Catalina **for sure**. Previously, I thought it might have been a problem with my old machine and upgrading from Mojave.

{% include break.html %}

The only good news is that I _sort of_ have a workaround, but not actually. I disabled automatic backups in System Preferences. This removes the annoying, incessant failure notifications. Unfortunately, it means that I must backup manually. However, every time that I initiate a manual backup it succeeds. So... who knows.  `¯\_(ツ)_/¯`

To be honest, hourly backups are a bit excessive for me anyway. Everything that is important to me is backed up elsewhere &mdash; code is on GitHub, photos in iCloud, etc. So this is not a terrible setup for me. I keep the Time Machine icon in my menu bar, which allows me to easily initiate a manual backup every day or every few days.

{% include break.html %}

Now that I think of it, "error 45" is an apt description of 2020 (and the past 4 years).
