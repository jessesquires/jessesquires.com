---
layout: post
categories: [software-dev]
tags: [ios, macos, apple, screen-time, bugs]
date: 2022-01-16T17:33:18-08:00
title: Screen Time is drunk
image:
    file: screen-time-1.jpg
    alt: Screen Time screenshot
    caption: Buggy Screen Time usage report
    source_link: null
    half_width: true
---

Speaking of [drunk software]({% post_url 2022-01-11-ios-app-library-is-drunk %}), Screen Time on iOS and macOS has been shockingly buggy for me lately. It reports that I spent over 22 hours on my devices in a single day last week, and nearly 10 hours on another day this week. In both instances, a significant portion of the usage is supposedly occurring after midnight.

<!--excerpt-->

This has happened to be a number of times now, and it is always a web address that is the culprit for making up the excessive time spent. See the screenshot below. Apparently I was going wild, nonstop from midnight until just before 6pm.

{% include post_image.html %}

It is quite clearly a bug, as evidenced by the per-app breakdown that Screen Time provides. It reports that I visited `http://hexedbits.localhost` for over 18 hours, while simultaneously reporting that I used Safari for only 44 minutes. I _was_ doing some local web development for [hexedbits.com](https://hexedbits.com) on my Mac that day using Safari, but certainly _not_ for 18 hours.

{% include blog_image.html
    file="screen-time-2.jpg"
    alt="Screen Time screenshot"
    caption="Screen Time showing inconsistent usage data"
    source_link=null
    half_width=true
%}

For yesterday's usage, Screen Time similarly reports that I visited one website for over 8 hours though used Safari for only 39 minutes. I remember the web page, which I only opened briefly on my phone. I'm not a "keep my tabs open" kind of guy. All tabs get closed by the end of every day, which makes this even more peculiar. I don't know how Screen Time works under-the-hood, but I assume part of it is simply tracking the active processes. And so, my best guess is that Safari --- on iOS and macOS --- has a leak. In any case, you would think that Screen Time would be able to intelligently identity and throw out obviously bad data.

It's all quite unfortunate, because I feel like I can't trust _any_ of the Screen Time reports now. This feature has helped me catch when I'm spending too much time on my devices, which usually means I'm feeling shitty. I suppose it's all kind of ironic --- a device telling me when I've used it too much, even though my mental health is obviously deteriorating from said usage, and I should just fucking go outside.
