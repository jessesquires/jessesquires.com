---
layout: standalone
title: Curriculum Vitae
---

<p class="text-muted"><i>Last updated: June 2021</i></p>

After working for a number of years as a full-time employee at various companies, I went independent at the end of 2019. I'm currently focusing on my own apps and open source projects, while doing contract work for various clients. You can [hire me]({% link hire-me.md %}).

{% assign resume = site.data.resume %}

<!-- WORK -->

{% include resume_section.html resume_section=resume.work %}

<!-- PROJECTS -->

{% include resume_header.html text="Projects & Open Source" icon="bi-terminal" %}

I’m working on a number of side projects, indie apps, and open source projects. You can find an [overview of my projects here]({% link projects.md %}). My open source projects are [hosted on GitHub]({{ site.data.social.github }}), and my indie apps are [available at Hexed Bits](https://www.hexedbits.com).

<!-- TALKS -->

{% include resume_header.html text="Conference Talks" icon="bi-person-badge" %}

I have spoken at conferences and meetups around the world to share my thoughts, ideas, and experiences about programming,
software, and community &mdash; particularly open source, iOS, Swift, and Objective-C.
You can find [a complete list of my talks here]({% link speaking.md %}), including slides, videos, and sample code.

<ul class="mb-4">
  {% for talk in site.data.talks %}
  <li>
    {{ talk.event.name }}, {{ talk.location.city }} &mdash; <i>{{ talk.date }}</i>
  </li>
  {% endfor %}
</ul>

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
