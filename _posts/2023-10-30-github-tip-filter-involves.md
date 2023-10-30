---
layout: post
categories: [software-dev]
tags: [github, productivity]
date: 2023-10-30T10:54:33-07:00
title: "GitHub Tip: using the involves filter"
image:
    file: github-pr-involves.jpg
    alt: "GitHub involves: filter"
    caption: null
    source_link: null
    half_width: true
---

When you work on a large team and are participating in many pull requests on GitHub, it can be difficult to keep track of everything you are working on. In addition to opening your own pull requests, you can be assigned to them, you can be requested as a reviewer, you can comment in discussion threads, and you can be mentioned by others. Each of these occurrences requires your attention --- perhaps immediately, but always eventually.

<!--excerpt-->

GitHub provides some convenient "built-in" filters to help you navigate the matters above. You can see all of your own pull requests, everything that's assigned to you, or everything where you are mentioned.

{% include blog_image.html
    file="github-pr-filters.jpg"
    alt="GitHub PR filters"
    caption=null
    source_link=null
    half_width=true
%}

However, wouldn't it also be nice to see _all of these pull requests_ at once? That is, all of your own pull requests, everything assigned to review, and everything where you are actively in discussion? You can, with the filter `involves:@me`, which will show you all the pull requests you are _involved in_, in any capacity. In other words, it shows you everything that requires your attention. I have found this super helpful when I'm participating in lots of pull request review discussions as well as opening a lot of pull requests, and I want to see everything together. Better yet, it also works when filtering issues.

{% include post_image.html %}
