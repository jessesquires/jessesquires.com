---
layout: post
categories: [software-dev]
tags: [ethics, tech, web, analytics, open-source]
date: 2020-05-08T14:24:43-07:00
title: Simple, private, and open source analytics with GoatCounter
---

I [removed Google Analytics]({{ site.url }}{% post_url 2018-04-22-removing-google-analytics-too %}) on this site over two years ago. It was doing more harm than good. I did not want to jeopardize readers' privacy. I did not want to be part of the [bullshit web](https://pxlnv.com/blog/bullshit-web/). I did not want to contribute to Google's massive data collection and its take over of the open web. I did not want to be Google's product. (Because [fuck Google](https://en.wikipedia.org/wiki/2018_Google_walkouts).)

I rarely even looked at those analytics back then. However, since going independent last year, I have more interest in knowing and understanding the traffic on this site. I found a fantastic solution for analytics that is simple, private, and open source called [GoatCounter](https://www.goatcounter.com).

<!--excerpt-->

### Searching for alternatives

In [my post about removing Google Analytics]({{ site.url }}{% post_url 2018-04-22-removing-google-analytics-too %}), I mentioned that [Matomo (formerly Piwik)](https://matomo.org) seemed like a promising alternative. Back when it was still Piwik it seemed very lightweight, but it has now evolved into an expensive and bloated corporate mess. It looks like it is [still open source](https://github.com/matomo-org), which is great, but it is simply too much for my needs. With Google Analytics, I was drowning in options and jargon I did not understand, and superfluous data I did not want to collect. Matomo does not seem much different in that respect. I only really care about tracking page views and referrers.

Recently, I discovered exactly what I was looking for &mdash; [GoatCounter](https://www.goatcounter.com) is [privacy-aware](https://www.goatcounter.com/privacy), lightweight, and simple. It collects no personal information and is pretty much just a simple page view counter. It is an indie project created by [Martin Tournoij](https://github.com/arp242) and it is entirely [open source on GitHub](https://github.com/zgoat/goatcounter). It is free for personal use, but I pay monthly so I can help support this project because I think it is incredibly important for a project like this to exist. And if for some reason the project is abandoned in the future, I can install it and run it on my own server.

### Open for all

Finding an open source solution for analytics was critical, and a hard requirement for me. This [entire site is open source](https://github.com/jessesquires/jessesquires.com), as are all of its dependencies, and I wanted to keep it that way.

In the spirit of openness, I wanted to go one step further &mdash; all of the analytics data is open source, too. You can view it yourself at [stats.jessesquires.com](https://stats.jessesquires.com). This data is exactly what I see. The only limitation of this public view is that it updates once per hour instead of in real time. (This is an opt-in feature, that to my knowledge is unique to GoatCounter, and I think it is pretty rad.)
