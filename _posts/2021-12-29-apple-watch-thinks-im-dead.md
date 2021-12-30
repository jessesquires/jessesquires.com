---
layout: post
categories: [essays]
tags: [tech, apple-watch, apple]
date: 2021-12-29T17:17:23-08:00
title: "My Apple Watch thinks I'm dead"
subtitle: "Or, how wrist tattoos still inhibit full functionality"
image:
    file: "apple-watch-wrists.jpg"
    alt: "My tattooed wrists"
    caption: "My tattooed wrists"
    source_link: null
    half_width: false
---

Despite the [many things about Apple Watch that I enjoy]({% post_url 2021-12-29-my-first-apple-watch %}), there is one major issue --- wrist tattoos. For users like me, the full functionality of Apple Watch is still encumbered by wrist tattoos. Specifically, wrist detection fails to work properly.

<!--excerpt-->

### Known issues

Tattoos interfering with Apple Watch functionality is a known issue. This was especially true for the first generation model, as reported by [iMore](https://www.imore.com/heres-why-apple-watch-does-not-play-nice-with-some-tattoos), [AppleInsider](https://appleinsider.com/articles/15/04/28/apple-watch-wrist-detection-failing-with-some-tattoos-users-complain), and [The Verge](https://www.theverge.com/2015/4/28/8510931/apple-watch-doesnt-work-tattooed-wrists) back in 2015. This is another reason I avoided buying one for so long. It appears that how the sensors interact with tattoos has dramatically improved over the years, but there are clearly still issues as evidenced by posts on the Apple Community Forums ([1](https://discussions.apple.com/thread/253410890), [2](https://discussions.apple.com/thread/7885762), [3](https://discussions.apple.com/thread/251798453), [4](https://discussions.apple.com/thread/250623236)) and on Reddit ([1](https://www.reddit.com/r/AppleWatch/comments/qf4cjl/auto_wrist_detection_vs_tattoos_advice/), [2](https://www.reddit.com/r/AppleWatch/comments/qegio8/sleeve_tattoos_brand_new_series_7/), [3](https://www.reddit.com/r/AppleWatch/comments/qb479b/apple_watch_series_7_tattoos/)). Apple also mentions potential problems [on this support page](https://support.apple.com/en-us/HT207941#heartrate):

> Permanent or temporary changes to your skin, such as some tattoos, can also impact heart rate sensor performance. The ink, pattern, and saturation of some tattoos can block light from the sensor, making it difficult to get reliable readings.

I knew all of this before buying the watch, but it seems very hit-or-miss depending on one's specific tattoos. I also knew I could return the watch for a full refund after 14 days if things didn't work out. Obviously, [I decided to keep it]({% post_url 2021-12-29-my-first-apple-watch %}) &mdash; despite the issues with wrist detection --- because the features that _do_ work are just too good.

### My wrist tattoos

Both of my wrists are fully tattooed, along with my arms and hands. In fact, the majority of my body is tattooed at this point. What can I say? I'm addicted to the joys of pain and suffering, which is, coincidentally, one reason that I became a professional software developer. My left wrist is solid, heavy black --- actually, my entire left arm is fully blacked-out from shoulder to wrist. (A topic for another post.) My right wrist is also tattooed in only black ink, but does have some negative space in its design and is composed of tiny dots instead of solid, fully saturated black.

I should confess that the title of this post isn't entirely accurate. My Apple Watch only thinks I'm dead if worn on my _left_ wrist. Luckily I'm left-handed and thus wear watches on my _right_ wrist, natch. However, there is still enough ink on my right wrist to cause issues with wrist detection.

Admittedly, my left wrist is somewhat extreme. Few people in the body modification community have their entire arms blacked-out. So I don't necessarily fault Apple for this edge case. I did not expect to get accurate heart rate readings on my left wrist.

{% include post_image.html %}

### Unnecessary limitations

On my left wrist, the watch cannot detect any vitals --- heart rate, blood oxygen, and ECG all fail. As you may know, the sensors that take these measurements shine light via green, red, and infrared LEDs at your wrist and compute the amount of light reflected back, from which they can derive these various readings. It makes sense that these readings fail on my left wrist that is fully saturated with black ink, which will absorb most, if not all, visible light. I'm not sure how infrared light interacts with black tattoo ink, but it does appear to cause problems.

On my right wrist, where I wear my watch, all of these vitals measurements and activity tracking work as expected. Perhaps there are minor inaccuracies, but overall the readings seem sufficiently precise in my experience. This is great, because it means that all the activity tracking features work --- my main motivation for getting an Apple Watch.

The big problem, however, is wrist detection, which consistently fails. If wrist detection is turned on, my watch will almost immediately auto-lock no matter how I position it. This means it thinks I have taken it off, and thus basically disables all functionality. No notifications are sent, the "always-on" display is turned off, etc. I have found a few "sweet spots" where wrist detection works, presumably where the sensors are able to align within the small areas of ink-less skin on my right wrist, however, keeping the watch in precisely the right spot is untenable. The only choice I have is to disable wrist detection entirely, which displays this enormous alert about everything that will happen if you do that:

{% include blog_image.html
    file='apple-watch-wrist-detect.jpg'
    alt='Apple Watch Wrist Detection Alert'
    caption='Disabling Apple Watch Wrist Detection'
    source_link=null
    half_width=true
%}

Unfortunately, this list of disabled functionality is not complete. Also disabled are stand notifications, mindfulness notifications, and perhaps others. Some of the restrictions I understand. For example, disabling background vitals measurements makes sense. But some of the restrictions seem unnecessarily limiting. This, in my opinion, is the biggest problem.

Even with wrist detection disabled, the activity app still accurately tracks and records my move, exercise, and stand goals --- so why do stand notifications have to be disabled? The watch clearly knows if I've been standing and should be able to notify me. The lack of mindfulness notifications is even more perplexing. Even if I configure mindfulness notifications to happen at specific times of the day, they fail to get delivered. Why does this have anything to do with wrist detection? And why do noise measurements and notifications need to be disabled?

### Security implications

Because I must keep wrist detection turned off, that means I have to manually lock the watch when I take it off. This presents some obvious security issues. However, because a watch is something you wear the security risk of leaving it unlocked is much less severe than leaving an iPhone unlocked. Still, I've taken some precautions here. Namely, I don't use the Wallet app or Apple Pay on the watch. (Honestly, I probably wouldn't do this anyway.) I also don't allow the watch to unlock my iPhone or my Mac. This is a bummer, but I can live without it (and have been up until now). And, as I wrote [in my other post]({% post_url 2021-12-29-my-first-apple-watch %}), I've disabled a lot of features that I simply don't use, like photos and email syncing. That, coincidentally, makes me feel better about leaving wrist detection off. There's certainly still sensitive information on the watch, like Messages and Calendar, but at least I can limit some of these other things. In the worst case (and, still, very unlikely) scenario that someone is able to steal the watch, I can always remotely lock it with Find My.

### Potential solutions

There's much discussion on Reddit ([1](https://www.reddit.com/r/apple/comments/63h8mp/found_a_fix_for_wrist_detection_with_tattoos_on/), [2](https://www.reddit.com/r/AppleWatch/comments/7cy8mw/trick_to_make_apple_watch_all_series_work_with/), [3](https://www.reddit.com/r/AppleWatch/comments/rptkbp/possible_tattoo_fix/)) about how to make wrist detection work with various hacks, all of which are variations of partially covering the sensors with different tapes or adhesives. None of these hacks are ideal. I have yet to find the courage to try any of these for fear of damaging the watch in some way, but I might try them eventually.

However, I think Apple could do significantly better here. The unnecessary limitations could be removed: allow stand and mindfulness notifications regardless of the wrist detection settings. Another idea is to allow certain apps to be locked with a passcode. For example, when wrist detection is off, you could require the passcode when opening Wallet, Messages, Contacts, and other apps with private or sensitive information. Doing these few things would address the majority of my problems.

I don't know enough about the hardware to know why the sensors for heart rate and blood oxygen levels work for me, but wrist detection fails. It seems like this is something that _could_ be fixed with some tweaks. But if not, what I would like to see most is a "tattoo mode". When you first setup your Apple Watch one of the prompts asks if you use a wheelchair, which tells the watch to adjust its behavior if you answer affirmatively. For example, it (presumably) does not notify users in wheelchairs to stand up every hour. I can imagine a similar mode, where you are prompted if you have wrist tattoos during setup, and the watch could relax the wrist detection restrictions or perhaps use other information or sensors to try to determine if you are wearing the watch or not.

To be clear, I am not equating tattoos with other users' accessibility needs. But if the Apple Watch can be tweaked to work better for wheelchair users, surely there are tweaks that can make it work better for tattooed users, too. Given all of the online posts and discussions, it seems like tattoos are affecting enough users for Apple to prioritize improving their experiences.
