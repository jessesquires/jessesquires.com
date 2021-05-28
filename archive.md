---
layout: standalone
title: Archive
---

{% assign groupedPosts = site.posts | group_by_exp:"post", "post.date | date: '%Y %B'"  %}
{% for each in groupedPosts %}

<div class="p-2 mt-4 mb-2 bg-light border-top">
    <h3 class="text-secondary" id="{{ each.name | slugify }}">
        <a href="#{{ each.name | slugify }}" class="text-reset">{{ each.name }}</a>
    </h3>
</div>

<ul class="list-unstyled">
{% for post in each.items %}
<li>
<i class="bi bi-caret-right-fill" role="img" aria-label="continue"></i>
<a href="{{ post.url }}" class="fs-5 text-decoration-none">{{ post.title }}</a>
</li>
{% endfor %}
</ul>

{% endfor %}
