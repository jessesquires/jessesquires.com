---
layout: post
categories: [software-dev]
tags: [jekyll, web, bootstrap, nearlyfreespeech, nfsn, github]
date: 2021-11-01T12:21:32-07:00
title: How to start a blog or portfolio website, for developers
---

Ever so often an iOS developer asks me how to get started with making their own blog or portfolio website. Or, I'll see a software developer from another community on Twitter ask the same thing. Often they are earlier in their career, or unfamiliar with web development, or unsure whether to build from scratch or use a platform, or all of the above. I find myself consistently making the same recommendations to folks. For this post, I want to share what I think is a great approach to get started, and how you can dive deeper once you master the basics.

<!--excerpt-->

### Things to consider

The first thing to consider is how much time and effort you want to commit to not only creating a site, but maintaining it. You'll also need to decide what you want your site to be. Some people only want a single-page site that links to their various online profiles &mdash; GitHub, LinkedIn, Twitter, etc. Others prefer a multi-page portfolio site. Some want to start a full blog where they will be regularly writing articles. You may want some combination of these, or you might want to start with a single-page site that eventually grows into a blog.

If you are only interested in a simpler portfolio site and don't want to worry about maintenance, it's probably worth considering one of the popular platforms: Squarespace, Wordpress, Wix, etc. Those will get you up and running pretty quickly. However, using these types of platforms is not the focus of this post. I don't have much experience with these platforms, but I know that they work as advertised, more or less.

However, not only are these platforms typically more expensive compared to building your own site, they give you much less control. I personally find them extremely frustrating to use as a software developer. They might be fine to begin with, but eventually you'll start running into their limitations. If you are planning to start a blog with technical writing, I highly discourage them as they are terrible with formatting code snippets and syntax highlighting.

The other question to ask yourself before starting a blog is: _do you really want to start a blog?_ You might be unsure, and that's ok! The reason I bring this up is to encourage you to start small and do the simplest thing first. You may write a couple of blog posts and decide that you actually hate blogging. (That's also ok.) What you want to avoid is spending a lot of time (and/or money) setting up some complex website that you actually don't want.

### Prerequisites

This post assumes some basic working knowledge of HTML, CSS, and Javascript. You don't need to be an expert. Being able to read and write simple HTML and CSS is all you need. Some Javascript experience is good too, but that's less important for a static site. If you don't have any experience with those, there are plenty of guides and tutorials online. These technologies lend themselves well to a "figure it out as you go" approach.

The only other pre-requisite is having a GitHub account, which I think the vast majority of software developers do. In my experience, it's the best platform out there for software projects &mdash; much better than BitBucket or GitLab.

### Getting started

This post is primarily geared toward someone who is interested in making their own website that includes:

- A handful of pages with information about yourself, your projects, your resume, your conference talks, etc.
- A blog where you can write and publish posts &mdash; or, at least the potential to start a blog later if you are currently undecided

