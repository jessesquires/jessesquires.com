---
layout: post
title: The A5 is dead (almost)
subtitle: iOS 10 drops support for A5 devices
redirect_from: /the-a5-is-dead/
---

As developers, we've been [lamenting](http://arstechnica.com/apple/2015/09/ios-9-on-the-ipad-2-not-worse-than-ios-8-but-missing-many-features/) the continued existence of the inferior [A5 system-on-a-chip](https://en.wikipedia.org/wiki/Apple_A5) for the past couple of years. Both [iOS 8](https://en.wikipedia.org/wiki/IOS_8) and [iOS 9](https://en.wikipedia.org/wiki/IOS_9) continued to support *iPhone 4S, iPad 2, and iPad Mini 1* &mdash; devices that struggled to run the OS itself. I had hoped that iOS 9 would finally drop support for these less powerful devices, but it didn't. Today, we can finally [say goodbye](http://arstechnica.com/apple/2016/06/goodbye-a5-ios-10-ends-support-for-iphone-4s-ipad-2-and-more/) to the A5. Well, almost.

<!--excerpt-->

<img class="img-thumbnail img-responsive center" src="{{ site.img_url }}/a5-chip.jpg" title="A5 SoC" alt="A5 SoC"/>

### iOS 10

[iOS 10](http://www.apple.com/ios/ios10-preview/) has dropped support for these older A5-powered devices &mdash; a reason for celebration. However, most developers support *at least* the two most recent versions of iOS, per Apple's recommendations. This means we'll been writing modern apps on modern OSes for 6-year-old or 7-year-old devices, depending on when you drop support for iOS 9. But the good news is, once you *are* ready to drop iOS 9 support in your app, you can say goodbye to the A5 forever. Oh, and you can also say goodbye to 3.5-inch screen sizes. Rejoice.

According to Apple's [press release](http://www.apple.com/newsroom/2016/06/apple-previews-ios-10-biggest-ios-release-ever.html), here are the **oldest** devices that will run iOS 10:

- [iPhone 5(c)](https://en.wikipedia.org/wiki/IPhone_5), A6 (2012)
- [iPod Touch 6](https://en.wikipedia.org/wiki/IPod_Touch_%286th_generation%29), A8 (2015)
- [iPad Mini 2](https://en.wikipedia.org/wiki/IPad_Mini_2), A7 (2013)
- [iPad 4](https://en.wikipedia.org/wiki/IPad_%284th_generation%29), A6X (2012)

This leaves us with a new baseline of the 32-bit [A6 SoC](https://en.wikipedia.org/wiki/Apple_A6). This is better for the moment, but the A6 already 4 years old. If iOS 11 continues to support the A6, then we'll likely return to the situation where the software has substantially out-paced the hardware. Again, we'll have sluggish devices that probably shouldn't be running the latest OS in the first place. Again, we'll be supporting 6-year-old hardware. But, maybe it won't be so bad.

Of course, when the day comes to drop the A6 we can say goodbye to 32-bit CPUs on iOS, and that will be great.

<span class="text-muted"><b>Note:</b> I realize that perhaps 6 years isn't <i>that old</i> for other platforms, but iOS moves so fast.</span>
