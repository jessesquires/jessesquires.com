---
layout: post
categories: [software-dev]
tags: [icloud, apple, bugs, dev-relations]
date: 2022-01-26T12:19:39-08:00
title: iCloud failures, developer relations, and the 30 percent
---

As a user, the [recent issues](https://www.macrumors.com/2022/01/26/apples-icloud-service-experiencing-outage/) [with iCloud](https://www.macrumors.com/2022/01/24/developers-icloud-unreliability-bug/) are extremely frustrating --- especially if you've paid for iCloud and paid for apps that use iCloud. It seems like the iCloud team is having a difficult time preventing and avoiding [clusterfucks](https://furbo.org/2019/09/04/icloud-clusterfuck/). The lack of [reliability](https://mjtsai.com/blog/2014/10/20/trusting-icloud/) should be a concern to everyone.

<!--excerpt-->

The [last time](https://furbo.org/2019/09/04/icloud-clusterfuck/) iCloud had major issues, I wrote [an rsync script]({% post_url 2019-09-27-icloud-backup-using-rsync %}) to manually backup my iCloud drive directory on my Mac. I also _turn-off_ the "Optimize Mac Storage" setting so that everything gets downloaded to my Mac. This all gets backed up again locally via Time Machine --- at least, [when it works]({% post_url 2022-01-11-time-machine-error-35-monterey %}). It really sucks to not be able to trust an essential service like iCloud.

The problem is that, in my view, the alternatives are not much better. Google Drive, like all Google products, is spyware. Apparently, they are now [scanning your personal files](https://torrentfreak.com/google-drive-flags-text-files-with-1-or-0-as-copyright-infringements-220125/) for copyright infringements, and [not very well](https://mjtsai.com/blog/2022/01/24/google-drive-incorrectly-flags-file-for-copyright-infringement/) at that. Dropbox is [scummy](http://www.drop-dropbox.com) and invasive --- it's [up in your kernel](https://www.theregister.com/2016/05/26/dropbox_kernel_access/) or [installing its own file manager](https://arstechnica.com/gadgets/2019/07/dropbox-silently-installs-new-file-manager-app-on-users-systems/). Other, less popular apps I've seen rarely meet both of my quality and trustworthiness expectations to the degree that I'm willing to make the effort to switch. Luckily, I have personally avoided all of the reported issues with iCloud, but I remain immensely skeptical. So, I stick with iCloud (for now) as a user and diligently make backups.

But as a developer, the iCloud issues are [_even more_ frustrating](https://mjtsai.com/blog/2022/01/24/increased-icloud-errors/). Sure, we all know software is hard. Minor, intermittent issues are to be expected. But two things are unacceptable --- [data loss](https://furbo.org/2019/09/04/icloud-clusterfuck/) and the ([still!]({% post_url 2020-09-15-why-is-apple-acting-like-an-asshole %})) terrible communication from Apple.

If Apple fails to maintain quality software and prevent data loss --- that affects our users and there isn't much we can do about it. Apple strongly promotes these services. Apple *really wants* third-party devs to integrate iCloud support into their apps. And yet, they seemingly can't be bothered to make it **reliable**. Among the many other issues that developers have with the App Store, this ranks at the top. Third-party developers must pay 15-30 percent of *their wages* to Apple. And for what? **What are we paying for?** A totally broken iCloud? Developers that depend on iCloud get doubly screwed.

And then, to make matters worse, developers received _zero communication_ from Apple during this outage --- not even an acknowledgement [that an issue existed](https://mjtsai.com/blog/2022/01/24/increased-icloud-errors/). Depending on when you start counting, it took multiple days (or months!) for their ["system status" page](https://www.apple.com/support/systemstatus/) to reflect reality, despite many reports of ongoing issues since last November.

It is no secret that [Apple's developer relations](https://marco.org/2021/06/03/developer-relations) are at an all-time, abjectly [abysmal low]({% post_url 2020-09-15-why-is-apple-acting-like-an-asshole %}). It is truly incredible that the company continues to make the exact same mistakes. The absolute dearth of communication and gross inconsideration for third-party devs is shocking. We honestly are not asking for much. Just like... tell us you know there is a problem, when you expect it to be fixed, and what we can do in the meantime. You know, very basic communication skills. They continue to disregard and shit all over third-party developers, as if third-party apps aren't the main reason that people continue to support Apple platforms.


