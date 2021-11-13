---
layout: post
categories: [software-dev]
tags: [ios, xcode, bugs]
date: 2021-11-13T10:13:58-08:00
title: Xcode 13 device orientation options bug
image:
    file: xcode13-device-orientation.jpg
    alt: Xcode project device orientation options
    caption: "Xcode project \"Device Orientation\" options."
    source_link: null
    half_width: true
---

This post started out as a "how to" for SwiftUI, but as I started testing and verifying I realized it is just an Xcode 13 bug. Historically, if you wanted to restrict your iOS app to specific device orientations, you would check or uncheck the various "Device Orientation" options in your project settings. You can find these by selecting your Xcode Project > App Target > "General" tab.

<!--excerpt-->

{% include post_image.html %}

The way this works &mdash; or _should work_ &mdash; is that it modifies the underlying property list for your app, the `Info.plist` file. Specifically, these check boxes should update the value for the `UISupportedInterfaceOrientations` key. If you have iPhone-specific or iPad-specific orientation values, the keys are `UISupportedInterfaceOrientations~iphone` and `UISupportedInterfaceOrientations~ipad`, respectively.

However, as of Xcode 13 **this checkbox has no effect**. For example, if you select only "Portrait" orientation and run your app, it will still rotate to all orientations as the device rotates.

For the SwiftUI app I'm working on, I wanted to restrict the device orientation on iOS to only portrait mode. I rarely do this, instead opting to support all orientations. But, for this app landscape orientation does not make sense. I selected only portrait as a supported device orientation, as pictured above. It did not work. The app UI still rotated on device rotation.

I thought this was a SwiftUI bug and searched online for a solution. However, I later realized that this bug affects UIKit-based apps too. It's a bug in Xcode 13. The problem, as I already hinted, is that the underlying plist is not updated correctly. I suspect this issue is a result of the new behavior in Xcode 13 where it will [automatically generate plist files](https://useyourloaf.com/blog/xcode-13-missing-info.plist/) for you. This new behavior applies by default to projects newly created with Xcode 13.

Looking at source for the plist immediately reveals the problem.

```xml
<key>UISupportedInterfaceOrientations</key>
<array>
    <string>UIInterfaceOrientationPortrait</string>
</array>
<key>UISupportedInterfaceOrientations~iphone</key>
<array>
    <string>UIInterfaceOrientationPortrait</string>
    <string>UIInterfaceOrientationLandscapeLeft</string>
    <string>UIInterfaceOrientationLandscapeRight</string>
</array>
<key>UISupportedInterfaceOrientations~ipad</key>
<array>
    <string>UIInterfaceOrientationPortrait</string>
    <string>UIInterfaceOrientationPortraitUpsideDown</string>
    <string>UIInterfaceOrientationLandscapeLeft</string>
    <string>UIInterfaceOrientationLandscapeRight</string>
</array>
```

The checkboxes in the project settings correctly modify the values for `UISupportedInterfaceOrientations`, but they **only** modify the values for that key. By default, there are also values for `UISupportedInterfaceOrientations~iphone` and `UISupportedInterfaceOrientations~ipad`, which take precedent over the values in `UISupportedInterfaceOrientations`.

To resolve the issue, you have 2 options:

1. Remove both the `~iphone` and `~ipad` key variants. This will restore the functionality of the checkbox settings, as `UISupportedInterfaceOrientations` will now be used for all devices. The checkboxes correctly update this key in the plist and will accurately reflect the configuration.

2. Remove `UISupportedInterfaceOrientations` and edit the device-specific values. Do this if you want different behavior for iPhone and iPad. Note that this will result in the checkboxes not accurately reflecting the actual configurations in the plist. Furthermore, if you modify the checkboxes again Xcode will re-add the `UISupportedInterfaceOrientations` key with the checked values resulting in all 3 keys being present in your plist.

This was reported as FB9757266.
