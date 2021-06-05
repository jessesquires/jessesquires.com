---
layout: post
categories: [software-dev]
tags: [jekyll, web, website-infra]
date: 2020-04-15T11:40:58-07:00
title: Updating permalinks and adding redirects for Jekyll sites
---

A fews days ago I changed the [permalink structure](https://jekyllrb.com/docs/permalinks/#front-matter) on my site. I think everything went smoothly, because it looks like no one noticed, which is exactly what you want to happen with a potentially breaking change like that.

<!--excerpt-->

**UPDATE:** As [Jeff](https://lapcatsoftware.com/) kindly pointed out ([tweet](https://twitter.com/lapcatsoftware/status/1250513028912746496)), this change did affect my RSS feed. All entry GUIDs were changed (because they are set to the URLs), so your feed reader may have marked all my posts as new. 😅 I do not have a good solution for that, so... 🤷‍♂️ You win some, you lose some. Sorry about that! 😄 In modern readers you should be able to mark them all as read.

This is actually the second time I've done this, but hopefully it will be the last. When I first started this blog, my permalinks were simply `/:title/`. More recently, my blog post permalinks were `/blog/:title/`, which produced urls like `jessesquires.com/blog/this-is-my-post-title`. I [updated](https://github.com/jessesquires/jessesquires.com/commit/4493751dd0172b90221dd7d264aa055ddad1c8f3) them to be `/blog/:year/:month/:day/:title/` instead, which produces URLs like `jessesquires.com/blog/2020/01/01/this-is-my-post-title`. I much prefer this format. I think having the year in the URL is more organized and adds additional clarification to when a post was published, which is important. I have always displayed the date for posts, but I like reinforcing it further. It is a **huge** pet peeve of mine when blogs do not date their articles clearly.

The obvious issue with changing permalinks is that you will **break all of your old links**. That, in my opinion, is a cardinal sin on the web. Do not let [404s](https://en.wikipedia.org/wiki/HTTP_404) happen if you can prevent it. Nothing is worse that clicking a link only to find an error page. So how can you accomplish this with a static site generator like [Jekyll](https://jekyllrb.com)?

One option is to use the [jekyll-redirect-from plugin](https://github.com/jekyll/jekyll-redirect-from), but this is not a very clean or elegant solution. You have to update the [front matter](https://jekyllrb.com/docs/step-by-step/03-front-matter/) for every post, which is tedious. The plugin then generates a bunch of empty HTML pages with client-side redirects using [`meta` tag](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/meta) refreshes.  Gross. The output in `_site/` is awful.

You can do much better by implementing this at the server level instead in your [.htaccess file](https://en.wikipedia.org/wiki/.htaccess), by adding [301 Permanently Moved redirects](https://en.wikipedia.org/wiki/HTTP_301).

```
Redirect 301 /blog/my-post-title /blog/2020/01/01/my-post-title
```

It would be tedious to implement this manually. But Jekyll makes it easy to write a script to generate all these redirects. [Posts must have their date in the title](https://jekyllrb.com/docs/posts/#creating-posts), using a naming convention like `2020-01-01-my-post-title.md`, so you have all the information you need to map that from `/blog/my-post-title/` to `/blog/2020/01/01/my-post-title/`. It took me just a few minutes to write [a Swift script](https://github.com/jessesquires/jessesquires.com/blob/master/scripts/process_posts.playground/Contents.swift#L11-L31) in a Playground.

I like this solution because it keeps your generated site in a clean and organized state, it tucks away all the redirect messiness in your `.htaccess`, and it is a better user experience since client-side redirects can be flaky or slow.
