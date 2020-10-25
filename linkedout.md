---
layout: standalone
title: Curriculum Vitae
---

<p class="text-muted"><i>Last updated: 25 Oct 2020</i></p>

{% assign resume = site.data.resume %}

<!-- WORK -->

{% include resume_section.html resume_section=resume.work %}

<!-- PROJECTS -->

{% include resume_header.html text="Projects & Open Source" %}

<p>See <a href="/projects">projects</a>, my <a href="{{ site.social_links.github }}">GitHub profile</a>, and <a href="https://www.hexedbits.com">Hexed Bits</a>.</p>

{% include resume_header.html text="Conference Talks" %}

<p>See <a href="/speaking">speaking</a>.</p>

<!-- SKILLS -->

{% include resume_header.html text=resume.skills.title %}

<ul class="list-inline">
{% for entry in resume.skills.entries %}
<li class="list-inline-item text-monospace">{{ entry }}{% if resume.skills.entries.last != entry %}<b> &bull; </b>{% endif %}</li>
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
