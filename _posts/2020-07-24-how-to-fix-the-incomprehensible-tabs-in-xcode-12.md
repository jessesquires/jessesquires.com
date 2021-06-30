---
layout: post
categories: [software-dev]
tags: [xcode, ios, macos]
date: 2020-07-24T15:25:58-07:00
date-updated: 2020-10-06T12:09:27-07:00
title: How to fix the incomprehensible tabs in Xcode 12
image:
    file: 'xcode12-tabs-with-tabs.png'
    alt: 'Xcode 12, tabs within tabs within tabs'
    caption: 'Xcode 12, tabs within tabs within tabs'
    source_link: null
    half_width: false
---

[Xcode 12 was released](https://developer.apple.com/documentation/xcode-release-notes/xcode-12-release-notes) and it includes a change to how tabs and navigation work. In Xcode 12, the tabs have their own tabs. It makes no sense to me. I know we are supposed to be nice to each other about software, but this new UI/UX is beyond incomprehensible. What made it worse is that this new "tabs within tabs" was the default setting (overriding preferences I had previously set) and I could not figure out how to restore the previous (desired) behavior.

<!--excerpt-->

{% include updated_notice.html
message="
This post was originally written during Xcode 12 beta 3, but has been updated to reflect the final release of Xcode 12.
" %}

Even worse than that, the keyboard shortcuts I have memorized for navigating, opening, and closing tabs were not working. The shortcuts I have committed to muscle memory only seemed to control the inner tabs, not the outer tabs. It was an unintelligible mess.

{% include post_image.html %}

After reaching peak frustration, I went to Twitter to ask what was going on. A lot of other folks were having the same problem. Luckily, I discovered how to disable the "tabs with tabs". (Thank you [@CaliCoding](https://twitter.com/calicoding/status/1286500177558175745).)

You need to open Xcode's Navigation preferences, and for "Navigation Style" select "Open In Place". The new "inner tab bar" will disappear, and the previous tab behavior (and shortcuts!) will be restored. For Xcode 12.5, you may need to close all windows and reopen them for the changes to take effect.

{% include blog_image.html
    file='xcode12-tabs-prefs.png'
    alt='Xcode 12 betas 3 settings to disable tabs-in-tabs behavior'
    caption='Xcode 12 betas 3 settings to disable tabs-in-tabs behavior'
    source_link=null
    half_width=false
%}

#### So what happened?

Xcode 12 introduces new options for these bottom four navigation settings, which are all concerned with "what happens when you open a file". Previously, the options were opening a new window or opening a new tab, and a few other options. Now, there is a concept of "tabs" (or "document tabs") and "window tabs" &mdash; again, a completely incoherent and confusing design. In this model, "window tabs" are the normal tabs you are thinking of, consistent with Xcode 11 behavior and design. And the "document tabs" are the "inner tabs" that exist within a "window tab". I also find these preferences indecipherable. How do any of these options accurately communicate how tabs will behave or which tabs ("inner" or "window") will be shown?

If you are facing the same confusion, I hope this helps!
