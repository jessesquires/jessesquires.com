---
layout: post
categories: [software-dev]
tags: [ci, danger, github, github-actions, open-source, automation]
date: 2020-04-10T12:59:29-07:00
date-updated: 2022-03-28T10:48:49-07:00
title: Running Danger on GitHub Actions
---

I have started using [GitHub Actions](https://github.com/features/actions) for CI for my newer open source projects. I recently setup [Danger](https://danger.systems) for the first time on GitHub Actions and it was quite easy. Here is how to do it.

<!--excerpt-->

You will need to follow Danger's [Getting Set Up](https://danger.systems/guides/getting_started.html) guide, which involves creating a bot account and [adding a new personal access token](https://github.com/settings/tokens/new) for it. After that, you will need to navigate to `Settings > Secrets` for your repo on GitHub, and add the personal access token you created as the value of the secret and name it `DANGER_GITHUB_API_TOKEN`. Technically, you could name this differently, but I think this is easiest to use this name to remember its purpose.

With the setup complete, all you need to do is implement your [workflow](https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions). Here is a template you can use for iOS or macOS projects, but with a few tweaks this can be used for any project.

{% raw %}
```yaml
name: Danger

on:
  pull_request:
    types: [synchronize, opened, reopened, labeled, unlabeled, edited]

env:
  DEVELOPER_DIR: /Applications/Xcode_13.2.1.app/Contents/Developer

jobs:
  main:
    name: Review, Lint, Verify
    runs-on: macOS-latest
    steps:
      - name: git checkout
        uses: actions/checkout@v3

      - name: ruby versions
        run: |
          ruby --version
          gem --version
          bundler --version

      - name: ruby setup
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: 2.7
          bundler-cache: true

      # additional steps here, if needed

      - name: danger
        env:
          DANGER_GITHUB_API_TOKEN: ${{ secrets.DANGER_GITHUB_API_TOKEN }}
        run: bundle exec danger --verbose
  ```
{% endraw %}

This workflow will only be triggered on pull requests, which is convenient. The first four steps are just boilerplate for [checking out the repo](https://github.com/actions/checkout) and [setting up ruby](https://github.com/ruby/setup-ruby). The final step executes `danger` and makes use of the `DANGER_GITHUB_API_TOKEN` secret that you created.

If your `Dangerfile` does not require any additional data, you can use this workflow as-is. Otherwise, you can add additional steps after the `ruby setup` step and before the `danger` step. For example, suppose you need access to `xcodebuild` output for a specific Danger plugin, you can add a step that builds your project. For non-Xcode projects, the same applies. Add any additional steps you need before `danger` is called.

{% include updated_notice.html
date="2022-03-28T10:48:49-07:00"
message="This workflow has been updated to reflect various changes and improvements to GitHub Actions, namely by using the more modern approach to [setting up ruby and caching gems](https://github.com/ruby/setup-ruby).
" %}
