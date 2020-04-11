---
layout: post
categories: [software-dev]
tags: [ci, danger, github, github-actions, open-source]
date: 2020-04-10T12:59:29-07:00
title: Running Danger on GitHub Actions
---

I have started using [GitHub Actions](https://github.com/features/actions) for CI for my newer open source projects. I recently setup [Danger](https://danger.systems) for the first time on GitHub Actions and it was quite easy. Here is how to do it.

<!--excerpt-->

You will need to follow Danger's [Getting Set Up](https://danger.systems/guides/getting_started.html) guide, which involves creating a bot account and [adding a new personal access token](https://github.com/settings/tokens/new) for it. After that, you will need to navigate to `Settings > Secrets` for your repo on GitHub, and add the personal access token you created as the value of the secret and name it `DANGER_GITHUB_API_TOKEN`. Technically, you could name this differently, but I think this is easiest to use this name to remember its purpose.

With the setup complete, all you need to do is implement your [workflow](https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions). Here is a template you can use for iOS or macOS projects, but with a few tweaks this can be used for any project.

{% raw %}
```yaml
# .github/workflows/danger.yml

name: Danger

on:
  pull_request:
    branches:
      - master
      - dev
env:
  DEVELOPER_DIR: /Applications/Xcode_11.4.app/Contents/Developer

jobs:
  job-danger:
    name: Review, Lint, Verify
    runs-on: macOS-latest
    steps:
      - name: git checkout
        uses: actions/checkout@v1

      - name: ruby versions
        run: |
          ruby --version
          gem --version
          bundler --version

      - name: cache gems
        uses: actions/cache@v1
        with:
          path: vendor/bundle
          key: ${{ runner.os }}-gem-${{ hashFiles('**/Gemfile.lock') }}
          restore-keys: |
            ${{ runner.os }}-gem-

      - name: bundle install
        run: |
          bundle config path vendor/bundle
          bundle install --without=documentation --jobs 4 --retry 3

      # additional steps here, if needed

      - name: danger
        env:
          DANGER_GITHUB_API_TOKEN: ${{ secrets.DANGER_GITHUB_API_TOKEN }}
        run: bundle exec danger
```
{% endraw %}

This workflow will only be triggered on pull requests, which is convenient. The first four steps are just boilerplate for [checking out the repo](https://github.com/actions/checkout), installing ruby gems, and [caching them](https://github.com/actions/cache/blob/master/examples.md#ruby---bundler). The final step is what executes `danger` and makes use of the `DANGER_GITHUB_API_TOKEN` secret that you created.

If your `Dangerfile` does not require any additional data, you can use this workflow as-is. Otherwise, you can add additional steps after the `bundle install` step and before the `danger` step. For example, suppose you need access to `xcodebuild` output for a specific Danger plugin, you can add a step that builds your project. For non-Xcode projects, the same applies. Add any additional steps you need before `danger` is called.

