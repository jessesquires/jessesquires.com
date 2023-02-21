---
layout: post
categories: [software-dev]
tags: [xcode, debugging, ios, macos, xcode-tips]
date: 2023-02-21T09:46:37-08:00
title: "Xcode tip: sharing breakpoints across projects"
image:
    file: xcode-shared-breakpoints.jpg
    alt: User Breakpoints in Xcode
    caption: User Breakpoints in Xcode
    half_width: true
---

In my [previous post]({% post_url 2023-02-20-ios-view-controller-loading %}), I explained how to use symbolic breakpoints to discover when view controllers load their views into memory. Often breakpoints are specific to a project. You'll create one for a specific class that only exists for that particular app. However, what I discussed in that post would be useful in _any_ project. Unlike regular breakpoints, symbolic breakpoints (at least when set on system frameworks) are more or less universal.

<!--excerpt-->

There are many different types of breakpoints that are "generic", or not specific to a particular codebase --- symbolic breakpoints, error breakpoints, exception breakpoints. Most of these can be shared. I'm sure many of you are like me and work with _multiple_ Xcode projects every week --- for work, side projects, open source libraries, etc. It would be tedious to create the exact same breakpoints for every single project you work on.

Luckily, Xcode has a solution to this --- User Breakpoints! After creating any breakpoint, you can right-click and select: "Move Breakpoint To" > "User" to move it _from_ your project or workspace _to_ user space. After this, you'll see a shared list of User Breakpoints in every Xcode project you open.

As you can see in this screenshot below, I've collected a few over the years. I added many of these User Breakpoints after learning about them in a blog post just like this one! Having these shared breakpoints has been a great way for me to remember various debugging tips and reuse them across all of my projects.

{% include post_image.html %}
