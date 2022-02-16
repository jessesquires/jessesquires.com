---
layout: post
categories: [software-dev]
tags: [apple, bugs, macos, macbook]
date: 2022-02-15T21:17:09-08:00
title: The MacBook sigh of death
image:
    file: mac-sigh-of-death-1.jpg
    alt: "macOS screen of death"
    caption: "macOS screen of death"
    source_link: null
    half_width: true
---

I have been experiencing bizarre kernel panics with my Mac lately. I have a 2020 Intel MacBook Pro, the last Intel model before the M1 debuted. It has generally been working fine. Despite poor software quality and numerous bugs lurking around in macOS, I rarely see kernel panics anymore. In fact, I can't remember the last time I had a kernel panic before this issue. There have been no major changes on my machine and I'm on the latest version of Monterey.

<!--excerpt-->

Here's what happens. Suddenly the MacBook display turns off, the fans turn on full blast for a couple seconds (they are louder than compiling the largest Xcode project you can think of), and then the machine shuts down completely. I'm calling it the "sigh of death" because it's as if the machine is simply giving up and exhaling in an exasperated, dramatic sigh of defeat --- like an exaggerated cartoon character would do. It has happened to me 3-4 times within the past few weeks.

{% include post_image.html %}

If you have been using a Mac for any amount of time, you have likely seen the "screen of death" at least once. If not, consider yourself lucky. Usually when this happens, it is preceded by some notable event --- your machine freezes, your cursor starts beach-balling, everything becomes completely unresponsive, and then you'll see the screen of death. It's also usually silent, or at least, there's no notable change with the fans.

That's why this is so peculiar. It seems to be random and unprovoked in terms of software --- there are not any specific apps, scripts, tasks, etc. that seem to trigger it. Prior to the kernel panic, the machine is fully responsive and functioning like normal. In some cases, I am actively using it. However, there is one commonality across all incidents so far. Each time it has happened, it is _after_ I unplug the machine from power. I typically work at a desk with the MacBook plugged in, and occasionally I'll move to the kitchen table or couch and work off battery power for a bit. Each time the sigh of death has occurred, it is shortly after being unplugged. It makes me wonder if there's some hardware issue?

Upon rebooting, the "Problem Report for macOS" window appears as expected. Usually, the details section will contain a stack trace from which you can derive _some_ kind of useful information about what happened --- but not with the sigh of death. All it says is "Intel CrashLog recorded due to unexpected reset" --- whatever that means.

{% include blog_image.html
    file="mac-sigh-of-death-2.jpg"
    alt="macOS report a problem"
    caption=null
    source_link=null
    half_width=true
%}

Finally, I vaguely remember reading another blog post from someone about this exact issue. It was awhile back, perhaps during a macOS beta, and they also called it the "sigh of death". Unfortunately, I could not find the article anywhere on the web. If anyone recalls this post or can find it, please send me the link and I'll update this post to link to it.

And if you are experiencing this issue, or have any idea about what's happening, please let me know.
