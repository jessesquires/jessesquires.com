---
layout: post
categories: [software-dev]
tags: [web, bing, duckduckgo, search]
date: 2022-04-17T17:06:31-07:00
date-updated: 2022-04-19T17:48:30-07:00
title: DuckDuckGo removing other sites
---

My website [is still missing from DuckDuckGo's and Bing's]({% post_url 2022-03-25-my-website-disappeared-from-bing-and-duckduckgo %}) search indexes. And now other sites are reporting similar issues.

<!--excerpt-->

Ernesto Van der Sar, [writing for TorrentFreak](https://torrentfreak.com/duckduckgo-removes-pirate-sites-and-youtube-dl-from-its-search-results-220415/):

> Privacy-centered search engine DuckDuckGo has completely removed the search results for many popular pirates sites including The Pirate Bay, 1337x, and Fmovies. Several YouTube ripping services have disappeared, too and even the homepage of the open-source software youtube-mp3 is unfindable.
>
> [...]
>
> **Update April 17:** DuckDuckGo informs us that no domains were removed but they are having some issues and we still have questions. More details are at the bottom of the article.
>
> For example, searching for "site:thepiratebay.org" is supposed to return all results DuckDuckGo has indexed for The Pirate Bay’s main domain name. In this case, there are none.

This is [the exact problem I'm currently facing]({% post_url 2022-03-25-my-website-disappeared-from-bing-and-duckduckgo %}).

> **Update April 17:** DuckDuckGo has responded to our findings and says that no domains were removed, according to their records.
>
> Before publishing the article we searched for YouTube-dl and The Pirate Bay without the "site:" operator the official domains were not showing up at our end. They do now.

According to Gabriel Weinberg, the CEO and Founder, the company is [having issues](https://twitter.com/yegg/status/1515636218691739653) with their "site:" operator:

> Similarly, we are not "purging" YouTube-dl or The Pirate Bay and they both have actually been continuously available in our results if you search for them by name (which most people do). Our site: operator (which hardly anyone uses) is having issues which we are looking into.

However, this doesn't explain the fact that even a search for my name or website without using the site: operator yields no relevant results. For comparison, Google Search is very accurate in this regard. Searching for my name there shows my website, Twitter profile, and GitHub profile --- in that order --- as the top 3 results. And **I know** the results _used to be_ the same on DuckDuckGo.

[TorrentFreak continues](https://torrentfreak.com/duckduckgo-removes-pirate-sites-and-youtube-dl-from-its-search-results-220415/):

> We don’t doubt that DuckDuckGo hasn’t intentionally removed any URLs but there still appear to be strange issues with pirate-related searches.
>
> **Update 2:** A DuckDuckGo spokesperson confirmed to TorrentFreak that the issues are related to Bing data.

Well, that seems [to confirm my suspicion]({% post_url 2022-03-25-my-website-disappeared-from-bing-and-duckduckgo %}) that this was ultimately caused by Bing removing my site (and apparently everything else about me) from its index. And, as [previously mentioned]({% post_url 2022-03-25-my-website-disappeared-from-bing-and-duckduckgo %}) I'm still waiting to hear back from Bing Support. Again, the lack of transparency into search engines in general is infuriating. I wonder, why doesn't DuckDuckGo do more to build its own infrastructure to crawl the web and build its search index without relying solely on third parties?

I [used to be really excited about DuckDuckGo]({% post_url 2018-02-25-replacing-google-with-duckduckgo %}), but I'm quickly becoming less of a fan and losing confidence in their results, which seem to be degrading lately. I've had to switch back to Google Search for many queries in the past few months.

{% include updated_notice.html
date="2022-04-19T17:48:30-07:00"
message="
There's [another update from TorrentFreak](https://torrentfreak.com/duckduckgo-restores-pirate-sites-and-points-to-bing-220419/). All of the pirate sites they were tracking have since been restored to the DuckDuckGo search index:

> At this point, it became clear that the search engine wasn't at all happy with what was happening. They never actively removed any of these sites. Instead, a third-party data provider 'removed' the results for them.
>
> Like many other smaller search engines, DuckDuckGo uses hundreds of data sources, including Bing. After some back and forths, DuckDuckGo's spokesperson informed us that Microsoft's search engine was the culprit.

My site [still does not appear on DuckDuckGo](https://duckduckgo.com/?q=site%3Ajessesquires.com), nor Bing. I'm still waiting to hear back from Bing Support. I wonder how many other sites are affected by this?
" %}
