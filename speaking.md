---
layout: standalone
title: Speaking
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
    <table class="table table-striped table-bordered align-middle">
        <thead>
            <tr>
                <th width="100">
                    <i class="bi bi-calendar-week-fill fs-5" role="img" aria-label="Date"></i>
                </th>
                <th>
                    <i class="bi bi-chat-quote-fill fs-5" role="img" aria-label="Title"></i>
                </th>
                <th>
                    <i class="bi bi-camera-reels-fill fs-5" role="img" aria-label="Event"></i>
                </th>
                <th>
                    <i class="bi bi-geo-alt-fill fs-5" role="img" aria-label="Location"></i>
                </th>
                <th>
                    <i class="bi bi-file-earmark-text-fill fs-5" role="img" aria-label="Links"></i>
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
                <td><a href="{{ event.link }}">{{ event.name }}</a></td>
                <td><a href="{{ location.link }}">{{ location.name }}</a>, {{ location.city }}</td>
                <td>
                    <ul class="list-unstyled list-group list-group-flush text-center">
                    {% if links.slides %}<li><a href="{{ links.slides }}">slides</a></li>{% endif %}
                    {% if links.video %}<li><a href="{{ links.video }}">video</a></li>{% endif %}
                    {% if links.code %}<li><a href="{{ links.code }}">code</a></li>{% endif %}
                    </ul>
                </td>
            </tr>
        {% endfor %}
        </tbody>
    </table>
</div>
