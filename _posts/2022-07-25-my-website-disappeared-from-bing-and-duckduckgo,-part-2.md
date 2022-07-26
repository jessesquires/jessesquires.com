---
layout: post
categories: [software-dev]
tags: [web, bing, duckduckgo, search, google]
date: 2022-07-25T17:59:27-07:00
title: My website disappeared from Bing and DuckDuckGo, Part 2
---

This is a follow-up to [my previous post]({% post_url 2022-03-25-my-website-disappeared-from-bing-and-duckduckgo %}) regarding my website getting de-indexed by Bing, and thus DuckDuckGo. (Sorry for the delay, I've [been away]({% post_url 2022-07-25-disconnected %}).) It turns out that [a number of sites]({% post_url 2022-04-17-duckduckgo-removing-other-sites %}) were experiencing this issue, including my friend [Jeff Johnson](https://lapcatsoftware.com/articles/bing.html). While I do not have concrete data on how widespread the issue was, anecdotally it appears to have been a significant problem.

<!--excerpt-->

Michael Tsai, as always, has [a great round up](https://mjtsai.com/blog/2022/06/20/removed-from-bing-and-duckduckgo/) of the problem and comments from others who were experiencing the issue, and [multiple readers](https://github.com/jessesquires/jessesquires.com/issues/163) left [comments](https://github.com/jessesquires/jessesquires.com/issues/165) on my blog as well. I originally discovered and [wrote about]({% post_url 2022-03-25-my-website-disappeared-from-bing-and-duckduckgo %}) the issue in late March. Jeff published [his post](https://lapcatsoftware.com/articles/bing.html) a few months later in June. I also received a number of emails and tweets from readers facing the same problem. It really felt like _everyone_ was having this problem. Yet, no one --- including DuckDuckGo's own CEO --- seemed to know what the fuck was going on.

I submitted a Bing support request on March 25 and finally received a reply on May 23, nearly two months later:

> Thank you for your patience during our investigation. After further review, it appears that your site (https://www.jessesquires.com) had issues with meeting the standards set by Bing to remain indexed the last time it was crawled. To ensure that this was not a false flag, I also escalated the issue to the next level, and they manually reviewed your site and confirmed that it is in violation of our webmaster guidelines detailed here: [Bing Webmaster Guidelines](https://www.bing.com/webmasters/help/webmasters-guidelines-30fba23a).
>
> We are not able to provide specifics for these types of issues because the relevant teams do not share reports with us. We recommend that you review our [Webmaster Guidelines](https://www.bing.com/webmasters/help/webmasters-guidelines-30fba23a), especially the section [Things to Avoid](https://www.bing.com/webmasters/help/webmasters-guidelines-30fba23a#avoid), and thoroughly check your site for any deliberately or accidentally employed SEO techniques that may have adversely affected your standing in Bing and Bing-powered search results. We will not be able to add your site to the index while Bingbot is finding it in violation of [Webmaster Guidelines](https://www.bing.com/webmasters/help/webmasters-guidelines-30fba23a). We have no control over this process, and you will need to make quality changes to your site and wait for the Bingbot's automated crawling process to agree that the site passes the webmaster standards before it can be served.
>
> Also, I spent some more time reviewing your site and found a few links and docs which will help you in this scenario.
> - [Why is My Site Not in the Index?](https://www.bing.com/webmasters/help/why-is-my-site-not-in-the-index-2141dfab)
> - [10 SEO Myths Reviewed](https://blogs.bing.com/webmaster/2014/05/09/10-seo-myths-reviewed)
> - [Is SEO The Future? No, And Here’s Why](https://blogs.bing.com/webmaster/2014/04/24/is-seo-the-future-no-and-heres-why)
> - [Building Authority & Setting Expectations](https://blogs.bing.com/webmaster/2014/10/17/building-authority-setting-expectations)
> - [The Role of Content Quality in Bing Ranking](https://blogs.bing.com/search-quality-insights/2014/12/08/the-role-of-content-quality-in-bing-ranking/)
>
> I hope the resolution provided was able to fully address your issue. I will be closing this ticket. However, if you do have any follow up questions or concerns please feel free to contact me or open a new support ticket.

Very cool. They confirmed my site committed so-called violations, but refused to tell me what. So I need to read a 5,000-word document about your "guidelines" and guess what the fuck I'm violating? At least Apple will tell you the specific rule that you are supposedly violating when they reject your app for a bug fix update, even if they just made it up or reinterpreted it to specifically fuck you over. But this response from Bing is like be summoned to court for committing so-called crimes, only to find out that in addition to defending yourself you must also guess what you've done wrong in order to proceed. The line about _"We have no control over this process..."_ is beyond perplexing. Didn't your million-dollar company pay some people to write this bot? How do you "have no control over this process"? What a bureaucratic clusterfuck. Did everyone at Bing graduate from clown school?

So of course, I read exactly **none** of those guides and made **zero** modifications to my website --- not just because [I was too busy _not_ using the internet for two months]({% post_url 2022-07-25-disconnected %}). I have not fundamentally changed the structure, functionality, or SEO techniques on this website for years. At this point, my Jekyll templates and git-based deployment workflow are locked-in. Publishing new posts on this site is a well-oiled machine. All I do is write markdown. It has been years since I updated my templates with significant SEO-related changes. Furthermore, Google and Yandex have zero issues with my website. They report no crawling errors. There are no HTML validation errors. And based on my Google search rankings, my site is very high quality and very relevant.

Fast forward almost exactly one month after Bing Support's response. Ostensibly and miraculously my site is no longer violating Bing's guidelines. I guess Bingbot changed its fucking mind. Woohoo. My site is now being indexed again by both Bing and DuckDuckGo. Jeff Johnson [tweeted](https://twitter.com/lapcatsoftware/status/1539451135341338626) on June 21, about a week after his post, to celebrate that both his site and mine had been restored. After checking today, that seems to be true. Bing webmaster tools also confirms that my site is receiving _some_ traffic. However, results on DuckDuckGo still seem incomplete compared to what they used to be, especially compared to Google. Oh, well.

To recap: I did nothing, Bing de-indexed my website, Bing said I violated its guidelines, I continued to do nothing, Bing restored my website, and now everything seems (mostly) fine. I can finally sleep at night knowing that a mediocre search engine decided my website is worthy of being served. Meanwhile, DuckDuckGo's main product is being held hostage by obtuse third-party data providers because it can't be bothered to build and maintain its own search index or webmaster tools.

 Of course, no explanation was provided by Bing or DuckDuckGo regarding how or why this happened (seemingly) to [_so many_ websites]({% post_url 2022-04-17-duckduckgo-removing-other-sites %}). If you were hoping for steps to resolve this issue for your own website, I'm sorry. My best advice is to do nothing.
