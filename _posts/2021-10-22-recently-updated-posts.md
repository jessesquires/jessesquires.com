---
layout: post
categories: [software-dev]
tags: [jekyll, web, website-infra, rss, json]
date: 2021-10-22T13:40:56-07:00
title: Recently updated posts
---

Periodically, I go back to add updates to older posts. I've been doing this for some time now, although not as often as I would like. I aspire to be as good and diligent as [Michael Tsai](https://mjtsai.com/blog/recently-updated/), but that's an incredibly high bar. (How does he do it?!)

<!--excerpt-->

If you are reading on my site, updates are clearly marked and awhile back I added a new section at [`/blog/recently-updated/`]({% link recently-updated.md %}) that you can browse. However, if not visiting that page regularly readers would otherwise be completely unaware of these updates &mdash; until today. I am now publishing an "updates only" feed, to which you can [subscribe]({% link subscribe.md %}) (direct links: [rss]({{ site.feeds.rss-updates-only }}), [json]({{ site.feeds.json-updates-only }})).

This new update feed is also hooked up to my existing automation that tweets newly published posts, so now updates will also be tweeted as they are published. If you [follow me]({{ site.data.social.twitter }}), you'll start seeing these updates.

### Implementation in Jekyll

This was not as straight-forward to implement as I anticipated. If you use [Jekyll](https://jekyllrb.com) and want to do something similar, here's how.

#### Creating a recently updated page

The first step is adding the metadata to your post [front matter](https://jekyllrb.com/docs/step-by-step/03-front-matter/), specifically a new `date-updated` variable.

```yaml
layout: post
title: My Title
date: 2021-01-01
date-updated: 2021-05-05
```

To create a page that lists only the recently updated posts is similar to how you list all your posts in general. The difference is filtering and sorting by the new `date-updated` variable.

{% raw %}
```liquid
{% assign updated_posts = site.posts | where_exp: "post", "post.date-updated != null" | sort: "date-updated" %}
{% for post in updated_posts reversed %}
    <!-- render post -->
{% endfor %}
```
{% endraw %}

Again, you can see my [recently updated page here]({% link recently-updated.md %}). This page does not get much traffic, but it is nice to have some output to verify that everything is working as expected. Note that because we sorted by `date-updated`, when iterating through the posts we need to use `reversed` so that the most recently updated post displays first.

There's one bug I encountered. I use `limit:` to only display the 30 most recent entries. (For more, you can [visit the archive]({% link archive-home.html %}).) For the regular list of posts, that looks like this:

{% raw %}
```liquid
{% for post in site.posts limit: site.feeds.limit %}
    <!-- render post -->
{% endfor %}
```
{% endraw %}

You can define a limit in your site's configuration file, `_config.yml`.

```yaml
feeds:
    limit: 30
```

Similarly, you can limit the updated posts:

{% raw %}
```liquid
{% for post in updated_posts reversed limit: site.feeds.limit %}
    <!-- render post -->
{% endfor %}
```
{% endraw %}

Again, we have to use `reversed` while iterating over the updated posts. And this is where the problem occurs.

Using `limit:` did not work in this scenario like it does when using `site.posts`. Even though we use `reversed` to iterate through `updated_posts` in reverse order, `limit:` appears to limit the iteration count _in-order_ using the *non-reversed* array. Thus, we end up with the first `N` updated posts rather than the `N` most recently updated posts. In other words, the "limiting" occurs first, truncating the list of posts, _and then_ the truncated list is reversed. That is not what you want. To fix it, we need to manually check the loop index against our desired limit, then break out of the loop manually.

{% raw %}
```liquid
{% for post in updated_posts reversed %}
    {% if forloop.index > site.feeds.limit %} {% break %} {% endif %}
    <!-- render post -->
{% endfor %}
```
{% endraw %}

Unfortunately, it is not possible to change the sort order when using `sort:`. It is always ascending.

Note that none of this an issue when using `site.posts` because Jekyll returns posts from newest to oldest by default. Thus, you do not need to use `reversed`.

#### Creating a recently updated feed

The next step is publishing a feed with only updated posts, which is also a bit tricky. Jekyll has [an official feed plugin](https://github.com/jekyll/jekyll-feed) that you can use to generate a normal RSS feed. For this however, we'll need to create our own template. You can find my feed templates [here](https://github.com/jessesquires/jessesquires.com/tree/master/_layouts). The process is the same for RSS and JSON Feed, but I'll use a simplified RSS feed for this example.

Let's start with the original RSS feed template in `feed.xml`.

{% raw %}
```xml
---
layout: null
---

<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom" xml:lang="en">
    <link href="{{ site.feeds.rss | absolute_url }}" rel="self" type="application/atom+xml" />

    <id>{{ site.url }}/</id>
    <link href="{{ site.url }}/" />
    <updated>{{ site.time | date_to_xmlschema }}</updated>

    <title>{{ site.title }}</title>

    {% for post in site.posts limit: site.feeds.limit %}
    <entry xml:lang="en">
        <id>{{ post.url | absolute_url | xml_escape }}</id>
        <link href="{{ post.url | absolute_url }}" />

        <title>{{ post.title | xml_escape }}</title>
        <published>{{ post.date | date_to_xmlschema }}</published>
    </entry>
    {% endfor %}
</feed>
```
{% endraw %}

We want to turn this into a layout template, and then parameterize it with a new front matter variable. We need to move the feed to `_layouts/feed_rss.xml`, then update the original `feed.xml` to use that layout.

```yaml
---
layout: feed_rss
updates_only: false
---

```

Note that `feed.xml` is now empty, except for the front matter. It inherits everything from the parent layout at `_layouts/feed_rss.xml`. At this point, nothing has changed regarding the generated output of the site.

Now we can add a `feed-updates.xml` with the same layout. But this time, specify `updates_only: true`.

```yaml
---
layout: feed_rss
updates_only: true
---

```

Now we need to update the parent layout template to check the value of `updates_only` and modify the feed accordingly. First, we'll update the title to append "Recently Updated".

{% raw %}
```xml
<title>{{ site.title }}{% if page.updates_only %}: Recently Updated{% endif %}</title>
```
{% endraw %}

In my case, this will produce "Jesse Squires: Recently Updated". Next, we'll generate the post list based on whether or not this is the main feed or only updates. This is similar to the code above for generating the page that displays updated posts.

{% raw %}
```liquid
{% if page.updates_only %}
    {% assign post_list = site.posts | where_exp: "post", "post.date-updated != null" | sort: "date-updated" %}
{% else %}
    {% assign post_list = site.posts | sort: "date" %}
{% endif %}

{% for post in post_list reversed %}
{% if forloop.index > site.feeds.limit %} {% break %} {% endif %}
    <!-- post entry -->
{% endfor %}
```
{% endraw %}

Finally, for each entry we'll change the title to prepend "[Updated]", provide a unique id using `date-updated`, and use the `date-updated` date as the published date.

{% raw %}
```xml
<entry xml:lang="en">
    {% assign post_title = post.title %}
    {% assign post_date = post.date %}
    {% assign post_id = post.url | absolute_url %}

    {% if page.updates_only %}
        {% assign post_title = "[Updated] " | append: post_title %}
        {% assign post_date = post.date-updated %}
        {% assign date_string = post.date-updated | date_to_long_string %}
        {% assign update_id = "updated " | append: date_string | slugify %}
        {% assign post_id = post_id | append: "#" | append: update_id %}
    {% endif %}

    <id>{{ post_id | xml_escape }}</id>
    <link href="{{ post.url | absolute_url }}" />
    <title>{{ post_title | xml_escape }}</title>
    <published>{{ post_date | date_to_xmlschema }}</published>
</entry>
```
{% endraw %}

And that's it. Jekyll will now generate both feeds from this template using `updates_only` to include the correct content for each feed. Again, you can take the same approach for generating a JSON Feed. This example was slightly simplified, but you want to see the full implementation for my site, [it is all open source]({{ site.data.github.repo }}).

{% include break.html %}

You might be wondering, why not have a single feed that provides new posts as well as updated posts? I considered this, but concluded it would be too complicated &mdash; and not worth my time. To do this, you would have to merge your `site.posts` sorted by `date` with your `updated_posts` sorted by `date-updated`. That's a tricky algorithm and it's not _too_ intimidating with a normal programming language, but the [Liquid templating language](https://jekyllrb.com/docs/liquid/) is very limited. You would probably need to write some custom plugins. So for now, I'm fine with having two separate feeds. It's simpler and easier. If you already subscribe to this blog via RSS, then you know how to add a new feed to your reader. And if you only get my posts through Twitter, you'll see the updated posts automatically.

Again, you can subscribe to the new updates feed [here for RSS]({{ site.feeds.rss-updates-only }}) and [here for JSON Feed]({{ site.feeds.json-updates-only }}).
