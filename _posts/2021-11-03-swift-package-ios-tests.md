---
layout: post
categories: [software-dev]
tags: [ios, xcode, swiftpm, swift]
date: 2021-11-03T11:43:37-07:00
date-updated: 2021-11-17T16:14:19-08:00
title: How to test an iOS Swift package without an Xcode project
---

I came across a situation today where I needed to run an iOS test suite for a Swift Package. Previously, this required you to have an Xcode project but it no longer does.

<!--excerpt-->

I'm not entirely sure when this changed, but before, if you had a Swift package that supported iOS then the only way to build, run, and test that package was to have an Xcode project. Only having a `Package.swift` file would not suffice. The Swift Package Manager could generate a project for you.

```bash
swift package generate-xcodeproj
xcodebuild test -project MyPackage.xcodeproj -scheme MyPackage -sdk iphonesimulator15.0 -destination "OS=15.0,name=iPhone 13 Mini"
```

Since it has been awhile since I've needed to do this, I wanted to see if there have been any changes. Luckily, there have and you no longer need an Xcode project for building and testing. This [older thread on the Swift Forums explains](https://forums.swift.org/t/swiftpm-and-library-unit-testing/26255/19). The `generate-xcodeproj` command has been deprecated, and you'll get a warning when using it.

If you have only a `Package.swift`, you can build and test via `xcodebuild` similar to how you would with a Xcode project. First, run `xcodebuild -list` to find valid schemes from the package. Then invoke `xcodebuild` with the desired scheme. Note that no project needs to be specified.

```bash
xcodebuild test -scheme MyScheme -sdk iphonesimulator15.0 -destination "OS=15.0,name=iPhone 13 Mini"
```

This makes working with iOS packages much nicer, especially for non-UI iOS libraries where you never need to actually run on a simulator. This also simplifies running tests on CI. However, you still cannot build **and run** a Swift package on the iOS simulator.

{% include updated_notice.html
message="
Reader [Bernd Rabe has pointed out](https://github.com/jessesquires/jessesquires.com/issues/158) that testing packages this way prevents Xcode from collecting code coverage results, which I have also noticed. You win some, you lose some, I guess. I do not know of any workarounds at this time. If you need code coverage, you will need to keep using an Xcode project.
" %}
