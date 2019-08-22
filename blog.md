---
layout: standalone
title: Writing
---

I mostly write about Swift, Objective-C, iOS, open source, and other software development topics.
Sometimes I write about the ethics of tech, labor, and politics.
I also write personal essays and notes on what I'm currently reading.
If you are trying to find something specific, you can also [search this site](/search).

{% for post in site.posts %}
<article class="post-entry">
    {% include post_entry.html post_entry=post include_excerpt=true %}
</article>
{% endfor %}
