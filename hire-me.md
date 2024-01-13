---
layout: standalone
title: Hire Me
description: Need an iOS developer? Hire me!
---

Need an iOS developer? Look no further! I am available for consulting, contracting, and freelance work for iOS. I have a decade of experience developing for Apple platforms. You can find my full [CV here]({% link linkedout.md %}).

<div class="alert alert-primary pb-0 px-4 my-4" markdown="1">
**<i class="bi bi-star-fill"></i> Interested in working with me?** I typically get booked quickly,
so I recommend reaching out sooner rather than later. Please be as detailed as possible about your
project and what you are looking for.
<br/><br/>
<i class="bi bi-envelope-fill"></i> You can **<a href="{% link contact.md %}" class="alert-link">contact me here</a>.**
</div>

### Services

Depending on your company's needs, I'm available to build entire iOS apps from scratch, work on existing apps, and everything in-between. I value clear, direct, proactive communication and getting things done right. My depth of experience enables me to work quickly and efficiently.

 - Build entire iOS apps from the ground up
 - Audit and evaluate an existing codebase to find improvements
 - Implement tooling and CI/CD automation to make your team and workflow more efficient and deliver more value
 - Update existing apps with new features or bug fixes
 - Refactor existing code to make it more maintainable and testable
 - Explore new product ideas with quick prototypes
 - Assist with your team's code review, offering advice on architecture design and best practices

### Rates

I typically work with open-ended, ongoing contracts at an hourly rate. However, I also offer flat rates for projects with fixed-lengths and well-defined deliverables. My rates vary depending on the nature and scope of the project, your budget, and the size of your organization. For example, building an entire app is very different than updating an existing app, and a Fortune 500 company is not the same as a non-profit. Please [get in touch]({% link contact.md %}) to discuss your project. Let me know what you are looking for, and we can figure out what works best!

### Location

I work remotely. I'm based in Oakland, CA and most often working in the [Pacific Time Zone](https://en.wikipedia.org/wiki/Pacific_Time_Zone). Occasionally, I travel while working.

### Testimonials

I've worked at a number of different companies as a full-time software engineer, as well as an independent contractor. With [a decade of experience]({% link linkedout.md %}) developing for Apple platforms, I've worked with a lot of great folks over the years. Here's what a few of them have to say.

<ul class="list-unstyled">
{% for each in site.data.testimonials %}
    <li>
        <p>
            <i class="bi bi-star-fill text-body-secondary"></i>
            <b><a href="{{ each.link }}">{{ each.name }}</a></b> &mdash; <i>{{ each.company }}</i>, {{ each.year }}
            <br/>
            <span class="fw-light">{{ each.position }}</span>
        </p>
        <blockquote>"{{ each.testimonial }}"</blockquote>
    </li>
{% endfor %}
</ul>
