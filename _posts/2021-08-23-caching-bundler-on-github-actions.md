---
layout: post
categories: [software-dev]
tags: [bundler, ruby, gems, github-actions]
date: 2021-08-23T14:28:51-07:00
title: Caching Bundler on GitHub Actions
---

When GitHub actions first launched, the recommended way to cache your Bundler dependencies was to use GitHub's [cache action](https://github.com/actions/cache). However, that is no longer the case. You should be using the Ruby team's [setup-ruby action](https://github.com/ruby/setup-ruby) instead.

<!--excerpt-->

I'm not quite sure when this changed. Here's how you used to cache Bundler using [GitHub's cache action](https://github.com/actions/cache).

{% raw %}
```yaml
# workflow.yml

- name: cache gems
  uses: actions/cache@v2
  with:
    path: vendor/bundle
    key: ${{ runner.os }}-gem-bundler-${{ hashFiles('**/Gemfile.lock') }}
    restore-keys: |
      ${{ runner.os }}-gem-bundler-
```
{% endraw %}

Apparently, caching gems with Bundler is [not trivial](https://github.com/actions/cache/blob/main/examples.md#ruby---bundler) and actually [quite difficult](https://github.com/ruby/setup-ruby#caching-bundle-install-manually) to get correct. I don't know the details, but I do know that my GitHub workflows started failing in strange ways when attempting to use `actions/cache`. When updating gems and especially when updating Bundler to a new version, the caching would fail on GitHub's CI machines, which resulted in `bundle exec` failing because no gems could be found.

Migrating the above workflow step to use Ruby's [setup-ruby action](https://github.com/ruby/setup-ruby) is easy.

```yaml
# workflow.yml

- name: ruby setup
  uses: ruby/setup-ruby@v1
  with:
    ruby-version: 2.7
    bundler-cache: true
```

Not only is it simpler, but it works! I have been using this for a few months now it I have not had any issues. If you have old workflows that still use `actions/cache`, you should update them to use `ruby/setup-ruby` instead.
