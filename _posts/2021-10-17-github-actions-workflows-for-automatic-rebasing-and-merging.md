---
layout: post
categories: [software-dev]
tags: [ci, github-actions, github, automation]
date: 2021-10-17T15:32:28-07:00
date-updated: 2022-04-13T12:26:15-07:00
title: GitHub Actions workflows for automatic rebasing and merging
---

This post continues from my earlier post on [label-based GitHub Actions workflows]({% post_url 2021-08-24-useful-label-based-github-actions-workflows %}). A common and tedious task in a typical pull request workflow is updating your branch with changes from the default branch of your repo. In many scenarios, you may want to rebase your pull request on the main branch or merge the main branch into your pull request.

<!--excerpt-->

Perhaps there are improvements from the main branch that you want incorporated into your pull request, or maybe you want to re-run the entire test suite with your changes and the latest changes from the main branch. It could also be the case that you require branches to be up-to-date before merging. With the way I work, this is a pain. After I submit a pull request for review, I typically start a new branch to start working on something else immediately. Later on, if I need to rebase an existing pull request, then I must stash or commit my current changes, switch branches and rebase, push the changes, then switch back to what I was working on before the interruption.

One workaround to this is having multiple checkouts, where you do all the rebasing on the second checkout while leaving your current in-progress checkout untouched. This, however, is still tedious. If your branch has no conflicts with the main branch, then rebasing or merging can be fully automated. I've written two new workflows for each. This frees up my time to focus on things a machine can't do for me.

### Automatic rebasing

This workflow is triggered by adding a label called `rebase` to your pull request. It uses the [automatic-rebase action](https://github.com/marketplace/actions/automatic-rebase) to perform the rebase, and [actions-ecosystem-remove-labels action](https://github.com/marketplace/actions/actions-ecosystem-remove-labels) to remove the label when complete. To use this, you'll need to add the `rebase` label to your repo. If you'd like to use a different label name you can, just be sure to edit the workflow accordingly. You'll also need to add a [personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).

{% raw %}
```yaml
name: Rebase Pull Request

on:
  pull_request:
    types: [labeled]

jobs:
  main:
    if: ${{ github.event.label.name == 'rebase' }}
    name: Rebase
    runs-on: ubuntu-latest
    steps:
      - name: git checkout
        uses: actions/checkout@v2
        with:
          token: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
          fetch-depth: 0

      - name: automatic rebase
        uses: cirrus-actions/rebase@1.5
        env:
          GITHUB_TOKEN: ${{ secrets.PERSONAL_ACCESS_TOKEN }}

      - name: remove label
        if: always()
        uses: actions-ecosystem/action-remove-labels@v1
        with:
          labels: rebase
```
{% endraw %}

### Automatic merging

If you would rather merge the main branch into your pull request instead of rebase, I wrote a workflow for that too. I've titled it "Merge Main into PR", but if your default branch is named differently, you can change this. You do not need to worry about updating the workflow based on what you've named your default branch, the workflow will detect the default branch name automatically. Similar to the rebase workflow, this one is triggered by adding a label named `merge main`. Again, you can adjust this as needed for your own configuration. And finally, this also removes the label when finished.

Note that I've generously used `git status` during the merge to make debugging easier if something goes wrong.

{% raw %}
```yaml
name: Merge Main into PR

on:
  pull_request:
    types: [labeled]

env:
  DEFAULT_BRANCH: ${{ github.event.repository.default_branch }}

jobs:
  main:
    if: ${{ github.event.label.name == 'merge main' }}
    name: Merge Main
    runs-on: ubuntu-latest
    steps:
      - name: git checkout
        uses: actions/checkout@v2
        with:
          token: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
          ref: ${{ github.event.pull_request.head.ref }}
          fetch-depth: 0

      - name: perform merge
        run: |
          git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
          git config --global user.name "${GITHUB_ACTOR}"
          git status
          git pull
          git checkout "$DEFAULT_BRANCH"
          git status
          git checkout "$GITHUB_HEAD_REF"
          git merge "$DEFAULT_BRANCH" --no-edit
          git push
          git status

      - name: remove label
        if: always()
        uses: actions-ecosystem/action-remove-labels@v1
        with:
          labels: merge main
```
{% endraw %}

### Collecting useful workflows

When combined with the workflows [from my previous post]({% post_url 2021-08-24-useful-label-based-github-actions-workflows %}), I have started to accumulate a decent collection of general-purpose workflows. To keep track, I created a new repo to house them all and track changes, which [you can find here](https://github.com/jessesquires/gh-workflows). All you need to do is copy them to `.github/workflows/` in your own repo, and edit them as needed. The current workflows are centered around automating tedious aspects of managing pull requests, but one can imagine all kinds of use cases for managing GitHub issues, releases, and more. As I write new workflows, I'll be sure to include them in this project.

{% include updated_notice.html
date="2022-04-13T12:26:15-07:00"
message="Good news, GitHub [now has these features built-in to pull requests](https://github.blog/changelog/2022-02-03-more-ways-to-keep-your-pull-request-branch-up-to-date/). You can use the \"Update branch\" button to either rebase or merge.

However, these label-based workflows can still be useful for performing these operations in large batches. For example, if you need to rebase many pull requests at once you could select them all and add the label rather than visit each pull request individually and click the \"Update branch\" button.
" %}
