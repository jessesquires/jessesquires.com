---
layout: post
categories: [essays]
tags: [apple, macbook-pro, macbook, macos]
date: 2023-12-16T10:48:15-08:00
date-updated: 2024-05-29T18:20:52-07:00
title: How to fix Mac menu bar icons hidden by the MacBook notch
---

Last week I [wrote about setting up a new MacBook Pro]({% post_url 2023-12-04-new-m3-mbp %}) --- my first Apple Silicon Mac, and thus my first MacBook with a notch. I lamented how poorly macOS interacts with the notch, specifically how menu bar apps and icons simply get hidden if you have too many to display. Lots of folks on Mastodon offered various solutions, and some readers emailed me with options as well. I figured it was worth making a separate post about this specific issue to list all of the workarounds and alternatives. It is clear that this is a widespread problem that users are having.

<!--excerpt-->

### Problems with the notch

[I previously wrote]({% post_url 2023-12-04-new-m3-mbp %}):

> I have gripes about the notch. There isn't enough room to display all of my menu bar apps and icons, so... they just get hidden!? Apparently, everyone in Cupertino thinks the best solution to this problem is to hide them with zero indication that there are more that simply can’t be displayed because of the notch. I wasted so much time trying to figure out why Little Snitch and 1Password were not running on my new machine. Was there a compatibility issue with Apple Silicon that I didn't know about? That couldn't be. It turns out, they were running the whole time but they were hidden by the notch.
>
> [...]
>
> This "design" (or lack thereof) is so dumb. It is utterly ridiculous to me that this is still how it "works" **two years after** the introduction of the redesigned MacBook Pro with a notch. How hard could it be to add an overflow menu with a "<<" (or should it be ">>"?) button that shows the remaining apps and icons that can't be displayed? This entire situation with the notch is ironic, because the iPhone notch and “dynamic island” are so **thoughtfully designed** with zero compromises regarding the functionality of iOS. In fact, they actually provide a _better_ user experience. Yet on the Mac, how the notch interacts with macOS is laughably incompetent. It is shockingly lazy regarding attention to detail, and results in an outright disruptive and confusing user experience.

