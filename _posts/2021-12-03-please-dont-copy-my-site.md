---
layout: post
categories: [software-dev]
tags: [web, jekyll, open-source]
date: 2021-12-03T14:08:16-08:00
title: Please don't copy my site. Here's a template!
---

As many of you know, [this site is open source]({{ site.data.github.repo }}). Most of the time, this does not cause any trouble. But occasionally, it does.

<!--excerpt-->

The primary reason for open sourcing my blog is to encourage feedback (by [opening]({{ site.data.github.issue }}) a GitHub issue) and to allow folks to submit corrections if I make a mistake or publish a typo. This has been a great experience overall. Using GitHub issues for [comments and feedback](https://github.com/jessesquires/jessesquires.com/issues?q=label%3A%22blog+comments+%26+questions%22+is%3Aclosed) is much better than trying to implement and maintain a "real" commenting system, in my opinion. And GitHub's pull request workflow makes submitting a correction easy.

The other main reason for making this site open source is to give other folks an opportunity to learn. I recently [wrote about starting your own blog]({% post_url 2021-11-01-how-to-start-a-blog %}) as well. However, this is the part that has caused some headaches.

I have encountered a few incidents over the past few months, where folks have copied my entire site (almost) verbatim, essentially impersonating me. Some are not exact copies and have been customized, but enough of my personal information and website branding has still been reproduced that it's a problem. This is not good! While I appreciate giving people the opportunity to learn from my site, copying it in its entirely is not really what I had in mind.

However, most of the time, this copying is not done with malicious intent &mdash; I realize that. And if that's what you've done accidentally &mdash; that's ok! We can fix it. If I discover a fork or direct copy, usually I can open an issue or submit a pull request to help the other person resolve the issue. It's not ideal, because it consumes some of my time, but ultimately I'm happy to have the issues resolved and the other person is happy to have a working website.

### How to use my open source website, _The Right Way&trade;_

What you **do not** want to do is fork or copy my site, because this approach is _very_ prone to error. There are _many_ personal files to delete and configurations to change &mdash; like my PGP public key and CV information. Perhaps the most significant issue is forgetting to remove my analytics code, and then you'll be spamming my server with imposter data.

Instead, **[please use this template](https://github.com/jessesquires/template-jekyll-site)** repo on GitHub, which you can easily fork and begin customizing. It's a fully working Jekyll site based on this one. It's configured almost exactly the same, and is fully ready to go. You can use my website **as a reference** if there's something specific you would like to implement that is not available in the template.
