---
layout: post
categories: [software-dev]
tags: [swift, swift-scripting, jekyll, website-infra]
date: 2021-03-18T11:05:31-07:00
date-updated: 2021-03-22T14:14:27-07:00
title: Using pipes in Swift scripts
---

I have a few Swift scripts to automate tedious tasks for maintaining my blog. I updated one today to use pipes. It took me a minute to figure out, because it did not feel very intuitive. I'm not sure if I feel that way because the interface is actually that clunky, or if I'm just inexperienced with Swift scripting. In any case, here's how it works.

<!--excerpt-->

First, some background: when I return to a post to update it after publishing, I like to do the proper bookkeeping to show that the post has been updated. I have a `post-updated:` field in my Jekyll [Front Matter](https://jekyllrb.com/docs/front-matter/) for this, and my template clearly displays this date for an updated post to notify the reader. Jekyll expects dates in [ISO 8601 format](https://en.wikipedia.org/wiki/ISO_8601), which are very easy to generate in Swift. My original script looked like this:

```swift
#!/usr/bin/swift

import Foundation

let fullDateTime = ISO8601DateFormatter.string(
    from: Date(),
    timeZone: .current,
    formatOptions: [.withFullDate, .withFullTime]
)

print(fullDateTime)
```

This uses a date formatter to simply print the current datetime via stdout.

```bash
$ ./scripts/current-date-time.swift
$ 2021-03-18T11:10:51-07:00
```

I would run this in the terminal, then manually copy the date. That is rather tedious, so I decided I wanted use `pbcopy` to automatically copy the date to my clipboard.

The trick is to create a separate `Process` for each command (`echo` and `pbcopy`) then appropriately connect their `standardOutput` and `standardInput`. The final script now looks like this:

```swift
#!/usr/bin/swift

import Foundation

let fullDateTime = ISO8601DateFormatter.string(
    from: Date(),
    timeZone: .current,
    formatOptions: [.withFullDate, .withFullTime]
)

print(fullDateTime)

let pipe = Pipe()

let echo = Process()
echo.executableURL = URL(fileURLWithPath: "/usr/bin/env")
echo.arguments = ["echo", fullDateTime]
echo.standardOutput = pipe

let pbcopy = Process()
pbcopy.executableURL = URL(fileURLWithPath: "/usr/bin/env")
pbcopy.arguments = ["pbcopy"]
pbcopy.standardInput = pipe

do {
    try echo.run()
    try pbcopy.run()
    pbcopy.waitUntilExit()
} catch {
    print("Error: \(error)")
}
```

I continue to print the generated datetime because it is nice to have some visual feedback. (If you do not closely follow Swift scripting, like me, note that [there have been some API deprecations](https://eclecticlight.co/2019/02/02/scripting-in-swift-process-deprecations/) for `Process`.)

This is a simple example. But if you need to chain many commands, connecting all these pipes correctly feels error-prone and tedious. It would be worth writing some abstraction on top of this to simplify and ensure correctness, but I'll leave that as an exercise for the reader.

{% include updated_notice.html
update_message='Ironically, (and very meta) I have an update for this post. Thanks to <a href="https://mobile.twitter.com/id/status/1372831195977879555">Ian for pointing out on Twitter</a> that I could also have used <code>NSPasteboard</code>, which is much simpler (only 2 lines of code), instead of using <code>Process</code> and <code>Pipe</code>. The only downside is that requires importing AppKit, which makes this script macOS-specific. However, in my case, that does not matter. Either way, this was a good learning exercise!'
%}
