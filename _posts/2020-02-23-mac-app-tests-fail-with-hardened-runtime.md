---
layout: post
categories: [software-dev]
tags: [xcode, macos, apps, ci, debugging, testing]
date: 2020-02-23T14:55:43-08:00
title: Mac app tests fail with hardened runtime enabled
---

I recently discovered that unit tests and UI tests for a macOS Xcode project will fail with obscure error messages if the [hardened runtime](https://developer.apple.com/documentation/security/hardened_runtime) is enabled. It took me awhile to realize what the actual source of the problem was, because the error messages led me in the wrong direction. Hopefully this will save you some time.

<!--excerpt-->

I have a typical macOS Xcode project for a small Mac app. It lives in a private repo on GitHub and I wanted to setup [GitHub Actions](https://github.com/features/actions) for CI. To simplify that process, I disabled all code signing in the project settings and configured the project to "Sign to Run Locally". With code signing turned off, I could run tests on GitHub's CI environment without any additional configuration. However, at some point I must have accidentally changed the hardened runtime settings.

When the hardened runtime is enabled for unit tests and UI tests, Xcode fails with some obscure error messages. The root of the problem seems to be that Xcode cannot load the `XCTest` bundle in this scenario. It is easy to reproduce: create a new empty macOS app project, enable hardened runtime for all targets, then run the tests.

For UI tests it fails with the following message:

```
not valid for use in process using Library Validation: mapped file has no Team ID and is not a platform binary (signed with custom identity or adhoc?)
```

The complete UI test logs (with paths redacted):

```
dyld: Library not loaded: @rpath/XCTest.framework/Versions/A/XCTest
  Referenced from: <PATH>/Xcode/DerivedData/MyApp-gqrupcoqijumllennrlrjosdynzy/Build/Products/Debug/MyAppUITests-Runner.app/Contents/MacOS/MyAppUITests-Runner
  Reason: no suitable image found.  Did find:
    <PATH>/Xcode/DerivedData/MyApp-gqrupcoqijumllennrlrjosdynzy/Build/Products/Debug/MyAppUITests-Runner.app/Contents/MacOS/../Frameworks/XCTest.framework/Versions/A/XCTest:
    code signature in (<PATH>/Xcode/DerivedData/MyApp-gqrupcoqijumllennrlrjosdynzy/Build/Products/Debug/MyAppUITests-Runner.app/Contents/MacOS/../Frameworks/XCTest.framework/Versions/A/XCTest)
    not valid for use in process using Library Validation: mapped file has no Team ID and is not a platform binary (signed with custom identity or adhoc?)
```

And unit tests fail similarly, with some additional (though not helpful) information.

```
Error Domain=NSCocoaErrorDomain Code=3587

NSLocalizedFailureReason=The bundle is damaged or missing necessary resources.

NSLocalizedRecoverySuggestion=Try reinstalling the bundle.
```

The complete unit test logs (with paths redacted):

```
MyApp[9030:262077] Launching with XCTest injected. Preparing to run tests.

MyApp[9030:262077] Failed to load test bundle from file://<PATH>/Xcode/DerivedData/MyApp-gqrupcoqijumllennrlrjosdynzy/Build/Products/Debug/

MyApp.app/Contents/PlugIns/MyAppTests.xctest/:
Error Domain=NSCocoaErrorDomain Code=3587 "dlopen_preflight(<PATH>/Xcode/DerivedData/MyApp-gqrupcoqijumllennrlrjosdynzy/Build/Products/Debug/MyApp.app/Contents/PlugIns/MyAppTests.xctest/Contents/MacOS/MyAppTests):

    no suitable image found.  Did find:
    <PATH>/Xcode/DerivedData/MyApp-gqrupcoqijumllennrlrjosdynzy/Build/Products/Debug/MyApp.app/Contents/PlugIns/MyAppTests.xctest/Contents/MacOS/MyAppTests:
    code signature in (<PATH>/Xcode/DerivedData/MyApp-gqrupcoqijumllennrlrjosdynzy/Build/Products/Debug/MyApp.app/Contents/PlugIns/MyAppTests.xctest/Contents/MacOS/MyAppTests)
    not valid for use in process using Library Validation: mapped file has no Team ID and is not a platform binary (signed with custom identity or adhoc?)"

    UserInfo={NSLocalizedFailureReason=The bundle is damaged or missing necessary resources.,

    NSLocalizedRecoverySuggestion=Try reinstalling the bundle.,

    NSFilePath=<PATH>/Xcode/DerivedData/MyApp-gqrupcoqijumllennrlrjosdynzy/Build/Products/Debug/MyApp.app/Contents/PlugIns/MyAppTests.xctest/Contents/MacOS/MyAppTests,

    NSDebugDescription=dlopen_preflight(<PATH>/Xcode/DerivedData/MyApp-gqrupcoqijumllennrlrjosdynzy/Build/Products/Debug/MyApp.app/Contents/PlugIns/MyAppTests.xctest/Contents/MacOS/MyAppTests):

    no suitable image found.  Did find:
    <PATH>/Xcode/DerivedData/MyApp-gqrupcoqijumllennrlrjosdynzy/Build/Products/Debug/MyApp.app/Contents/PlugIns/MyAppTests.xctest/Contents/MacOS/MyAppTests:
    code signature in (<PATH>/Xcode/DerivedData/MyApp-gqrupcoqijumllennrlrjosdynzy/Build/Products/Debug/MyApp.app/Contents/PlugIns/MyAppTests.xctest/Contents/MacOS/MyAppTests)
    not valid for use in process using Library Validation: mapped file has no Team ID and is not a platform binary (signed with custom identity or adhoc?),

    NSBundlePath=<PATH>/Xcode/DerivedData/MyApp-gqrupcoqijumllennrlrjosdynzy/Build/Products/Debug/MyApp.app/Contents/PlugIns/MyAppTests.xctest,

    NSLocalizedDescription=The bundle “MyAppTests” couldn’t be loaded because it is damaged or missing necessary resources.}

MyApp[9030:262077] Waiting to run tests until the app finishes launching.

MyApp[9030:262077] ApplePersistenceIgnoreState: Existing state will not be touched. New state will be written to (null)

MyApp[9030:262077] The bundle “MyAppTests” couldn’t be loaded because it is damaged or missing necessary resources. Try reinstalling the bundle.

MyApp[9030:262077] (dlopen_preflight(<PATH>/Xcode/DerivedData/MyApp-gqrupcoqijumllennrlrjosdynzy/Build/Products/Debug/MyApp.app/Contents/PlugIns/MyAppTests.xctest/Contents/MacOS/MyAppTests): no suitable image found.  Did find:
    <PATH>/Xcode/DerivedData/MyApp-gqrupcoqijumllennrlrjosdynzy/Build/Products/Debug/MyApp.app/Contents/PlugIns/MyAppTests.xctest/Contents/MacOS/MyAppTests:
    code signature in (<PATH>/Xcode/DerivedData/MyApp-gqrupcoqijumllennrlrjosdynzy/Build/Products/Debug/MyApp.app/Contents/PlugIns/MyAppTests.xctest/Contents/MacOS/MyAppTests)
    not valid for use in process using Library Validation: mapped file has no Team ID and is not a platform binary (signed with custom identity or adhoc?))
```

Considering I was intentionally changing code signing settings for tests to run on CI, you can see how the error messages about a missing Team ID, custom signing identity, and a damaged bundle were confusing.

The solution to fix this is to enable the hardened runtime only for release, and leave it disabled for debug.