And as [Michael Tsai pointed out](https://mjtsai.com/blog/2023/12/08/mac-menu-bar-icons-and-the-notch/), the situation from a developer's perspective is just as bad:

> Aside from the problem of the icons being hidden, there's no API for an app to _tell_ whether its icon is hidden. `NSStatusItem.isVisible` tells you whether the app or user _wants_ the icon to be visible, but it will return `true` if the icon is hidden in the notch---or even if it's hidden behind a menu title.

### First-party workarounds

If you prefer _not_ to install any third-party apps (like me), there are a number of steps you can take to alleviate your crowded menu bar and possibly remedy the issue entirely (which I've successfully done). My goal with the steps below is to get all of my apps and icons to display when Finder is active. Some applications have more menu items that span across the other side of the notch, and in this scenario there is not much we can do to prevent hidden menu bar icons --- which was actually the case _before_ the notch existed for applications with a very large number of menu items.

1. Move macOS system-provided icons into Control Center. A number of icons can be configured to display only in Control Center, which frees up space in your menu bar for icons and third-party apps that must be displayed in the menu bar. For example, you can move WiFi, Bluetooth, Battery level, AirDrop, etc. into Control Center. Additionally, some icons can be configured to only display when they are active, like Focus status or Screen Mirroring.

2. Reorder your apps and icons from right to left to display the ones that are _most important_ to you on the right and least important on the left. The result is that the least important icons are the ones that get hidden by application menus or the notch, while the most important icons are more likely to remain visible. For example, I like having Time Machine in the menu bar, but it doesn’t matter if it gets hidden while I'm working in an app with a large menu that spans to the other side of the notch, thus hiding Time Machine. Therefore, I have placed Time Machine in the left-most position. Furthermore, I place system icons that display _only when active_ (like Focus status) in the _right most_ position. This is important for me, because I want to make sure I always see when these things are active.

3. Reduce the menu bar item spacing and padding via `UserDefaults`. (Thanks to [Oliver Busch](https://mastodon.social/@gummibando/111546699397435187) for the tip. Also see [this Reddit post](https://www.reddit.com/r/MacOS/comments/16lpfg5/hidden_preference_to_alter_the_menubar_spacing/).) There are two defaults settings you can configure via Terminal, `NSStatusItemSpacing` and `NSStatusItemSelectionPadding`.

**Read the current defaults:**

```bash
defaults -currentHost read -globalDomain NSStatusItemSpacing
defaults -currentHost read -globalDomain NSStatusItemSelectionPadding
```

**Note:** These values are _not set_ by default. This means you will get an error that the keys and values do not exist if you have not previously set them.

**Write the defaults by providing an integer value:**

```bash
defaults -currentHost write -globalDomain NSStatusItemSpacing -int 12
defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 8
killall SystemUIServer
```

After some experimentation, I landed on the values above --- `12` for spacing and `8` for padding fit my needs. You should experiment as well. The smallest tolerable values are probably around `6` or `8`.

**Remove the values to restore the default behavior:**

```bash
defaults -currentHost delete -globalDomain NSStatusItemSpacing
defaults -currentHost delete -globalDomain NSStatusItemSelectionPadding
killall SystemUIServer
```

### Third-party solutions

There are several third-party applications to help organize and manage all of your menu bar apps and icons. The apps I have listed below seem to capture the three broad categories of possible solutions. I know there are a few others out there with similar functionality, but I think these are the most representative.

1. **Bartender**. (Paid with Free Trial. [Website](https://www.macbartender.com)). This one is very advanced and complex with elaborate customization options, including styling the entire menu bar. It works well, but I found it to be very heavy-handed and a bit cumbersome for my needs. It felt clunky and glitchy to me, in ways that I think the developer has tried hard to mitigate, but I imagine Apple does not make developing this sort of app easy. (I don't think there are any public APIs for this stuff.) Bartender seems to rely on some hacks (like screen recording) to dynamically hide and show your overflowed menu bar apps. Like iOS, macOS now has a privacy feature where you are notified when apps are using the camera, microphone, screen recording, etc. On iOS there's a little dot indicator that shows in the status bar, on macOS there's an icon that displays in your menu bar. One specific issue I had with Bartender, was that the privacy indicator icon for screen recording appears very frequently, which was annoying.

2. **Hidden Bar**. (Free. [Mac App Store](https://apps.apple.com/us/app/hidden-bar/id1452453066), [GitHub](https://github.com/dwarvesf/hidden)). This one is extremely lightweight, providing a simple chevron "<" icon to expand and collapse the extra icons. You can customize which icons are always shown, and which are hidden when the menu is collapsed.

3. **Say No to Notch**. (Free with IAPs, [Mac App Store](https://apps.apple.com/us/app/say-no-to-notch/id1639306886)). This is another heavy-handed approach. This one adds a letterboxed-style black bar to the top of your screen and shifts the entire menu bar down below the notch --- along with the entire contents of your screen. I do not like the reduced screen real estate that this creates.

All of these apps have pros and cons. Unfortunately, I was not quite satisfied with any of them. However, your experience and preferences might be very different!

{% include updated_notice.html
date="2024-05-29T18:20:52-07:00"
message="
Thanks to reader [Moritz Thiele](https://github.com/thielem) who [suggested some](https://github.com/jessesquires/jessesquires.com/issues/194) alternative third-party solutions. They use [zNotch](https://github.com/zkondor/znotch) in combination with [Raycast](https://www.raycast.com) shortcuts.
" %}

### Conclusion

As noted above, I have opted for the collection of first-party workarounds. For me, all of the third-party apps felt cumbersome, wonky, lacking, or simply did not match my aesthetic taste. That's not to say they aren't great apps and creative solutions --- they just aren't for me. In any case, I hope this post has been helpful if you've been searching for solutions to the MacBook notch problem.
