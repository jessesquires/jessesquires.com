---
layout: post
title: How to run sysdiagnose on iOS
subtitle: And on all the Apple things
image:
    file: apple-bug-report.png
    alt: 'Apple Bug Report'
    source_link: https://dribbble.com/shots/3617982-Apple-Bug-Report-iOS
    half_width: false
---

When you [file a radar](https://developer.apple.com/bug-reporting/) for a bug on one of Apple's platforms, you should (usually) always attach a sysdiagnose. A sysdiagnose provides a lot of helpful information for the person who is trying to understand how the bug happened. Amongst other things, it contains logs from various parts of the OS, and all recent crash logs. Without it, the person on the other end of your report inside Apple may not be of much help. On macOS running sysdiagnose is somewhat common, but what about iOS?

<!--excerpt-->

{% include post_image.html %}

### sysdiagnose on macOS

On macOS, [sysdiagnose is fairly well-documented](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/sysdiagnose.1.html). You can run it from the command line via `sudo sysdiagnose`, which will place the resulting `.tar.gz` file in `/var/tmp/`. Alternatively you can use the keyboard shortcut: `control` + `option` + `command` + `shift` + `.` &mdash; which will trigger a flash on your screen and when the report is finished generating, Finder.app will open the enclosing folder (`/var/tmp/`). It can take up to 10 minutes to complete and there are no visual indicators that anything is happening. Be patient and continue with whatever work you were doing. The report will contain tons of logs, system statistics, and other diagnostic information. You can find official [instructions for macOS here](https://download.developer.apple.com/OS_X/OS_X_Logs/sysdiagnose_Logging_Instructions.pdf).

> **Note:** On all systems, the device will become unresponsive during parts of generating the sysdiagnose and the generated `.tar.gz` will usually be around 200-300 MB.

### sysdiagnose on iOS

What about sysdianogse iOS? A friend recently told me this was possible. After some searching, I did find [official developer instructions](https://download.developer.apple.com/iOS/iOS_Logs/sysdiagnose_Logging_Instructions.pdf) for running sysdiagnose on iOS. To trigger a sysdiagnose on iOS, simultaneously press both volume buttons and the power button. You'll feel a short vibration or haptic feedback if successfully triggered. Like macOS, it will take up to 10 minutes to generate. After waiting, you'll find the `.tar.gz` by navigating to Settings.app > Privacy > Analytics > Analytics Data. It's a bit obscure. There will be a large list of files and logs here in alphabetical order. Scroll toward the bottom until you find the "sysdiagnose..." file. Tap the file, then tap the "share" button in the top right and you can AirDrop it to your Mac. Then attach the file to your bug report. Like I mentioned earlier, this file will be around 200-300 MB, so don't try sending it via email or iMessage.

### sysdiagnose for tvOS and watchOS

I was surprised to learn that you can even run sysdiagnose on tvOS and watchOS.

- [Instructions for tvOS](https://download.developer.apple.com/iOS/tvOS_Logs/sysdiagnose_Logging_Instructions.pdf)
- [Instructions for watchOS](https://download.developer.apple.com/iOS/watchOS_Logs/sysdiagnose_Logging_Instructions.pdf)

### sysdiagnose for specific apps

Some macOS applications have their own sysdiagnose. For Xcode, you can run `sudo sysdiagnose Xcode`. For Mail.app you can run `sudo sysdiagnose Mail`. Next time you're having an issue with Xcode, file a radar and attach a sysdiagnose.

- [Instructions for Mail.app](https://download.developer.apple.com/OS_X/OS_X_Logs/Mail_app_sysdiagnose_Logging_Instructions.pdf)
- [Instructions for Xcode](https://download.developer.apple.com/OS_X/OS_X_Logs/Xcode_sysdiagnose_Logging_Instructions.pdf)

### Writing better bug reports

Peter Steinberger already wrote a great guide to [writing good bug reports](https://pspdfkit.com/blog/2016/writing-good-bug-reports/). In addition to all of his excellent advice, often attaching a sysdiagnose can be a huge help &mdash; even if you have reliable steps to reproduce or a specific crash report. A sysdiagnose contains additional helpful information. It's easy to do and available on all platforms.
