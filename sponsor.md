---
layout: standalone
title: Sponsor
description: Sponsor my work!
---

If you enjoy reading [my blog]({% link blog.md %}), watching [my conference talks]({% link speaking.md %}), or using one of [my open source projects]({{ site.data.social.github }}), consider becoming a [sponsor]({{ site.data.github.sponsor }}). Your support is very much appreciated! &#x1F64C;

<hr>

### Support my work

<ul class="list-unstyled fs-5 mt-1">
{% for item in site.data.sponsorLinks %}
<li class="my-1">
<i class="bi {{ item.icon }} px-2"></i><a href="{{ item.url }}" class="text-decoration-none">{{ item.title }}</a>
</li>
{% endfor %}
</ul>
