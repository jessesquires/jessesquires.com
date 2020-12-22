---
layout: post
categories: [software-dev]
tags: [macos, bridgeos, apple, macbook, touch-bar]
date: 2020-12-22T15:33:04-08:00
title: Obscure bridgeOS crash
image:
    file: bridge-os-crash.jpg
    alt: "bridgeOS crash"
    caption: null
    source_link: null
    half_width: false
---

This is a first for me. I returned to my MacBook after leaving it for a couple of hours, and it was shutdown even though I left it powered on. The machine was idle. I didn't have any specific tasks running. I figured it might have been a macOS kernel panic, but upon rebooting I discovered that the crash was caused by bridgeOS.

<!--excerpt-->

[bridgeOS](https://en.wikipedia.org/wiki/BridgeOS) (a modified version of watchOS) is responsible for a few tasks on modern MacBooks. It is powered by the [T2 chip](https://en.wikipedia.org/wiki/Apple-designed_processors#T_series) and operates the Touch Bar and the [Secure Enclave](https://en.wikipedia.org/wiki/IOS#Secure_Enclave).

The details of the crash leave much to be desired:

```
Unexpected SoC (system) watchdog reset occurred
```

My guess is that the crash is related to the Touch Bar, [which I loathe]({{ site.url }}{% post_url 2020-07-08-best-touch-bar-configuration-for-people-who-hate-the-touch-bar %}). However, it is difficult to tell exactly what occurred given the dearth of information. And an internet search yielded no results.

Why are these laptops still shipping with the Touch Bar? How useful is it, *really*? I dislike it and everyone I know dislikes it too. And now, the fact that it can (potentially) crash my entire machine makes me dislike it even more. 

Perhaps the next generation of machines with the next generation of [M-Series chips](https://en.wikipedia.org/wiki/Apple_M1) will obviate the need for bridgeOS and the separate T2 chip altogether &mdash; and if we're lucky, there will be an option to *remove* the Touch Bar.

{% include post_image.html %}
