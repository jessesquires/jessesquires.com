---
layout: post
categories: [software-dev]
tags: [xcode, ios, macos]
date: 2022-03-04T13:10:11-08:00
date-updated: 2022-03-09T13:48:45-08:00
title: Quickly displaying the Swift version that ships with Xcode
---

I previously [wrote about]({% post_url 2020-07-07-quickly-switching-between-xcodes %}) writing a custom shell command to quickly switch between Xcodes. But recently, I needed to determine the version of Swift that is bundled with Xcode --- specifically the version of Swift that is shipping with the current Xcode 13.3 beta. I was pretty sure that it is Swift 5.6, but I wanted to know for certain.

<!--excerpt-->

Strangely, the [Xcode beta release notes](https://developer.apple.com/documentation/xcode-release-notes/xcode-13_3-release-notes) do not explicitly mention the Swift version included with the release. I expected this information to be available in the "Overview" section of the release notes, which is where all the SDK versions are listed, but the Swift version not present. If you are not following Swift development and Swift Evolution closely, then it isn't immediately clear which version is shipping with Xcode.

Luckily, we can find this by calling `swiftc --version`, but for the Xcode Beta we need to know the full path bundled with the app. It is located at `/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc`, which is a mouthful and difficult to remember.

{% include updated_notice.html
date="2022-03-09T13:48:45-08:00"
message="
Thanks to [Sven Schmidt](https://mobile.twitter.com/_sa_s/status/1500379619744178179) for offering improvements here to simplify the script and make it more robust. We can use `DEVELOPER_DIR` to specify which Xcode to use and then invoke `xcrun` to avoid having to use the exact path to the binaries. The script below has been updated.
" %}

The custom commands below build on [what I previously wrote]({% post_url 2020-07-07-quickly-switching-between-xcodes %}) to switch between Xcode versions. I've added a new command, `xcwhich` that displays the currently selected Xcode, and then prints all the version information for both Xcode.app and Xcode-beta.app.

```zsh
# print current Xcode info
function xcwhich() {
    _xcselect false
    echo ""
    echo "RELEASE"
    env DEVELOPER_DIR=/Applications/Xcode.app xcrun xcodebuild -version
    env DEVELOPER_DIR=/Applications/Xcode.app xcrun swift --version

    echo "\nBETA"
    env DEVELOPER_DIR=/Applications/Xcode-beta.app xcrun xcodebuild -version
    env DEVELOPER_DIR=/Applications/Xcode-beta.app xcrun swift --version
}

# switch between release and beta Xcodes
function xcswitch() {
    _xcselect true
}

# shared between `xcswitch` and `xcwhich`
# determines current Xcode (beta or release)
# pass true to switch, pass false to print current
function _xcselect() {
    RELEASE="Xcode.app"
    BETA="Xcode-beta.app"

    CURRENT=$(xcode-select -p)
    NEXT=""

    if [[ "$CURRENT" =~ "$RELEASE" ]]
    then
        NEXT="$BETA"
        CURRENT="$RELEASE"
    else
        NEXT="$RELEASE"
        CURRENT="$BETA"
    fi

    if [ "$1" = true ]
    then
        sudo xcode-select -s "/Applications/$NEXT"
        echo "Switched to $NEXT"
    else
        echo "Current: $CURRENT"
    fi
}
```

If you'd like to use this, you can paste the code above into your `.zprofile` (or similar). Here's an example usage and output:

```zsh
> xcwhich
Current: Xcode.app

RELEASE
Xcode 13.2.1
Build version 13C100
swift-driver version: 1.26.21 Apple Swift version 5.5.2 (swiftlang-1300.0.47.5 clang-1300.0.29.30)
Target: x86_64-apple-macosx12.0

BETA
Xcode 13.3
Build version 13E5104i
swift-driver version: 1.45.2 Apple Swift version 5.6 (swiftlang-5.6.0.323.60 clang-1316.0.20.8)
Target: x86_64-apple-macosx12.0
```

An additional benefit of this is that you can see the _exact_ Swift version that is bundled with the stable release of Xcode. Typically, point releases of Xcode bump the Swift version too. In this case, Xcode 13.2.x ships with Swift 5.5.2. This rarely matters for development purposes as you often only need to know which major and minor version of Swift that you are using --- Swift 5.5 in this example. However, it is convenient to see the complete version information in one place.
