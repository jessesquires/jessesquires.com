---
layout: post
categories: [software-dev]
tags: [objective-c, open-source, ios, github]
title: Officially deprecating JSQMessagesViewController
subtitle: No longer maintaining or supporting this project
date-updated: 2017-07-18T10:00:00-07:00
---

Beginning immediately, [JSQMessagesViewController](https://github.com/jessesquires/JSQMessagesViewController) is no longer officially supported or maintained. In fact, you may have noticed that it has been neglected for the past year. The most recent release was published almost exactly one year ago today. This is an incredibly difficult post for me to write and I have not made this decision carelessly. This open source project had a great run. There was (and still is) a great community around it, and I'm sorry for bringing this to an end.

<!--excerpt-->

{% include updated_notice.html
    update_message='The community has started a thread about alternative solutions and is organizing a new GitHub organization for a new community-driven library. This would be a great project to get involved with. See <a href="https://github.com/jessesquires/JSQMessagesViewController/issues/2159" class="alert-link">#2159</a> for details.'
%}

### Why now?

For the past year I've gone back and forth, debating with myself about whether or not to continue working on this library or give it up. There is no single reason why I have finally decided to abandon the project, it is more of a *death by a thousand cuts* kind of story. In short, I simply do not have the time nor the motivation to continue working on this project, given its current state. However, I want to emphasize how difficult this is for me to do. I love this project and I loved working on it with the [dozens of contributors](https://github.com/jessesquires/JSQMessagesViewController/graphs/contributors). This is not easy, but if I am going to be honest with myself and with the community, it is time to let it go. (And really, I should have written this 6 months ago.)

I have [written before](/blog/open-source-everything/) about how to successfully maintain open source projects, so this post may seem a bit ironic. Shouldn't I know how to do this? 😉 Well, the history of `JSQMessagesViewController` is quite different from the other projects that I maintain. In fact, my other projects and [*that post*](/blog/open-source-everything/) were largely the result of what I learned from all the mistakes I made with `JSQMessagesViewController`.

This library was **my first ever open source project**. I built it for an app I was working on and extracted this component to put on GitHub. The fact that it grew into what it is today was purely an accident. Within the first few weeks of being on GitHub, it skyrocketed to 1,000 stars. Keep in mind, this was back when that was *a lot of stars* and there were only about 1,000 or so libraries available via CocoaPods. [CocoaPods](https://cocoapods.org) now has over 34 thousands libraries. However, the project did not get off to a great start from the perspective of long-term maintenance. In the early days, there was little or no documentation and certainly no tests. There was no continuous integration, release notes, or even proper semantic versioning. I had no idea what I was doing. But eventually, each of these things were implemented and each time the project got better and more stable. I was learning each step of the way.

Things were great and I was regularly spending time on the project for years. Then life, other projects, other interests, and a million other little things started consuming more of my time. This meant less time for `JSQMessagesViewController`. The project started to fall behind while iOS continued to rapidly advance. There is a substantial amount of work to do to properly support this project and as I mentioned, I simply do not have enough time. But more importantly, I no longer have the motivation. I'm sorry it took me a year to finally admit this to myself and to you.

Furthermore, while there are many great contributors, unfortunately there is not a clear owner to succeed me and take over the project.

For years, I maintained and supported this library well beyond my own needs &mdash; I built features with the community that I never needed nor used for my own apps. In fact, for the majority of the lifetime of this project I was no longer actively using it in any of my own apps. I worked on it because it was fun, and because I had some free time. Now, however, the maintenance burden and my lack of interest and motivation for the project have won. Not to mention, there are *so many* other things I want to build. In a single word, my answer to *why?* is [prioritization](/blog/prioritization/).

This brings us to today.

### Current state of the project

For the past year, I have been underwater with notifications and issues. I cannot remember the last time I had fewer than hundreds of unread notifications and open issues. I have been debating whether or not to publish one final "clean up" release, but I simply cannot do it. Though there is not *a ton* of technical debt in this project, but there is a substantial amount of work to do to get it where it needs to be.

Most recently, I was working on the [8.0 release](https://github.com/jessesquires/JSQMessagesViewController/milestone/7) when my participation started to dwindle significantly. This release was going to drop iOS 7 support, provide proper Swift inter-op, and fix up some long-standing architectural issues. As you know, we are now on the cusp of iOS 11. There is simply too much "catch up" to do at this point, not to mention a huge backlog of unanswered issues.

I'll be updating the README, closing all open issues and pull requests, and marking the library as deprecated in CocoaPods today.

There are already hundreds of forks maintained by contributors, not to mention there are similar libraries in CocoaPods. I cannot vouch for any of these alternatives, as I am not familiar enough with any of them. If there are any that you can recommend, let me know and I will update this post.

I don't think there's any immediate danger to using this library, but I would recommend finding a new solution or building something yourself. And if you do build it yourself, you should open source it and let me know about it. 😄 At the very least, you can use this project as a starting point or as a source for ideas.

Please share this post to help spread the word to allow everyone to plan how to migrate off of this library.

### Reflecting on the last 4 years

It is hard to believe that `JSQMessagesViewController` is 4 years old. It's now approaching 11,000 stars. According to [CocoaPods stats](https://cocoapods.org/pods/JSQMessagesViewController) there have been almost 2 million downloads and over 36,000 apps that use the library. There are over 2,000 forks and 100 contributors. I never dreamed that anyone would ever use this other than me. I never expected any of this, and I am grateful that it evolved into such a well-loved library.

I am grateful that my first ever endeavor into open source was a pleasant one &mdash; unfortunately, that is not the experience for many others. There were some assholes along the way, but mostly everyone in the community was great. I would like to sincerely thank everyone who contributed to, or used this library. I still receive messages and meet people who have used or are currently using this library. I have met so many great people through this project. I'll never forget that.

I'm sorry to bring such sad and disappointing news to the community. Other the hand, I must admit that I feel so relieved.

I hope you can understand.
