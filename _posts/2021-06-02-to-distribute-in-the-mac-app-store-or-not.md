---
layout: post
categories: [software-dev]
tags: [macos, mac-app-store, indie-dev, apps, app-sandbox]
date: 2021-06-02T16:48:46-07:00
title: To distribute in the Mac App Store, or not
subtitle: Is the app sandbox worth it?
---

For the past few weeks I have been debating on whether or not to distribute a new Mac app via the Mac App Store or independently. I have arrived at a crossroads in development where I need to make this decision. I am mostly code-complete for my MVP 1.0 release. The question I am facing is how I want to spend the remainder of my time to cross the finish line.

<!--excerpt-->

### A brief background

For the best user experience, my app requires Full Disk Access. It is a utility that interacts heavily with the filesystem. Unfortunately, [there is no API](https://benscheirman.com/2019/10/troubleshooting-appkit-file-permissions/) to simply request Full Disk Access from the user upfront and explain why you need it. Nor is there an API for simply asking the user for access to a folder &mdash; it is all implicit via open/save dialogs or [drag-and-drop](https://developer.apple.com/design/human-interface-guidelines/macos/user-interaction/drag-and-drop/). A workflow similar to how iOS handles its various permissions would be great, but it does not exist on macOS.

### Sandboxing and file permissions

A quick search on the web for "macOS Full Disk Access" yields myriad results of various company help articles and support pages carefully instructing users how to enable Full Disk Access for their apps. It is obscure and opaque from both [a developer perspective](https://developer.apple.com/forums/thread/124895) (no explicit APIs like iOS!), and an end user perspective (no explicit prompts like iOS!). The breadth of this baffling and abjectly terrible design is evidenced by [every](https://helpcenter.trendmicro.com/en-us/article/tmka-20794) single [identical](https://macpaw.com/how-to/full-disk-access-mojave) help [article](https://support.intego.com/hc/en-us/articles/360016683471-Enable-Full-Disk-Access-in-macOS) that [every](https://help.kolide.com/en/articles/3387759-how-to-grant-macos-full-disk-access-to-kolide) developer [must](https://documentation.n-able.com/remote-management/userguide/Content/macos_full_disk_access.htm) write [to explain](https://support.avast.com/en-us/article/Mac-full-disk-access) to users [how to enable it](https://embrilliance.com/archives/2835).

To get a sense of how much extra work and effort is required to support the app sandbox, see [Ben Scheirman's](https://twitter.com/subdigital) excellent piece on [Modern AppKit File Permissions](https://benscheirman.com/2019/10/troubleshooting-appkit-file-permissions/), or [Peter Steinberger's gist](https://gist.github.com/steipete/40a367b64b57bfd0b44fa8d158fc016c) on how to access sandboxed URLs after an app restart. Even when a user grants you access to a specific file &mdash; that is, they select a file from a standard [Open Dialog](https://developer.apple.com/documentation/appkit/nsopenpanel) using `NSOpenPanel` &mdash; [you cannot even fucking rename that file](https://stackoverflow.com/questions/13950476/application-sandbox-renaming-a-file-doesnt-work) because you do not have write permission to the file's **enclosing** directory.

In order to achieve a somewhat acceptable user experience, you must utilize the [Security-Scoped Bookmarks API](https://developer.apple.com/library/archive/documentation/Security/Conceptual/AppSandboxDesignGuide/AppSandboxInDepth/AppSandboxInDepth.html#//apple_ref/doc/uid/TP40011183-CH3-SW16) to "save" access to any files and directories to which the user has previously granted your app. Otherwise, you must constantly prompt the user with annoying [Open](https://developer.apple.com/documentation/appkit/nsopenpanel) and [Save](https://developer.apple.com/documentation/appkit/nssavepanel) Dialogs to implicitly regrant permission to the filesystem after your app is relaunched. You cannot simply use `NSFileManager` [like you would expect](https://stackoverflow.com/questions/13950476/application-sandbox-renaming-a-file-doesnt-work). Using [Security-Scoped Bookmarks](https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/EntitlementKeyReference/Chapters/EnablingAppSandbox.html#//apple_ref/doc/uid/TP40011195-CH4-SW18) is an another non-trivial rabbit hole into which you must descend during development, in addition to other sandboxing quirks and nuances. Because of this, we have [an entire open source library](https://github.com/leighmcculloch/AppSandboxFileAccess) (by [Leigh McCulloch](https://github.com/leighmcculloch)) to accommodate working with sandboxed file access.

Even [Quinn](https://github.com/macshome/The-Wisdom-of-Quinn) admits that [there are no ideal solutions](https://developer.apple.com/forums/thread/124895) for working within or around the app sandbox limitations in certain situations, and even suggests distributing **outside** of the Mac App Store!

### Mac App Store or Independent?

So this brings me to the question I need to answer. Do I spend my time and effort properly sandboxing my app (and writing a help document to explain Full Disk Access to my users!), which will undeniably produce a worse user experience (even with Leigh's [library](https://github.com/leighmcculloch/AppSandboxFileAccess))? Or, do I instead spend that same time and effort learning and figuring out how to distribute my app independently, which includes a solution to payment processing and licensing? What are the benefits and drawbacks of each?

#### Mac App Store

&#x2705; Distributing via the Mac App Store is simple. You upload your app bundle to App Store Connect, fill-in your metadata, and set your price. You do not have to implement your own software update mechanisms, binary hosting, payment processing, or licensing.

&#x2705; Discovery and installation is easier for most, typical users.

&#x2705; The App Store is familiar, because of my extensive iOS experience.

&#x1F6AB; I must pay the (bullshit) 15-30% App Store Tax.

&#x1F6AB; Sandboxing requires a lot of development effort and resources. It produces a worse user experience, in general, but it is especially terrible for my app.

&#x1F6AB; There is a risk of an outright rejection during the initial submission. All that effort to sandbox would be wasted if Apple does not want my app in its store. I am currently 2 for 2 on rejections. See: [Lucifer]({% post_url 2019-03-26-introducing-lucifer %}) and [Red Eye]({% post_url 2019-09-03-introducing-red-eye %}). Admittedly, these are unserious, hobby apps &mdash; but still.

&#x1F6AB; Even once accepted, I will potentially be subject to [arbitrary, bullshit rejections](https://lapcatsoftware.com/articles/review-folly.html) during updates, or possibly [complete removal](https://mjtsai.com/blog/2020/10/20/stadium-removed-from-the-app-store/).

&#x1F6AB; Every update is subject to [frivolous](https://mjtsai.com/blog/2021/05/10/inside-app-review/), [undocumented](https://mjtsai.com/blog/2020/09/30/pop-out-timer-rejected-from-the-app-store/) App Review policies.

&#x1F6AB; Limited business model options: no paid upgrades, no proper trials, etc.

#### Independent

&#x1F6AB; I need to figure out and implement distribution, hosting, software updates, payment processing, and licensing on my own. Likely I will be using [Paddle](https://paddle.com) for payments and licensing, and [Sparkle](https://github.com/sparkle-project/Sparkle) for updates. I'm not sure about hosting.

&#x1F6AB; Discovery and installation is more difficult. But it's arguable how beneficial the App Store is for "discovery" anyway.

&#x2705; However, learning and implementing all of the above is mostly a "set up once" kind of task, after which maintenance should not be too time consuming. Furthermore, after building this foundation, I'm ready to take advantage of it for any future apps I create. I could even bring these enhancements to [Lucifer](https://www.hexedbits.com/lucifer/) and [Red Eye](https://www.hexedbits.com/redeye/), to turn them into something more serious and consider selling them.

&#x2705; I do not have to implement sandboxing. This is a better development experience, requires less testing, and produces a significantly better user experience.

&#x2705; Paddle takes a percentage of transactions, but it is nowhere close to Apple's 15-30% tax. I will capture more of the value I produce for myself, instead of subsidizing the wealthiest corporation in the world.

&#x2705; More business model options, and the ability to easily change or experiment with them.

&#x2705; The are no submissions, no reviews, and no rejections to deal with &mdash; ever.

### Final thoughts

I also recommend checking out [Guilherme Rambo's](https://twitter.com/_inside) excellent guide on [distributing Mac apps outside the App Store](https://rambo.codes/posts/2021-01-08-distributing-mac-apps-outside-the-app-store).

It is clear to me that independent distribution is a significantly better investment of my time &mdash; especially considering Apple could reject my app from the start. It gives me more control and greater independence. It will provide me with a better, more lucrative, sustainable, long-term foundation to build on &mdash; not only for this app, but for all future apps I create.
