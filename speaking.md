---
layout: standalone
title: Speaking
tags: [conference, talk, speaking]
---

I enjoy speaking at conferences and meetups to share my thoughts, ideas, and experiences about programming,
software, and community &mdash; particularly open source, iOS, Swift, and Objective-C.
You can find the materials and details for all of my talks [on GitHub](https://github.com/jessesquires/talks)
and all of my slides [on Speaker Deck](https://speakerdeck.com/jessesquires).

Feel free to [contact me](/contact) about speaking at your event!

### Upcoming talks

*Upcoming talks will be listed here as they are announced.*

### Past talks

<div class="table-responsive">
    <table class="table table-striped">
        <thead>
            <tr>
                <th class="table-date-column"><i class="fa fa-calendar fa-lg" aria-hidden="true"></i></th>
                <th><i class="fa fa-quote-left fa-lg" aria-hidden="true"></i></th>
                <th><i class="fa fa-video-camera fa-lg" aria-hidden="true"></i></th>
                <th><i class="fa fa-map-marker fa-lg" aria-hidden="true"></i></th>
                <th><i class="fa fa-file-text fa-lg" aria-hidden="true"></i></th>
            </tr>
        </thead>
        <tbody>
        {% for t in site.data.talks %}
        {% assign talk = t[1] %}
        {% assign event = talk.event %}
        {% assign location = talk.location %}
        {% assign links = talk.links %}
            <tr>
                <td class="table-date-column">{{ talk.date }}</td>
                <td><i>{{ talk.title }}</i></td>
                <td><a href="{{ event.link }}">{{ event.name }}</a></td>
                <td><a href="{{ location.link }}">{{ location.name }}</a>, {{ location.city }}</td>
                <td>
                    <ul class="list-unstyled">
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
