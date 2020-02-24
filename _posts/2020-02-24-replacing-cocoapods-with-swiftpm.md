---
layout: post
categories: [software-dev]
tags: [xcode, ios, macos, cocoapods, swiftpm, dependencies]
date: 2020-02-24T10:23:25-08:00
title: My experience replacing CocoaPods with SwiftPM
image:
    file: xcode-swiftpm.png
    alt: Xcode integration with SwiftPM
    caption: Xcode integration with SwiftPM
    half_width: false
---

Last year [Xcode 11](https://developer.apple.com/documentation/xcode_release_notes/xcode_11_release_notes) was released with integrated support for the [Swift Package Manager](https://swift.org/package-manager/). For a couple of small projects of mine, I decided to try using it to manage dependencies instead of [CocoaPods](https://cocoapods.org). Overall, using SwiftPM was a great user experience, but (as expected) it has clear shortcomings due to its lack of maturity.

<!--excerpt-->

{% include post_image.html %}

### The good

Adding packages is easy. There is no [Podfile](https://guides.cocoapods.org/using/the-podfile.html) to maintain, which is great. Xcode provides a great UI for adding packages. Select your project in the sidebar, select the "Swift Packages" tab, then click the "+" button to add a package.

In terms of authoring packages, you do not have to maintain a [podspec](https://guides.cocoapods.org/syntax/podspec.html) file and publish separate spec updates. All you need to do is tag new releases in git or on GitHub. In fact, once writing your `Package.swift` it should rarely need to change. Compare this with a `.podspec`, where you at least have to update the version number for every release.

It is very convenient to have a first party tool. There is nothing extra to install on CI environments. Other contributors also do not need to install additional tools.

Xcode displays your dependencies in the sidebar in a clear and organized way. It even shows the current version number for a package, which I appreciate.

You do not have to use an Xcode workspace, or otherwise tamper with the build process. A first-party tool means you can be reasonably confident that everything will be built and linked correctly.

There is no "black box magic". SwiftPM is [open-source](https://github.com/apple/swift-package-manager) like CocoaPods. It may not be as easy or as fast to contribute, but it is possible.

Using private packages is much easier and simpler than using private pods. You no longer have the burden of maintaining a private specs repo. Instead you can add packages from private repositories directly in Xcode, like with open-source packages. If you sign-in to GitHub in the Xcode account preferences, when adding a package it will list all the repos for your account and for organizations to which you belong. If working on a team, all members would need access to any private package repositories. You would also need to make GitHub credentials available on your CI environment. However, you have probably already done this since your team is most likely working on a private, closed-source app. (And this basically what you would need to do to setup a private specs repo.)

The `Package.resolved` file is stored in your project directory, so you can easily check it in to source control.

Overall, the developer experience is great. In my usage, everything "just works" as expected. Having dependency management integrated into Xcode makes development easier and simpler.

### The bad

There is no equivalent to the `Pods/` directory that CocoaPods creates. Checking-in your `Pods/` directory [has always been a source of controversy](https://guides.cocoapods.org/using/using-cocoapods.html#should-i-check-the-pods-directory-into-source-control), but at least everyone could make that choice. With SwiftPM, the dependencies are stored in deep in your project's derived data directory (`~/Library/Developer/Xcode/DerivedData/...`). Depending on your `Pods/` preference, this will be great or terrible. One workaround is to change the Xcode "Locations" preferences to store `DerivedData/` relative to your project directory. However, this comes with additional concerns since `DerivedData/` includes **a lot** more than just SwiftPM dependencies. You will have to ignore those additional files and directories. And unfortunately, that is a global setting for all Xcode projects.

There is no way to update a single package. In general, updating packages is sort of cumbersome. You do this via the `File > Swift Packages` menu. This is currently "all or nothing", which is not always what you want to do. As a workaround, you can update the version rules for a single package. This is not ideal.

The `Package.resolved` file is created in your project directory but it is stored at `MyApp.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`. This is not a huge problem, but it would be nice to have this in the project root or another more obvious location.

There is no flexibility or ability to customize how packages are integrated. There are no "pre-install" or "post-install" hooks. When using the integration in Xcode, there is no way to link packages to specific targets (for example, if you want to use a third-party testing framework), or only include packages in a specific configuration (for example, linking a debugging framework only in `DEBUG`.) If you maintain your own `Package.swift` file, it is possible to specify test-target dependencies. However, for Apple-platform projects you still need a proper `.xcodeproj`.

As mentioned above, SwiftPM is open-source but upstreaming changes and fixes is a slower process than a community-driven tool like CocoaPods. CocoaPods can release new versions quickly for fixes and new features. SwiftPM is bound to the Xcode release schedule. You could use development snapshots, but this comes with its own concerns and disadvantages.

SwiftPM currently does not support libraries that are mixed Objective-C and Swift.

SwiftPM currently does not support bundling resources like images, Storyboards, asset catalogs, etc.

### Summary

Again, the projects where I'm using SwiftPM are small and simple. I am the only developer and I own all of the dependencies that I'm using. These dependencies also do not contain any Objective-C or bundled resources. In this scenario, using SwiftPM is pretty great, since the cons mentioned above do not really affect me. For larger and more complex apps, or when working on a team, I think the flexibility and customization made possible by CocoaPods would be preferred for most projects. For my larger apps, I will continue using CocoaPods for now.

Still, I think there is a lot of potential with SwiftPM integration in Xcode. The majority of the issues noted above can be easily fixed &mdash; adding a per-package update, adding a per-package target for linking, adding an option to keep a `SwiftPM/` directory in your project root, allow including bundled resources, and allow mixing Objective-C and Swift. I am hopeful that these shortcomings will be addressed, but unfortunately that is subject to Apple's internal release schedule.
