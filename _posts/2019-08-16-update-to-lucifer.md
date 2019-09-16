---
layout: post
categories: [software-dev]
tags: [apps]
date: 2019-08-16T10:00:00-07:00
title: An update to Lucifer
image:
    file: lucifer-about.png
    alt: Lucifer
    half_width: true
---

I just pushed a small update to Lucifer. You can [download it here](https://www.hexedbits.com/lucifer).

<!--excerpt-->

Notable changes:

- Previously, clicking on the status bar item opened a menu from which *you then* had to toggle Dark Mode. Obviously, this was not ideal. I wanted a single click. As I've written, [the APIs for this are not very intuitive]({{ site.url }}{% post_url 2019-08-15-implementing-right-click-for-nsbutton %}). Now, in this version, a left-click will immediately toggle Dark Mode and a right-click will open the menu.

- I implemented a simple "About" view that you can open from the menu, like a typical Mac app would have. There is also an "easter egg" on this view. Just for fun.

{% include post_image.html %}

I doubt many people are using this and I probably won't update much it again. But this project was not about anything other than me having fun and *doing whatever the fuck I want.* If you are using it, I hope you like it!
