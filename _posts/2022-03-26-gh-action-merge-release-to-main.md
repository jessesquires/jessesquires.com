---
layout: post
categories: [software-dev]
tags: [ci, github, github-actions]
date: 2022-03-26T18:49:28-07:00
title: Automate merging release branches into your main branch with GitHub Actions
---

A typical release process for Git workflows involves creating a release branch, performing various tests on that branch, and applying any necessary fixes or changes to that branch. Once stable and ready to release, you create a build from the release branch, create a git tag, and finally merge the release branch changes back into your main branch.

<!--excerpt-->

It isn't difficult to keep your branches in sync, but it is tedious. And sometimes, you need the fixes from your release branch back on your main branch immediately. Furthermore, if you want to try to avoid git conflicts, it is best to merge your release branch into your main branch frequently throughout your release process rather than waiting until the very end. This makes merging your release branch into your main branch a great task to automate. We can create a workflow using [GitHub Actions](https://github.com/features/actions) to do this for us.

The following workflow will create a pull request from `release/*` branches that targets the repository's default branch. It runs every time there is a push or merge to the release branch, which means you'll get any fixes or changes from `release/*` back into `main` almost immediately. And because it opens a pull request, it gives your team a chance to double-check and review the changes. It _does not_ handle conflicts (obviously), so if there are conflicts between `release/*` and `main`, you'll have to resolve those manually --- but that's what you would have to do without this automation anyway. However, in many scenarios, this should save you a lot of time.

{% raw %}
```yaml
name: Merge Release Into Main

on:
  push:
    branches:
      - 'release/*'

jobs:
  main:
    name: Create PR Release to Main
    runs-on: ubuntu-latest
    steps:
      - name: git checkout
        uses: actions/checkout@v3
        with:
          token: ${{ secrets.PERSONAL_ACCESS_TOKEN }}

      # https://github.com/marketplace/actions/github-pull-request-action
      - name: create pull request
        id: open-pr
        uses: repo-sync/pull-request@v2
        with:
          github_token: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
          destination_branch: ${{ github.event.repository.default_branch }}
          pr_title: "[Automated] Merge ${{ github.ref_name }} into ${{ github.event.repository.default_branch }}"
          pr_body: "Automated Pull Request"
          pr_reviewer: "jessesquires"
          pr_assignee: "jessesquires"

      # https://github.com/marketplace/actions/enable-pull-request-automerge
      - name: enable automerge
        if: steps.open-pr.outputs.pr_number != ''
        uses: peter-evans/enable-pull-request-automerge@v2
        with:
          token: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
          pull-request-number: ${{ steps.open-pr.outputs.pr_number }}
          merge-method: merge
```
{% endraw %}

You can customize this to fit your needs. For example, if you name your release branches differently than `release/*`, you'll need to make that change. You will also need to configure the title, description, reviewers, and assignees for the pull request. Also note that you'll need to configure a [personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) for everything to work properly.

The workflow uses two third-party actions, [GitHub Pull Request Action](https://github.com/marketplace/actions/github-pull-request-action) and [Enable Pull Request Automerge](https://github.com/marketplace/actions/enable-pull-request-automerge). The second one is particularly nice to have, because it will setup the pull request to automerge. This means all your team needs to do is approve the pull request, and after all CI status checks pass it will merge automatically.

I hope this helps improve your release process! If you enjoyed this post, check out my [other posts about GitHub Actions]({{ "github-actions" | tag_url }}). You can also find my collection of GitHub Actions workflows [on GitHub here](https://github.com/jessesquires/gh-workflows).
