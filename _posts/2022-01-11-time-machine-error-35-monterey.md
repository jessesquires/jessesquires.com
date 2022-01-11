---
layout: post
categories: [software-dev]
tags: [macos, time-machine, macos-monterey, bugs]
date: 2022-01-11T14:22:19-08:00
title: Time Machine error 35 in macOS Monterey
image:
    file: time-machine-fail-again.jpg
    alt: "Time Machine backups failing on macOS Monterey"
    half_width: true
---

Well, it appears my saga of [obscure errors with Time Machine]({{ "time-machine" | tag_url }}) continues. The first issue I had was in 2020 with [macOS Catalina and "error 45"]({% post_url 2020-01-10-time-machine-failing-on-macos-catalina %}). That error was [fixed (for me) in Big Sur]({% post_url 2021-04-07-time-machine-error-45-big-sur %}) in 2021. As of this week, the error is back, though this time on macOS Monterey.

<!--excerpt-->

I've been on macOS Monterey for quite a few months now. I haven't had any _major_ issues with Monterey --- only the thousands of paper cuts (like this error) representing the slow degradation of macOS that I've grown to expect in recent years.

The error message is basically the same as before, _"the backup disk image could not be accessed (error 35)"_ --- however, now the error code is 35 instead of 45. Perhaps it is failing in a slightly different way, or perhaps the error code simply changed in Monterey. Like [I mentioned before]({% post_url 2020-01-10-time-machine-failing-on-macos-catalina %}), I use Time Machine with my NAS ("Leviathan.local") and haven't had any problems with my setup until these recent errors. Sadly, I still have no idea what causes the error nor how to fix it given the absolute dearth of useful information in the error message.

For now, rebooting my MacBook has "fixed" the issue and backups are working again --- but this is likely only temporary. I expect to see the error again soon, and I supposed I'll just have to reboot again. And again. And again.

{% include post_image.html %}
