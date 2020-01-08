---
layout: post
categories: [software-dev]
tags: [xcode, git, github, ci]
date: 2020-01-06T11:03:45-08:00
title: Selecting an Xcode version on GitHub Actions CI
---

I have started using [GitHub Actions](https://github.blog/2019-08-08-github-actions-now-supports-ci-cd/) for CI on a new project as a replacement for my usual setup on [Travis CI](https://travis-ci.org). It generally seems to be much faster and more reliable so far. It also has an equivalent feature set, as far as I can tell. But one issue that I have run into is selecting a specific Xcode version, which is a bit cumbersome and not fully documented.

<!--excerpt-->

I searched GitHub's [workflow syntax documentation](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/workflow-syntax-for-github-actions) but did not find anything mentioning Xcode versions. I discovered the documentation that specifies [the software installed on GitHub-hosted machines](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/software-installed-on-github-hosted-runners). There is a [full spec for macOS](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/software-installed-on-github-hosted-runners#macos-1015) that lists all the installed software and SDKs, which is convenient and well-organized. It clearly specifies the available Xcode versions that are installed, but fails to mention how to specify one for your workflow.

The only option seemed to be adding a build step to run `xcode-select`. It did not seem correct. Given my experience with Travis CI and other similar services, not to mention the popularity of Apple platform projects on GitHub, I thought it was odd that GitHub would omit a way to configure this.

I resorted to an old strategy &mdash; the same one I used to learn how to setup Travis CI for the first time long ago &mdash; look at a popular Swift or Objective-C project and see how they are doing it. I noticed that [Alamofire](https://github.com/Alamofire/Alamofire) had recently switched from Travis CI to GitHub Actions, and the [answer was there](https://github.com/Alamofire/Alamofire/blob/9187007b0fd31b7419f42bfd175eff638b7c702c/.github/workflows/ci.yml#L18) in their workflow yaml file. Apparently, you can set the `DEVELOPER_DIR` environment variable. You can specify any version [listed here](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/software-installed-on-github-hosted-runners#xcode).

```yaml
name: CI
on: [push]
env:
  DEVELOPER_DIR: /Applications/Xcode_11.2.app/Contents/Developer

jobs:
  # specify jobs...
```

Now that I knew what I was looking for, I wanted to work backwards to find the docs. There is [this page on using environment variables](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/using-environment-variables), but there is no mention of `DEVELOPER_DIR`. In fact, I searched all of the GitHub docs on actions and workflows that I could find. There was no mention of `DEVELOPER_DIR` anywhere, *except* for [this GitHub community forum post](https://github.community/t5/GitHub-Actions/Selecting-an-Xcode-version/td-p/31105). Unsurprisingly, the question was asked by Jon Shier, who is a [top contributor to Alamofire](https://github.com/Alamofire/Alamofire/graphs/contributors) and the author of the change switching the project to GitHub Actions for CI.

Compared with other services, this feels odd and it is unclear why there is no explicit documentation for such a common and necessary task for Apple platform projects. However, the GitHub team [does seem to be responsive](https://github.com/actions/virtual-environments/issues/182) to feedback and feature requests. It would be great to see Xcode version selection improved, but at least it is possible.
