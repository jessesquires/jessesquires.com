---
layout: post
categories: [essays]
tags: [tech, apple-watch, apple]
date: 2021-12-29T16:17:23-08:00
title: "My first Apple Watch: thoughts and reflections"
---

I decided to finally get my first Apple Watch with the Series 7 this year. I am typically never one to get a first-generation product &mdash; my first iPod back in the day was the iPod Photo and my first iPhone was the 3G (or maybe the 3GS?) &mdash; but I rarely wait _this long_ if I'm interested in something. The original Apple Watch had little appeal to me at the time, and the mere existence of the $10,000 gold _Edition_ model made the entire thing feel all the more ridiculous. But over the years as the watch hardware and watchOS improved, and as I got more into fitness, I became more interested. I've always felt like there's a lot of hype around the Apple Watch &mdash; people really seem to love it. After wearing and using one for about two months, now I understand. It's pretty damn good.

<!--excerpt-->

Overall, I think the watch is great. However, there is one major issue with it for me specifically, [which I've decided to write about in a separate post here]({% post_url 2021-12-29-apple-watch-thinks-im-dead %}). Spoiler alert: wrist tattoos still interfere with some functionality.

{% include break.html %}

The features where the Apple Watch shines are fitness, health, and activity tracking. All of the health-related apps &mdash; Activity, Workout, Heart Rate, Mindfulness, etc. &mdash; are shockingly good. After health and fitness, the next best part of Apple Watch is what I consider the "watch-related" apps: Timers, Alarms, World Clock, Nightstand Mode, Calendar, Calculator, and Weather. Maybe Weather is a stretch, but the others are essentially all of the features you expect from a typical digital watch, even the "dumb" ones. Of course, it would be quite embarrassing if Apple Watch were not good at watch-related things. All of these first-party apps are built extremely well. In fact, they are the best apps I have used on the watch so far, by significant margins. They are superb examples of what apps should be: clear and well-organized UI, intuitive to use, and they "just work".

The other major feature that people seem to like are notifications, but I've disabled most of those except for Messages, Phone, Calendar, and health-related apps.

{% include break.html %}

My main motivation for getting the watch was for the activity tracking and fitness features. I underestimated how good and how motivating those features would be for me. For years now, I've used my iPhone exclusively to track my runs and bike rides, and the watch brings such a massive improvement to that in every way. I particularly enjoy being able to leave my phone at home when I go run or bike, but know that I can still make and receive calls if there's an emergency.

I know there are other brands of smart/fitness/GPS watches out there &mdash; so I could have had this "fitness watches are amazing" epiphany sooner. However, other watches are around the same price as an Apple Watch, and as an iOS dev, I felt like the Apple Watch was a better fit and a provided an opportunity to explore the platform as a developer too, instead of just as a consumer. As an iPhone user, I was also interested in all of the iOS integration, which other watches cannot do.

The first-party Activity app and Workout app are _incredibly good_ &mdash; significantly better than any of the third-party apps I've used. I've been a long time RunKeeper user on iPhone. I've tried Strava, but I couldn't get over how terrible the UI was. Unfortunately, the RunKeeper watch app is terrible. Thus, I have switched to using only the first-party apps for activity and fitness tracking.

{% include break.html %}

Battery life is incredible. I can go on a run or bike ride for 1-2 hours with only my watch, tracking my activity while streaming a Spotify playlist over cellular and listening via Bluetooth headphones &mdash; and battery only drops by 10-20 percent, depending on how long I'm out. That leaves me with plenty of battery life for the rest of the day. I primarily bike to get around Oakland, and also track those rides throughout the day. I don't do anything to try to conserve battery life, nor do I charge it during the day. Yet, I have never ended my day with less than 20-30 percent battery left to spare. The fast charging feature of the Series 7 is noticeable and impressive, though I have not needed it.

{% include break.html %}

If I had to choose one criticism of Apple Watch, it would be that it tries to do too much. There are too many features carried over from the iPhone and iOS that seem like they are there just because _they could be_ without much attention to whether or not _they should be_. I find these features of the Apple Watch to be absolutely ridiculous &mdash; email, for example. The last thing I want to do, basically ever, is read my email. So I definitely _do not_ want emails on my wrist watch. One of the first things I did during setup was to remove apps or disable features that I didn't need, or want:

- Disabled photo syncing. I wish you could delete the app completely, but you can't.
- "Disabled" mail. (Notably, the new "Mail Privacy Protection" feature in iOS 15 is [undermined by Apple Watch](https://www.macrumors.com/2021/11/16/mail-privacy-protection-undermined-by-apple-watch/) which doesn't support the feature.) Unfortunately, you can't delete the app entirely. You also can't actually turn off mail syncing entirely, but I found a hack:
    1. Turn off mirroring your phone email.
    1. Turn off notifications.
    1. Create a new, empty mailbox/folder on your iCloud account. I named it "Empty".
    1. Select this mailbox as the only one to sync to your watch.
    1. Effectively, this results in no mail syncing to the watch.
- Deleted the following apps, either because I do not use them at all, or because I won't use them on the watch:
    - Find Items
    - Find People
    - Memoji
    - Remote
    - Tips
    - Walkie-talkie

There are still other built-in apps that I would like to completely remove, but watchOS does not allow it right now. If I could, I would also delete: Photos, Mail, App Store, Audiobooks, News, Reminders, and Stocks. Seriously, who is reading News and looking at Stocks on their watch?

I hope future versions of watchOS will follow the lead of iOS, allowing users to delete more of the built-in apps.

{% include break.html %}

Finally, most third-party apps I've tried to use are just terrible. Absolutely horrific UI and UX. Like I mentioned above, the RunKeeper watch app is awful, especially compared to the first-party Workout app, which is insanely good. It looks like RunKeeper shipped an MVP when the watchOS SDK first launched and then never touched it again. Spotify is the only third-party app I use regularly, and it is incredibly glitchy and buggy. I'm working on building a playlist that I can store locally on the watch via the Music app instead.

I'm not sure if third-party apps are so bad because the SDK is too limited for third-party developers, or because companies are not investing any time and resources into the platform. My guess is that it is a combination of both, but primarily that there isn't enough incentive for companies to invest in high-quality watch apps.
