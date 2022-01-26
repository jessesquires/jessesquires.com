---
layout: post
categories: [software-dev]
tags: [apple, app-store, ios, dev-relations]
date: 2020-09-15T18:12:21-07:00
title: Why is Apple acting like an Asshole?
image:
    file: appholes.jpg
    alt: 'Appholes'
    caption: null
    source_link: null
    half_width: false
---

Today Apple announced [at their media event](https://www.apple.com/apple-events/september-2020/) that the final public release of iOS 14 ships tomorrow, which came as quite a shock to all third-party developers.

<!--excerpt-->

This unwelcome surprise comes against the backdrop of dozens of controversies around the App Store &mdash; most recently [Hey.com](https://www.theverge.com/2020/6/16/21293419/hey-apple-rejection-ios-app-store-dhh-gangsters-antitrust) and [Epic](https://daringfireball.net/linked/2020/08/28/apple-terminates-epic-games-account), but more generally its [painfully confusing](https://marco.org/2020/09/11/app-review-changes) and [arbitrarily applied](https://inessential.com/2020/05/10/heads_up_to_rss_reader_authors) rules, its incomprehensible [app rejections](https://mjtsai.com/blog/tag/rejection/) and their often sudden retractions, app [approvals followed by sudden removals](https://www.macrumors.com/2016/03/07/flexbright-adjust-display-temperature/) without explanation, and the general unequal treatment of developers where [big companies](https://gizmodo.com/researchers-uber-s-ios-app-had-secret-permissions-that-1819177235) or favorites [get special treatment](https://mjtsai.com/blog/2019/02/27/bbedit-12-6-to-return-to-the-mac-app-store/). It leaves me wondering, what the hell is Apple's strategy here? This is not a flurry of bad PR for the sake of it. There are serious problems here that need to be addressed &mdash; in particular, Developer Relations.

{% include post_image.html %}

{% include break.html %}

Historically, these events announce new hardware and the upcoming release of the next major version of iOS, which is typically made public a few days later or the following week. For as long as I can remember it goes something like this:

- Apple hosts a media event on a Tuesday in September.
- Announcements include new iPhones, iPads, and Watches. Or, at least some combination of those. Maybe something about Apple TV.
- All of the new hardware will run the latest version of iOS (or watchOS, or tvOS).
- The next major release of iOS is announced to be shipping on Friday (in a few days) or sometime the following week, like the next Tuesday.

But today, Apple announced that iOS 14 is shipping **tomorrow**. This was near the end of the event &mdash; at roughly 11:00 AM Pacific time. This means West Coast developers have half a day to put the final touches on their app updates for iOS 14 **AND** get their apps submitted with the just-released Xcode 12 GM **AND** get through App Store review. None of those tasks are trivial, and no one familiar with them would agree that this is a sufficient amount of time to complete them. If you happen to be working on the East Coast, this means you were given just a few hours before the working day was over to get your app ready and submitted. And if you live in Europe or anywhere else in the world, well, go fuck yourself and good luck tomorrow!

On top of this, critical bugs still exist in the latest releases of the SDKs, Xcode 12, and iOS 14. It seems they will not be addressed.

{% include break.html %}

Given the increasingly tenuous relationship that Apple has with developers, I do not understand how it could be in their interest to act like such an asshole right now. Not to mention, it is unlikely that they will even be able to review all of these app submissions in time. We already do not feel valued due to the aforementioned issues, and this is an outright negligent response to developer relationships the company has damaged over the past few years. Announcing that iOS 14 ships tomorrow with virtually no notice to developers is yet another breach of trust, another disappointment, and quite frankly feels like a big 'fuck you' to developers. What purpose does it serve to place this last-minute, unnecessary stress on third-party developers?

Who is in charge of iOS releases at Apple that thought this was a good idea? Who is the head of Developer Relations that thought this was a good idea?

To whomever made these decisions: **y'all fucked up. Again.**
