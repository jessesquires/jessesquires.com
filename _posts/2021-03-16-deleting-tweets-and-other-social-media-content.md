---
layout: post
categories: [essays]
tags: [social-media]
date: 2021-03-16T22:09:31-07:00
title: Deleting tweets and other social media content
image:
    file: twitter-delete-likes.png
    alt: "Twitter Likes"
    caption: "My 45 phantom 'likes' that cannot be removed."
    source_link: null
    half_width: false
---

I have been periodically deleting my tweets for a while now. Yesterday, I finally found a reliable solution for deleting my Twitter "likes" as well and I spent some time deleting all of them. Long ago, I also deleted all of my content on Facebook and Instagram. If you are interested in purging your social media accounts, here are some options. 

<!--excerpt-->

There are two main reasons that I am interested in deleting all of my content from social media.

1. To reduce and discourage my general usage of these manipulative platforms, making them less addictive.
2. To assert control over my data and the methods with which I interact with these platforms. I want to use them **how I want** &mdash; in ways that are beneficial for me &mdash; rather than **how the corporations want to coerce me into using them** for their financial gain.

I will elaborate on these points more below.

### Deleting your tweets

You could [apply for access](https://developer.twitter.com/en/apply-for-access) to the [Twitter developer API](https://developer.twitter.com/), read the docs, create a Twitter app, and then write a client to do this yourself. Originally I started down this path, but I realized I am too lazy of a developer. I do not have the time to waste or the patience, especially when I know someone else has already built a tool for this.

I can recommend [TweetDelete](https://tweetdelete.net), which has worked for me. There are free and paid options depending on how many tweets/likes you want to delete, and how old they are. There are **a ton** of these kinds of tools out there. Most of them are overpriced and seem largely like marketing bullshit. This one seemed the most reasonable to me. It is only $15 for the "premium" version, which gives you access to delete everything. The time I saved was worth much more than that $15. You can schedule it to regularly delete all Tweets older than a certain number of days, etc.

### Deleting your Twitter likes

Oddly, there seems to be a limitation in Twitter's [API for deleting likes](https://tweetdelete.net/faq/#delete-likes), which I have seen mentioned in multiple places on the web. Apparently you can only remove the most recent 3,200 (according to TweetDelete). And then there is this "phantom likes" issue, where no likes will appear for your account, but the total number of likes will be non-zero. This appears to be caused by the company's [change from "favorites" to "likes"](https://www.theverge.com/2015/11/3/9661180/twitter-vine-favorite-fav-likes-hearts) back in 2015. Or, it might simply be broken. Either way, I am sure no one employed at Twitter actually understands how it works entirely. 

**Update:** It appears that the "phantom likes" could be tweets I can no longer read because the accounts went private or blocked me. [Thanks Jeff](https://mobile.twitter.com/lapcatsoftware/status/1372134069933383687)!

To workaround the limitation in TweetDelete and delete **all** of your likes, you will need to find another way. Luckily, I found [this gist on GitHub](https://gist.github.com/aymericbeaumet/d1d6799a1b765c3c8bc0b675b1a1547d) from [Aymeric Beaumet](https://github.com/aymericbeaumet) that works. It is a small JavaScript snippet that you can execute in the console of your browser. Even if you are not familiar with JavaScript, it is rather easy to understand.

```javascript
setInterval(() => {
    for (const d of document.querySelectorAll('div[data-testid="unlike"]')) {
        d.click()
    }
    window.scrollTo(0, document.body.scrollHeight)
}, 1000)
```

I had multiple thousands of likes to delete, so I had to run this a few times. It seems like Twitter's API gets overwhelmed when doing this. Maybe there are too many requests? I saw a lot of 404 errors in the console.

Eventually, I got down to 152 total likes and could not remove the rest. After waiting a bit, I was able to delete more with only 23 remaining. 
Today, my account shows 45 total likes, although trying to view them on my profile now displays "You don't have any likes yet". I suppose these 45 phantom likes will have to wade in the ether of the Internet forever.

{% include post_image.html %}

### Deleting Facebook and Instagram content

If you want to do the same for Facebook, you are now able [to bulk delete posts](https://www.lifewire.com/how-to-mass-delete-facebook-posts-4767192), but it is still a somewhat manual and tedious process. I do not know of a way to automate it, like how TweetDelete works. Of course, this is intentionally difficult (and it used to be worse) because deleting your content is contrary to Facebook's interests. If you search for automated solutions, you will only find [posts about outdated Chrome extensions](https://social.techjunkie.com/delete-all-facebook-posts/) that no longer work. 

For Instagram, you are sadly out of luck. I do not know of a reliable and trustworthy way to automate deleting your posts there. A quick search reveals some sketchy looking (and pricey) third-party apps. I would avoid those. You will have to do it manually.

As far as I know, there are no reliable and trustworthy third-party tools for deleting content on Facebook's platforms because they remain closed, and their frequent changes will swiftly break any tools that used to work.

{% include break.html %}

Many years ago when I decided to stop using Facebook, there was no bulk delete feature and the only option was "deactivation" which allowed you to return to your "paused" account at any time. Over multiple months, I painstakingly removed all content I had there &mdash; I deleted posts, deleted photos, un-followed pages, un-liked everything, and more. It took a long time, but it was worth it. I wanted to completely eradicate any reason I would ever want to return. I enabled the most strict privacy settings, disabled photo tagging, etc. 

An entirely vacant account was the only way to ensure that I would not return. And, by disabling as many features as possible (like photo tagging), I could no longer be bothered by notifications. Now, of course, it is possible to delete your account, but only after navigating a labyrinth of intentionally obscure, user-hostile settings and manipulative warnings about how you will miss out on every update from your friends. Notably absent are messages about missing out on disinformation, conspiracy theories, and the destruction of western democracy.

Ironically, later on I ended up taking a job at Instagram (long after it was acquired). At the time, Instagram still had its own personality and was largely siloed away from Facebook, unlike today where they are merely windows into the same underlying platform. At the time, I could see the oncoming "Facebookification" of Instagram that I suspected would ruin the platform. (Have you seen Instagram lately? I think that prediction was correct.) So, before I quit, I wrote a script to remove all my posts. Lucky me, I guess.

### But why though?

Let's return to my motivations for doing this. Why go through all this trouble to delete content on social media? And perhaps more importantly, why not delete the accounts entirely?

Regardless of whether or not I choose to continue using these platforms in the future, I prefer to retain the accounts for historical reasons and leave them vacant &mdash; at least for now. This is similar to what I did [when I got off of LinkedIn]({% post_url_absolute 2019-08-13-linked-out %}). This preserves (at least the shell of) my online "identity" and prevents someone else from taking the usernames that I used for so many years. I would rather someone find my old, vacant accounts with a message to contact me by other means, instead of finding some Internet rando and wondering what happened &mdash; or worse, mistaking that other person for me.

The other reason I am hesitant to entirely delete accounts is because **what if** something happens in the future and I do need to login for some reason? I hate to admit it, but that FOMO is real. Currently, my LinkedIn and Facebook accounts are entirely vacant and I cannot remember the last time I used them. As time goes on, my concerns about _maybe_ needing these accounts has diminished significantly. 

Eventually, I think I will be able to delete them for good without confronting any FOMO stress. For now, having essentially destroyed the accounts by removing all content, I can prevent myself from regressing into the addictive consumption and manipulative content production behaviors that they facilitate.

{% include break.html %}

The only accounts I use regularly are Twitter and Instagram, though I use them increasingly less. As it turns out, the less you use them, the less you want to use them. And at least for me, the less content I have in total, the less I feel obligated to post at all. Perhaps a more accurate description is that I am giving the algorithms fewer and fewer opportunities to manipulate me into using the platforms more.

Twitter remains valuable to me for now. I use it almost entirely for interacting with the developer community. In my experience, it is a great way to help others or get help from others &mdash; diagnosing bugs, sharing development tips, etc. However, I do not need a private company to maintain a public record of everything I have ever typed into its shitty website. I would rather my tweets be ephemeral. And no, I do not want useless "fleets" that manufacture urgency and exploit users' psychological weaknesses into checking their feeds more frequently. I just want to periodically delete my tweets after they are a month or two old. I am glad that Twitter makes this easy, rather than waging war on its users like Facebook.

Instagram is similar for me, though I interact with different communities there that have nothing to do with software development or programming. 

As I mentioned, deleting content helps me control how I use these platforms, rather than allow the platforms to control me. My tweets are deleted periodically via TweetDelete. On Instagram, after deleting everything years ago, I now keep a small handful of posts &mdash; 9 to be exact. When I post something new, I delete the oldest one. If ever decide to leave the account vacant, it will be quick and easy to do. This is how I use these accounts in ways that keep me in control.

{% include break.html %}

Overall, I am no longer interested in willfully allowing private corporations to monetize my entire history of interactions and thoughts. I do not wish to willingly be a device for capitalist profit extraction, nor do I enjoy being subjected to the surveillance of parasitic advertising networks. I realize that by continuing to use these platforms, even in very limited ways, I cannot avoid these things entirely. But, this approach feels much better to me.

Avoiding social media is also a way to encourage myself to write here on my blog instead, which I own and control, which requires more thoughtful consideration, and which is a much more rewarding way to publish new content.
