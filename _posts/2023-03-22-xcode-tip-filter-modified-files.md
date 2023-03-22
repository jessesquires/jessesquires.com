---
layout: post
categories: [software-dev]
tags: [xcode, xcode-tips, ios, macos]
date: 2023-03-22T15:12:50-07:00
title: "Xcode Tip: filter to show modified files only"
image:
    file: xcode-tip-filter-2.jpg
    alt: "Xcode: filter sidebar to show modified files only"
    caption: "Xcode: filter sidebar to show modified files only"
    source_link: null
    half_width: false
---

Large Xcode projects can be difficult to navigate, especially when you are making a large change across a large number of files. Depending on how your project is configured, modified files will be spread across multiple nested directories and multiple targets.

<!--excerpt-->

Before I commit my changes and submit a pull request, I like to take one last pass at the code I've written. This is when I make formatting fixes and optimizations where needed, and generally clean things up. Especially when I'm implementing a large change that is spread across multiple files, the navigation experience in Xcode can be clunky. I often use Quick Open (`cmd-shift-O`) to search for and open a file --- but in a massive project, I can't remember all the file names. Xcode helpfully shows an `M` next to modified files and an `A` next to added files. But when there are _thousands_ of files in the sidebar, it is difficult to see what's going on with your specific change. It can be overwhelming.

{% include blog_image.html
    file="xcode-tip-filter-1.jpg"
    alt="Xcode: unfiltered sidebar showing all files"
    caption="Xcode: unfiltered sidebar showing all files"
    source_link=null
    half_width=false
%}

I usually use [Git Tower](https://www.git-tower.com/mac) to review and commit my changes, but you can't edit files in Git Tower, which means switching back-and-forth between Xcode if you need to make additional modifications. Xcode provides a nice commit interface that allows editing, but it isn't always easy to use for editing --- the side-by-side view forces lines to wrap and sometimes scrolling is wonky. File selection in this view is often glitchy, too.

Luckily, there's an easier way. Instead of trying to use Git Tower or Xcode's commit UI, you can filter the files in the sidebar to show only ones that have been modified! It's a very subtle button in the bottom right corner with a `+/-` icon. Click that and Xcode will hide all the files you haven't touched. I've found this to be helpful for focusing specifically on the changes I'm making and removing all the clutter in large projects.

{% include post_image.html %}
