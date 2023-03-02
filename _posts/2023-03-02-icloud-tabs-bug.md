---
layout: post
categories: [software-dev]
tags: [icloud, macos, ios, safari, apple, bugs]
date: 2023-03-02T10:25:26-08:00
title: How to fix iCloud Safari tabs syncing bug
---

Since iOS 15 and and macOS 12, or whenever Apple launched the new "Start Page" for Safari, I've had various issues getting tabs to sync across my devices. It seems to be [a common problem](https://discussions.apple.com/thread/252782200).

<!--excerpt-->

Aside from tabs not syncing, the biggest problem I've had is that tabs from my Mac get "stuck" on my iPhone and iPad. These "ghost tabs" are ones that have been closed on my Mac --- often for weeks or months --- yet they continue to appear as open tabs on my iOS devices. Most recently, a tab appeared on my iPhone that was supposedly open on my Mac for a project on GitHub that I haven't worked on for over a year! I've tried deleting/closing these ghost tabs on my iPhone, but they always reappear.

I finally decided to try to fix it. Most online forums suggest signing out of iCloud completely on all devices --- but that is too destructive and risky for me. I decided to try another approach and it looks like it worked. If you have the same issue, here's what you can do:

1. On your Mac, backup your Safari data --- bookmarks, etc. Just in case.
1. Completely quit Safari on all devices.
1. Disable Safari syncing in iCloud settings on all devices. Choose the option to delete the data from the device on iOS, but keep the data on your Mac.
1. Launch Safari on all devices. Bookmarks, etc. should be gone on iOS.
1. Completely quit Safari on all devices, again.
1. Reboot all devices.
1. Re-enable Safari syncing in iCloud settings on all devices.
1. Launch Safari on your Mac, so it can sync the initial data.
1. Launch Safari on all iOS devices.

After doing this, the issue should be fixed!
