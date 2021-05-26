---
layout: standalone
title: Curriculum Vitae
---

<p class="text-muted"><i>Last updated: 1 Dec 2020</i></p>

{% assign resume = site.data.resume %}

<!-- WORK -->

{% include resume_section.html resume_section=resume.work %}

<!-- PROJECTS -->

{% include resume_header.html text="Projects & Open Source" icon="fa-code-fork" %}

I’m working on a number of side projects, indie apps, and open source projects. You can find an [overview of my projects here](/projects). My open source projects are [hosted on GitHub]({{ site.data.social.github }}), and my indie apps are [available at Hexed Bits](https://www.hexedbits.com).

{% include resume_header.html text="Conference Talks" icon="fa-id-badge" %}

I have spoken at conferences and meetups around the world to share my thoughts, ideas, and experiences about programming,
software, and community &mdash; particularly open source, iOS, Swift, and Objective-C.
You can find [a complete list of my talks here](/speaking), including slides, videos, and sample code.

<!-- SKILLS -->

{% include resume_section.html resume_section=resume.skills %}

<ul class="list-inline">
{% for entry in resume.skills.items %}
<li class="list-inline-item font-monospace">{{ entry }}{% if resume.skills.items.last != entry %}<b> &bull; </b>{% endif %}</li>
{% endfor %}
</ul>

<!-- VOLUNTEERING -->

{% include resume_section.html resume_section=resume.volunteering %}

<!-- EDUCATION -->

{% include resume_section.html resume_section=resume.education %}

<!-- RESEARCH -->

{% include resume_section.html resume_section=resume.research %}

<!-- PUBLICATIONS -->

{% include resume_section.html resume_section=resume.publications %}
