---
layout: post
title: Measuring Swift compile times in Xcode 9
subtitle: Using -Xfrontend Swift compiler flags
image:
    file: xcode-front-end-flags.png
    alt: Swift frontend flags
    caption: Xcode "Other Swift Flags" build settings
    source_link: null
    half_width: false
---

The Swift type-checker remains [a performance bottleneck](https://www.cocoawithlove.com/blog/2016/07/12/type-checker-issues.html) for compile times, though it has [improved](https://github.com/apple/swift/search?utf8=✓&q=type+checker+improve&type=Commits) [tremendously](https://github.com/apple/swift/search?utf8=✓&q=type+checker+performance&type=Commits) over the past two years. You could even say the type-checker has gone from being [drunk](https://spin.atomicobject.com/2016/04/26/swift-long-compile-time/) to [sober](https://github.com/apple/swift/commit/2cdd7d64e1e2add7bcfd5452d36e7f5fc6c86a03). To help users debug these issues, awhile back [Jordan Rose added](https://github.com/apple/swift/commit/18c75928639acf0ccf0e1fb6729eea75bc09cbd5) a frontend Swift compiler flag that would emit warnings in Xcode for functions that took too long to compile, or rather took too long to type-check. In Xcode 9, there's a new, similar flag for checking expressions.

<!--excerpt-->

### About `-warn-long-function-bodies`

[Bryan Irace](http://irace.me/swift-profiling) and [Soroush Khanlou](http://khanlou.com/2016/12/guarding-against-long-compiles/) originally wrote about the `-warn-long-function-bodies` flag when it was first introduced. You could specify a threshold in milliseconds that would trigger a warning. For example: `-Xfrontend -warn-long-function-bodies=100` would trigger a warning in Xcode for any function that took longer than 100ms to type-check. This was always considered an experimental flag, as Jordan notes in his original [commit](https://github.com/apple/swift/commit/18c75928639acf0ccf0e1fb6729eea75bc09cbd5): *As a frontend option, this is UNSUPPORTED and may be removed without notice at any future date.* As far as I can tell, this is still the case. However, this flag still works in Xcode 9 and I haven't seen any discussion about removing it.

### About `-warn-long-expression-type-checking`

In Xcode 9, there is a new, similar flag for type-checking expressions, not just functions. However, this time the flag made an appearance in the *official* Xcode 9 GM [release notes](https://download.developer.apple.com/Developer_Tools/Xcode_9_GM_seed_build_9A235/Xcode_9_GM_seed_Release_Notes.pdf):

> The compiler can now warn about individual expressions that take a long time to type check.
>
> To enable this warning, go the Build Settings, "Swift Compiler - Custom Flags", "Other Swift Flags", and add:
`-Xfrontend -warn-long-expression-type-checking=<limit>` where `<limit>` is the lower limit of the number of milliseconds that an expression must take to type check in order for the warning to be emitted.
>
> This allows users to identify those expressions that are contributing significantly to build times and rework them by splitting them up or adding type annotations to attempt to reduce the time spent on those expressions. (32619658)

This time, you can thank [Mark Lacey](https://github.com/apple/swift/pull/10214) for the flag. ([pull request for Swift 4](https://github.com/apple/swift/pull/10215))

### Using these flags to improve compile times

As mentioned, after you add these flags you will start getting warnings. Keep in mind that if the threshold is too low, for example 10ms, then you will get **a ton** of warnings that cannot be fixed. Experiment with these threshold values and adjust as needed. I suggest starting at `200` and tuning from there. If your code base is large, it might make more sense to use a higher value for your project (say `500`) and try to decrease it over time. Otherwise, you'll be spending **a lot** of time trying to get all functions and expressions to compile in under 200ms. Also, I recommend setting these flags only for `DEBUG` build configurations.

There are two common scenarios where Xcode will start emitting warnings with these flags: (1) very complex expressions or functions, and (2) expressions that omit explicit types and rely on [type inference](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Types.html). To silence the warnings &mdash; and thus improve compile times &mdash; try breaking up expressions into smaller steps with intermediate variables, and adding explicit types to variable declarations and closure parameters. The code may not look as elegant after these changes, but what's more important to you and your team?

{% include post_image.html %}

### A temporary solution

Using these flags is obviously a temporary (and kind of hacky) solution to improving compile times. It only treats the symptoms rather than the cause, but it is better than nothing. As I said before, the Swift team is well aware of the problems and they are working hard to address them. Every single Swift release is getting better and I'm sure Swift 5 will bring even more improvements.

I'm hoping using these flags &mdash; and having to change your code to improve compilation times &mdash; will soon be a hack of the past. Eventually it will be, we just don't know when.

If you are interested in learning more about the type-checker design and implementation, see [this doc in the main Swift repo](https://github.com/apple/swift/blob/master/docs/TypeChecker.rst). But beware, it was last updated about a year ago in October 2016.
