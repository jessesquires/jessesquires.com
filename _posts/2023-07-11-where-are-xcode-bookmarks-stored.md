---
layout: post
categories: [software-dev]
tags: [xcode, xcode-tips]
date: 2023-07-11T12:17:32-07:00
title: Where are Xcode bookmarks stored?
---

[Xcode 15](https://developer.apple.com/documentation/xcode-release-notes/xcode-15-release-notes) introduces a new "bookmarks" feature, which lets you [bookmark lines or entire files](https://sarunw.com/posts/bookmark-in-xcode15/). It is a welcome change that has [sherlocked](https://en.wikipedia.org/wiki/Sherlock_(software)#Sherlocked_as_a_term) my hack for [using breakpoints as bookmarks]({% post_url 2020-01-21-xcode-tip-breakpoints-as-bookmarks %}).

<!--excerpt-->

However, one advantage of breakpoints is that [they can be shared]({% post_url 2023-02-21-xcode-tip-sharing-breakpoints %}). This is useful for symbolic breakpoints that can be shared across projects. But it could also be useful for teams to share breakpoints within a project. As I was [updating my old post]({% post_url 2020-01-21-xcode-tip-breakpoints-as-bookmarks %}), I was wondering if the same was possible for bookmarks. The question then is, how and where does Xcode save them?

Bookmarks are stored in a plist at the following path:

```
PROJECT_NAME.xcodeproj/project.xcworkspace/xcuserdata/USER.xcuserdatad/Bookmarks/bookmarks.plist
```

where `PROJECT_NAME` is the name of your project and `USER` is the current user -- that is, the output of `$USER` or `whoami`.

Typically, `xcuserdata/` is added to `.gitignore` so you likely would not notice any changes to this directory. Importantly, bookmarks are user-specific and there is a unique `.xcuserdatad/` directory for each user. So if multiple users create bookmarks, you would have something like the following:

```
MyApp.xcodeproj/project.xcworkspace/xcuserdata/jsq.xcuserdatad/Bookmarks/bookmarks.plist
MyApp.xcodeproj/project.xcworkspace/xcuserdata/gregheo.xcuserdatad/Bookmarks/bookmarks.plist
```

Furthermore, Xcode filters bookmarks in the UI based on the current `$USER`. This means if you _do_ check-in `xcuserdata/` and `bookmarks.plist` for each user, Xcode will only display _your_ bookmarks in the Bookmarks Navigator panel.

I think this is a reasonable design choice. However, I can imagine scenarios where it would be useful to share bookmarks with your team, similar to breakpoints. For example, if you are trying to debug a problem with your remote team member and you've tracked down the issue to a few specific files and lines, you could bookmark those locations, push your branch, and have the other person checkout that branch. That's a nicer, more precise experience than listing a bunch of filenames and line numbers in a Slack message that will eventually get lost. Another example would be for an interview exercise or a coding tutorial. You could prepare an Xcode project with bookmarks to guide someone through an exercise.

For now, this is not possible in Xcode's UI, but you could easily write a script to move a pre-populated `bookmarks.plist` file to the correct location, based on the current `$USER`.

{% include break.html %}

While I'm here, there is one other usability issue with bookmarks. You have to right-click in a file to bring up the contextual menu to create one. It's a bit cumbersome. There are keyboard shortcuts, but it would also be nice if you could create bookmarks by clicking in the line number gutter --- similar to how you create breakpoints.
