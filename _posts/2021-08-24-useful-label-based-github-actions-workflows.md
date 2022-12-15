---
layout: post
categories: [software-dev]
tags: [ci, github-actions, github, automation]
date: 2021-08-24T22:08:13-07:00
date-updated: 2022-03-21T10:48:00-07:00
title: Useful label-based GitHub Actions workflows
---

My current team has started using GitHub Actions to automate some tedious tasks for pull requests. In particular, we use labels on GitHub to categorize pull requests or highlight important metadata about them. Most of the time, a machine can figure out which labels are appropriate to add or remove. This is a great use case for GitHub Actions.

<!--excerpt-->

### Labeling stacked pull requests

One common workflow (or problem, depending on how you view it) in git and GitHub is stacking pull requests. This is necessary when you have multiple pull requests that depend on each other and must merge into your main branch sequentially. For example, pull request `A` is opened to merge into `main`, pull request `B` is opened to merge into `A`, pull request `C` is opened to merge into `B`, and so on. After `A` is merged, `B` must be updated to merge into `main`, and so on.

We like to highlight this and make it obvious. We have a brightly colored `stacked PR` label, which communicates to the reviewer _"hey! this PR is part of a stack, just so you know."_ It is tedious to repeatedly manually add and remove this label for every pull request in the stack, so I wrote this workflow to automate it.

{% raw %}
```yaml
name: Label stacked PRs

on:
  pull_request:
    types: [synchronize, opened, reopened, edited, closed]

env:
  BASE_BRANCH: ${{ github.base_ref }}

jobs:
  remove-labels:
    runs-on: ubuntu-latest
    steps:
      - name: remove labels
        uses: actions-ecosystem/action-remove-labels@v1
        if: env.BASE_BRANCH == 'main'
        with:
          github_token: ${{ github.token }}
          labels: stacked PR

  add-labels:
    runs-on: ubuntu-latest
    steps:
      - name: add labels
        uses: actions-ecosystem/action-add-labels@v1
        if: env.BASE_BRANCH != 'main'
        with:
          github_token: ${{ github.token }}
          labels: stacked PR
```
{% endraw %}

This workflow contains two jobs that are nearly identical. The first checks if the pull request is merging into the `main` branch, and if so, it will remove the `stacked PR` label, if present. The second job does the opposite, it will add the `stacked PR` label to any pull request that is not targeting the `main` branch. It uses two actions from the [Actions Ecosystem](https://github.com/actions-ecosystem) community project, [add-labels](https://github.com/marketplace/actions/actions-ecosystem-add-labels) and [remove-labels](https://github.com/marketplace/actions/actions-ecosystem-remove-labels).

### Do Not Merge

Another important label we have is `do not merge`, which (unsurprisingly) indicates that a pull request should not be merged. Despite the label being a striking bright red, it could still be overlooked if all of our other CI status checks pass and you see that tempting, big green "merge" button on GitHub. It would be much safer if adding this label would **fail** the pull request to prevent you from merging it. We can write a workflow to do that using Michael Heap's [required-labels action](https://github.com/marketplace/actions/require-labels).

```yaml
name: Do Not Merge

on:
  pull_request:
    types: [opened, reopened, labeled, unlabeled]

jobs:
  do-not-merge:
    runs-on: ubuntu-latest
    steps:
      - name: check labels
        uses: mheap/github-action-required-labels@v1
        with:
          mode: exactly
          count: 0
          labels: "do not merge"
```

This will check if the pull request has the `do not merge` label. If it does, the workflow will fail. Once you remove the label, the workflow will pass.

To make this workflow actually prevent merging requires a few extra steps. You need to set up [branch protection rules](https://docs.github.com/en/github/administering-a-repository/defining-the-mergeability-of-pull-requests/managing-a-branch-protection-rule) for your main branch and require this workflow to pass before a pull request can be merged. Once configured, the "merge" button will only be enabled if this workflow succeeds.

{% include updated_notice.html
date="2022-03-21T10:48:00-07:00"
message="Thanks to my friend [Ben Asher](https://benasher.co) for [sharing](https://twitter.com/benasher44/status/1503460237331734528) an improvement to the 'Do Not Merge' workflow, which can be rewritten **without** using third-party actions. You can find it below.

Also, I've started maintaining a collection of useful workflows [on GitHub](https://github.com/jessesquires/gh-workflows). Check them out.
" %}

{% raw %}
```yaml
name: Do Not Merge

on:
  pull_request:
    types: [synchronize, opened, reopened, labeled, unlabeled]

jobs:
  do-not-merge:
    if: ${{ contains(github.event.*.labels.*.name, 'do not merge') }}
    name: Prevent Merging
    runs-on: ubuntu-latest
    steps:
      - name: Check for label
        run: |
          echo "Pull request is labeled as 'do not merge'"
          echo "This workflow fails so that the pull request cannot be merged"
          exit 1
```
{% endraw %}
