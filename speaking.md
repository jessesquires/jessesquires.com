---
layout: standalone
title: Speaking
description: All of my conference talks
tags: [conference, talk, speaking]
---

I enjoy speaking at conferences and meetups to share my thoughts, ideas, and experiences about programming,
software, and community &mdash; particularly open source, iOS, Swift, and Objective-C.
You can find the materials and details for all of my talks [on GitHub]({{ site.data.github.talks }})
and all of my slides [on Speaker Deck](https://speakerdeck.com/jessesquires).

Feel free to [contact me]({% link contact.md %}) about speaking at your event!

### Upcoming talks

*Upcoming talks will be listed here as they are announced.*

### Past talks

<div class="table-responsive">
    <table class="table table-sm table-striped table-bordered align-middle">
        <thead>
            <tr>
                <th width="100px">
                    <i class="bi bi-calendar-week-fill fs-4" role="img" aria-label="Date"></i>
                </th>
                <th>
                    <i class="bi bi-chat-quote-fill fs-4" role="img" aria-label="Title"></i>
                </th>
                <th>
                    <i class="bi bi-camera-reels-fill fs-4" role="img" aria-label="Event"></i>
                </th>
                <th>
                    <i class="bi bi-geo-alt-fill fs-4" role="img" aria-label="Location"></i>
                </th>
                <th width="75px">
                    <i class="bi bi-file-earmark-text-fill fs-4" role="img" aria-label="Links"></i>
                </th>
            </tr>
        </thead>
        <tbody>
        {% for talk in site.data.talks %}
            {% assign event = talk.event %}
            {% assign location = talk.location %}
            {% assign links = talk.links %}
            <tr>
                <td>{{ talk.date }}</td>
                <td><i>{{ talk.title }}</i></td>
                <td><a href="{{ event.link }}" class="text-decoration-none">{{ event.name }}</a></td>
                <td><a href="{{ location.link }}" class="text-decoration-none">{{ location.name }}</a><br/>{{ location.city }}</td>
                <td>
                    <ul class="list-unstyled list-group list-group-flush text-center">
                    {% if links.slides %}<li><a href="{{ links.slides }}" class="text-decoration-none">slides</a></li>{% endif %}
                    {% if links.video %}<li><a href="{{ links.video }}" class="text-decoration-none">video</a></li>{% endif %}
                    {% if links.code %}<li><a href="{{ links.code }}" class="text-decoration-none">code</a></li>{% endif %}
                    </ul>
                </td>
            </tr>
        {% endfor %}
        </tbody>
    </table>
</div>
