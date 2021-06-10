---
layout: post
categories: [software-dev]
tags: [macos, big-sur, apple]
date: 2021-06-01T10:07:19-07:00
date-updated: 2021-06-09T22:33:13-07:00
title: Three months of Big Sur
---

I upgraded to Big Sur three months ago. I know I'm (fashionably?) late to this party, but here I am. This is the longest I have ever waited to upgrade macOS. It feels weird, considering WWDC is next week where we will see what is next for macOS. Big Sur still feels new to me, and announcing the next major release already feels too soon. I was avoiding Big Sur based on various reports about bugs and instability. There were not any 'killer' features I was eager to have, thus the main reason I upgraded was because Xcode 12.5 required it.

<!--excerpt-->

Generally, my experiences upgrading over the past few years have not been great &mdash; really, ever since the California-themed releases started. The initial releases never feel as polished as they used to. So I usually wait until the .1 release. This time I waited even longer. I really do miss the stability and polish of the [Big Cat-themed versions of Mac OS X](http://morrick.me/archives/9220).

{% include break.html %}

I upgraded a 2020 Intel MacBook Pro running Catalina 10.15.7. The installation failed on the first attempt. System Preferences displayed an error after downloading the update, then reported that 10.15.7 was up to date. I had to reboot and try again, after which it succeeded. Curiously, despite the latest version being 11.2.2 at the time, I had to install 11.2.1 first. Only then could I upgrade to 11.2.2.

Strangely, there were **multiple** reboots during the upgrade (to 11.2.1 _and_ the subsequent 11.2.2). It seemed like many more than usual and the screen flashed gray/white multiple times as well. I was quite nervous the entire time, thinking something was going wrong. I had backups, so I wasn't afraid of losing data. I was anxious about spending the next 1-2 days setting up my Mac from scratch. However, both updates installed successfully.

{% include break.html %}

[Michael Tsai](https://mjtsai.com/blog/2021/05/24/remaining-issues-in-big-sur/) and [Howard Oakley](https://eclecticlight.co/2021/04/29/big-sur-11-3-bug-tracker/) have diligently documented all sorts of issues with Big Sur. I have experienced many of them. Most bugs are small, or they are "fixed" temporarily with a reboot. The last six or so years of macOS have felt like ["death by 1,000 cuts"](https://mjtsai.com/blog/2019/10/16/catalina-vista/) &mdash; I would love to see that change next week at WWDC.

Despite all of these tiny cuts, there are things I do like about Big Sur and overall it does feel pretty stable. I haven't experienced any _major_ problems, nor lost any data &mdash; but that should be the norm, not the exception. Overall, the UI refresh is nice. I think it looks _mostly_ great, but there are some **significant** usability issues. Namely, there is not enough contrast across UI elements and most buttons do not look clickable. It reminds me of the disaster we called iOS 7 &mdash; removing affordances, reducing contrast, decreasing information density. It's painful to see Apple make the same mistakes in Big Sur as iOS 7. Only now, in iOS 14, have most of the issues from iOS 7 been addressed. It feels like the company willfully sabotages its own products by obstructing internal communication across teams to preserve its unique culture of secrecy.

Luckily, many usability issues can be "fixed". The best tip I learned was to turn on "Reduce transparency" in System Preferences > Accessibility > Display. Otherwise, some UI elements are too difficult to see, especially the status bar. Unfortunately, the window chrome (title bars, navigation bars, toolbars, etc.) is way **too light**. There is simply not enough contrast. I'm three months in and I still keep clicking on the active window to make it active, thinking it is not active.

{% include break.html %}

Other random thoughts and impressions:

- I wish buttons looked like damn buttons.

- I really like that AirPods and Do Not Disturb get their own icons in the status bar. Very nice.

- Home.app is significantly better, but I rarely use it. I wish you could add home controls to Control Center like on iOS, which is primarily how I interact with "Home". I can't remember the last time I opened Home.app on iOS.

- I don't use really Control Center. I prefer the classic macOS status bar.

- Photos.app and Safari are excellent.

- My [Time Machine bug]({% post_url 2021-04-07-time-machine-error-45-big-sur %}) appears to be fixed!

- The [new notification UI is very hard to use](https://neil.computer/notes/apple-ux-ui-is-regressing/). The buttons are hidden until you hover and now it takes multiple clicks to take an action. I hate it.

- The new alerts and modal sheets are [major usability regressions](https://mjtsai.com/blog/2020/07/03/big-surs-narrow-alerts/). The layout, size, and centered text of alerts makes them difficult to read.

- The animation for modal sheets is absolutely embarrassing. I much preferred the previous design, where they slid down and out from the title bar or toolbar.

- I initially disliked the new status bar icon spacing, but now I kind of like it. It would be nice if it were configurable &mdash; perhaps you could select between "normal" and "compact" spacing. I have a lot of status bar apps/icons. When using most apps, the spacing is ok. But for Xcode and other apps with large menus, the status bar gets truncated, which is annoying. I would rather have the status bar icons dynamically switch to a configurable "compact mode" in those scenarios.

- The new unified title bar + toolbar looks nice, but now there is less space for buttons combined with increased padding around UI elements. This results in my toolbar buttons getting truncated and showing a chevron more frequently &mdash; even with window sizes that are not that small. It become so frustrating, that I have started to heavily customize the toolbar buttons for most apps. For example, in previous releases, I never thought that much about the toolbars in Finder windows and never customized them. In Big Sur, I have customized them to remove everything I don't use, which is almost every default button. The end result is very nice, but it just feels odd that I have to make so many customizations to reach a state that feels usable.

- Speaking of customizing, I dislike that you cannot customize the button on the _left_ side of the new unified split view + sidebar. For example, in Mail, the button in this location is the "Filter" button. I don't use it, and I don't want it there, but I can't remove it.

- Overall, I think Finder looks great (except for toolbar buttons not looking enough like buttons and not having enough contrast). The folder icons and most other UI elements look great. The menus look nice, except for [the grayed out keyboard shortcuts](https://mjtsai.com/blog/2021/03/24/big-surs-gray-menu-keyboard-shortcuts/).

- Some of the new icons for Apple's apps look great &mdash; Safari, Xcode, Preview, Contacts, TextEdit, Time Machine, Font Book. Other icons, however, are just fucking ridiculous &mdash; QuickTime, Keychain Access, Disk Utility. I mean... what is that.

- I love the new wallpapers, especially the dynamic ones.

- I had a weird experience re-installing [Reeder](https://www.reederapp.com) from the Mac App Store. It showed up in Launchpad, but not in `Applications/` in Finder, until I relaunched Finder.

- I setup my Notification Center widgets after upgrading, but after the first reboot they all disappeared and I had to redo everything.

- Most of the new sound effects are simply great. However, I do not like the new trash sound effects. What happened there? The irony that the trash sound effect _is trash_ is not lost on me.

- Speaking of trash &mdash; Mac Catalyst apps. [They are just terrible](https://pilky.me/apples-developer-app/). Two quick examples:
    - Books.app previously had a toolbar button to toggle between a Grid and List view. Now that button is gone, and the option is buried in the View Menu. And it does not have a shortcut. The reason this is important is because List View is the only way to edit book metadata.

    - The Messages.app is a big improvement over the previous iteration in some aspects, but mostly because the previous app was utterly abandoned. Otherwise, Messages.app is a massive regression, thanks to Catalyst. Having feature parity with the iOS app is great. Hitting `shift return` adds a newline instead of sending your message &mdash; **fucking finally**. However, simple [_Mac-assed_ Mac app](https://inessential.com/2020/03/19/proxyman) expectations are missing. For example, selecting a message thread and hitting `cmd delete` no longer deletes the message. It does nothing, it does not even play the error "you can't do that" sound. This is because of Catalyst. With AppKit, you essentially get that functionality for free.

    - Every Catalyst app has _dozens_ of these [little paper cuts](https://daringfireball.net/linked/2019/10/08/catalysts-glaring-shortcomings), and they add up to create an infuriating experience compared to regular [_Mac-assed_ Mac apps](https://inessential.com/2020/03/19/proxyman).

{% include updated_notice.html
update_message="A reader [has pointed out](https://github.com/jessesquires/jessesquires.com/issues/150) that Books.app is, in fact, _not_ a Catalyst app. So it really is just that bad. You can confirm using `otool -L`.
" %}

{% include break.html %}

Despite the issues, I would still say I enjoy Big Sur. It works. It hasn't crashed or lost any of my data. My gripes are about tiny cuts and the UI regressions &mdash; all of which can be easily fixed. The problem, however, is if Apple is committed to fixing them or willing to ignore them for multiple years &mdash; [like those keyboards]({% post_url 2020-09-15-dont-forget-the-keyboards %}).
