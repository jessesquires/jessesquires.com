---
layout: standalone
title: Archive
permalink: /blog/archive/
---

<div class="my-3">
{% include search_box.html %}
</div>

{% assign groupedPosts = site.posts | group_by_exp: "post", "post.date | date: '%Y %B'" %}
{% for each in groupedPosts %}

<div class="p-2 mt-4 mb-2 bg-light border-top">
    <h3 class="text-secondary" id="{{ each.name | slugify }}">
        <a href="#{{ each.name | slugify }}" class="text-reset">{{ each.name }}</a>
    </h3>
</div>

<ul class="list-unstyled">
{% for post in each.items %}
<li>
    <i class="bi bi-caret-right-fill" role="img" aria-hidden="true"></i>
    <a href="{{ post.url }}" class="fs-5 text-decoration-none">{{ post.title }}</a>
    {% if post.date-updated %}
    <span class="badge bg-light text-secondary border mx-1" title="{{ post.date-updated | date: '%d %b %Y %r %Z' }}">
        Updated
    </span>
    {% endif %}
</li>
{% endfor %}
</ul>

{% endfor %}
