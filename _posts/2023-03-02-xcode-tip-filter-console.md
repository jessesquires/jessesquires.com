---
layout: post
categories: [software-dev]
tags: [xcode, debugging, ios, macos, xcode-tips]
date: 2023-03-02T10:59:35-08:00
title: "Xcode Tip: filtering debugger output"
image:
    file: xcode-debug-filter.jpg
    alt: Filtering debugger output in Xcode
    caption: Filtering debugger output in Xcode
    half_width: false
---

When debugging a large project in Xcode that a large team works on, the console can get quite busy. Logs are everywhere! It can be difficult to sift through the noise, particularly when you have a number of breakpoints configured to log messages, execute debugger commands, and continue after evaluating rather than pause.

<!--excerpt-->

You can find a good example of this from [my previous post]({% post_url 2023-02-20-ios-view-controller-loading %}), where I showed how to debug view controller loading with symbolic breakpoints. Wouldn't it be nice if you could hide all the other logs happening in the console to focus solely on debugging? You can! In Xcode's debug console, you can select the "Debugger Output" option in the menu on the bottom left. When selected, the only thing you will see in the console are the logs and output from your breakpoints and any debugger commands that you execute manually.

{% include post_image.html %}