What I highly recommend to folks is using [GitHub Pages](https://pages.github.com) to get started. It's a great place to experiment, get started quickly, and build a great-looking site. Maintenance is also near zero if hosting on GitHub. And &mdash; it's free.

### About GitHub Pages

In many ways, [GitHub Pages](https://pages.github.com) a great middle-ground between building from scratch and choosing a platform like Squarespace. You can get your site up and running in a few minutes using their built-in templates and hosting on GitHub. The difference is that with GitHub Pages, you can keep advancing into the technical side of creating on your own site well beyond what any of these platforms offer. Better yet, you can move at your own pace and dive as deep as you like.

Let's step through the process, from the simplest options to the most advanced. Keep in mind that you can stop at any point when you reach a level with which you are comfortable. You can always progress to something more advanced later.

### A simple GitHub Pages site

The main [GitHub Pages landing page](https://pages.github.com) has a great getting started guide, complete with a video and links to additional guides and documentation. In short, it's built on [Jekyll](https://jekyllrb.com), a static site generator. This means you can write some markdown and Jekyll will turn that into a webpage.

After stepping through their guides to create your new repository and choose a template, you'll have your site up and running at `username.github.io`. It should only take a few minutes. You can start adding new pages to your website or start writing blog posts right away. Better yet, this is all possible to do within the GitHub web UI. In fact, you can build an entire GitHub Pages site without ever opening terminal or cloning the repo to your own machine. In this way, it closely approximates how you would work with something like Squarespace. Of course, I would not necessarily recommend doing this. You may want to preview something before you publish it. In that scenario, you would need to [build and preview your site locally](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/testing-your-github-pages-site-locally-with-jekyll), then `git push` the changes to be published.

I use GitHub pages as a sort of homepage for my open source projects. If you want to see an example, you can find the [repo here](https://github.com/jessesquires/jessesquires.github.io) and the [rendered site here](https://jessesquires.github.io). This is hosted on GitHub using one of their built-in templates. It's just a simple, single-page website.

If you are completely new to this, I would take some time to get acquainted with how GitHub Pages and [Jekyll](https://jekyllrb.com) work. Experiment, publish, iterate. Again, both have great tutorials and documentation, so I won't reproduce them here.

### Getting a custom domain

Once you feel comfortable working with and updating your site, the next big step will be [setting up a custom domain](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site) instead of using the `.github.io` subdomain. The good news is that the `.github.io` domain will automatically redirect to your new custom domain. So if you have already been sharing your site, don't worry about broken links.

I view this step as "committing" to your website, since this is where you'll start to spend money. Registering a domain is typically inexpensive, but I think it still represents a commitment. You have decided "yes, this is for me" and you want to continue. If you are not enthusiastic about continuing, you can stop here. You can even delete your repo, and thus, delete your website.

Any registrar will work. I use [NearlyFreeSpeech.net](https://www.nearlyfreespeech.net). The hardest part will be configuring the DNS records correctly, but the [GitHub guides](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site) should help. Whatever registrar you choose should also have guides, or at least easy-to-find settings to configure.

### A more advanced GitHub Pages site

At this point, you have a fully working website with a custom domain. That's awesome! The next big step will be implementing a custom design for your site instead of relying on the limited selection of GitHub Pages themes. This sounds much more intimidating than it is, but it can be tricky.

So far, GitHub Pages has hidden a lot of implementation details from you. As I mentioned before, it is built on [Jekyll](https://jekyllrb.com). So diving deeper means "lowering" into Jekyll directly. I recommend going through Jekyll's [step by step tutorial](https://jekyllrb.com/docs/step-by-step/01-setup/). Don't worry about your content, that will all be preserved. This step is only about abandoning your GitHub Pages theme and implementing a custom design.

The tutorial explains everything quite well, but I want to call out one thing. You'll be creating [layouts](https://jekyllrb.com/docs/step-by-step/04-layouts/), or templates. Note that layouts can inherit from other layouts. Another useful concept is [includes](https://jekyllrb.com/docs/includes/), which are reusable snippets of HTML. These are useful, for example, for building navigating menus or footers that should appear on every page.

If, like me, you are not a web designer, then designing a website sounds intimidating. However, there are many tools and frameworks to help. I've been using [Bootstrap](https://getbootstrap.com) for years, and I really enjoy it. It is a well-establish and well-maintained frontend library. Think of it like UIKit, but for your website. There are many of these types of frameworks, like [tailwind](https://tailwindcss.com) and [gatsby](https://www.gatsbyjs.com). Bootstrap has [excellent documentation](https://getbootstrap.com/docs/5.1/getting-started/introduction/) and a great [collection of examples](https://getbootstrap.com/docs/5.1/examples/). You'll use one of these frameworks to make your layout templates, then your workflow will be similar to GitHub Pages where you simply write markdown, then `git push` to publish.

If you would prefer to avoid a custom design from scratch, then I recommend checking out the vibrant collection of third-party themes at [JekyllThemes.io](https://jekyllthemes.io).

### Diving deeper: a custom Jekyll site

Now you have a custom-built, custom-themed website using Jekyll, which you host for free on GitHub Pages. This is what I used to have, but I eventually moved away from hosting on GitHub. I wrote about that [in-depth here]({% post_url 2017-09-10-building-a-site-with-jekyll-on-nfsn %}). Again, I [highly recommend NearlyFreeSpeech.net]({% post_url 2021-03-02-a-web-host-worth-using %}) for hosting, but they are very bare-bones and DIY. If using them, expect to spend some time learning about hosting, DNS, and general web technologies, as well as trouble-shooting issues.  After a few years hosting on GitHub Pages, I feel like I simply outgrew it as I started to run into various limitations and desired more control. That's why I decided to host my website elsewhere. You may never get to this point, and that's fine.

If you want to dive _even deeper_ into Jekyll, you'll need to learn some [Ruby](https://www.ruby-lang.org/en/). Jekyll is written in Ruby and its templating language is called [Liquid](https://jekyllrb.com/docs/liquid/). One neat, more advanced feature of Jekyll is writing [custom plugins](https://jekyllrb.com/docs/plugins/), which are written in Ruby. This allows you to extend Jekyll itself.

I should also note that if you prefer not to design your own site, you can keep using the GitHub Pages theme you originally selected, even if you are not hosting on GitHub. To do this, you'll need to include the [GitHub Pages gem](https://github.com/github/pages-gem) instead of plain [Jekyll](https://github.com/jekyll/jekyll).

### Other resources

I occasionally write about [Bootstrap]({{ "bootstrap" | tag_url }}) and [Jekyll]({{ "nearlyfreespeech" | tag_url }}) on this blog. You may find those posts interesting as you advance.

This entire website [is open source]({{ site.data.github.repo }}) if you need examples or want to see how all the pieces fit together. My only request is that you don't reproduce an exact (or near-exact) copy of my site. The intent is to learn from it, not to duplicate it.

Finally, I maintain a [template repo on GitHub](https://github.com/jessesquires/template-jekyll-site) that you can use to get started on a more advanced site using Jekyll and Bootstrap.

### Alternatives

As I mentioned before, the mainstream platforms might be a better fit for what you are trying to achieve. If that's the case, you should not feel like have to do something more technical just because you're a software developer. Good software developers choose the right tool for the job.

One alternative that is similar to Jekyll would be using John Sundell's [Publish](https://github.com/johnsundell/publish), which is a static site generator written in Swift. This might appeal more to iOS developers. You could write your entire site in Swift. I do not have any experience with this, but I'm sure you can find tutorials, examples, and guides online. [Kaya Thomas](https://twitter.com/kthomas901/status/1284692707537858561) used Publish for [her personal website](https://kaya.dev), and I think it looks great. And of course, [Swift by Sundell](https://www.swiftbysundell.com) uses Publish, if you want another example.

However, if you have the time, patience, and interest then I highly encourage you to explore a new technology stack. If you are primarily an iOS developer, building your own website with Jekyll is great way to explore something completely different.
