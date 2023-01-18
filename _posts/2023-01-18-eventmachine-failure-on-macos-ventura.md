---
layout: post
categories: [software-dev]
tags: [ruby, web, jekyll, website-infra, bundler, macos-ventura]
date: 2023-01-18T14:47:56Z
title: "Fix: eventmachine gem failed to build on macOS Ventura with Ruby 2.7.6"
---

After [upgrading to macOS Ventura]({% post_url 2023-01-18-upgrading-to-macos-ventura %}), I decided to upgrade my Ruby version and ran into issues trying to build my site locally.

<!--excerpt-->

As I've [written before]({% post_url 2017-09-10-building-a-site-with-jekyll-on-nfsn %}), I use [Jekyll](https://jekyllrb.com) to build this site and I host with [NearlyFreeSpeech](https://www.nearlyfreespeech.net). I was upgrading to Ruby 2.7.6, which I realize is old and near its [end of life](https://endoflife.date/ruby). However, this is the version installed on NearlyFreeSpeech and I need my local environment to match that. Because of how NearlyFreeSpeech operates, I cannot upgrade Ruby on my server on my own. Instead, I must wait for the sysadmins to perform upgrades. It's not ideal, but I rarely have issues. Overall their service is stable and inexpensive, so I have no complaints.

Anyway, installing a new version of Ruby on my Mac meant I needed to perform a fresh `bundle install`, and that's where the trouble started. Most of the time this "just works" because I'm diligent about staying up-to-date. However, my `bundle install` failed with the following error:

```
Gem::Ext::BuildError: ERROR: Failed to build gem native extension.

current directory: /usr/local/var/rbenv/versions/2.7.6/lib/ruby/gems/2.7.0/gems/eventmachine-1.2.7/ext
/usr/local/var/rbenv/versions/2.7.6/bin/ruby -I /usr/local/var/rbenv/versions/2.7.6/lib/ruby/site_ruby/2.7.0 extconf.rb

[....]

An error occurred while installing eventmachine (1.2.7), and Bundler cannot continue.

In Gemfile:
  jekyll-archives was resolved to 2.2.1, which depends on
    jekyll was resolved to 4.3.1, which depends on
      em-websocket was resolved to 0.5.3, which depends on
        eventmachine
```

A transitive dependency from Jekyll, [`eventmachine`](https://rubygems.org/gems/eventmachine/) 1.2.7, failed to install because it could not build native extensions. These problems are no fun to debug, especially because I am not a Ruby expert. Luckily, after some searching online, I found [a solution here](https://github.com/eventmachine/eventmachine/issues/960#issuecomment-1332076385). If you also run into this problem, you need to install `eventmachine` with the following flags:

```bash
gem install eventmachine -v '1.2.7' -- --with-ldflags="-Wl,-undefined,dynamic_lookup"
```

After this, `bundle install` succeeded!
