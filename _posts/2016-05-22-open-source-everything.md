---
layout: post
title: Open source everything
subtitle: Getting meaningful contributions to move your projects forward
redirect_from: /open-source-everything/
---

I recently had an incredible experience with one of my open source projects that I'd like to share. It's a story of openness and collaboration that I hope other open source project maintainers will find valuable. This post continues the theme of "building successful open source projects" from my [previous article](/swift-documentation/) on documentation.

<!--excerpt-->

### The story

A couple of weeks ago, I released the fourth major version of [JSQCoreDataKit](https://github.com/jessesquires/JSQCoreDataKit/releases/tag/4.0.0). This release contained a number of improvements and breaking changes &mdash; a redesigned Core Data stack and a lot of refactoring to bring the library in line with the latest [Swift API Guidelines](https://swift.org/documentation/api-design-guidelines/). It was a big step forward for the library and **I barely wrote any code** for this release. That's right. [Sébastien Duperron](http://code-craftsman.fr/about/) ([**@Liquidsoul**](https://github.com/Liquidsoul)) pretty much completed the entire release for me. All I had to do was review and merge his [pull requests](https://github.com/jessesquires/JSQCoreDataKit/pulls?q=is%3Apr+author%3ALiquidsoul+is%3Aclosed).

The release was seamless and free of regressions. So, how did we do this?

<img class="img-thumbnail img-responsive center" src="{{ site.img_url }}/success_release.jpg" title="No regressions" alt="No regressions"/>

### The *other* kind of documentation

The success of this release was the result of a number of attributes about this project:

1. It has [100% API documentation](http://www.jessesquires.com/JSQCoreDataKit/)
2. It has [96% test coverage](https://codecov.io/gh/jessesquires/JSQCoreDataKit)
3. It has [continuous integration](https://travis-ci.org/jessesquires/JSQCoreDataKit) with Travis CI
4. [All issues](https://github.com/jessesquires/JSQCoreDataKit/issues?utf8=✓&q=is%3Aissue) are organized, labeled, and clearly explained
5. Each release has a corresponding [milestone](https://github.com/jessesquires/JSQCoreDataKit/milestones?state=closed) that groups the issues going into it

Collectively, *all* of these things serve as *documentation* &mdash; not just the API documentation itself. By keeping a project organized in this fashion, you can empower *anyone* to easily and successfully contribute.

With excellent API documentation and test coverage, contributors can fix bugs and add features without worrying about breaking something. Together, the docs and tests provide the complete picture for how your APIs should behave. Continuous integration keeps this in check by regularly running tests for each change, and notifying you of any regressions in test failures or test coverage. Once [travis-ci](https://travis-ci.org/jessesquires/JSQCoreDataKit) and [codecov.io](https://codecov.io/gh/jessesquires/JSQCoreDataKit) were green for each pull request, I was **certain** that it was safe to merge. To me, this is the most liberating feeling in software development.

<img class="img-thumbnail img-responsive center" src="{{ site.img_url }}/tests_pass.jpg" title="All tests pass" alt="All tests pass"/>

### Transparency via issues and milestones

I work diligently to keep issues [labeled](https://github.com/jessesquires/JSQCoreDataKit/labels) and grouped in [milestones](https://github.com/jessesquires/JSQCoreDataKit/milestones?state=closed). I try to explain a task as clearly as possible, so that anyone could read it and know what to do. I open issues for **everything** &mdash; bugs, features, todo items, refactors, future work, random ideas, and anything else. For me, issues serve not only as a way to track work for a project, but to communicate with the open source community about where I want to take a project. I also use issues as reminders for myself, and as forums for discussions or questions.

Milestones allow the community to clearly see the changes made in past, present, and future releases. Using milestones also makes it easier to write a [changelog](https://github.com/jessesquires/JSQCoreDataKit/blob/develop/CHANGELOG.md) for each release.

With all of the above, the project becomes entirely transparent. The community knows everything that I know. Discussions on design decisions are open source, questions and their answers are open source &mdash; **nothing is a secret**. Everyone has all of the information they need to take an issue to work on and submit a pull request for it, and they can be confident in their changes because of [travis-ci](https://travis-ci.org/jessesquires/JSQCoreDataKit) and [codecov.io](https://codecov.io/gh/jessesquires/JSQCoreDataKit). I believe this kind of transparency is the foundation of successful open source projects.

### Easier said than done

So that's what happened. Sébastien was able to synthesize and navigate all of the information and resources on GitHub, and submit a pull request for each issue for the `4.0.0` release of JSQCoreDataKit. We had some discussion and I made few gardening passes to clean up some documentation and formatting, but I mostly sat back and watched. I cannot express how thankful I am for his contributions, and how much time he saved me. The upfront cost of writing tests and docs, and keeping the project extremely organized paid off.

Finally, I must admit that everything I have outlined here is much easier said than done. Keeping documentation and test coverage at or near 100 percent is challenging. Keeping GitHub issues, milestones, and pull requests organized is challenging. It takes time and effort to maintain any open source project, no matter how big or small it might be. But if you do these things then the future of your project will be bright, and the cost of maintaining it will diminish dramatically. You'll find it easier to merge pull requests and release new versions faster.

Remember, *writing the actual code is only __half__ of the work.*
