---
layout: post
categories: [software-dev]
tags: [web, bootstrap]
date: 2018-04-16T10:00:00-07:00
title: Upgrading to Bootstrap 4
subtitle: And some minor design tweaks
---

I just updated my blog to use [Bootstrap 4.1](https://blog.getbootstrap.com/2018/04/09/bootstrap-4-1/) from v3.3.7. Its a major version with lots of breaking changes, so it took me a few hours over a few Saturday afternoons to get everything fixed up. That's also partially why I missed posting something last month.

<!--excerpt-->

I’m not a web developer, which is probably why it took me so long to update this. I can only write CSS and HTML for so many hours before I'm ready to move on to something else. It's fun, but in small quantities. That's also why I use [Jekyll](https://jekyllrb.com). Most of the time I only have to write markdown. But that’s what’s great about having a blog. In addition to writing, which I enjoy, this site is my primary exposure to web development and web design. It’s a fun hobby to build and maintain your own site, which [I've written about before]({{ site.url }}{% post_url 2017-09-10-building-a-site-with-jekyll-on-nfsn %}).

### Migrating

You can see [the diff here](https://github.com/jessesquires/jessesquires.com/pull/75/files) if you're curious. It wasn't  trivial with 499 additions and 735 deletions. The API name changes were simple to fix, but the grid system and some style changes took longer to resolve. The [grid system](https://getbootstrap.com/docs/4.1/layout/grid/) is much simpler &mdash; they [moved](https://getbootstrap.com/docs/4.1/migration/#grid-system) to using [flexbox](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox).

The main container for the site was previously defined using columns and offsets:

```html
<div class="container container-fluid">
    <div class="row">
        <div class="col-sm-12 col-sm-offset-0 col-md-10 col-md-offset-1 col-lg-10 col-lg-offset-1">

            <!-- Content here -->

        </div> <!-- col -->
    </div> <!-- row -->
</div> <!-- container -->
```

This is a bit cumbersome and awkward to maintain. It's easy to get wrong. Flexbox simplifies this, allowing you to insert "empty" columns. The code below produces similar results, but rather than using offsets, there are 3 columns where the main content is centered in the center column.

```html
<div class="container">
    <div class="row justify-content-md-center">
        <div class="col"></div>
        <div class="col-12 col-md-8">

           <!-- Content here -->

        </div>
        <div class="col"></div>
    </div> <!-- row -->
</div> <!-- container -->
```

I was able to simplify tons of CSS and HTML, and even remove some dirty hacks. There are new `.list-unstyled` and `.list-inline` [styles](https://getbootstrap.com/docs/4.0/content/typography/#lists), which I use to build the row of icons in the footer (the links to GitHub, Twitter, LinkedIn, etc). Those are placed in a row and column with these new classes applied. But previously, it required doing:

```css
ul li {
    margin-left: 0.25rem;
    margin-right: 0.25rem;
}

ul {
    -webkit-padding-start: 0px !important;
    -webkit-margin-before: 0px !important;
    -webkit-margin-after: 0px !important;
    -moz-padding-start: 0px !important;
    -moz-padding-before: 0px !important;
    -moz-padding-after: 0px !important;
}
```

These are only a couple of examples. Overall, I had tons of wins across the board with this migration. I'd highly recommend upgrading to v4. If you don't use Bootstrap, you should consider it.

### Design tweaks

I’m not a designer, so I mostly use the defaults with a few minor overrides. Some of the [default colors changed](https://getbootstrap.com/docs/4.1/utilities/colors/) and I wasn't a fan of some of them, but others that were added are great. The new "warning" yellow is a bit too bright for me, but I love the new dark and light text colors. I've refined some of the typography, font sizing, and spacing on the site. It feels much cleaner to me.

### Refactoring

While fixing things that broke in the new version, I decided to refactor some duplicate code into new components using [jekyll includes](https://jekyllrb.com/docs/templates/#includes). A new [`_includes/post_entry.html`](https://github.com/jessesquires/jessesquires.com/blob/master/_includes/post_entry.html) contains the code for rendering a post title, subtitle, and date. This was either duplicated or inconsistent across the site, but now it's used on the [main page]({{ site.url }}), individual posts like this one, and the [archive]({{ site.url }}{% link archive.md %}) page. This is one of my favorite features of Jekyll.

### Make your own

If you don’t have a blog, you should make one. Experience the open web. Own and control all of your thoughts and writing, rather than give them away to a corporation to exploit and monetize, or to a startup that will shutdown next year. You can even fork this site and make it your own, like [Josh Adams](https://twitter.com/vermont42/status/983135699493830656) did for [Race condition](http://racecondition.software/blog/programmatic-layout/).
