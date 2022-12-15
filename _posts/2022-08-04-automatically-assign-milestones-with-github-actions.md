---
layout: post
categories: [software-dev]
tags: [ci, github, github-actions, release-process, automation]
date: 2022-08-04T17:16:57-04:00
title: Automatically assign milestones with GitHub Actions
---

One of the most important parts of software development is tracking changes. Documenting what is going into a release is necessary not only to simply know what changed and inform your users by writing good release notes, but also to track down issues when something goes wrong. If there's a new bug or a new crash in your latest release, you need to be able to quickly find the change that introduced the problem.

<!--excerpt-->

Of course, this is why we use version control like git. However, combing through raw commit history is tedious and often not the first tool we reach for. Instead, it is more common to look through merged pull requests. For most of my projects, we use [GitHub milestones](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/about-milestones) for release tracking. For each release we create a milestone, then we add all issues and pull requests to the milestone. This way, tracking changes is as easy as looking at the milestone --- and even non-programmers can navigate through all the changes in GitHub's web UI.

But adding a milestone to your pull request is tedious and easy to forget. Luckily, we can automate that.

#### Automate querying your current release version

The first step to complete is programmatically determining your current release version. For iOS and macOS projects, we can write a small script to do this. For other dev environments, you can do something similar.

```ruby
#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'Xcodeproj'

config = Xcodeproj::Config.new('Sources/xcconfigs/MyApp.xcconfig')
version = config.attributes['MARKETING_VERSION']

puts "#{version}"
```

This reads and prints the app version from your `.xcconfig` file. If you are only using an Xcode project file, you can use [fastlane's `get_version_number`](https://docs.fastlane.tools/actions/get_version_number/#get_version_number) to read the version from your app's plist. If your current version is `1.2.3`, this script will print "1.2.3".

#### Auto-assign milestones

Using the version script above, we can write a workflow to get the correct milestone and automatically assign that to our pull requests. This requires that your milestones are named exactly like your version numbers, for example "1.2.3".

{% raw %}
```yaml
name: Assign Milestone

on:
  pull_request:
    types: [opened, reopened]
  pull_request_target:
    types: [opened, reopened]

jobs:
  assign-milestone:
    runs-on: macos-12
    steps:
      - name: git checkout
        uses: actions/checkout@v3

      - name: ruby setup
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.0
          bundler-cache: true

      - name: set env variables
        run: |
          echo "app_version=$(./scripts/app_version.rb)" >> $GITHUB_ENV

      - name: set milestone
        uses: zoispag/action-assign-milestone@v2
        with:
          repo-token: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
          milestone: ${{ env.app_version }}
```
{% endraw %}

After setup, we use our script to get the version number and save that in an environment variable. Then we use that variable to select the correct milestone. This uses [action-assign-milestone](https://github.com/marketplace/actions/assign-a-milestone-to-pull-requests) from the GitHub Actions marketplace to set the milestone based on its name. With this, every time you open a pull request the GitHub Actions bot will set the milestone for you!

The cool part about this workflow is that it will "just work" for multiple branches and releases. Consider the following setup. You have a new version coming up and have created a milestone and release branch for it, `release/1.2.0`. Meanwhile, you continue to work on your `main` branch as well, which is now at version `1.3.0` and also has an associated milestone. Because GitHub workflows run in the context of the branch from which they are triggered, any pull request targeting `release/1.2.0` will be assigned to the "1.2.0" milestone and any pull request targeting `main` will be assigned to the "1.3.0" milestone. Neat!

If you enjoyed this post, you can find my other writing on GitHub Actions at the [#github-actions tag]({{ "github-actions" | tag_url }}), and you can find all of my GitHub Actions workflows [here on GitHub](https://github.com/jessesquires/gh-workflows).
