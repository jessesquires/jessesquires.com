---
layout: post
categories: [software-dev]
tags: [macos, testing, apps, debugging, xcode]
date: 2021-03-19T13:24:11-07:00
date-updated: 2021-04-06T23:19:04-07:00
title: How to test your Mac app (or not) and decide which versions of macOS to support (or not)
---

As I continue to pursue Mac app development more seriously, I can build on and borrow from my many years of iOS experience. While many aspects of writing Mac apps are very similar to iOS, or at least *somewhat familiar*, other aspects are quite different. One of the big differences is testing, and deciding how many versions of macOS to support.  

<!--excerpt-->

### Choosing a deployment target

For iOS, the general rule in the community and "official" guidance from Apple is to support the most recent major version of iOS as well as the previous major release. As of this writing, that would mean supporting iOS 13 and 14. Usually, there is a short period right after a new iOS release where you are supporting the last three versions, the oldest of which is eventually dropped. (Now is around the time that teams are dropping support for iOS 12, if they haven't already.) In some cases, especially for very popular apps at large companies, supporting three (or more) versions of iOS may be the norm, but generally speaking, it is not common.

In any case, there is ample data not only provided [by Apple on their App Store support page](https://developer.apple.com/support/app-store/), but third-party analytics companies [like Mixpanel also report their own data](https://mixpanel.com/trends/#report/ios_14). Even popular tech blogs, like [MacRumors regularly repost](https://www.macrumors.com/2020/12/16/ios-14-installed-81-percent-iphones/) this information as well, in case you do not follow these primary sources.

Notably absent is any information about macOS adoption rates. Try to search, and you will be met with disappointment. The best (that is, *only*) information I could find, was [this data from StatCounter](https://gs.statcounter.com/macos-version-market-share/desktop/worldwide/#monthly-202003-202102-bar), which measures desktop market share worldwide based on web traffic. I do not know anything about this company or whether this data is accurate and trustworthy. It also is not entirely clear from their charts if "macOS version market share" is in relation to only macOS users or all users of all desktop operating systems. We are left with *some vague idea* about what macOS adoption is like, but it does not seem reliable. 

Of course, one reason for the discrepancy in data between iOS and macOS is because of the App Store &mdash; which is the only method of software distribution for iOS, but is optional (and largely neglected) for macOS. This makes it rather easy, especially for third-parties, to compile this data for iOS. Presumably, Apple has data on macOS adoption rates, which they could derive from serving software updates, but they refuse to publish it. (Perhaps this is because macOS adoption rates are so bad compared to iOS?)

In the absence of adoption rate data, and even guidance from Apple, choosing a deployment target for macOS remains somewhat elusive. Should we simply conform to the norms established by iOS and only support the two most recent major releases? Maybe. But maybe not, because we know that macOS adoption rates are significantly slower and some users *never* update their desktop computers or laptops. The new features (aka, new emoji) are so widely publicized for iOS that most users are ecstatic about updating as soon as possible. This is not the case for macOS.

So, what do we do? I think supporting at least the two latest version of macOS is the obvious default. The question is how far back do you go? (Which will bring us to our next issue below: testing.) You do not want to be miserable, burn out, or compromise on quality because you bear the burden of maintaining support for so many macOS versions, but you also do not want to leave potential users (or paying customers!) behind. People keep their Macs around for much longer than their iPhones, and often ignore macOS updates. However, the SDKs seem to generally support backwards compatibility very well.

My default approach for now is to support at least the last three versions of macOS. As of this writing, that means 10.14 Mojave, 10.15 Catalina, and 11.0 Big Sur. This feels like a good balance to me, as a team of one. However, for some apps, it is interesting to see how low of a deployment target is feasible with as few code changes as possible. For example, if I can set the deployment target back to 10.11 El Capitan **without** having to add any [`#available` checks](https://nshipster.com/available/), then should that be my minimum supported version? I think the biggest consideration should be the maintenance cost, because how would you even test your app on macOS 10.11 El Capitan?

### Testing on older version of macOS

Note that, like iOS, setting your macOS deployment target and building with the latest SDKs will give you backwards compatibility for old operating systems for free. So, I could just assume everything works as expected on macOS 10.14 and 10.15, even though I am only building and running on macOS 11.0 during development. Lately, that has been my strategy. And as I mentioned, the macOS SDKs seem much more robust than iOS in terms of backwards compatibility (possibly due to neglect?), but it would be nice to verify that my apps function correctly. If claiming to support older versions of macOS, I want to do my due diligence and _at least_ make sure they work as expected on those older versions, like a _good developer_.

For iOS development, this is quite easy. You can download the old simulator runtimes that you support, then build and run from Xcode. Or even better, you may have an old iPhone or iPad running an older version of iOS that you keep around specifically for testing. Then you can build and run directly on that old device. However, there is no simulator for macOS, and I do not have old Macs running old versions of macOS just lying around. (Maybe long-time Mac developers do?) So... what do I do?

### Installing older versions of macOS

The first step is [creating a bootable installer for macOS](https://support.apple.com/en-us/HT201372). Thankfully, Apple provides a support guide for this which contains links to various macOS versions. Notably, the oldest version listed is macOS 10.11 El Capitan. I would say this clearly indicates that you should probably not try to support any version before El Capitan &mdash; which is 6 years old!

Next is figuring out where to install these older versions of macOS such that you can install and run your app on them to verify it works. You can probably guess what your options are here. I will list them from least to most invasive.

1. Use a virtual machine. This is pretty straight forward. You can uses Parallels or VMWare. (I have not tried either.)
2. Partition and install different macOS versions on an external hard drive, then boot from that drive.
3. Partition your Mac's **internal** hard drive and install different macOS versions, then boot from specific partitions.

A virtual machine seems quick and easy enough, though less reliable than a native installation. As [Peter Steinberger](https://mobile.twitter.com/steipete/status/1368891985482940416) pointed out on Twitter, VMs are slow with graphics and Metal emulation can be unreliable and unstable.

Partitioning my Mac's internal drive sounds like a nightmare. My experience with macOS has been too unstable in recent years to even want to attempt this, especially resizing the existing partition live, etc. Who knows what kinds of bugs this might introduce. Or worse, I may end up with a bricked MacBook and have to wipe my machine and start over if something goes wrong. No, thank you.

Installing macOS on a partitioned **external** drive sounds like a great balance. This is the approach I am going to take, using a small external Thunderbolt SSD that I will reserve for this purpose only. This feels like the best middle ground between reliability and invasiveness. However, rebooting in order to test or debug something on macOS 10.14 or 10.15 will be annoying. Luckily, based on feedback from other Mac developers on Twitter, it sounds like it may not be necessary very often.

### Debugging your app on older versions of macOS

This next problem is much more complicated. So far, we have discussed simply **installing and running** your Mac app on an older macOS. But what about **debugging** on older versions of macOS? This is where the real conundrum begins. 

As you know, *eventually* every major Xcode release requires the latest release of macOS. This is happening right now with [Xcode 12.5](https://developer.apple.com/documentation/xcode-release-notes/xcode-12_5-beta-release-notes) (currently in beta), which requires macOS Big Sur 11.0 or later. If you want to build and run your app on macOS 10.15 and earlier, you will need to use Xcode 12.4 or earlier. 

But it gets more complicated than that. Because every major release of Xcode eventually drops support for prior versions of macOS, you must continue reverting to prior releases of Xcode. Essentially, this means each time you go back to a previous macOS, you also need to go back to a previous Xcode. And by now I'm sure you've realized the problem &mdash; what if your app's Xcode project **cannot be built with older versions of Xcode?** 

The primary barrier to using an old Xcode is the Swift Language and Compiler version. Newer versions of the Swift Compiler can compile older versions of the Swift Language &mdash; but only to a certain point. (For example, you cannot use the latest compiler to mix Swift 1.0 with Swift 5.0.) However, older versions of the Swift Compiler do not know about future versions. You may be able to workaround this using [Swift's version checking](https://nshipster.com/swift-system-version-checking/), for example `#if swift(<5)`. Depending on your app, this may or may not be feasible, not to mention the increased maintenance burden.

Next, though less likely, you may be using new Xcode or SDK features that are not backwards compatible. For example, if you are using [SwiftUI](https://developer.apple.com/documentation/swiftui/) (even just [SwiftUI previews](https://nshipster.com/swiftui-previews/)), then you are in trouble. Because SwiftUI does not exist in Xcode 10, which you would need for testing on 10.14 Mojave.

Finally, if you are using **only** Objective-C (I'm looking at pretty much **only** you, [Jeff](https://lapcatsoftware.com/main/Resume.html)), then none of this is much of a concern. You may need to add some [`@available` checks](https://developer.apple.com/documentation/swift/objective-c_and_c_code_customization/marking_api_availability_in_objective-c), which I think should mostly work without any issues.

There is no good solution here. Unfortunately, I do not have the capacity to implement a robust solution for this either. Because I am using Swift and I have little interest in returning to Objective-C, my plan for now is to drop older versions of macOS once they become too burdensome to support.

### Summary

Before writing this article, I asked folks on Twitter for advice and how they approach these problems. The above is everything I have learned so far. Many thanks to [Jeff Johnson](https://mobile.twitter.com/lapcatsoftware), [Tony Arnold](https://mobile.twitter.com/tonyarnold), [Ellen Teapot](https://mobile.twitter.com/asmallteapot), [Peter Steinberger](https://mobile.twitter.com/steipete), [Nick Lockwood](https://mobile.twitter.com/nicklockwood), [Sam Rowlands](https://mobile.twitter.com/Sam_Ohanaware), and the many others who replied.

Based on the discussions from Twitter, the general consensus in the community and key takeaways for how to tackle these problems are the following:

1. There seems to be an even mix of how people manage multiple macOS installations &mdash; virtual machines, internal partitions, or booting from an external drive. Do what works best for you, but be aware of the pros and cons of each.
1. Most folks choose to support only the two or three most recent major releases of macOS. Anything else is usually too difficult for testing if you find bugs, especially for small teams.
1. You can largely get away with simply installing and running your app on older versions of macOS and doing some usability "smoke" testing, rather than trying to build with an old Xcode. This is simple and fast. If you get bug or crash reports for old macOS versions, then you can investigate further.
1. There is no good solution to the debugging problems mentioned, if you are using the latest version and features of Swift extensively.
1. If you do find a bug when testing (by installing and running, not by building via Xcode), then evaluate the severity of the bug and if it is worth fixing or simply dropping the version of macOS in which it occurs. How many customers would be affected by dropping that macOS release? How much development time and effort will it take to continue supporting that macOS version?

As always, if you have any other tips or advice, let me know!

### Update: what about M1 Macs?

Recently, [Antoine van der Lee](https://www.avanderlee.com) started a [discussion on Twitter](https://mobile.twitter.com/twannl/status/1379087981135429633) centered around the question of testing with an M1 Mac. If you only have an M1 Mac, how do you proceed with all of the above? 

It appears that an internal partition will be more involved due to the substantial changes to [boot and recovery](https://eclecticlight.co/2021/01/14/m1-macs-radically-change-boot-and-recovery/) on M1 Macs. I am not entirely sure how this will work. But, per the discussion above, this was not the best option anyway. Regarding booting from an external drive, it looks like [there have been issues](https://eclecticlight.co/2021/02/10/external-boot-disks-still-dont-work-properly-with-m1-macs/) using [external boot disks with M1 Macs](https://eclecticlight.co/2021/02/27/big-sur-11-2-2-still-doesnt-fix-bugs-with-m1-external-bootable-disks/), but [it is possible](https://eclecticlight.co/2020/12/22/booting-an-m1-mac-from-an-external-disk-it-is-possible/) to do. Regarding virtual machines, I did a brief search and it looks like Parallels and VMware plan to eventually support the M1, but it is not clear when that will happen.

However, all of this is somewhat of a moot point once you realize that M1 Macs **cannot** run versions of macOS prior to Big Sur. Perhaps you could run macOS Catalina in a VM, but I have no idea. As far as I can tell, booting into macOS Catalina (or earlier) via an external disk on an M1 Mac simply will not work. How could it? Prior to Big Sur, macOS has no knowledge of the M1.

What a mess. I guess the best advice is: if you upgrade to an M1, do not get rid of your Intel Mac.

If you have an M1 Mac, I highly recommend checking out Howard Oakley's [excellent collection of articles](https://eclecticlight.co/m1-macs/) about the M1.
