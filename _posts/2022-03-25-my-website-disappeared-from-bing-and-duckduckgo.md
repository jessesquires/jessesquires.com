---
layout: post
categories: [software-dev]
tags: [web, bing, duckduckgo, search, google]
date: 2022-03-25T21:45:53-07:00
date-updated: 2022-07-28T12:36:54-07:00
title: My website disappeared from Bing and DuckDuckGo
---

I discovered earlier this week that my website is no longer being indexed by [Bing](https://www.bing.com/search?q=url%3ahttps%3a%2f%2fwww.jessesquires.com) and [DuckDuckGo](https://duckduckgo.com/?q=site%3Ahttps%3A%2F%2Fwww.jessesquires.com). In fact, it appears that it has been deliberately removed from their search indexes. On Bing, rather than display a *"no results"* message, it displays a *"Some results have been removed"* message, which is very concerning. Notably, however, [Google search](https://www.google.com/search?q=site%3Awww.jessesquires.com) is working fine.

<!--excerpt-->

I triple-checked all of my server and website configurations and settings &mdash; DNS records, `robots.txt`, occurrences of the [`noindex` meta tag](https://developers.google.com/search/docs/advanced/crawling/block-indexing) (there are none), etc. Everything looks fine. No issues. No errors. And again, [Google search](https://www.google.com/search?q=site%3Awww.jessesquires.com) seems to be working great, which indicates that there are no problems on my end.

{% include break.html %}

My website does not appear in any searches on Bing and DuckDuckGo, nor does a search for my name produce any relevant results. For contrast, my website is the first hit on Google when you search for my name. I'm not the kind of person who regularly searches my own name, but I discovered the issue when attempting to find one of my old blog posts. The [search page]({% link search.md %}) on my site [is implemented]({% post_url 2018-02-25-replacing-google-with-duckduckgo %}) using a basic HTML form that is hooked up to DuckDuckGo's [site-specific search](https://help.duckduckgo.com/duckduckgo-help-pages/results/syntax/) functionality. Much to my surprise, when I tried to [search my site]({% link search.md %}) for a blog post there were _zero results_.

Normally, when [searching]({% link search.md %}) from my site you will be redirected to DuckDuckGo with the search automatically populated with `<your search terms> site:jessesquires.com`, and you will be able to see all pages on my site containing your search query. I know for certain that this was working at some point in the past.

You can also use the `site:` operator to verify that your site is indexed. For example, `site:jessesquires.com`. You can see that this currently [produces zero results](https://duckduckgo.com/?q=site%3Ahttps%3A%2F%2Fwww.jessesquires.com), indicating the site is not indexed at all. To see a working example, we can check Michael Tsai's blog [using `site:mjtsai.com`](https://duckduckgo.com/?q=site%3Ahttps%3A%2F%2Fmjtsai.com). So, aside from the primary issue of no longer being indexed, this means search on my site is also broken.

Similar to DuckDuckGo's `site:` operator, Bing provides a `url:` operator which indicates whether or not your site is indexed. Again, we can try Michael's blog [using `url:mjtsai.com`](https://www.bing.com/search?q=url%3Amjtsai.com), which produces the expected results. If you search for [nonsense like `url:thisIsNotARealWebsite.com`](https://www.bing.com/search?q=url%3AthisIsNotARealWebsite.com), you'll see a *"There are no results for..."* message. However, when you [search for my website](https://www.bing.com/search?q=url%3Ajessesquires.com), you see a *"Some results have been removed"* message that links to [this support page](https://support.microsoft.com/en-us/topic/how-bing-delivers-search-results-d18fc815-ac37-4723-bc67-9229ce3eb6a3) about how Bing results are delivered and why results might be removed. I don't know, but that seems _pretty bad_, right? Like, _my site was **removed?!**_

{% include break.html %}

You might be wondering what the hell does Bing have to do with any of this? (Also, do people actually use Bing?) Unlike other major search engines, DuckDuckGo [does not provide](https://okeyravi.com/duckduckgo-search-engine-submission/) any kind of webmaster tools, like [Google Search Console](https://search.google.com/search-console/about) and [Bing Webmaster](https://www.bing.com/webmasters/about). Thus, you [cannot can submit URLs](https://www.quora.com/How-do-I-submit-my-URL-to-DuckDuckGo?share=1) and sitemaps directly to DuckDuckGo, nor can you request indexing of pages. Instead, DuckDuckGo gets results [from various other sources](https://help.duckduckgo.com/results/sources/), including Bing and specifically **not** from Google. According to various online forums, the best way to ensure your site gets indexed by DuckDuckGo is to submit it to Bing and Yandex.

Thus, my current theory is that because my site was (seemingly) removed from Bing, it was therefore subsequently removed from DuckDuckGo. So now the question to answer is why was my website removed from Bing?

I had a Bing Webmaster account at some point, which I used to submit my site. I remember testing it and seeing results on Bing, as well as DuckDuckGo, but this was years ago. However, I don't know what happened to my account. I might have deleted it, but I don't remember. Or, maybe Microsoft deleted it after a certain period of time with no activity. I basically never logged in to it after submitting my site. If my defunct Bing Webmaster account was in fact deleted, perhaps that resulted in my website being removed from the search index? Otherwise, this appears like a deliberate removal for some kind of violation of Bing's terms? I have no idea.

{% include break.html %}

So without a working Bing Webmaster account, I decided to create a new one. This time I logged in using my Google account. Bing Webmaster allows you to login with Google and will conveniently import all of your sites from Google Search Console. This had the effect of basically reinstating my old account, with my sites ready to go. I resubmitted my sitemaps, did a site scan, looked at the SEO reports, and checked on the search performance results in Bing Webmaster. Everything seemed ok.

My traffic on Bing is rather low compared to Google. In the last month, Bing reports only a handful of clicks and impressions while Google reports over 10,000 clicks and over 368,000 impressions. I assume that's because of popularity and preference amongst most software developers? I'm not sure. Anyway, all the crawl results look fine, seemingly indicating no problems with the site or Bing's ability to index it. In fact, Bing reports that it has successfully indexed hundreds of pages on my site. The crawl information also dates back to 2017 --- so I'm not crazy, this was working before. Furthermore, all results and metrics on Google Search Console look good and indicate there are no problems.

But then, I noticed on Bing Webmaster that all search metrics dropped to zero starting March 11. Unfortunately, the Webmaster tools don't provide any additional information or insight into why this happened. Again, the theory is that my website was deliberately removed from Bing. I also checked the "Copyright Removal Notices" page in Webmaster, which is where you can see _"URLs have been flagged and are liable to be removed from Bing search results"_, and there are **zero** notices listed.

{% include break.html %}

This is quite the predicament. Seemingly, everything is fine. Yet, for some reason my website has been delisted from Bing. I'm perplexed. But to be honest, I'm not that concerned about Bing --- I really just want my site indexed by DuckDuckGo again.

Out of desperation to get my site back on DuckDuckGo, I debased myself and created a Yandex Search Webmaster account too. I submitted my sitemaps there, requested indexing, etc. Everything on Yandex looks good, and a `site:` search already [produces results](https://yandex.com/search/?text=site%3Ajessesquires.com). I'm hoping the indexing data from Yandex will make it over to DuckDuckGo eventually.

In the meantime, I've submitted a support request with Bing Webmaster to inquire about the apparent removal of my site. When I hear back, I will update this post. Otherwise, all I can do is wait and periodically check if results start to appear again.

If you have any advice, please let me know!

{% include break.html %}

There's one last thing. The issue described above was also happening with another one of my websites, [hexedbits.com](https://www.hexedbits.com). Google search was working, but not Bing and DuckDuckGo. However, Bing showed a standard _"no results"_ message for HexedBits. Since submitting the URL and sitemap to Bing and Yandex, content from hexedbits.com is now appearing correctly on Bing, DuckDuckGo, and Yandex. This really has me wondering what could have gone wrong. Hopefully, the indexing issues for jessesquires.com will be resolved soon.

{% include break.html %}

All of this emphasizes the frustrating lack of transparency around search engines and how they work. It is infuriating to be essentially helpless trying to debug and resolve issues with your site not being properly indexed. I will forever lament that search was not a core component of the Internet itself, but was instead a feature that private corporations had to bolt on top.

{% include updated_notice.html
date="2022-04-01T17:19:24-07:00"
message="Good news! Well, sort of. I heard back from Bing Support. They confirmed that they received my report and have \"escalated this request to the engineering team.\" _[Editor's note: not April fools.]_

Also of note, [Delisa pointed out](https://mobile.twitter.com/kattrali/status/1507666040561582086) that this might be related to the [algorithmic changes that DuckDuckGo has been making lately](https://mjtsai.com/blog/2022/03/14/duckduckgo-will-down-rank-russian-disinformation-sites/) and noted that queries for dev topics have been noticeably missing things over the past few weeks.

In addition to algorithmic changes, DuckDuckGo has also [\"paused\" its relationship with Yandex](https://www.protocol.com/bulletins/duckduckgo-yandex-ukraine).
" %}

{% include updated_notice.html
date="2022-04-20T15:14:46-07:00"
message="
Reader [Nicolas Magand](https://github.com/nicolastjt) left [a comment](https://github.com/jessesquires/jessesquires.com/issues/163) that they are also having the same problem, and shared [this blog post](https://www.linkedin.com/pulse/bing-exploit-allows-website-owners-deindex-chase-watts/), _Bing Exploit Allows Website Owners to Deindex Competitors_. The gist of the article is that Bing has an inferior search algorithm that is subject to negative SEO campaigns from malicious actors, a problem that Google _does not_ have. The general issue of having your website de-indexed from Bing seems to be much more common than I expected.

To reiterate, I really don't give a shit about Bing, per se --- I just want my site indexed by DuckDuckGo again. But, as noted above, it seems the best (only?) way to do that is through Bing. I sent a follow-up email to Bing Support today to check on the status of my support request.
" %}

{% capture notice_content %}
This post is still being circulated and showing up in Google search for folks, so I want to highlight [my recent follow-up post here]({% post_url 2022-07-25-my-website-disappeared-from-bing-and-duckduckgo-part-2 %}).

Also, another reader experiencing this issue emailed me after finding this post via Google. They also [published a blog post here](https://io.bikegremlin.com/28530/microsoft-bing-serp-gone-overnight/) detailing their experience.
{% endcapture %}

{% include updated_notice.html
date="2022-07-28T12:36:54-07:00"
message=notice_content
%}
