---
layout: post
categories: [essays]
tags: [social-media]
date: 2023-02-06T09:44:56-08:00
date-updated: 2023-04-03T20:06:16-07:00
title: Goodbye, Twitter
---

When I [wrote about joining Mastodon]({% post_url 2022-12-14-mastodon %}), I said I would stay on Twitter for the moment and see what happens. Well, unsurprisingly, the service has continued to erode. It really is a shame, because I've found the software developer community there very helpful over the years. I met a lot of friends on Twitter, and later met them for the very first time in person at WWDC.

<!--excerpt-->

I've been less active on Twitter for over a year, prior to the flippant billionaire crybaby takeover. Since then, I've been _even less_ active on the site. I tried, briefly, to continue posting to both Twitter and Mastodon, but I simply don't have time for that --- especially as Twitter seems to be [quickly deteriorating](https://mjtsai.com/blog/2023/01/26/missing-tweets/) and [increasingly unreliable](https://daringfireball.net/linked/2023/01/23/twitter-frum-crumbling). Am I seeing content I care about? Are my own tweets even being seen? Meanwhile, Mastodon continues to improve --- and by improve, I mean more of my friends and connections are joining. Mastodon, as ever, is also free of ads, corporate surveillance, and manipulative algorithmic bullshit. So really, what choice did I have? I naturally gravitated away from Twitter and toward Mastodon.

{% include break.html %}

Anyway, a [recent announcement](https://twitter.com/TwitterDev/status/1621026986784337922) from the Twitter Dev account is why I'm writing today. Apparently, they plan to revoke free access to the Twitter API on February 9, in just a few days. (See also: [Michael Tsai](https://mjtsai.com/blog/2023/02/02/twitter-to-charge-for-api/) and [Daring Fireball](https://daringfireball.net/linked/2023/02/02/twitter-apis).) As I've [written before]({% post_url 2022-12-15-rss-to-mastodon %}), I use [Zapier](https://zapier.com) to automatically tweet blog posts (and [IFTTT](https://ifttt.com) for Mastodon). I also use [TweetDelete](https://tweetdelete.net) to periodically delete old tweets.

It remains to be seen, but the expectation is that these services will stop working after Twitter makes this change. I suppose these companies could pay for Twitter API access to keep their own services running. If that happens, I expect the cost to be forwarded to users. Depending on how much they charge, I might do it --- but given the progressively dismal state of Twitter, it's hard to see how any fee would be worth it. Why automatically tweet blog posts when folks won't even see the tweets? Why continue to invest in a platform that is clearly crumbling, especially when there is an exciting and growing alternative?

And it gets worse. Twitter has blocked API access for a popular tool, [Movetodon](https://www.movetodon.org/twitterlogin/), which facilitates migrating from Twitter to Mastodon. You can follow [this thread on Mastodon](https://mastodon.social/@Tibor/109800904950500383) for updates from the author, Tibor Martini. Sadly, I doubt it will start working again. How petty and childish can Twitter get? I do not have time for this kind of weak-ass bullshit.

What will transpire after February 9 is unclear at the moment, so I'm operating as if these things will simply stop working, or be too expensive for me to justify paying for them. I sure as hell will not be paying Twitter directly for API access. Had this API change happened prior to Twitter embarking on its journey into self-inflicted ruin, I would have gladly paid for these tools that save me so much time. But now? I gaze over at the state of affairs at this company and I think, _you want me to pay... **for this**?_ Nah, I'll pass.

{% include break.html %}

Because of the announcement, I've run TweetDelete to delete all my content on Twitter and I won't be participating there until we see what happens on February 9. If the automation services to tweet my blog posts continue to work, I will leave them intact. However, I won't be active there much, if at all, going forward. Also, I will not be deleting my account. I'll keep it for historical reasons --- or just to auto-tweet blog posts, if that remains an option.

I know deleting tweets is controversial. Many folks are interested in preserving content and preventing broken links, or saving links to tweets for reference later. My position is that social media is inherently ephemeral and should not persist indefinitely. That's [how I use it]({% post_url 2021-03-16-deleting-tweets-and-other-social-media-content %}). Like in real life, I don't record and keep transcripts of every conversation or thought that I have. If something is important, it should exist permanently outside of the guarded corporate walls of social media companies, because they could make any content inaccessible on a whim.

{% include break.html %}

If you primarily see my blog posts through Twitter, you can instead [subscribe via RSS]({% link subscribe.md %}) and follow me at [@jsq@mastodon.social]({{ site.data.social.mastodon }}).

And if you want to join the party, you can use [this invite link](https://mastodon.social/invite/Bw4iPeR9) for Mastodon.social. As of this writing, it looks like [Fedifinder](https://fedifinder.glitch.me), a similar tool to Movetodon, is still working. I would recommend using it while you can. It involves a more manual process than Movetodon, but it is better than nothing.

{% include updated_notice.html
date="2023-02-14T10:11:50-08:00"
message="
It looks like Twitter's [attempted API changes](https://www.cnbc.com/2023/02/08/twitter-daily-limit-error-prevents-users-from-posting.html) did not [turn out well](https://arstechnica.com/tech-policy/2023/02/twitter-experiencing-international-outages-most-users-cant-tweet-or-dm/). It is truly comical how disorganized and chaotic the company seems to be. On February 8, I received an email from Zapier Support stating they anticipate that any Zap using the Twitter integration will stop working. Then on February 10, Zapier Support sent a second email confirming that Zaps will continue to work:

> Our team has been working to ensure your Zaps continue working regardless of Twitter's unexpected API changes. We're happy to announce that we've found a solution to keep your Twitter Zaps running for the time being. No action is required from you at this time.

It's unclear if Twitter conceded or came to an agreement with Zapier (and, presumably other services like IFTTT). Or, perhaps Zapier is using an unsanctioned workaround, like extracting the API keys from the Twitter mobile apps. (lolz)

Anyway --- for now, that's good news! This means my blog posts should continue to be tweeted automatically. I still have no plans to engage with the service beyond this.
" %}

{% include updated_notice.html
date="2023-04-03T20:06:16-07:00"
message="
You may have noticed that my new blog posts and updated posts are still being tweeted automatically. A few readers have mistaken this automation as me returning to Twitter, so I want to be clear: **I am not returning to Twitter**. I have no plans to continue to use the service beyond the automation I have configured with Zapier, which is why I'm writing this update today.

Twitter has officially [announced](https://twittercommunity.com/t/announcing-new-access-tiers-for-the-twitter-api/188728) their new API changes. See also: Michael Tsai's [roundup](https://mjtsai.com/blog/2023/04/03/new-twitter-api-tiers/). It is unclear if my automation via Zapier will break at the end of the month, or if they will start charging me for Twitter integration. Either way, I don't plan on fixing it nor paying for it.

Let's hope it keeps working. Otherwise, you know where else to find me.
" %}
