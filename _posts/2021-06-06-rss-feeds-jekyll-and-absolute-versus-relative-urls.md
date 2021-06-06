---
layout: post
categories: [software-dev]
tags: [rss, jekyll, website-infra, web, ruby]
date: 2021-06-06T09:59:24-07:00
title: RSS feeds, Jekyll, and absolute versus relative URLs
---

Lately I've been upgrading and making improvements to my website and blog. As part of that work, I was updating and refining how my RSS feed gets generated with [Jekyll](https://jekyllrb.com). And then I realized something that I had not given much thought to previously. When including the full content of blog posts in an RSS feed, if you link to other posts or pages on your site should you be using absolute URLs or are relative URLs ok?

<!--excerpt-->

### Generating a feed

First, let's consider a basic RSS/Atom feed.

```xml
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>My Blog</title>
  <link href="https://myblog.com"/>
  <updated>2021-01-01T12:00:00Z</updated>
  <id>https://myblog.com</id>

  <entry>
    <title>My Second Post</title>
    <link href="https://myblog.com/my-post-2"/>
    <id>https://myblog.com/my-post-2</id>
    <updated>2021-01-01T12:00:00Z</updated>
    <summary>
        This is a summary of my 2nd post.
    </summary>
    <content type="html">
        This is the entire content of my 2nd post.
        You can read the first <a href="/my-post-1/">here</a>.
    </content>
  </entry>

  <!-- more posts... -->
</feed>
```

For `<link>` elements, you must use absolute URLs. This should be obvious, otherwise feed readers have no idea where your site exists. But what about the HTML of your blog posts within the `<content>` elements (for Atom) or `<description>` elements (for RSS)? When linking to previous blog posts or other pages and viewing on the web, using relative links is fine. That's how the web works. But when your RSS feed gets generated, wouldn't those relative links break in feed readers? More explicitly, using the example above, which of the following should we write?

 ```html
 <!-- absolute -->
 <a href="https://myblog.com/my-post-1/">here</a>

 <!-- relative -->
 <a href="/my-post-1/">here</a>
```

### Reviewing the Specs

