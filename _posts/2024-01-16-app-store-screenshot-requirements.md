---
layout: post
categories: [software-dev]
tags: [app-store, mac-app-store, ios, macos, apple, screenshots]
date: 2024-01-16T09:52:29-08:00
title: App Store screenshot requirements need to change
---

Providing screenshots for the App Store has always been a tedious and time-consuming process. But as the number of differently-sized iOS devices has grown and changed over the years, it has become more difficult to manage. (This is why the developer community built tools like [fastlane snapshot](https://docs.fastlane.tools/actions/snapshot/).) The screenshot requirements for the App Store have increasingly become a burden for developers, especially indies. With the Mac App Store, there are fewer hurdles and less strict requirements. However, if you are now targeting only the latest OS releases and latest hardware, the screenshot requirements for both App Stores are not only burdensome but they no longer makes any sense!

<!--excerpt-->

### A (brief) history of screen sizes

For the first ~8 years of the iPhone, screen sizes and resolutions did not change. (Yes, the iPhone 5 got a _little bit_ taller, but it was not a dramatic change.) All devices had 3.5-inch or 4-inch displays. Similarly, iPad screen sizes and resolutions did not change for the first ~5 years. Each device has a history that can be broken up into distinct phases.

The first phase of iPhone was the original `320 x 480` display. The second phase and the first fundamental changes for iPhone came with iPhone 6 and iPhone 6 Plus (up to the 8 and 8 Plus), which had larger and higher resolution displays. These displays were 4.7-inch and 5.5-inch. The next fundamental shift occurred with iPhone X, which began the third (and current) phase. This includes the current lineup of iPhones 15, with the Plus, Pro, and Pro Max. Again, this phase brought larger screen sizes, higher resolution displays, and --- importantly --- different aspect ratios. The current generation of display sizes for iPhone include 5.8-inch, 6.1-inch, 6.5-inch, and 6.7-inch.

 The first fundamental changes for iPad occurred with iPad Pro and then again with iPad Air. Overall, iPad screen size changes have been more subtle and resolutions have been much more consistent. The majority of iPad models have a `3:4` aspect ratio, the outliers are the recent generations of iPad Air and iPad Mini. The current generation of display sizes for iPad include 8.3-inch, 9.7-inch, 10.5-inch, 11-inch, and 12.9-inch.

If you want to browse through all the details, I highly recommend [ScreenSizes.app](https://www.screensizes.app) and [iOSRef.com](https://iosref.com/res).

{% include break.html %}

On the Mac, the story is (expectedly) quite different. Obviously, the Mac is significantly older than iPhone and iPad and a significantly different machine. However, the _Mac App Store_ is about 2.5 years _younger_ than the iOS App Store. MacBooks have been pretty consistent in screen size and resolution. The first fundamental shift regarding resolution occurred with the Retina Displays. Over the years, there have been Mac laptops with displays ranging from 11-inches to 17-inches across the MacBook, MacBook Air, and MacBook Pro lineups. (Fun fact: with the introduction of the M-series MacBook Pro, there has been a MacBook display size for every 1-inch increment from 11 to 17.) Then there are the desktop Macs, some of which include a display like the iMac (ranging from 20-inch to 27-inch, which eventually shifted to Retina Displays) while the others require an external display. With external displays, there are too many possibilities to enumerate.

Unfortunately, I have been unable to find comprehensive resources about Mac Models and their specs like [ScreenSizes.app](https://www.screensizes.app) for iOS devices. Apple does maintain a thorough [Tech Specs](https://support.apple.com/specs) page, but it is rather tedious to examine each product manually and individually.

{% include break.html %}

I should also briefly mention that the discussion above is only considering screenshots for a single localization. If you need to provide screenshots in multiple languages, this is even more difficult to manage. Again, shoutout to [fastlane](https://docs.fastlane.tools/) for helping with this on iOS.

### Aspect ratios

The most significant metric that affects screenshots is not device size, but aspect ratio. The aspect ratio of a display is what can produce the most notable differences in the content that is displayed on screen.

iPhones with a 5.8-inch screen and larger have a `19.5:9` aspect ratio, while all other modern iPhones (5.5-inch and smaller) have `16:9` aspect ratio. The now-obsolete iPhones with a 3.5-inch screen have a `3:2` aspect ratio.

Almost all iPads have a `4:3` aspect ratio. iPads with an 11-inch screen have a `10:7` aspect ratio and iPads with a 10.9-inch screen have a `23:16` aspect ratio. The single outlier is the 6th Gen iPad Mini, which is the only model with a `6.1:4` aspect ratio.

Most Macs and Apple Displays have either a `16:10` or `16:9` aspect ratio. However, the current generation of M-series MacBooks (Air and Pro) have an obscure `16:10.35` aspect ratio. So weird.

### App Store screenshot requirements for iOS

You can currently upload screenshots for all device sizes, if you wish. There was a time, if I remember correctly, when Apple required screenshots for _all_ device sizes. However, this was eventually relaxed to include only some of the larger devices, which can then be scaled down to display for smaller devices with the same aspect ratio. You can find the current [screenshot specification reference here](https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications).

**Screenshot requirements for iPhone:**

1. Either 6.7-inch or 6.5-inch (The current generation of devices). Scaled versions of these will be used for 6.1-inch and 5.8-inch.
1. 5.5-inch (iPhone 6s/7/8 Plus).
1. 4.7-inch (iPhone 6/7/8 and iPhone SE 2nd/3rd Gen).

However, if your app is targeting iOS 17 and later, **generating 5.5-inch screenshots is impossible!** There are [no 5.5-inch devices that can run iOS 17](https://support.apple.com/guide/iphone/models-compatible-with-ios-17-iphe3fa5df43/17.0/ios/17.0)! The iPhones 6s/7/8 Plus stopped at iOS 16. It doesn't make any sense to provide these screenshots if your app only runs on iOS 17 and later.

Even more ridiculous, App Store Connect still allows you to submit 3.5-inch screenshots. Not only are those devices obsolete, it is impossible to release an app today that even runs on those devices. Xcode prevents you from setting a minimum deployment target lower than iOS 12, which does not run on any 3.5-inch device!

Luckily, for tvOS and watchOS (and now visionOS) you only need to choose a single size for all of your screenshots.

**Screenshot requirements for iPad:**

1. 12.9-inch (iPad Pro 6th Gen, Face ID).
1. 12.9-inch (iPad Pro 2nd Gen, Touch ID).

All other iPad sizes (9.7-inch, 10.5-inch, 11-inch) will use scaled versions of these. Notably, there is no option to upload screenshots for iPad Mini (not the old 7.9-inch display, nor the latest 8.3-inch display). Talk about consistency. This is certainly less cumbersome, at least there is [a device of each size capable of running iOS 17](https://support.apple.com/guide/ipad/models-compatible-with-ipados-17-ipad213a25b2/17.0/ipados/17.0).

But you might have noticed... these screenshots are exactly the same size, resolution, and aspect ratio --- so why the duplication? The **only difference** is whether or not the device has a _home button_ (with Touch ID) or a virtual [_home indicator_](https://developer.apple.com/design/human-interface-guidelines/layout) (with Face ID). Thus, _the only difference_ when generating these two sets of screenshots is whether or not the home indicator is present at the bottom of the screen. I understand these are fundamental differences in the hardware, but do we really need to provide both sets of screenshots just for a difference of a few pixels at the bottom of the screen?

Is a home button versus a home indicator truly a meaningful distinction for screenshots? I don't think so, especially considering that Apple provides an API that [allows your app to hide the home indicator](https://developer.apple.com/documentation/uikit/uiviewcontroller/2887510-prefershomeindicatorautohidden)! In this case, screenshots would be identical. I do not see a good justification for the extra work involved here to generate two sets of the same screenshots.

### Suggested improvements for iOS screenshots

I suspect, similar to the iPad requirements, the primary reason that a 5.5-inch screenshots are required for iPhone --- aside from the difference in aspect ratio --- is that this is the largest device with a home button (Touch ID). All other sizes (5.8-inch and larger) are for devices with a [home indicator](https://developer.apple.com/design/human-interface-guidelines/layout) (Face ID), that is, no home button.

Here are the changes I would like to see:

1. Remove all obsolete device sizes from App Store Connect.
1. Do not require screenshots for devices that cannot run your app, based on its minimum deployment target.
1. Do not require screenshots solely to distinguish between _home button_ and _home indicator_ devices.
1. Only require screenshots for additional device sizes when there is a **significant difference** in size and aspect ratio, otherwise use scaled versions of the screenshots for other devices.

With these changes, developers would only need to provide the following screenshots:

1. iPhone 6.5-inch
1. iPhone 4.7-inch
1. iPad 12.9-inch

That's 3 sets of screenshots instead of 5. Honestly, I would prefer that iPhone 4.7-inch screenshots be optional so that you only need one size per device, but I can see a valid argument against that because they have different aspect ratios. But hopefully, iPhones with 4.7-inch screens will be obsoleted with iOS 18, which then reduces the requirements to only 1 set of screenshots for each device.

### App Store screenshot requirements for macOS

As I mentioned above, the screen sizes for macOS are much more nebulous considering the numerous possibilities of externals displays. Thus, App Store Connect requires screenshots in any of the following sizes:

1. `1280 x 800`
1. `1440 x 900`
1. `2560 x 1600`
1. `2880 x 1800`

Luckily, you only have to choose one.

Notably, these all have a `16:10` aspect ratio --- and that's the problem. There is only one modern Mac that has a `16:10` aspect ratio and it's the 13-inch MacBook Air M1. The other MacBook Air models and all MacBook Pro models have an obscure `16:10.35` aspect ratio --- _almost there_, but just different enough to be unable to simply take a desktop screenshot and scale it down to `2880 x 1800`. Instead, you'll have to scale it down and crop it. Thanks [notch]({% post_url 2023-12-16-macbook-notch-and-menu-bar-fixes %})! The current iMac models along with the Studio Display and Pro XDR Display all have `16:9` aspect ratios --- though perhaps this is a moot point considering 4K+ images are obviously too massive.

You _could_ simply take screenshots of your app windows at one of the specified sizes, and that will certainly work for some use cases. But what about menu bar apps? Or apps with multiple windows? Generally, I think screenshots look much nicer when your Mac app is shown within the context of a full desktop screenshot.

Looking at the apps that Apple ships via the Mac App Store, you'll see both types of screenshots for all of them. For example, [Pages for Mac](https://apps.apple.com/us/app/pages/id409201541) only has screenshots of the app itself in fullscreen. On the other hand, the [Developer App](https://apps.apple.com/us/app/apple-developer/id640199958) shows the app window on a full Mac desktop. Both are valid approaches and both should be easy for developers to generate.

### Suggested improvements for macOS screenshots

Allowing 4K or larger desktop screenshots is obviously not feasible given their size. However, I think the App Store should allow additional aspect ratios and sizes.

Here are the changes I would like to see:

1. Allow `16:9` aspect ratios.
1. Allow the weird `16:10.35` aspect ratios for the latest MacBook lineup.
1. Allow _at least_ one of the following new sizes:
   1. `2560 x 1664` (MacBook Air 13" M2, at `16:10.35`)
   1. `3024 x 1964` (MacBook Pro 14", at `16:10.35`)

This would make it significantly easier in many scenarios to generate screenshots without having scale and/or crop everything.

### Current solutions and workarounds

I've alluded to solutions above, but I'll enumerate them here for clarity.

For iOS, you can automate generating all screenshots with [fastlane snapshot](https://docs.fastlane.tools/actions/snapshot/), which alleviates the majority of these issues. The tool is somewhat clunky and definitely feels like it is aging, but it still works. It would be nice if third-party tools like this were not necessary.

To address having to provide 5.5-inch screenshots for an app that only runs on iOS 17 and later, there are a few steps and caveats. You need to satisfy the nonsensical requirement by uploading 5.5-inch screenshots, but you should also provide proper 4.7-inch screenshots, which display on devices that _can_ run your app. Providing both is important, as [Jeff Johnson has pointed out](https://lapcatsoftware.com/articles/2023/12/3.html), if you only provide 5.5-inch screenshots they will be used for the 4.7-inch screen sizes. This is not ideal, because we have to manually resize them, which doesn't look great. Here's my process:

1. I generate 4.7-inch screenshots using fastlane.
1. I upscale these screenshots to the 5.5-inch resolution using [Retrobatch](https://flyingmeat.com/retrobatch/). (You could also use Photoshop, Sketch, Gimp, Acorn, or any other image editor.)
1. Upload the (somewhat ugly) scaled 5.5-inch screenshots along with all the others (via fastlane).

_Technically_ (again, [Jeff notes](https://lapcatsoftware.com/articles/2023/12/3.html)) you only need to provide one 5.5-inch screenshot. Users will never see these because they'll instead see the correct 4.7-inch screenshots. However, my automation with Retrobatch and fastlane make it trivial, so I do upload a full set for 5.5-inch screens.

For macOS screenshots, you can choose to only upload screenshots of your app windows. If you have an M-series MacBook and want to take full desktop screenshots, you'll have to resize and crop them to `2880 x 1800`. [Retrobatch](https://flyingmeat.com/retrobatch/) can streamline this process, too. Unfortunately, [fastlane snapshot](https://docs.fastlane.tools/actions/snapshot/) remains broken for macOS.

{% include break.html %}

Finally, I should note that all of this only applies if you are taking proper screenshots. Unfortunately, the majority of listings in the App Store these days simply use various promotional images (sized appropriately) that were made in Photoshop, etc. But even if this is your strategy, generating screenshots in all the various sizes is still a burden. Being able to provide only a single set of screenshots per device would help.

### Conclusions

I would love to see these changes (and fixes!) come to App Store Connect that make dealing with screenshots easier. Hopefully someone at Apple is listening!

#### References

Here are all the resources I used to find and confirm device and screenshot specifications:

- [Apple - Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications)
- [ScreenSizes.app](https://www.screensizes.app)
- [iOSRef.com](https://iosref.com)
- [Apple Support - iPhone model compatibility](https://support.apple.com/guide/iphone/models-compatible-with-ios-17-iphe3fa5df43/17.0/ios/17.0)
- [Apple Support - iPad model compatibility](https://support.apple.com/guide/ipad/models-compatible-with-ipados-17-ipad213a25b2/17.0/ipados/17.0)
- [Apple Human Interface Guidelines - Layout](https://developer.apple.com/design/human-interface-guidelines/layout)
- [Apple Support - Technical Specifications](https://support.apple.com/specs)
