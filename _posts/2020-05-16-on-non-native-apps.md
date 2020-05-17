---
layout: post
categories: [essays]
tags: [tech, apps]
date: 2020-05-16T19:21:42-07:00
title: "On non-native apps: JavaScript doesn't suck but your app might"
image:
    file: slack503.jpeg
    alt: 'Slack screenshot 503 error'
    caption: 'Slack app displaying a 503 error page.'
    source_link: null
    half_width: false
---

The other day [Slack went down](https://status.slack.com/2020-05-12) and I tweeted to express my dissatisfaction and sarcastically comment that non-native apps are the future. I should have known it would get as much attention as a tweet about Elon Musk. People argued about the merits of native versus non-native app development, which seems like a never-ending a controversy. However, I really do not care which *technologies are used* to make an app. I only care about the *quality* of an app and the user experience it provides &mdash; which is the problem with Slack.

<!--excerpt-->

{% include post_image.html %}

When Slack's service fell over, the entire UI of the app disappeared. How is this an acceptable error state or user experience? The entire window turned into a blank webpage with an obscure server error. Programmers would understand exactly what is happening here, but non-tech savvy users would have no idea. Is this the best that the talented folks at Slack can offer? I am confident they can do better.

To be clear, there are plenty of **native apps** that suck. Some native apps are very shitty. Just browse through any of Apple's curated App Stores. Like [Brent Simmons recently wrote](https://inessential.com/2020/05/07/what_happened_when_i_looked_at_two_mac_a), _"By not paying attention to the basics of a good Mac app, each of these apps lost a potential customer."_ It is possible to write poor-quality software, no matter the underlying technology. But is it possible to write high-quality software, no matter the underlying technology? I want to say yes, but I am not sure.

The same goes for [Mac Catalyst](https://developer.apple.com/mac-catalyst/) apps. It is *painfully obvious* which Mac apps are built using Catalyst and which ones are not. To me, those apps are simply not good Mac apps. (But they are great iPad apps.)

And that is sort of my point &mdash; I do not think I should be able to tell with which technologies your app is built when I use it. I can *almost always* tell when an app is not native on iOS or macOS. It is usually slow and hoards system resources, or otherwise behaves in ways foreign to the platform and breaks established paradigms. Again, Mac Catalyst apps are guilty here, too. While native apps can exhibit these shortcomings, it is much less prevalent in my experience. Is it possible to build a non-native app that truly feels native? I want to say yes, but the evidence says otherwise. Surely it could be *possible*?

{% include break.html %}

I do not think non-native apps are inherently bad because they are non-native. I do not think "JavaScript sucks" and I do not think that people who use JavaScript are "stupid" for using it. Actually, my view is quite the opposite. I like JavaScript. I rarely write it, but I enjoy it when I do. Its pervasiveness is a testament to how easy it is to learn. Being easy to learn is great.

Programming languages are imperfect and opinionated, just like their authors and maintainers. Tell me your favorite language and why it is the best, and I can provide a list of reasons why other people think it sucks. But I am not interested in the infighting, signaling, or gatekeeping around which programming languages are "good" or "bad" &mdash; they all have pros and cons. (I apologize for the snarky tweet.)

What I am interested in, is high-quality software and criticizing its decline. It seems like the bare minimum is now good enough for much of the software many of us are required to use daily for work. If your current approach to building software is producing poor-quality or barely-good-enough apps, then perhaps a different approach should be considered? Like [Brent said](https://inessential.com/2020/05/07/what_happened_when_i_looked_at_two_mac_a), _"Maybe that’s not worth it? But doing a not-good Mac app **is** somehow worth it? I don’t understand."_
