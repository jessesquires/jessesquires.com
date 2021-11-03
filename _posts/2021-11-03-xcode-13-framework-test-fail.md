---
layout: post
categories: [software-dev]
tags: [xcode, ios, testing, bugs]
date: 2021-11-03T13:24:41-07:00
title: "Workaround: Xcode 13 failure after running framework project tests"
image:
    file: xcode-13-test-fail.png
    alt: Xcode 13 test failure
    caption: Xcode 13 test failure for framework tests
    source_link: null
    half_width: true
---

I discovered a bug in Xcode 13 where tests crash for framework projects, preventing unit tests from successfully running on CI. The issue is due to some obscure code signing or debugger error that did not occur on Xcode 12. Fortunately, I have found a workaround.

<!--excerpt-->

### The Xcode failure

This week, I've been updating CI for all of my open source projects to use Xcode 13 &mdash; specifically Xcode 13.1 (13A1030d). My projects use GitHub Actions, so I expected this to be a quick change like usual &mdash; update the workflow to use the latest Xcode, specify the latest simulators in `xcodebuild`, open a pull request to make sure everything works, then merge.

One of my projects experiencing this issue is my library [Foil](https://github.com/jessesquires/Foil). You can reproduces the issues with that project. For the remainder of this post, I'll use it as an example. It supports all platforms.

Unfortunately, making these updates did not go as planned for any of my projects. When attempting to run tests for a **framework project**, tests fail with the following error:

```
Could not attach to pid : “32764”
Domain: IDEDebugSessionErrorDomain
Code: 7
Failure Reason: “FoilTests” failed to launch or exited before the debugger could attach to it. Please verify that “FoilTests” has a valid code signature that permits it to be launched on “Clone 1 of iPhone 13 mini”. Refer to crash logs and system logs to for more diagnostic information.
User Info: {
    DVTRadarComponentKey = 855031;
    IDERunOperationFailingWorker = DBGLLDBLauncher;
    RawUnderlyingErrorMessage = "no such process.";
}
```

{% include post_image.html %}

It appears that _sometimes_ the tests _do run_ successfully and _then_ this failure occurs. Then subsequent test runs will not launch and fail immediately. This is particularly problematic for CI because it results in a failure for the entire run.

All platforms are affected &mdash; iOS, tvOS, watchOS, and macOS. It appears to be some issue with code signing and/or the debugger? I don't really understand it. However, my code signing settings have not changed for any of my projects since Xcode 12 &mdash; which, again, did not experience this issue. The signing settings are:

1. Automatically manage signing is _unchecked_
2. No team is selected
3. Signing certificate is generic "iOS Developer" and "Sign to Run Locally"

In effect, this these are the typical "disabled/turn-off all signing" settings that worked before Xcode 13.

### The workaround

The workaround, both locally on my machine and for CI, is to clean first. That is, run `xcodebuild clean test` instead of `xcodebuild test`. Then tests run successfully and the error does not occur. However, this only works for tvOS, watchOS, and macOS. It **does not** work for iOS.

For iOS, the workaround I found was [running tests via a Swift package instead]({% post_url 2021-11-03-swift-package-ios-tests %}). Again, this is a framework project. I distribute my libraries via SwiftPM and CocoaPods, so I already had a `Package.swift` file for this project.

Because I also use an Xcode project, on GitHub Actions I needed to delete that project first. This will force `xcodebuild` [to use the Swift package]({% post_url 2021-11-03-swift-package-ios-tests %}) instead.

```bash
rm -rf Foil.xcodeproj
xcodebuild test -scheme Foil -sdk iphonesimulator15.0 -destination "OS=15.0,name=iPhone 13 Mini" | xcpretty -c
```

### Xcode 13.2 Beta

In the latest Xcode 13.2 beta (13C5066c), the issue still occurs. However, attempting to run tests again without cleaning consistently fails with _a new error_ indicating that the LLDB RPC server has crashed:

```
Could not launch “FoilTests”
Domain: IDEDebugSessionErrorDomain
Code: 3
Failure Reason: The LLDB RPC server has crashed. You may need to manually terminate your process. The crash log is located in ~/Library/Logs/DiagnosticReports and has a prefix 'lldb-rpc-server'. Please file a bug and attach the most recent crash log.
User Info: {
    DVTErrorCreationDateKey = "2021-11-03 19:42:11 +0000";
    DVTRadarComponentKey = 855031;
    IDERunOperationFailingWorker = DBGLLDBLauncher;
    RawUnderlyingErrorMessage = "The LLDB RPC server has crashed. You may need to manually terminate your process. The crash log is located in ~/Library/Logs/DiagnosticReports and has a prefix 'lldb-rpc-server'. Please file a bug and attach the most recent crash log.";
}
```

Attempting to run tests again results in the same "code signature" / debugger error above.

Again, [using Foil as an example](https://github.com/jessesquires/Foil), I can reproduce this consistently for all platforms &mdash; iOS, tvOS, watchOS, and macOS.

1. Clean and run tests. Everything works. Tests run and pass as expected. (Except iOS, as mentioned.)
2. Run tests again, without cleaning. The LLDB RPC server crashes.
3. Run tests again, without cleaning. The "please verify valid code signature" error occurs.

Is anyone else seeing this? Let me know.

And yes, I did file a report: FB9738278.
