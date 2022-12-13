---
layout: standalone
title: Subscribe
description: Subscribe to my blog!
---

<h4 class="mt-4 mb-0">Main feed</h4>

<p class="mb-0">Subscribe to the main feed for all new posts on my blog. This feed <i>does not</i> include updated posts.</p>

- [RSS]({{ site.feeds.rss }})
- [JSON]({{ site.feeds.json }})

<h4 class="mt-4 mb-0">Updates feed</h4>

<p class="mb-0">I periodically <a href="{% link recently-updated.md %}">publish updates</a> to older posts on my blog. Subscribe to the updates feed for updated posts <i>only</i>.</p>

- [RSS (updates-only)]({{ site.feeds.rss-updates-only }})
- [JSON (updates-only)]({{ site.feeds.json-updates-only }})

<h4 class="mt-4 mb-0">Social Media</h4>

<p class="mb-0">Newly published and updated blog posts are automatically tweeted and posted to Mastodon.</p>

- [@jesse_squires]({{ site.data.social.twitter }})
- [@jsq@mastodon.social]({{ site.data.social.mastodon }})
