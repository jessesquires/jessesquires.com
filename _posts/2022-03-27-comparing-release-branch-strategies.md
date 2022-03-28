---
layout: post
categories: [software-dev]
tags: [git, release-process]
date: 2022-03-27T17:01:49-07:00
title: Comparing release branch strategies
---

My [previous post]({% post_url 2022-03-26-gh-action-merge-release-to-main %}) sparked some questions and discussion around release branch strategies. There are two main strategies that I know about that I've used on different teams and projects. I think it's worth elaborating on the differences between the two, especially when considering different types of automation for managing releases, [which was the topic of my previous post]({% post_url 2022-03-26-gh-action-merge-release-to-main %}).

<!--excerpt-->

Generally, a release process involves creating a release branch and letting it "soak" for some period of time, usually a week or two. During that time, various tests are performed (automated and/or manual), and anything broken gets fixed. At some point, you decide everything is ready to go and you publish your app or deploy your website. Regarding your release process, one of the primary tasks is to determine _where_ and _how_ those fixes occur.

### Notes on terminology

For the rest of this post I’ll assume Git is the version control system and refer to the primary/default branch as `main` and the release branch as `release/*`, indicating a naming pattern like `release/1.5.3`.

A "hot-fix release" refers to a quick follow-up release that addresses a critical bug in the primary release. For example, if you release version `3.2.0` of your app and then discover a crash affecting a large portion of users, then you would fix the issue and release version `3.2.1` as soon as possible.

Whether you use Git or not, the general concepts here should transfer easily to other systems, like Mercurial. Regarding the release strategies, I'm not sure if there are "official" names for them, but I'll be referring to them as the "cherry-pick to release" strategy and the "merge release to main" strategy.

### Cherry-pick to release

In this strategy you branch `release/*` from `main` and never look back. The release branch is **never** merged back into `main`. When complete, the release can be tagged in Git for historical bookkeeping. Usually the release branch lives on, either indefinitely or until it is determined that it is safe to delete and no follow-up hot-fix releases will be needed.

Development continues on `main` at full speed. Any issue that occurs on `release/*` gets fixed on `main` **first** and then those commits get cherry-picked into `release/*`. If the branches have sufficiently diverged or if there are conflicts during the cherry-pick, only then is the fix applied directly on `release/*` _separately_ from the fix that lands on `main` --- resulting in the branches diverging even further. But this divergence is not an issue because the branches are never merged. The result is that not all commits from `release/*` find their way back into `main`.

If a hot-fix release is needed, a hot-fix release branch is created from the primary `release/*` branch, and the rest of the process is the same for the hot-fix release branch.

The way to view this release strategy is that it is "main-centric". Your primary focus is on `main`, fixes are applied on `main`, and the `release/*` branch is off on its own and never interacts with other branches.

### Merge release to main

In this strategy, you branch `release/*` from `main` and continually keep the branches in sync. That is, the `release/*` branch is repeatedly merged back into `main` as fixes and changes land on `release/*` **first**. When complete, the release can be tagged in Git, there is one final merge from `release/*` back to `main`, and then the `release/*` branch can be deleted.

Primary development continues on `main`, but the two branches never diverge. All issues that occur on `release/*` are **fixed on the release branch first**, and then the branch gets merged back into `main`. If there are conflicts between the branches when attempting to bring the fixes back to `main`, those get resolved on an intermediate branch which is then merged into `main` and subsequently deleted. The result is that all commits (eventually) land back on `main` and `main` is always ahead of `release/*`.

If a hot-fix release is needed, you create a hot-fix release branch by branching from the Git tag of the release that needs to be patched. Then the same process continues.

The way to view this release strategy is that it is "release-centric". Any changes or fixes that happen on `release/*` get merged back into `main`, ensuring that `release/*` is (eventually) 0 commits ahead of `main`.

### Which is best?

There is no objective "best" option here when building your release process. Whichever works best will depend on your team and project configuration --- but those circumstances typically involve some forcing functions that will yield a clear answer for which one you should use.

In my experience, the "cherry-pick to release" strategy is most common on very large teams at very large companies, especially if you are working in a monorepo. In fact, I would say this strategy is essentially mandatory as the release process would otherwise be untenable. At Instagram/Facebook, we followed the "cherry-pick to release" method --- they have a monorepo that houses all of their code for all of their apps for all of their supported platforms, and there are thousands of people pushing dozens of commits every day. Attempting to continually merge a release branch back into `main` (for all apps for all platforms!) would be nearly impossible at that scale. Furthermore, they have built all kinds of custom infrastructure to support "main-centric" development only --- everything must land on `main` first and there's an entire pipeline to manage reducing conflicts while queuing up and landing thousands of commits daily. The "merge release to main" method simply is not feasible under these kinds of conditions. The main drawback of "cherry-pick to release" is that you end up dealing with divergent branches, which is more difficult conceptually.

At smaller companies and on smaller teams, the "merge release to main" method is most common --- and most appropriate, in my opinion. Too often small companies and teams attempt to emulate large companies, which are solving problems far beyond the scope of what a smaller company will ever encounter. So if your (small) team is trying to develop a release process, I recommend doing the simpler option first. I think the "merge release to main" strategy is much easier to comprehend conceptually, especially with regard to how Git branching works. This strategy is essentially a special case of the pull request workflow. On a small team, you don't have the vast amount of traffic on your branches that a large company has and your probability of conflicts is small, especially [when you automate]({% post_url 2022-03-26-gh-action-merge-release-to-main %}) merging `release/*` into `main`. Using this strategy produces a cleaner and more comprehensible Git history, and you can trim release branches safely and immediately. Since everyone on your team has an understanding of pull requests, that knowledge is directly transferrable to the release process.

The last thing to point out is that teams and projects tend to grow over time. While you may begin with the "merge release to main" option, eventually you might have no choice but to switch to the "cherry-pick to release" option. As your teams and projects change, so should your release process.
