---
layout: post
categories: [software-dev]
tags: [ios, macos, apple, app-store, mac-app-store, app-store-rejection]
date: 2024-01-03T18:34:44-08:00
title: Another frivolous and frustrating App Store rejection
---

I'm happy to share that I released [an update to Taxatio](https://www.hexedbits.com/news/2024/01/03/taxatio-update/) today, but unfortunately it was not without a lot of friction and hassle with the App Store approval process.

<!--excerpt-->

[Taxatio](https://www.hexedbits.com/taxatio/) is a universal app for iOS and macOS. I submitted the same update (version 1.3.0) for both platforms on December 30. The iOS app was accepted within a few hours, which was excellent. However, the macOS update was delayed for a ridiculous reason, after waiting to be reviewed for three entire days.

It is important to note --- and I cannot stress this enough --- the iOS app and macOS app are **nearly identical**. They are SwiftUI apps with the exact same functionality and they share 90 percent of their code. The metadata in the App Store for each is exactly the same, the only exception is the screenshots. So, it was curious to me how one could be approved within hours while the other was waiting to be reviewed for multiple days --- ultimately, only to be rejected.

So what happened? On January 2, three days after submitting to App Review and three days after the iOS app was approved, I received this message from App Store Review (yes, with this formatting and typos):

>  **Bug Fix Submissions**
>
> The issues we've identified below are eligible to be resolved on your next update. If this submission includes bug fixes and you'd like to have it approved at this time, reply to this message and let us know. You do not need to resubmit your app for us to proceed.
>
> Alternatively, if you'd like to resolve these issues now, please review the details, make the appropriate changes, and resubmit.
>
> ### Guideline 2.3 - Performance - Accurate Metadata
>
>
> We noticed that your app's metadata includes the following information, which is not relevant to the app's content and functionality:
>
> What’ new text showed iOS reference.
>
> **Next Steps**
>
> To resolve this issue, please revise or remove this content from your app's metadata. For resources on metadata best practices, you may want to review the App Store Product Page information available on the Apple Developer website.

In my release notes for this update **for both the iOS app and the macOS app**, I wrote:

> - Dropped support for iOS 16 and macOS 13. Now requires minimum iOS 17 and macOS 14.

So acknowledging that my app is a universal app --- a fact that users are aware of --- is grounds for a **rejection**? That is beyond ridiculous, especially considering **the iOS app contained the exact same release notes** and got approved. I mean, seriously! What a fucking joke! Not to mention, Apple _actively encourages_ developers to [support universal purchases](https://developer.apple.com/support/universal-purchase/) for apps available on their platforms since they started [supporting this in 2020](https://developer.apple.com/news/?id=02052020a). I do not think that mentioning OS support changes for a universal app is "not relevant" and I certainly do not think it should result in a rejection. It's harmless.

I replied asking to be approved anyway and "resolve" the "issues" on my next update --- but surprise, my release notes for the next update will be completely different anyway. I replied shortly after receiving the rejection notice, hoping that the turn around would be quick --- I had already waited three days! Of course, it took another entire day to finally be approved on January 3. That means time from submission to approval was four days in total.

I have two major complaints about this process.

First, the inconsistency is absolutely maddening. The time discrepancy between review times between platforms is annoying, especially considering you can submit multiple items for review for a universal app at once --- and the fact that, you know, **the app is universal**. Wouldn't it make sense to review and approve both at the same time? More obviously and more infuriating is the fact that these apps are identical with identical release notes. There were no issues with the iOS app release notes mentioning macOS, but apparently you cannot mention iOS in the release notes for a macOS app.

Second, while I appreciate Apple's new approach to allowing apps to be approved for minor "violations" without having to resubmit, it does not work well in practice (obviously). In 2020, [Apple announced](https://www.apple.com/newsroom/2020/06/apple-reveals-new-developer-technologies-to-foster-the-next-generation-of-apps/) _"for apps that are already on the App Store, **bug fixes will no longer be delayed** over guideline violations except for those related to legal issues. Developers will instead be able to address the issue in their next submission."_ (Emphasis mine.) This sounded great in 2020, but the problem is that my app release _was still delayed_. I'm glad I did not have to wait _another three days_, but I did have to wait _another entire day_ because of this inconsistent, bureaucratic nonsense. Instead of the back-and-forth, why not simply approve the submission immediately and then mandate changes on the next submission?

It is so disappointing, after so many years, that the App Store approval process continues to be so erratic, unpredictable, petty, and (often) slow for such benign app updates --- all the while [scam apps continue to get approved](https://www.theverge.com/2021/4/21/22385859/apple-app-store-scams-fraud-review-enforcement-top-grossing-kosta-eleftheriou) and promoted in [the top charts](https://9to5mac.com/2021/04/12/fake-reviews-and-ratings-manipulation-app-store/), much less [get rejected](https://mjtsai.com/blog/2022/07/14/most-fraudulent-apps-still-on-the-app-store/).
