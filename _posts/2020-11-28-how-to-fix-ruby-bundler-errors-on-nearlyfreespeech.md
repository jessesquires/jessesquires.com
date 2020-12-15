---
layout: post
categories: [software-dev]
tags: [ruby, jekyll, web, bundler]
date: 2020-11-28T22:03:15-08:00
date-updated: 2020-12-15T11:15:49-08:00
title: "How to fix Ruby/Bundler error 'No such file or directory' on NearlyFreeSpeech.net"
---

Part of the joy of having a 'bare bones' DIY host is that sometimes you have to figure shit out on your own. I am not a great web developer, nor a Ruby expert. But, I learn more each time something breaks &mdash; you know, [Type II fun](https://www.rei.com/blog/climb/fun-scale). Most recently, I came to understand and fix a new error on my web server: `env: ruby26: No such file or directory`.

<!--excerpt-->

I previously [wrote about my website setup here]({{ site.url }}{% post_url 2017-09-10-building-a-site-with-jekyll-on-nfsn%}). The short version is: I use [Jekyll](https://jekyllrb.com), I host on [NearlyFreeSpeech](https://www.nearlyfreespeech.net), and I deploy with [git](https://git-scm.com) using a [post-receive hook](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks). The source is [mirrored on GitHub](https://github.com/jessesquires/jessesquires.com). Overall, it is very smooth and works great &mdash; except when it breaks.

It took two instances of this recent error for me to fully understand what was happening. I'll explain the error first, then discuss the solution.

#### The error: No such file or directory

A few months back, deploying with git suddenly stopped working. On GitHub you can view the [full source](https://github.com/jessesquires/jessesquires.com/blob/500d8847311dd0e6516442aa8f660b8ced803496/scripts/deploy_site.sh) of my `post-receive` git hook. [Bundler](https://bundler.io) was failing in the final step of the script:

```
bundle install --jobs 4 --retry 3

bundle exec jekyll build --destination $PUBLIC_WWW
```

with the following error:

```
env: ruby25: No such file or directory
*** Error code 127

Stop.
```

Prior to this, the last time I had published a post, everything was working. Now, suddenly, "ruby25" could not be found? More curious, if I simply ran `jekyll build`, it succeeded. Only when using Bundler, `bundle exec jekyll build`, was it producing the error.

I [posted on the member forums](https://members.nearlyfreespeech.net/forums/viewtopic.php?t=10725), but didn't fully grasp the answer provided. With some uncertainty, I decided to just redo/reconfigure my RubyGems setup (again, [described here]({{ site.url }}{% post_url 2017-09-10-building-a-site-with-jekyll-on-nfsn%})). After that, everything started working again, so I didn't give it much thought other than "lol computers". But then the error happened again a few days ago, though this time _slightly_ differently:

```
env: ruby26: No such file or directory
```
First `ruby25`, now `ruby26`. This second time around, I suddenly realized what had happened. Ruby was upgraded to a new version while the old Ruby version was removed, and Bundler was referencing the old version.

#### Debugging

NearlyFreeSpeech has this concept of [realms](https://faq.nearlyfreespeech.net/q/siterealm), which refers to "the combined collection of all the operating system files, programming languages, and third party applications present in its environment. These are the tools available to your site for web applications, and for use over ssh." Periodically, realms get updated and upgraded automatically (depending on your settings). When this happens NearlyFreeSpeech will notify you, but it usually has no impact on my site.

I realized that these "No such file or directory" errors were happening after realm upgrades. I ssh'd into my server, and ran `gem env`:

```
RubyGems Environment:
  - RUBYGEMS VERSION: 3.0.6
  - RUBY VERSION: 2.7.1 (2020-03-31 patchlevel 83) [amd64-freebsd11]
  - INSTALLATION DIRECTORY: /home/private/.gem
  - USER INSTALLATION DIRECTORY: /home/private/.gem/ruby/2.7
  - RUBY EXECUTABLE: /usr/local/bin/ruby27
  - GIT EXECUTABLE: /usr/local/bin/git
  - EXECUTABLE DIRECTORY: /home/private/.gem/bin
  - SPEC CACHE DIRECTORY: /home/private/.gem/specs
  - SYSTEM CONFIGURATION DIRECTORY: /usr/local/etc
...
```

The relevant information here is the path to the Ruby executable: `RUBY EXECUTABLE: /usr/local/bin/ruby27`. The output of `bundle env` was similar:

```
Bundler       2.1.4
  Platforms   ruby, amd64-freebsd-11
Ruby          2.7.1p83 (2020-03-31 revision a0c7c23c9cec0d0ffcba012279cd652d28ad5bf3) [amd64-freebsd11]
  Full Path   /usr/local/bin/ruby27
  Config Dir  /usr/local/etc
...
```

Ah ha! &mdash; `ruby27`. Now the original error made sense. Of course, `ruby26` could not be found. Ruby had been upgraded from 2.6 to 2.7, thus the old executable `ruby26` had been replaced with the new one, `ruby27`.

The obvious question here is why doesn't NearlyFreeSpeech keep multiple Ruby versions installed? I don't know. You get what you pay for, I guess? (And I pay about $1.66 USD per month. \*shrugs\*)

#### The solution

To fix the problem, I ssh'd into my server and reinstalled Bundler: `gem install bundler`. Then, I re-ran `bundle install` for the first time. These two steps reinstalled everything for the new Ruby version, and now everything was working again. (This also explains why my previous decision to redo my entire RubyGems setup worked.)

I'm not entirely sure how/why Bundler was referencing the old Ruby executable. I'm assuming it caches this based on your first `bundle install`? Again, I am not a Ruby/Bundler expert, and I could not find anything about this [in the docs](https://bundler.io/docs.html). Can you specify a Ruby version for Bundler to use?

To prevent this error from happening in the future, I now run `gem install bundler` as part of my `post-receive` git hook. The next time that Ruby is updated, my deployment process should continue to "just work".

```
gem install bundler --no-document
bundle install --jobs 4 --retry 3

bundle exec jekyll build --destination $PUBLIC_WWW
```

It does feel somewhat awkward to install Bundler every time I deploy, but: (1) it works, (2) I'm not publishing new posts more than a couple times a week, if that, and (3) it is quite fast with `--no-document`. I think I might be able to improve this workflow using [bundle config](https://bundler.io/v2.1/man/bundle-config.1.html), but I'm not sure.

In any case, if you also host on NearlyFreeSpeech (which I strangely do recommend) and ran into this issue, I hope this helps. And if there is something I can improve here, let me know!

**UPDATE:** 

There's another possible solution here. You can [specify the Ruby version](https://bundler.io/gemfile_ruby.html) in your `Gemfile`.

```ruby
source 'https://rubygems.org'

ruby '2.7'

gem 'jekyll', '~> 4.0'
```

This will produce a hard failure when the Ruby version changes on NearlyFreeSpeech. Then you can update your `Gemfile` and local Ruby version, and redeploy your site.
