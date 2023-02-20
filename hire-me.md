---
layout: standalone
title: Hire Me
description: Need an iOS developer? Hire me!
---

Need an iOS developer? Look no further! I am available for hire for freelance and contract work for iOS. If you don't know much about me, take a look around this site to learn more. You can find my [CV here]({% link linkedout.md %}).

<div class="alert alert-primary pb-0 px-4 my-4" markdown="1">
**<i class="bi bi-star-fill"></i> Interested in working with me? <a href="{% link contact.md %}" class="alert-link">Contact me here</a>.** I typically get booked quickly, so I recommend reaching out sooner rather than later. Please be as detailed as possible about your project and what you are looking for.
</div>

### How I work

I have [a decade of experience]({% link linkedout.md %}) developing for Apple platforms. Depending on your company's needs, I'm available to build entire iOS apps from scratch, explore new ideas with quick prototypes, work on new features or fixes for existing apps, and everything in-between. I value clear, direct, proactive communication and getting things done right. With my breadth and depth of experience, I can build solutions efficiently and effectively, always adhering to industry best practices.

I typically work with open-ended contracts at an hourly rate. However, I am open to working for a flat rate for fixed-length projects. Let me know what you are looking for and we can figure out what works best. Depending on the nature and scope of the project and your budget, rates are negotiable. I am based in Oakland, CA and most often working in the Pacific time zone, although I sometimes travel while working.

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
