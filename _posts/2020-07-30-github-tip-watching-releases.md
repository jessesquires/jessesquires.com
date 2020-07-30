---
layout: post
categories: [software-dev]
tags: [github]
date: 2020-07-30T11:47:39-07:00
title: 'GitHub Tip: watching releases'
image:
    file: github-watch-releases.png
    alt: 'Watching releases only on GitHub'
    caption: 'Watching releases only on GitHub'
    source_link: null
    half_width: false
---

A while ago, GitHub [added a new option](https://github.blog/changelog/2018-11-27-watch-releases/) for "watching" repositories, the setting that determines which events on a project trigger a notification for you.

<!--excerpt-->

Previously, the options were:

1. Not Watching: be notified when participating or @mentioned.
2. Watching: be notified of all conversations.
3. Ignoring: never be notified.

The new addition is "Releases Only" &mdash; to be notified of new releases, and when participating or @mentioned. It is the perfect middle-ground between "not watching" and "watching". For me, it is one of the best and most useful features on GitHub.

{% include post_image.html %}

Why is it so useful? I rarely want to get notifications for _all_ activity on a project, especially if I am only a user of the project, not a contributor to it. More importantly, many projects do not have a blog or mailing list that announces new releases &mdash; and for those that do, they often only announce major releases, not _all_ releases. And even then, I often miss these announcements in my RSS reader (that is, _if_ the blog even provides an RSS feed).

I would rather not clutter my RSS feed with project release announcements, anyway. GitHub is where I go to work, and that is where I want to be notified. There are many tools that I use that I want to keep updated, like [SwiftLint](https://github.com/realm/SwiftLint), [Jazzy](https://github.com/realm/jazzy), and [CocoaPods](https://github.com/cocoapods/cocoapods). "Watching releases" for these projects and others has been great. Sometimes, I am waiting on a patch release for a project to fix a specific bug that I have encountered, or maybe I am waiting on CocoaPods to support the latest version of Xcode &mdash; now GitHub notifies me for every release.

Here's a bonus: I also watch releases on [actions/virtual-environments](https://github.com/actions/virtual-environments) so that I get notified whenever the [GitHub Actions](https://github.com/features/actions) environments change. That means as soon as a new Xcode version is deployed to GitHub Actions, I can update all of my workflows.
