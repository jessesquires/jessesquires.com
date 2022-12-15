---
layout: post
categories: [software-dev]
tags: [ios, xcode, nine41]
date: 2020-04-13T11:46:38-07:00
title: Fully automating perfect status bar overrides for iOS simulators with Nine41
image:
    file: 'nine41-second-build.png'
    alt: 'Nine41 build output'
    caption: 'Nine41 build output in Xcode.'
    source_link: null
    half_width: false
---

I few months ago I [wrote a script]({% post_url 2019-09-30-automating-simctl-status-bar %}) to override status bar display settings in the iOS simulator using the new `simctl status_bar` feature in Xcode 11. This was great, but it still required that you manually run the script after launching simulators. This was not ideal, as [Dave pointed out in iOS Dev Weekly](https://iosdevweekly.com/issues/424#tools) when he challenged me to automate this anytime a simulator launches.

<!--excerpt-->

> What I really want is for **every** simulator to start up **every** time with a perfect status bar. Can I link to a blog post that makes **that** possible next week please Jesse? ([Issue #424](https://iosdevweekly.com/issues/424#tools))

Well, Dave &mdash; it is time to celebrate. I managed to figure this out, but it is *a little bit* of a hack. 😬 (Also, thanks to [Harlan Haskins](https://twitter.com/harlanhaskins) and [Gal Cohen](https://twitter.com/GcIsMe26) for their help debugging some issues on Twitter.)

### Nine41

Let's start with the [latest changes in Nine41](https://github.com/jessesquires/Nine41/releases). I made it a proper [Swift package](https://github.com/jessesquires/Nine41/blob/master/Package.swift), so it is now much easier for clients to consume. One detail that I missed before was that iPad status bars display a date (example: `Tue Sep 10`) as well as the time, so now the default overrides [include a date](https://github.com/jessesquires/Nine41/pull/4) value (the release date of the original iPhone). Next, [Xcode 11.4](https://developer.apple.com/documentation/xcode_release_notes/xcode_11_4_release_notes) added the ability to override the operator (carrier) name, which displays on non-notched iPhones (like iPhone 7 and 8). Nine41 now overrides this to be the empty string, instead of the default "Carrier" text.

### Automate running the script when launching the simulator

Initially I was unsure how to accomplish this, and then I realized I could probably add a "Run Script Phase" to Xcode's build phases &mdash; obvious in hindsight. But the challenge was, how can this be as easy as possible? How could it potentially work for a team?

You could build the package, and then simply execute the binary in the script phase. But that would require that everyone on your team download the package, build the package, and place the binary in their `PATH`, or some other predetermined location so that the script phase can find it. This could be automated, but it would require manually running an install script or something, and it creates more potential for error. If someone forgot to run the install script, then Xcode would fail on that build phase because it could not find the executable.

Then I had an idea. What if we could include Nine41 as a Swift package? We can. Though, it comes with a few caveats.

First, we need to add Nine41 as a [package dependency in our Xcode project](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).

{% include blog_image.html
    file='nine41-add-package.png'
    alt='Add Nine41 as a package dependency in Xcode'
    caption='Adding Nine41 as a package dependency in Xcode.'
    source_link=null
    half_width=false
%}

Note that we **cannot add this package as a target dependency** for our iOS app, because it is a macOS package. This is kind of a hack, but Xcode will fetch the package correctly.

Then we need to add a "run script" [build phase](https://help.apple.com/xcode/mac/11.4/#/dev50bab713d), with the following:

```bash
/usr/bin/xcrun --sdk macosx swift run --package-path "${BUILD_ROOT}/../../SourcePackages/checkouts/Nine41"
```

Let's break this down.

First, we need to specify the `macosx` SDK to [avoid build errors](https://forums.swift.org/t/swift-build-fails-inside-xcode-build-script/35127) when running `swift` inside an Xcode build phase script. Otherwise, Xcode will get confused, because we are working in an iOS project. We prefix the script with `/usr/bin/xcrun --sdk macosx` to accomplish this.

Next, we run the script using `swift run --package-path`, where we specify the path to the package.

This is where it gets sort of hacky. Unfortunately, there is no Xcode build variable that points to the root of your SwiftPM package sources, which lives in `~/Library/Developer/Xcode/DerivedData/<PROJECT>/SourcePackages/`. If we run `xcodebuild -showBuildSettings` on our project (or workspace), we can see the full list. The best we can do is `BUILD_ROOT`, which points to `~/Library/Developer/Xcode/DerivedData/<PROJECT>/Build/Products`. From there, we can go back a few directories where we will find the `SourcePackages/` directory and thus the full path to our package.

This setup satisfies our requirements. It is an easy, one-time setup and it will work for teams without any additional user intervention.

All that is left now is to build and run. And it works!

{% include post_image.html %}

### Caveats

There a few caveats to note. For the first run, Xcode will need to build the package, and if no simulators are running, it will not update the simulator status bars.

{% include blog_image.html
    file='nine41-first-build.png'
    alt='Nine41 build output'
    caption='Nine41 build output for the first run.'
    source_link=null
    half_width=false
%}

However, this is not _too bad_, since every subsequent run _will_ work. I think it is rare that developers are frequently closing simulators between runs. So in practice, this should not be much of a problem.

Next, it's not that fast. As you can see in the screenshots, the first run can be very slow. But subsequent runs are much faster. It my testing, it takes anywhere from 0.7 to 1.4 seconds to run. Depending on your current build times, this may not be ideal.

The script has to parse the JSON for the list of devices using `xcrun simctl list devices`. If you find the script to be too slow, try removing simulators you do not need, or remove all unavailable ones with `xcrun simctl delete unavailable`.

Next, you will have to set this up for each project you are working on individually. It is not ideal, but I do not know of a better solution. However, this is similar to other boilerplate setup that you always have to do, like running SwiftLint, for example.

Finally, because we are using the Swift Package Manager, we face [the drawbacks and shortcomings]({% post_url 2020-02-24-replacing-cocoapods-with-swiftpm %}) that I wrote about before. Using CocoaPods instead would probably fix this, though I have not written a `.podspec` yet. Feel free to [send me a pull request](https://github.com/jessesquires/Nine41/pulls). 😄

### Bonus Trivia

We all know why [9:41 AM is always used by Apple for iPhone screenshots and marketing images](https://www.engadget.com/2014-04-14-why-9-41-am-is-the-always-the-time-displayed-on-iphones-and-ipad.html). But what about iPad screenshots and marketing images? They also display `9:41 AM`, but [the status bar was redesigned in iOS 12](https://www.macrumors.com/how-to/use-ios-12-ipad-gestures/) to include a date. Apple is too detail-oriented for this to be random, so what is its significance? If you look at the marketing images for the latest models &mdash; [iPad Pro](https://www.apple.com/ipad-pro/), [iPad Air](https://www.apple.com/ipad-air/), [iPad](https://www.apple.com/ipad-10.2/), [iPad Mini](https://www.apple.com/ipad-mini/) &mdash; they have different dates. The iPad Pro is `Wed Mar 18` and the others are `Tue Sep 10`. [Sound familiar](https://www.macrumors.com/2019/08/29/apple-september-10-event-apple-park/)? Each date matches the date that the iPad model was released or announced by Apple. Neat. There is a [complete list here](https://en.wikipedia.org/wiki/List_of_iOS_devices).

Wouldn't it be cool if Nine41 used the correct date for each iPad simulator? I think so! There is an [open issue on Github](https://github.com/jessesquires/Nine41/issues/7) if anyone is interested in working on this. It should not be too difficult.

### Conclusion

So there we have it &mdash; automatic pretty simulator status bars all the time, well sort of. I am not sure if this is the best task to add to your build process, but it works and it is not intrusive.
