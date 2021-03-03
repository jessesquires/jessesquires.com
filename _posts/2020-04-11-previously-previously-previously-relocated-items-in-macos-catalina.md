---
layout: post
categories: [software-dev]
tags: [macos, bugs]
date: 2020-04-11T10:30:57-07:00
title: Previously previously previously relocated items in macOS Catalina
image:
    file: previously-relocated-items.jpg
    alt:  Previously relocated items
    caption: Previously previously relocated items in macOS Catalina
    half_width: false
---

When I first upgraded to macOS Catalina, there was a "Relocated Items" folder on the desktop. Well, actually it was an alias to `/Users/Shared/Relocated Items/`. This was expected, given the new "[security features](https://mjtsai.com/blog/2019/07/23/annoying-catalina-security-features/)" in Catalina, which includes a new [read-only system volume](https://support.apple.com/en-us/HT210650). What I did not expect was to see this folder reappear with **every single update**.

<!--excerpt-->

{% include post_image.html %}

Not only does "Relocated Items" reappear with each point release (10.15.1, 10.15.2, etc), it also returned with the latest [*supplemental update*](https://9to5mac.com/2020/04/08/apple-releases-macos-10-15-4-supplemental-update/). That is absurd to me. Who at Apple finds this acceptable?

{% include break.html %}

After my initial upgrade to Catalina, I can't remember all the files that were in "Relocated Items", but now it's the same apache config files every time single time. And every single time, I delete this folder and my system is fine. I have some custom apache configurations (in `/etc/apache2/..`) to test this website locally, but none of the relocated files are those configs.

{% include break.html %}

As a software developer I understand what's happening, but what about my parents or other folks who are not tech savvy? They have no idea what "Relocated Items" are and they don't care. It only creates confusion, and leaks technical implementation details to users.

Is this a major problem? Of course not. But it is yet another incredibly [annoying](https://mjtsai.com/blog/2019/07/23/annoying-catalina-security-features/) "feature". It is another cut to add to the [list of 1000 cuts](https://mjtsai.com/blog/2019/10/15/catalina-system-issues/) that came with macOS [~~Catalina~~ Vista](https://tyler.io/macos-10-15-vista/). I really hope the next major release of macOS addresses the shortcomings, bugs, and annoyances introduced in Catalina.
