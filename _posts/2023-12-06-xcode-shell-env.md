---
layout: post
categories: [software-dev]
tags: [xcode, apple-silicon, m3, homebrew]
date: 2023-12-06T10:19:56-08:00
title: Xcode does not have access to your shell environment
date-updated: 2023-12-15T15:50:32-08:00
---

I recently discovered, while [setting up my first Apple Silicon Mac]({% post_url 2023-12-04-new-m3-mbp %}), that Xcode does not have access to your shell environment. But there's one caveat to that. (Thanks to [Boris for confirming](https://mastodon.social/@NeoNacho/111494454201420440#.)!) This post will hopefully be a reminder to my future self when I encounter this issue again.

<!--excerpt-->

I realized the problem when an Xcode build failed because a Run Script [Build Phase](https://developer.apple.com/documentation/xcode/customizing-the-build-phases-of-a-target) that runs [SwiftLint](https://github.com/realm/SwiftLint) failed because the SwiftLint binary could not be found. I have SwiftLint installed via [Homebrew](https://brew.sh). I knew SwiftLint was in my `PATH` because I could run it successfully on the command line. This meant Xcode did not have access to my `PATH` (and, as I learned later, my entire shell environment).

This only started to happen after switching from an Intel Mac to an Apple Silicon Mac --- and that was the issue. Homebrew [installs at different locations](https://docs.brew.sh/Installation) for Intel (`/usr/local`) and Apple Silicon (`/opt/homebrew`). Invoking SwiftLint from a Run Script Build Phase in Xcode on Intel Macs _just happens to work_ because `/usr/local` is part of your default `PATH`. To fix the issue on Apple Silicon Macs, you need to tell Xcode where to look for Homebrew packages in your script.

```sh
export PATH="$PATH:/opt/homebrew/bin"
```

{% include break.html %}

Anyway, the moral of this story is that Xcode does not have access to your shell environment. This is not necessarily an obvious thing, especially on Intel machines. Xcode only gets whatever the default `PATH` is, configured via launch services --- **unless** you launch it through a terminal. What this means is that `xcodebuild` run from terminal and Xcode could end up with potentially different behavior in their Run Script Build Phases because they expose different environments. Good to know!

{% include updated_notice.html
date="2023-12-15T15:50:32-08:00"
message="
Thanks to Dave for [linking to this post this week](https://iosdevweekly.com/issues/640?#tools) and sharing a very relevant tip on this topic:

> Don’t forget you can still set environment variables from your project’s scheme configuration. Edit your scheme from the Product menu, select the Arguments tab against the Run behaviour, and set Environment Variables.
" %}
