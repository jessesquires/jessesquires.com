---
layout: post
title: ! 'Summoning Lucifer: on making my first Mac app as an iOS developer'
image:
    file: lucifer-app.jpg
    alt: Lucifer
    half_width: false
---

I made my first Mac app &mdash; [Lucifer](https://www.hexedbits.com/lucifer/). It is a menu bar app that allows you toggle Dark Mode on and off in macOS Mojave. To be honest, it feels like a stretch to actually call this a Mac app. It is less than 100 lines of code in a single `AppDelegate.swift` file and the meat of the program is an AppleScript that tells System Preferences to enable or disable Dark Mode. As an iOS developer, much of the experience was familiar. The most salient aspect, however, was learning the frustrating and obscure details of [app sandboxing](https://developer.apple.com/app-sandboxing/), the ["hardened runtime"](https://developer.apple.com/documentation/security/hardened_runtime_entitlements), and app [notarization](https://developer.apple.com/documentation/security/notarizing_your_app_before_distribution) &mdash; altogether it was like visiting hell and giving Satan a bubble bath. Appropriate, I suppose.

<!--excerpt-->

{% include post_image.html %}

I wanted a project that was small and fun, and that I could build in a weekend &mdash; not just the coding, but also the design/concept, a simple [website](https://www.hexedbits.com/lucifer/) for "marketing", and submitting to the Mac App Store (spoiler: rejected). And of course, I wanted to make something I would use. I like to toggle dark mode often. It depends on what I'm working on and the current ambient lighting. I know there are existing apps that do this, but I wanted to make this on my own. (And obviously, those apps did not have enough Satan.)

### Familiar, but different

This app was a good 'hello world' exercise to introduce me to the joy of developing for the Mac, and the misery of sandboxing and the hardened runtime. Within a short time, I had the basics of a menu bar app working. I ran into [a few issues with AppleEvents and sandboxing]({{ site.url }}{% post_url 2018-11-17-executing-applescript-in-mac-app-on-macos-mojave %}). The majority of my time was spent figuring out which entitlements I needed to properly work within the sandboxed and hardened runtime environments.

From an iOS developer perspective, building a macOS app is intimately familiar. There certainly are differences beyond replacing `UI` with `NS`. It is a completely different platform with different paradigms. But the development environment is the same &mdash; the Mac, Xcode, Swift, and Objective-C. It is like visiting your parents at your childhood home as an adult. It’s still sort of your home, but it’s different now. Sometimes a little weird, and often frustrating.

I cannot speak much to the difference in paradigms because this app is so small. There is no menu bar in iOS, but that is the only major difference I faced in this case. I suspect dealing with multiple windows is challenging compared to iOS where you have only one.

What I struggled with the most was sandboxing and the new hardened runtime requirements introduced in macOS 10.14 Mojave. Each of these mandate specific entitlements to enable functionality. Documentation is sparse. If you attempt to execute code that requires a specific entitlement without specifying that entitlement, the app will silently fail. You are left scratching your head and wondering what went wrong. It would be a much more pleasant developer experience if such scenarios triggered an exception with a meaningful message explaining which entitlement you needed to specify. This is particularly frustrating given the overlap of sandboxing and hardened runtime entitlements.

### Not on the Mac App Store

I wanted to submit this app to the Mac App Store. Mainly, I wanted the experience of going through that full process. Maybe I would have charged 99 cents for awhile before making it free. I suppose I got "the experience" I was looking for, just not with the desired outcome. As I wrote [in my previous post]({{ site.url }}{% post_url 2018-11-17-executing-applescript-in-mac-app-on-macos-mojave %}), writing this app required using the `com.apple.security.temporary-exception.apple-events` entitlement, which is not allowed on the Mac App Store. I should have researched that before submitting. Turns out, none of these `temporary-exception` entitlements are allowed, unless you receive [special](https://mjtsai.com/blog/2018/11/16/transmit-5-on-the-mac-app-store/) [treatment](https://mjtsai.com/blog/2019/02/27/bbedit-12-6-to-return-to-the-mac-app-store/) from Apple. Thus, Lucifer was promptly rejected from residing within the walled garden. Again, appropriate now that I think about it.

### Getting notarized

I suppose the good news is that you can distribute Mac apps outside of the Mac App Store, unlike iOS. Notarization is not mandatory, but it provides a smoother installation process for users. There are fewer frightening warning dialogs and manual steps to "allow" the app to run. I also wanted to go through the process of notarization to see what it was like. Eventually, notarization [will be required](https://developer.apple.com/news/?id=10192018a&1539965082).

In general, actual notarization process was painless, quick, and easy via Xcode. However, I did not initially have the hardened runtime enabled in my project settings. The app was working in a sandboxed environment, but failing silently once notarized. It simply was not working. Once I discovered that the hardened runtime needed to be enabled, the problem was fixed. However, it required yet another entitlement, `com.apple.security.automation.apple-events`.

### Sandboxing versus notarizing

I owe a huge thanks to [Michael Tsai](https://mjtsai.com/blog/), who's blog was an indispensable resource for debugging and learning about Mac development, and Jeff Johnson for writing [this post on the hardened runtime and sandboxing](https://lapcatsoftware.com/articles/hardened-runtime-sandboxing.html), which not only provides a clear explanation of both technologies and how they impact developers, but also provided the exact answers I was looking for regarding getting Apple Events to work. He writes:

> By default, apps with the hardened runtime are not allowed to send Apple Events to other apps on Mojave. Again, this will silently fail with no permission dialog. In order to send Apple Events, a hardened app needs the `com.apple.security.automation.apple-events` entitlement. In Xcode 10, this is added by checking "Apple Events" under Hardened Runtime Resource Access. With this entitlement, a hardened but non-sandboxed app is allowed to send Apple Events to any other app, without having to specify bundle identifiers. The app also needs a `NSAppleEventsUsageDescription` string, of course, because Xcode 10 uses the 10.14 SDK. And like always on Mojave, the first Apple Event sent will trigger a permission dialog.
>
> What happens on Mojave when an app is sandboxed and hardened at the same time? It's crucial to understand that sandboxing and hardening are both disabling rather than enabling technologies. Without the `com.apple.security.automation.apple-events` entitlement, a hardened sandboxed app cannot send Apple Events, even if it has `com.apple.security.temporary-exception.apple-events` sandbox exceptions. and without a `com.apple.security.temporary-exception.apple-events` entitlement, a hardened sandboxed app cannot send Apple Events, even if it has the `com.apple.security.automation.apple-events` entitlement. Moreover, the `com.apple.security.automation.apple-events` entitlement does not give a hardened sandboxed app the ability to send Apple Events to arbitrary targets, because the sandbox still prevents Apple Events to apps other than those specified by `com.apple.security.temporary-exception.apple-events`.

Did you follow that? It accurately sums up what I was pulling my hair out over for multiple hours on a Sunday afternoon.

### Lessons learned

Overall, this was a lesson in sandboxing and the hardened runtime. I am glad I experimented with this with such a small and relatively unimportant app. If I had been building something serious and hit these walls, it would have been incredibly demoralizing and disappointing, especially if it meant I could not publish to the Mac App Store. If I ever want to get serious about developing for the Mac, I now know what to expect.

My advice: thoroughly investigate what entitlements your app would need to be functional within the sandbox and/or hardened runtime environments. Also investigate what it would take to be accepted into the Mac App Store before doing any substantial work, if you want to distribute there. Avoid any “temporary” entitlements, as Apple will not let you use them (again, unless you are special). Finally, you should start developing with the hardened runtime and sandbox enabled from the start. Do not leave this to the last minute unless you want to redesign your app to accommodate them.
