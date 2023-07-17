---
layout: post
categories: [software-dev]
tags: [ios, macos]
date: 2023-07-17T08:41:13-07:00
date-updated: 2023-07-17T11:37:12-07:00
title: Stop prefixing your UserDefaults keys
---

[`UserDefaults`](https://developer.apple.com/documentation/foundation/userdefaults) is probably one of the most popular APIs on Apple Platforms. It is a highly-optimized key-value persisted store that is backed by a property list, and it is most commonly used for saving small pieces of data like user preferences. Despite its ease-of-use, there is one common anti-pattern I see developers use often.

<!--excerpt-->

In dozens of iOS projects over the years, I find that developers are prefixing key names with the app's bundle identifier. For example, instead of naming a key `"sounds-enabled"` it will be named `"com.mycompany.MyApp.sounds-enabled"`. I am writing this post as a PSA to tell you that you **do not need to do this!**

On iOS, in your application's user data sandbox you will find the backing plist for `UserDefaults` at `~/Library/Preferences/com.mycompany.MyApp.plist`. On macOS, for a non-sanboxed app you will find the plist at the same path and for an app that _is_ sandboxed you will find the plist at `~/Library/Containers/MyApp/Data/Library/Preferences/com.mycompany.MyApp.plist`.

As you can see, your instance of `UserDefaults` is **already** namespaced by your app's bundle identifier! Prefixing your keys is redundant. So please --- do not prefix your key names with your app's bundle identifier!

{% include break.html %}

You might argue that prefixing key names is harmless, and that could be true sometimes. However, there are [known issues](https://github.com/jessesquires/Foil/pull/61#issuecomment-1253147705) with `UserDefaults` [key-value observing](https://developer.apple.com/documentation/foundation/userdefaults#2926902) if key names have periods in the name --- KVO does not work in that scenario. Furthermore, if you use debug tools (like [FLEX](https://github.com/FLEXTool/FLEX)) that allow you to inspect the values saved in `UserDefaults` or if you manually open the plist (which is just XML) to examine it, it gets really cumbersome to search and read through if every single key is prefixed with the same ~30 characters.

Lastly, if you are convinced to drop the unnecessary prefixes, beware that you will need to write migration code to save your values from the old key to the new one, otherwise you will lose data.

{% include updated_notice.html
date="2023-07-17T11:37:12-07:00"
message="
A few folks on Mastodon have pointed out two situations where prefixing might be warranted. Or rather, pointed out problematic scenarios to generally watch out for.

[Matt Massicotte noted](https://mastodon.social/@mattiem/110730470926606357) that some system frameworks store values in your app's `UserDefaults`. For example, AppKit and SwiftUI on macOS store state restoration data, most commonly window size and location. I had forgotten about this. However, I **highly doubt** you'll have naming collisions. For example, here are a couple of keys for one of my apps: `NSWindow Frame com_apple_SwiftUI_Settings_window`, `com_apple_SwiftUI_Settings_selectedTabIndex`.

More importantly, [Andy Ibanez noted](https://mastodon.social/@andy@iosdev.space/110730254596336650) that a third-party dependency might read and write to the same key name. That is very bad! If you are a library author, you **should not** be writing to `UserDefaults.standard`. This is why [`UserDefaults.init(suiteName:)`](https://developer.apple.com/documentation/foundation/userdefaults/1409957-init) exists --- your library should initialize its own suite.
" %}
