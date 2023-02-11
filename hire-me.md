---
layout: standalone
title: Hire Me
description: Need an iOS developer? Hire me!
---

Need an iOS developer? Look no further! I am available for hire for freelance and contract work for iOS. If you don't know much about me, take a look around this site to learn more. You can find my [CV here]({% link linkedout.md %}).

<div class="alert alert-primary pb-0 px-4 my-4" markdown="1">
**If you are interested in working with me, you can <a href="{% link contact.md %}" class="alert-link">contact me here</a>.** I typically get booked quickly, so I recommend reaching out sooner rather than later. Please be as detailed as possible about your project and what you are looking for.
</div>

### How I work

- I can work a maximum of 15-30 hours per week on any given project.
- I typically work with open-ended contracts and charge an hourly rate. However, I am open to working for a flat rate for fixed-length projects.
- Depending on the nature and scope of the project and your budget, rates can be negotiable.
- I prefer to avoid frequent, recurring meetings. I usually cannot do more than one meeting per week per project.
- I am based in Oakland, CA and most often working in the Pacific time zone, although I sometimes travel.

### Testimonials

I've worked at a number of different companies as a full-time software engineer, as well as an independent contractor. With [a decade of experience]({% link linkedout.md %}) developing for Apple platforms, I've worked with a lot of great folks over the years. Here's what a few of them have to say.

<ul class="list-unstyled">
{% for each in site.data.testimonials %}
    <li>
        <p>
            <i class="bi bi-star-fill text-secondary"></i>
            <b><a href="{{ each.link }}">{{ each.name }}</a></b> &mdash; <i>{{ each.company }}</i>, {{ each.year }}
            <br/>
            <span class="fw-light">{{ each.position }}</span>
        </p>
        <blockquote>"{{ each.testimonial }}"</blockquote>
    </li>
{% endfor %}
</ul>
