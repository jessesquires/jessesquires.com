---
layout: post
categories: [software-dev]
tags: [cocoapods, dependencies, ios, macos, swiftpm, xcode]
date: 2020-03-04T21:22:45-08:00
title: Another issue with SwiftPM Xcode integration
---

I recently [wrote about using SwiftPM instead of CocoaPods]({% post_url_absolute 2020-02-24-replacing-cocoapods-with-swiftpm %}), which included a list of pros and cons. While working on one of my projects that is using SwiftPM, I realized another issue with how SwiftPM currently integrates with Xcode.

<!--excerpt-->

I mentioned that there is no equivalent of a `Pods/` directory with SwiftPM and that package dependencies are stored in Xcode's derived data directory, `~/Library/Developer/Xcode/DerivedData/`. This is problematic beyond not being able to check-in dependencies into source control. What I failed to realize at the time are the implications for cleaning or deleting derived data, which unfortunately is often necessary when working with Xcode. In fact, I have a custom shell command for doing this (which I call `xcclean`), and it runs `rm -rf ~/Library/Developer/Xcode/DerivedData`. Most folks I know have something similar, because Xcode.

This will not work if you are using SwiftPM. If you completely nuke your `DerivedData/` directory and then attempt to build your project, it will fail to build with the error "Missing package product" for each package. To trigger re-downloading, you must choose `File > Swift Packages > Resolve Package Versions`. What a pain this would be if you were working without an Internet connection.

Luckily, simply "cleaning" your build folder by choosing `Product > Clean Build Folder` in the Xcode file menu, or `cmd+shift+K` will do the correct thing, and leave your package sources intact.

I suppose I will have to update my `xcclean` command to be smarter.
