---
layout: post
categories: [software-dev]
tags: [xcode, ios, macos, bugs, swiftpm, swift, git]
date: 2024-05-29T19:06:41-07:00
date-updated: 2024-05-30T09:49:22-07:00
title: "Workaround: Xcode deletes Package.resolved file and produces 'missing package product' errors"
---

More and more Apple Platform developers are migrating away from [CocoaPods](https://cocoapods.org) in favor the [Swift Package Manager](https://www.swift.org/documentation/package-manager/), which is Apple's first-party tool for managing and integrating dependencies. While it is still [not quite a complete replacement]({% post_url 2020-02-24-replacing-cocoapods-with-swiftpm %}) for CocoaPods, it is getting closer. Unfortunately, SwiftPM's integration with Xcode still has a number of shortcomings, even though it was introduced with [Xcode 11](https://developer.apple.com/documentation/xcode-release-notes/xcode-11-release-notes) --- 4 years ago. The worst bug is that Xcode frequently and randomly deletes the `Package.resolved`, which in turn produces dozens or hundreds of `'missing package product'` errors. Here's how I've worked around this bug on a team I work on.

<!--excerpt-->

### The bug

Xcode seems to specifically delete `Package.resolved` when changing branches in git. Then, depending on how large your project is and how many Swift packages are included, you'll see dozens or hundreds or thousands of `'Missing package product <product_name>'` errors.

However, I have also experienced Xcode deleting the file for seemingly no reason at all. In fact, I've had moments where Xcode deletes the file immediately after I restore it via `git restore` --- and I can just do that infinitely. I put the file back, then Xcode deletes it. In that beautiful scenario, the Xcode project must be closed and re-opened.

Searching the Apple Developer Forums [returns dozens of results](https://developer.apple.com/forums/search?q=missing+package+product) for this bug. Here is [a recent one](https://developer.apple.com/forums/thread/755772) that correctly describes the problem. Here is [another post from 2021](https://developer.apple.com/forums/thread/687275) that has new replies from 2 weeks ago. There is also [this post from the Swift.org forums](https://forums.swift.org/t/missing-package-product-error-for-all-local-swift-packages-when-switching-git-branches/38041) --- from June 2020 --- describing the issue. If you read through that thread, you will see the problem was briefly fixed around Xcode 12, but regressed in either the 12.5 or 13.0 release. This forum thread also has new comments from the past 2 weeks (including from yours truly). Unfortunately, the Swift forums are not the right place to report bugs in Xcode.

Most "solutions" on the forums revolve around some magical combination of cleaning your project (`cmd-shift-K`), deleting Xcode's `DerivedData/`, running `File > Packages > Reset Package Caches`, running `File > Packages > Resolve Package Versions`, and closing and re-opening Xcode. All of this is very heavy-handed and there's a much lighter weight approach you can take to work around it.

This bug is happening in the latest release, Xcode 15.4 (15F31d). It is a widespread problem reported across the various forums, as well as on Mastodon and other platforms. Any developer on a team that is using SwiftPM with Xcode is experiencing this bug daily. Furthermore, running `xcodebuild -resolvePackageDependencies` seems to have no effect and it does not regenerate `Package.resolved`.

### The `Package.resolved` file and git

First, what is `Package.resolved` and why is it important? This file is equivalent to [`Podfile.lock`](https://guides.cocoapods.org/using/the-podfile.html) in CocoaPods --- similar to [`Gemfile.lock`](https://bundler.io/guides/using_bundler_in_applications.html#gemfilelock) in Ruby/Bundler, or [`package-lock.json`](https://docs.npmjs.com/cli/v7/configuring-npm/package-lock-json) in Node.js/npm. This file is a manifest that describes the exact versions used for every package dependency. It allows SwiftPM to always install the exact same packages on multiple machines, for example the machines of each member on a team and CI machines.

It turns out, it's just a JSON file. Here's an example of `Package.resolved` for an app that imports one library called `Foil`.

```json
{
  "pins" : [
    {
      "identity" : "foil",
      "kind" : "remoteSourceControl",
      "location" : "https://github.com/jessesquires/Foil",
      "state" : {
        "revision" : "bc08a46268cb3bb22fee2c8465d97e6d7bf981e1",
        "version" : "5.0.1"
      }
    }
  ],
  "version" : 2
}
```

Because `Package.resolved` is necessary to resolve the exact packages at their exact specified versions, it should be checked-in to source control.

If you are working with an Xcode project, `Package.resolved` is located at:

```
MyApp.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved
```

If you are working with an Xcode workspace, the file is located at:

```
MyApp.xcworkspace/xcshareddata/swiftpm/Package.resolved
```

When working with only Swift packages, your `Package.swift` file defines all of your package dependencies. This plays a similar role to the `Podfile` in CocoaPods. With SwiftPM's Xcode integration, the project file `project.pbxproj` --- everyone's favorite file --- maintains the list of Swift package dependencies and their pinned versions. Again, this fulfills the same role as the `Podfile`.

The project file is located at `MyApp.xcodeproj/project.pbxproj`. If you search the `project.pbxproj` file for `XCRemoteSwiftPackageReference` and `XCSwiftPackageProductDependency`, you will find all the Swift package references for your project. For the example `Package.resolved` file above, here is the `project.pbxproj` representation:

```xml
/* Begin XCRemoteSwiftPackageReference section */
0B3E8A0A28AD7D9C006FB785 /* XCRemoteSwiftPackageReference "Foil" */ = {
    isa = XCRemoteSwiftPackageReference;
    repositoryURL = "https://github.com/jessesquires/Foil";
    requirement = {
        kind = upToNextMajorVersion;
        minimumVersion = 5.0.0;
    };
};
/* End XCRemoteSwiftPackageReference section */
```

For small teams or individuals that already include their entire `.xcodeproj` or `.xcworkspace` bundles in git, there is nothing else you need to do. However, most teams explicitly ignore `.xcodeproj` and `.xcworkspace` --- ironically, because of `project.pbxproj`, which is a nightmare to resolve when you have conflicts in git. These teams typically use [Xcodegen](https://github.com/yonaskolb/XcodeGen) or a similar tool to generate their project files, thus entirely avoiding merge conflicts on `project.pbxproj`. In this scenario, including the `Package.resolved` file but ignoring everything else requires a bit of work. Here are the git ignore rules needed:

```bash
# .gitignore file

MyApp.xcworkspace/*
!MyApp.xcworkspace/xcshareddata/
MyApp.xcworkspace/xcshareddata/*
!MyApp.xcworkspace/xcshareddata/swiftpm/
MyApp.xcworkspace/xcshareddata/swiftpm/*
!MyApp.xcworkspace/xcshareddata/swiftpm/Package.resolved
```

Note that with tools like Xcodegen, you [define your packages](https://github.com/yonaskolb/XcodeGen/blob/master/Docs/ProjectSpec.md#swift-package) in your `project.yml` file, which essentially is a replacement for `project.pbxproj`.

{% include updated_notice.html
date="2024-05-30T09:49:22-07:00"
message="
Thanks to [Kyle Bashour for pointing out](https://mastodon.social/@kylebshr/112528585781867745#.) a couple of details I got wrong about `project.pbxproj`. This section has been corrected.
" %}

### Handling `Package.resolved` deletions

Now that the `Package.resolved` file is saved in git, we can easily handle when Xcode deletes it by simply restoring it via git. For teams that ignore their project and workspace files and use Xcodegen (or similar), you also have the issue where Xcodegen deletes `Package.resolved` when it regenerates your project file. If you are also still using CocoaPods in conjunction with SwiftPM, then you have the issue where CocoaPods will delete `Package.resolved` when it regenerates your workspace file.

When you notice the file gets deleted, you can restore it using `git restore`. And then all the `'Missing package product'` errors will go away when you build your project.

It is common for iOS and macOS projects to use a `Makefile` in order to bootstrap project setup, which often includes: generating the project file via Xcodegen, installing CocoaPods via Bundler, running `pod install`, etc. In addition, makefiles are also a great place to write "shortcut" commands that are relevant to your project, for example, linting files or running tests.

Here's a target you can add to your `Makefile` to make restoring a deleted `Package.resolved` file easier.

```makefile
PACKAGE_FILE := "MyApp.xcworkspace/xcshareddata/swiftpm/Package.resolved"

.PHONY: swiftpm
swiftpm:
    @# Restore Package.resolved, which gets deleted when re-generating the project/workspace.
    @# Or, it gets deleted by Xcode.
    @# Only do this if the file was completely deleted.
    @# Otherwise, the user could be modifying packages which updates Package.resolved, so do not git restore it.
    @if [ ! -f "$(PACKAGE_FILE)" ]; then \
        echo "Restoring Package.resolved..."; \
        git restore "$(PACKAGE_FILE)"; \
        xcodebuild -resolvePackageDependencies; \
    fi
```

With this target in your `Makefile`, you can simply run `make swiftpm` as needed.

Note that this only calls `git restore` if the file is _deleted_, in case it has been (correctly) modified after updating packages. At the end, it calls `xcodebuild -resolvePackageDependencies`, which _should_ regenerate the `Package.resolved` on its own, but that's also broken. It will, however, download packages to the package cache if they are missing, which is what Xcode does when opening a project.

 To make this even better, you can include running this target as part of your bootstrapping process if you are using CocoaPods, Xcodegen, etc. Include this target part of your primary setup flow, and you should rarely have to run it manually.

If you do not use a `Makefile`, then you can write a simple bash script instead with the contents above.

### Danger: accidental deletions

Unfortunately (again), what we discovered on one of my teams is that the above is not foolproof. Because Xcode can (and literally _does_) randomly delete `Package.resolved` at any time, someone on your team might not notice and commit the file deletion. Oops! If you use a tool like [Danger](https://danger.systems/ruby/) to automate code reviews (which, _you should_), then you can add a rule to catch this mistake.

```ruby
# Dangerfile

if git.deleted_files.include?("MyApp.xcworkspace/xcshareddata/swiftpm/Package.resolved")
    fail("It looks like you deleted `Package.resolved`. Please don't do that.")
end
```

This will fail a pull request if `Package.resolved` was deleted.

### Summary

To recap: make sure `Package.resolved` is saved in git, use a `Makefile` to quickly and easily restore it, and add a Danger rule to catch mistakes, if needed. This should eliminate all `'Missing package product'` errors. As a last resort, if you are still having trouble, you can run `File > Packages > Resolve Package Versions`. If you search for solutions on StackOverflow or elsewhere, you will find some really elaborate bash scripts that use [fswatch](https://formulae.brew.sh/formula/fswatch) to monitor the file system to workaround this problem. I think this is a bit overkill and prefer the simpler solutions I've offered here.

This is all a bit ridiculous, and I would say it's shocking that this bug still hasn't been fixed after 4 years, but this kind of thing is not all that surprising for Apple. It is rather routine that many bugs remain unfixed and tools remain broken for years.
