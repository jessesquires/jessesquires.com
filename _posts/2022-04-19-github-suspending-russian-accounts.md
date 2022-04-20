---
layout: post
categories: [software-dev]
tags: [github, git, open-source, politics]
date: 2022-04-19T17:59:36-07:00
title: GitHub can't be trusted. Or, how suspending Russian accounts deleted project history and pull requests
---

According to various reports ([[1]](https://www.pcmag.com/news/github-reportedly-suspends-accounts-related-to-sanctioned-russian-orgs), [[2]](https://techweez.com/2022/04/18/github-suspending-accounts-russian-developers/), [[3]](https://www.investing.com/news/cryptocurrency-news/github-suspends-accounts-of-russian-developers-linked-to-sanctioned-firms-2805302), [[4]](https://techthelead.com/russian-developers-get-their-github-accounts-suspended-lose-work-without-warning/)), GitHub is suspending accounts of Russian developers and organizations linked to or associated with organizations sanctioned by the US government over Russia’s invasion of Ukraine. But it appears that GitHub did not think this through entirely, because these account suspensions are fucking up my projects.

<!--excerpt-->

{% include break.html %}

First, some brief context and background.

I recently [took over as a lead maintainer]({% post_url 2022-04-17-quick-5-released %}) for two popular projects in the Apple developer community, [Quick](https://github.com/quick/quick) and [Nimble](https://github.com/quick/nimble). I _just released_ [version 5.0 of Quick](https://github.com/Quick/Quick/releases/tag/v5.0.0) a few days ago. During the week leading up to the release, I was reviewing and merging many pull requests. But when it came time to write the release notes, I noticed very bizarre behavior. Mysteriously, some pull requests were **deleted**. Poof. Gone. Then I realized that an entire contributor's presence had disappeared --- all of their comments on issues were missing, all of the issues they opened were gone, all of the pull requests they opened had vanished. Every piece of activity related to the user was gone. What the fuck?!

As an example, you can see this line from GitHub's [auto-generated release notes](https://github.com/Quick/Quick/releases/tag/v5.0.0):

> [**@BobCatC**](https://github.com/BobCatC) made their first contribution in [#1129](https://github.com/Quick/Quick/pull/1129)

Both the user account and the pull request result in a 404. But you can find [the merge commit here](https://github.com/Quick/Quick/commit/a0a5fc857cea079fbe973e4faa80b6ceaf17bd46), which is all that's left in terms of an historical accounting of this change. It's particularly notable for this project because PR #1129 was a critical bug fix.

Today, maintainer [Rachel Brindle](https://github.com/younata) opened [a pull request](https://github.com/Quick/Quick/pull/1143) with another important bug fix, but lamented the fact that the _original pull request_ that had introduced the bug had since been deleted:

> The original PR that introduced it has since been deleted, so I'm unsure exactly of the intention of that contribution.

So here I am for the past few days wondering what the fuck is going on. Why are **multiple** users and pull requests disappearing from our project? My gratitude goes out to [Tomasz Sapeta](https://github.com/tsapeta) for [helping us realize](https://github.com/Quick/Quick/pull/1143#issuecomment-1103079607) that all of these mysterious disappearances are due to GitHub flippantly suspending the accounts of Russian developers without any regard for the destructive side effects.

There are multiple contributors to Quick whose accounts have been suspended, which means we have lost everything they contributed aside from raw commit history.

{% include break.html %}

It is unclear to me what GitHub's intended result was with these account suspensions, but it appears to be incredibly destructive for any open source project that has interacted with a now-suspended account. On a service like Twitter, you can visit the placeholder profile of a suspended account and see a message communicating that the account is suspended, and other users' @mentions of the account still link to the suspended account's profile. On GitHub, that's not how it works at all.

Apparently, "suspending an account" on GitHub actually means **deleting all activity for a user** --- which results in (1) every pull request from the suspended account being **deleted**, (2) every issue opened by the suspended account being **deleted**, (3) every comment or discussion from the suspended account being **deleted**. In effect, the user's entire activity and history is evaporated. **All of this valuable data is lost.** The only thing left intact is the raw Git commit history. It's as if the user never existed.

Again, at this time it is not clear to me if the data loss was GitHub's goal or if this was a mistake. Either way, it's a massive problem. Deleting this data with no notice is an abuse of trust. Should we continue to trust GitHub with important data?

{% include break.html %}

This has been absolutely perplexing because there was no notification or communication from GitHub about this, aside from [their generic statement](https://github.blog/2022-03-02-our-response-to-the-war-in-ukraine/) in which they claimed _"we are continuing to ensure free open source services are available to all, including developers in Russia."_ So much for that. I've been working for only a week or so on this project that I inherited, trying to diligently keep track of changes like a good maintainer, and then all kinds of peculiar and unexpected weird shit started happening. Unbeknownst to me, GitHub was quietly joining the rest of the western world in its crusade to punish innocent Russian civilians whose only crime was being born in the wrong place and maybe being formerly associated with a bank that is now being sanctioned. Fuck Putin, but I don't see how deleting GitHub accounts and causing food shortages for civilians is "winning" for anyone. As far as I could tell, the now-missing contributors were just ordinary iOS and macOS developers interested in contributing to a community open source project.

These actions from GitHub are harmful and damaging to open source projects and the open source community. All of a sudden, I was seeing pull requests, issues, and comments disappear from users who were actively contributing to the project. **We lost valuable contributions, information, context, and discussion history** on issues and pull requests. We even lost pull requests that were open and under active review. That work is now entirely lost. Gone forever. For pull requests that _did_ merge, we have the raw commit history --- but that is not a substitute for a full code review and discussion.

{% include break.html %}

It's hard enough to maintain open source projects. It's even harder to inherit an old, somewhat neglected project and try to get it back on track. In that scenario, every single pull request, issue, and comment is important for the long-term maintenance and success of the project. Comments, discussions, and code reviews provide valuable context that is not always captured in the commit history --- especially for open source projects that have cycled through multiple maintainers over the years. I think a proper solution from GitHub would have been to leave all contributions intact, freeze the suspected accounts to prevent future activity, and clearly mark the account profile pages as suspended. And then, when possible, flip the switch to fully re-enable the accounts. But apparently GitHub thought the best thing to do was delete it all.

So, thank you GitHub for royally fucking this up.
