---
layout: post
categories: [software-dev]
tags: [xcode, ios, macos, swift, swiftpm]
date: 2025-03-10T11:16:17-06:00
title: How to remove unwanted Swift Package schemes in Xcode
---

Xcode automatically creates schemes for your app and other targets included in your project, which allow you to build and run those targets. I recently ran into an issue where Xcode was including schemes from third-party Swift Package dependencies in its auto-populated list. This automatic behavior does not cause any problems, but it can be quite annoying and distracting to have unwanted schemes from packages pollute your list of schemes.

<!--excerpt-->

This issue [has been reported in the developer forums](https://developer.apple.com/forums/thread/716024). Apparently, if a Swift package includes a `.swiftpm/` directory with `.xcscheme` files for its own project development, then Xcode will automatically detect and display these schemes in the dropdown list of schemes for your project. This is rather undesirable. It's an especially frustrating experience because even if you delete them from the list in Xcode, they will eventually reappear when packages get updated or refreshed. For example, you'll experience this issue with the popular library, [CocoaLumberjack]( https://github.com/CocoaLumberjack/CocoaLumberjack), which includes schemes using [a `.swiftpm/` directory here](https://github.com/CocoaLumberjack/CocoaLumberjack/tree/master/.swiftpm/xcode/xcshareddata/xcschemes).

The [solution](https://developer.apple.com/forums/thread/716024?answerId=735186022#735186022) to preventing these package schemes from appearing in Xcode automatically is for package authors to switch to using an `.xcworkspace` file for their schemes, rather than a `.swiftpm/` directory. Here's an example from the [sideeffect.io/AsyncExtensions](https://github.com/sideeffect-io/AsyncExtensions/pull/29) package.

Curiously, I have also seen schemes appear from packages that use neither `.xcworkspace` nor `.swiftpm`, but just a normal `.xcodeproj`. Why _those_ schemes appear automatically in Xcode is a mystery to me.

{% include break.html %}

You may not always be able to get package authors to make this change. While you wait for library maintainers to implement changes or accept a pull request (if they ever do), you can use my workaround to delete them from your projects.

Unfortunately, working with Swift packages in Xcode remains a cumbersome experience. Unlike CocoaPods --- which adopted the prior art developed by established package managers in other ecosystems by using a specification file and storing package sources in a directory relative to your project --- Xcode forces you use an opaque UI to add package dependencies. Even worse, rather than store packages relative to your project, when you add Swift packages to your Xcode project they get stored in `~/Library/Developer/Xcode/DerivedData/<YOUR_APP_NAME-SOME_UUID>/SourcePackages/checkouts/`. These implementation details along with the lack of the equivalent of [CocoaPods post-install hooks](https://guides.cocoapods.org/syntax/podfile.html#post_install) make workarounds more challenging. SwiftPM integration in Xcode was designed by people who think very different. But it's ok --- we can workaround this annoyance, too.

Here's a script that will delete all `.xcscheme` files for packages added to your Xcode project. These schemes will then no longer appear in your scheme list.

```bash
#!/bin/bash

# Deletes unwanted schemes from SwiftPM packages
# to prevent them from being listed in Xcode.
#
# If a Swift Package includes `.swiftpm/xcode/xcshareddata/xcschemes/`,
# then the schemes will show up in Xcode automatically.

set -eu

SCHEME_DIRS=~/Library/Developer/Xcode/DerivedData/YOUR_APP_NAME*/SourcePackages/checkouts/*/.swiftpm/xcode/xcshareddata/xcschemes
all_dirs=($SCHEME_DIRS)

for each in "${all_dirs[@]}"; do
  if [ -d "$each" ]; then
    rm -rf "$each"/* && rmdir "$each"
  fi
done
```

You'll need to either run this script somewhere as part of your build process, or manually invoke it as needed. For example, if your team uses a [XcodeGen](https://github.com/yonaskolb/XcodeGen) or a similar tool, you'll want to run this script after rebuilding your Xcode project. Alternatively, you could add a _Build Script Phase_ to your project that executes the script.

This is not a perfect solution, but it should save you some time.

A few notes:

- You'll need to replace `YOUR_APP_NAME` with the name of your Xcode project.
- If you have multiple projects with the exact same name, this script will match both paths (because `YOUR_APP_NAME*/`).
- Similarly, if you have multiple git checkouts of the same project, this script will match all of them.
- All packages are captured by `/SourcePackages/checkouts/*/`, so there's no need to enumerate the specific packages causing the problem. This is also convenient because it will catch any future packages that exhibit the same problem.
- I tried to use Xcode environment variables to grab the project's specific `DerivedData/` directory, but none of those work. I tried `BUILD_DIR`, `BUILD_ROOT`, `PROJECT_TEMP_DIR`, `TARGET_TEMP_DIR`, and `DERIVED_FILE_DIR`. None of them return the correct directory in `~/Library/`, but instead return directories relative to your Xcode project that do not exist.
- After the script runs for the first time, the schemes may still appear in the list. Restarting Xcode should remove them, or you can manually remove them.
- As mentioned above, when packages are updated or redownloaded, the schemes will reappear, so you'll need to re-run the script after packages are refreshed.

If you've been annoyed by random package schemes being listed in your Xcode project, I hope this helps!
