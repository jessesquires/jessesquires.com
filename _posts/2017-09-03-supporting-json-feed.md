---
layout: post
categories: [software-dev]
tags: [web, json, rss, jekyll]
date: 2017-09-03T10:00:00-07:00
title: Supporting JSON feed
subtitle: Now available
---

A couple of weeks ago I finally got around to adding support for Brent Simmons' and Manton Reece's [JSON Feed](https://jsonfeed.org/version/1) for this blog. You can subscribe to the feed [here]({{ site.feeds.json | absolute_url }}). It was simple and fun to implement.

<!--excerpt-->

> The JSON Feed format is a pragmatic syndication format, like [RSS](http://cyber.harvard.edu/rss/rss.html) and [Atom](https://tools.ietf.org/html/rfc4287), but with one big difference: it’s JSON instead of XML.
>
> For most developers, JSON is far easier to read and write than XML. Developers may groan at picking up an XML parser, but decoding JSON is often just a single line of code.
>
> Our hope is that, because of the lightness of JSON and simplicity of the JSON Feed format, developers will be more attracted to developing for the open web.
>
> &mdash; [JSON Feed Version 1](https://jsonfeed.org/version/1)

There are obvious benefits to adopting JSON Feed over something less modern like RSS/Atom. However, new standards (at least, initially) suffer from the [chicken-and-egg](https://en.wikipedia.org/wiki/Chicken_or_the_egg) problem: feed reader developers have little incentive to support the new JSON Feed format because so few publishers adopt it, while publishers have little incentive to adopt a new format because so few feed readers support it. Not to mention, publishers already have a working solution (RSS/Atom). In this case, I think publishers need to drive this change and eventually feed readers will follow. The good news is that &mdash; like Brent and Manton so clearly articulate &mdash; it's easy *and fun* to work with [JSON](http://json.org).

### JSON Feed and Jekyll

This site is built using [Jekyll](https://jekyllrb.com), so supporting JSON Feed just requires adding a new template `feed.json` file in the root directory of your site. It's the same as supporting RSS/Atom, where you provide a `feed.xml` template. Your site configuration will vary, but your `feed.json` should be similar to mine. [Here it is](https://github.com/jessesquires/jessesquires.com/blob/master/feed.json). You fill-in your site metadata, and iterate through each post to build an array of items. You'll notice that it's similar to [the feed.xml](https://github.com/jessesquires/jessesquires.com/blob/master/feed.xml) for RSS/Atom.

{% raw %}
```json
---
layout: null
---

{
    "version": "https://jsonfeed.org/version/1",
    "title": "{{ site.title }}",
    "home_page_url": "{{ site.url }}",
    "feed_url": "{{ site.feeds.json | absolute_url }}",
    "description": "{{ site.description }}",
    "icon": "{{ site.logo | absolute_url }}",
    "favicon": "{{ site.favicon | absolute_url }}",
    "expired": false,
    "author": {
        "name": "{{ site.author.name }}",
        "url": "{{ site.url }}",
        "avatar": "{{ site.author.avatar | absolute_url }}"
    },
    "items": [
        {% for post in site.posts %}
        {
            "id": "{{ post.url | absolute_url }}",
            "url": "{{ post.url | absolute_url }}",
            "title": {{ post.title | jsonify }},
            "date_published": "{{ post.date | date_to_xmlschema }}",
            {% if post.date-updated %}
            "date_modified": "{{ post.date-updated | date_to_xmlschema }}",
            {% else %}
            "date_modified": "{{ post.date | date_to_xmlschema }}",
            {% endif %}
            "author": {
                "name": "{{ site.author.name }}",
                "url": "{{ site.url }}",
                "avatar": "{{ site.author.avatar | absolute_url }}"
            },
            "summary": {{ post.excerpt | jsonify }},
            "content_html": {{ post.content | jsonify }}
        }{% if forloop.last == false %},{% endif %}
        {% endfor %}
    ]
}
```
{% endraw %}

Then, you'll need to add a `<link />` tag in the `<head>` section of your site:

```html
<link type="application/json" rel="alternate" href="/feed.json" title="YOUR SITE TITLE" />
```

That's all. When you run `jekyll build`, your [full feed]({{ site.feeds.json | absolute_url }}) will be generated. Now, go add JSON Feed support to your blog, too.
