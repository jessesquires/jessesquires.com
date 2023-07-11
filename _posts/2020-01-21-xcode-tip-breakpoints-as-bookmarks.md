---
layout: post
categories: [software-dev]
tags: [xcode, debugging, ios, macos, xcode-tips]
date: 2020-01-21T17:09:36-08:00
date-updated: 2023-07-11T12:06:52-07:00
title: "Xcode tip: Using breakpoints as bookmarks"
---

Xcode has a great UI for setting and editing breakpoints. I use breakpoints all the time while working and debugging, but I want to share another, unconventional way that I use them.

<!--excerpt-->


{% include updated_notice.html
date="2023-07-11T12:06:52-07:00"
message="
I'm happy to share that bookmarks are now a first-class feature in [Xcode 15](https://developer.apple.com/documentation/xcode-release-notes/xcode-15-release-notes)! We no longer have to hack breakpoints like I describe in this post. You can learn more about how they work in [Sarun's recent blog post](https://sarunw.com/posts/bookmark-in-xcode15/).
" %}

One of the best features is being able to [set and keep breakpoints](https://help.apple.com/xcode/mac/10.2/#/dev9a374afc9) in place, but quickly enable or disable them individually. In the sidebar, you can quickly see a list of all your breakpoints in the [breakpoint navigator](https://help.apple.com/xcode/mac/10.2/#/dev1cf0a324f) and toggle them on or off. Even better, Xcode preserves them across app launches for each project, but they do not affect your git working directory. This makes disabled breakpoints perfect "bookmarks" in your code, that only you can see.

Any time I am exploring or getting familiar with a new codebase in Xcode, especially very large projects, I use disabled breakpoints as "bookmarks" to keep track of where I am, where I have been, and things I want to remember or need to revisit. Sometimes I even do this when debugging issues in codebases that I know well.

This "bookmarking" is particularly useful when tracing through a long path of function calls to understand how something works, or if you are frequently jumping around (via "jump-to-definition") to view the full declaration of new types that you encounter.

When attempting to fix that first "starter bug" you get assigned, it is hard to know exactly which files you will need to edit to fix it. Perhaps a veteran maintainer on the project gets you started with a class name, or the name of a view controller. As you track down the bug, you confront dozens of new types for the first time. All of those different types are interacting together, and any of them may be relevant to fixing the issue. It is difficult to remember everything you have seen once you start digging around. Unobtrusively clicking in the gutter of the editor to add a breakpoint as you go along can be a huge help. And after browsing through dozens of files for the first time, you will have a list of relevant locations to investigate further, or examine tomorrow.

Next time you are thrown into a new project, trying leaving some disabled breakpoint breadcrumbs so you can find your way back.
