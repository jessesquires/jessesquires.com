---
layout: post
categories: [software-dev]
tags: [rss, automation, social-media]
date: 2022-12-15T10:52:14-08:00
title: Publishing an RSS feed to Mastodon
---

If you follow me on Twitter, you've likely noticed that my blog posts are automatically tweeted for me. There are multiple services you can use to do this, like [Zapier](https://zapier.com) and [IFTTT](https://ifttt.com). I use both services for various automations. Each has built-in actions for listening to an RSS feed and then tweeting new items as they appear. Sadly, neither service has a built-in action for Mastodon. However, we can achieve the same results with a generic webhook action on both platforms.

<!--excerpt-->

The webhook actions require a bit more manual work to set up, unlike the built-in tweet actions. And you'll need to do some configuration on your Mastodon account as well. This post will assume an account on [mastodon.social](https://mastodon.social), but note that other instances may vary slightly.

### Motivation

I've found that some folks prefer social media to be notified of blog posts, rather than subscribe via RSS. It's easy enough for me to automate it, and it allows me to publish content without also having to actually login to Twitter or Mastodon to share it there if I don't want to. I prefer to avoid Twitter more these days, so having the automation configured there is very nice. Even though I'm enjoying Mastodon, I want to implement automatically posting my RSS feed there too.

### Create a Mastodon application

1. Navigate to [Preferences > Development](https://mastodon.social/settings/applications) and create a new application.
1. Give it a name. For example, IFTTT.
1. Provide the URL. For example, <https://ifttt.com>.
1. Uncheck all scopes except for `write:statuses`.
1. Copy your access token at the top.
1. Save.

### Creating a Zap on Zapier to post to Mastodon

For Zapier:

1. Create a new Zap.
1. Add the "RSS by Zapier" action with "New Item in Feed" as the event.
1. Add your feed URL.
1. For the next action, choose "Webhooks by Zapier".
1. Set the event to "POST".
1. Set the URL to `https://mastodon.social/api/v1/statuses?access_token=YOUR_ACCESS_TOKEN`.
1. Payload Type should be "form".
1. For the Data section, enter "status" as the key.
1. For the value, select the feed item title and link. (This is the content to be posted.)
1. Save and activate!

Unfortunately, using webhooks on Zapier is a premium feature and requires a subscription that costs a minimum of $20/month. I have a free account and paying $240/year just to post a few dozen articles to Mastodon sounds ridiculous to me. Generally, I would be happy to pay for a service like this... but not that much. Luckily, using webhooks on IFTTT is free!

### Creating an Applet on IFTTT to post to Mastodon

For IFTTT:

1. Create a new Applet.
1. Add the "New feed item" RSS action.
1. Enter your feed URL.
1. Next, add the "Make a web request" webhooks action.
1. Set the URL to `https://mastodon.social/api/v1/statuses`.
1. Set the Method to "POST".
1. Set the Content Type to `application/x-www-form-URLencoded`.
1. Set Additional Headers to "Authorization: Bearer YOUR_ACCESS_TOKEN"
1. Set the body to "status=\{\{EntryTitle\}\} \{\{EntryUrl\}\}"
1. Save and activate!

### Alternatives

I found another free service, [MastoFeed](https://www.mastofeed.org/) that claims to do this as well. In fact, it is a bespoke web app specifically for posting RSS content to Mastodon. However, **you should not use this!** MastoFeed requests full read/write permissions for _everything_ --- all scopes. However, it only needs the `write:statuses` scope. MastoFeed is overzealous with the permissions it requests and there's no information on the site about who owns or made this. I would avoid it.

For Mastodon, it would also be easy to write your own script using `curl`. I might do this and then just run it manually after I run my script to publish a new post. For my set up, I'd have to first parse my `feed.json` and grab the most recent item, which should be easy. However, I automatically post from multiple feeds and already had an IFTTT account setup, so I did the lazy thing first.
