---
layout: post
categories: [software-dev]
tags: [ci, danger]
date: 2020-12-15T11:53:14-08:00
title: Running multiple instances of Danger
---

For a client project that I've been working on, I recently integrated [Danger](https://danger.systems/ruby/) to automate pull requests for the team. I initially setup a single `Dangerfile` to run on CI, but soon after we had the need to split it up in order to run `danger` more than once for a single CI run.

<!--excerpt-->

There are many good reasons you may want to do this. Some Danger rules only require git or pull request metadata, while others depend on build and test results. For example, you may have Danger rules that check the git diff to ensure certain files are not changed, examine a pull request to suggest adding specific labels, or run a linter like SwiftLint. None of these rules require building and running a full test suite for your app. However, other rules might post build results, test failures, code coverage, or links to build artifacts. In this case, you would need these rules to run at the very end of your CI workflow. 

The benefit of splitting up your `Dangerfile` and running `danger` more than once is that you can provide feedback on a pull request much earlier. For example, linter errors can be posted almost immediately rather than waiting for an entire test suite to complete. At least for iOS projects, I have seen test suites with UI tests that run anywhere from 30 to 90 minutes. What a shame it would be for a pull request to be approved and for all tests to pass, only to have to push another commit (and thus re-run all the tests) to fix minor linting errors. Most CI services now offer the option to cancel a build as soon as you push a new commit to a pull request branch. Thus, getting early feedback on a pull request short-circuits your entire workflow, and saves you a lot of time.

To run `danger` multiple times, you'll need a separate `Dangerfile` for each run. You can name these however you like, for example `Dangerfile.preCI` and `Dangerfile.postCI`. Place the appropriate rules in each file. When you run `danger` you'll need to specify a `danger_id` &mdash; otherwise, the second run will **overwrite** the results from the first run, erasing any comments that `danger` had left on the pull request.

Finally, you will need to update your build scripts where you invoke `danger` on your CI service:

```bash
# Run first danger
bundle exec danger --dangerfile=Dangerfile.preCI --danger_id=PreCI

# Run second danger
bundle exec danger --dangerfile=Dangerfile.postCI --danger_id=PostCI
```