Unfortunately, the official [RSS Specification](https://cyber.harvard.edu/rss/rss.html) does not mention relative links anywhere that I could find. The [Atom Specification](https://datatracker.ietf.org/doc/html/rfc4287), however, does mention handling relative links:

> Any element defined by this specification MAY have an `xml:base`
 attribute [W3C.REC-xmlbase-20010627].  When `xml:base` is used in an
 Atom Document, it serves the function described in section 5.1.1 of
 [RFC3986], establishing the base URI (or IRI) for resolving any
 relative references found within the effective scope of the `xml:base`
 attribute.

There is additional discussion at the [W3C feed validator](https://validator.w3.org/feed/docs/atom.html) and its [explanation of possible warnings](https://validator.w3.org/feed/docs/warning/ContainsRelRef.html) &mdash; which strongly discourages using relative URL references. When `xml:base` is used, feed readers should use it to resolve relative URLs. We can modify the example above.

```html
<content type="html" xml:base="https://myblog.com">
  This is the entire content of my 2nd post.
  You can read the first <a href="/my-post-1/">here</a>.
</content>
```

The question remains whether or not most feed readers correctly handle `xml:base`, or &mdash; if `xml:base` is not present &mdash; whether relative URLs will still be resolved against the feed URL?

Of course, I asked for help from [Brent Simmons](https://inessential.com), who kindly [replied on Twitter](https://twitter.com/brentsimmons/status/1398696153915428867):

> For compatibility with all RSS readers, it’s best not to use relative URLs. Many readers will handle them, but not all.

Unsurprisingly, I later found [this 2004 post from Brent](https://inessential.com/2004/01/12/postels_law_atom_and_netnewswire) titled "Postel’s Law, Atom, and NetNewsWire". The post is about parsing XML for Atom and mentions [Postel's law](https://en.wikipedia.org/wiki/Robustness_principle) &mdash; a design guideline for software that states that you should be lenient and forgiving in what data you accept, but strict with the data that you send or generate.

Most feed readers _probably_ handle relative URLs just fine, and in my experience they do. However, we should use absolute URLs within feed `<content>` and `<description>` elements for the greatest level of compatibility.

Furthermore, if you use a service like Mailchimp's [RSS-to-email](https://mailchimp.com/features/rss-to-email/), then you **must** use absolute URLs for all resources, otherwise your emails will be full of broken links and missing images.

### Problems with static site generators

However, this presents an issue for static site generators like Jekyll. It appears this is also a problem in Hugo ([here](https://discourse.gohugo.io/t/absolute-urls-in-rss-feeds/25971)) and Gatsby ([here](https://github.com/gatsbyjs/gatsby/issues/14133) and [here](https://markshust.com/2020/06/25/fixing-images-in-gatsby-rss-feeds/)). I am not familiar with Hugo and Gatsby, but I assume they work similarly to Jekyll. In Jekyll, if you want to link to a previous blog post, the best way to do that is to use the [`post_url` Tag](https://jekyllrb.com/docs/liquid/tags/#linking-to-posts):

{% raw %}
```
[previous post]({% post_url 2021-01-01-some-title %})
```
{% endraw %}

In Jekyll, this would link to the post you wrote that is saved as `2021-01-01-some-title.md`. Using this [Liquid tag](https://jekyllrb.com/docs/step-by-step/02-liquid/#tags) is important, because Jekyll will always generate the correct URL based on your [permalink configuration](https://jekyllrb.com/docs/permalinks/). Additionally, if you rename or delete the file but continue to link to it somewhere on your site using `post_url`, Jekyll will fail to build your site with an error message that it cannot find the post &mdash; which prevents you from accidentally publishing broken links.

The problem is that `post_url` will generate a **relative** &mdash; not absolute &mdash; URL. The example above produces the following HTML:

```html
<a href="/2021/01/01/some-title/">previous post</a>
```

Thus, your RSS/Atom feed will contain relative URLs. Writing links by hand is not an option because it is error prone and risks breaking if you ever change your permalink structure &mdash; for example, from `2021/01/01/some-title/` to `/blog/2021/some-title/`. Jekyll provides an [`absolute_url` Liquid filter](https://jekyllrb.com/docs/liquid/filters/), but it does not work with `post_url`. The following produces a syntax error:

{% raw %}
```
[previous post]({{ {% post_url 2021-01-01-some-title %} | absolute_url }})
```
{% endraw %}

If using Jekyll "out of the box", you have two potential workarounds. You could capture the output from `post_url`, then send that to `absolute_url`:

{% raw %}
```
{% capture post %}{% post_url 2021-01-01-some-title %}{% endcapture %}
{{ post | absolute_url }}
```
{% endraw %}

Alternatively, you could prepend your `site.url`:

{% raw %}
```
[previous post]({{ site.url }}{% post_url 2021-01-01-some-title %})
```
{% endraw %}

Both options are simply barbaric. Surely, we can do better?

### Creating custom Liquid Tags to generate absolute post URLs

I am not a Ruby expert, nor do I have much experiencing writing Jekyll plugins. The documentation on [including custom Liquid Tags](https://jekyllrb.com/docs/plugins/tags/) for your site provides a great example to get started. The problem is that I do not want to write a Tag that simply prepends `site.url` to a link &mdash; I want the additional validation that comes with `post_url`.

Having no idea what I'm doing, I decided to dig around in the Jekyll source code. I found the source for `absolute_url` [here](https://github.com/jekyll/jekyll/blob/76517175e700d80706c9139989053f1c53d9b956/lib/jekyll/filters/url_filters.rb) and the code for `post_url` [here](https://github.com/jekyll/jekyll/blob/76517175e700d80706c9139989053f1c53d9b956/lib/jekyll/tags/post_url.rb). However, I do not want to copy-paste any of this code.

It turns out, all we need to do is subclass `PostUrl`, call `super`, and pass that to `absolute_url()`.

```ruby
module Jekyll
  class PostUrlAbsolute < Jekyll::Tags::PostUrl

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    # Returns absolute url to a post
    def render(context)
      absolute_url("#{ super(context) }")
    end
  end
end

Liquid::Template.register_tag('post_url_absolute', Jekyll::PostUrlAbsolute)
```

You can use this by placing it in your `_plugins/` directory, and then replacing all usage of `post_url` with `post_url_absolute`.

{% raw %}
```
[previous post]({% post_url_absolute 2021-01-01-some-title %})
```
{% endraw %}

This produces the following HTML:

```html
<a href="https://myblog.com/2021/01/01/some-title/">previous post</a>
```

Similar to `post_url`, Jekyll has a [`link` Tag](https://jekyllrb.com/docs/liquid/tags/#links) that you can use for linking to pages and other resources like images. Unfortunately, it also produces relative URLs and also does not work with `absolute_url`. You can implement a custom `link_absolute` Tag in the same way as `post_url_absolute` above. I'll leave that as an exercise for the reader. As always, you can find the source for this site [on GitHub]({{ site.data.github.repo }}).

{% include break.html %}

Admittedly, it does feel kind of awkward to link to pages on your own site within your own site using absolute URLs. But the alternative would be to do some very heavy and ugly manual processing when generating your feed. So I am content with this solution.

Also, it is worth clarifying that you can still use `link` and `post_url` on other pages on your site &mdash; those are not included in your RSS/Atom feed. Only within the contents of your blog posts should you use the `*_absolute` variants.
