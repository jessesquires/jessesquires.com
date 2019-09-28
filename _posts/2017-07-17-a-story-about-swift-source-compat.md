---
layout: post
categories: [software-dev]
tags: [swift, open-source]
date: 2017-07-17T10:00:00-07:00
title: A story about Swift source compatibility
subtitle: How to add your projects to the swift-source-compat-suite and why you should
---

The Swift community has been through [some](http://furbo.org/2017/02/17/swift-changes-considered-harmful/) [rough](https://mozilla-mobile.github.io/ios/firefox/swift/core/2017/02/22/migrating-to-swift-3.0.html) [migrations](https://swift.org/migration-guide-swift3/). It is frustrating when your project no longer compiles because of API and syntax changes, but it is an entirely different story when your project seg faults the compiler. When that happens, you cannot simply run a migration tool or apply fix-its &mdash; your project is *broken* and there's little you can do until a fix is released. This is why the [swift-source-compat-suite](https://github.com/apple/swift-source-compat-suite) project was created.

<!--excerpt-->

### About Swift source-compat

The Swift Source Compatibility Test Suite was [announced](https://swift.org/blog/swift-source-compatibility-test-suite/) by Luke Larson a few months ago as part of the effort to maintain source compatibility in future Swift releases. The Swift team is *serious* about maintaining source compatibility to prevent additional painful migrations. This is paying off already. So far for the Swift 4 beta releases, complaints and frustrations in the community have been few and far between, especially compared to the Swift 2 to 3 transition period.

The way the suite works is rather simple. In the [repository](https://github.com/apple/swift-source-compat-suite), you'll find some Python scripts and a [project manifest](https://github.com/apple/swift-source-compat-suite/blob/master/projects.json) JSON file. The scripts read the project metadata from the manifest, do a `git clone` for each project, then build and run each one. The suite is run periodically on [Swift's CI system](https://ci.swift.org) and can be manually invoked on pull requests with `@swift-ci Please test source compatibility`.

### A project that kept on breaking

With respect to Swift source compatibility, I maintain a unique project. [JSQDataSourcesKit](https://github.com/jessesquires/JSQDataSourcesKit) originally broke in Xcode 8.3 beta 3 (`8W132p`). [It crashed](https://github.com/jessesquires/JSQDataSourcesKit/issues/95) with the now infamous `Segmentation fault: 11` error. This was *before* the swift-source-compat-suite existed. I'm no compiler expert and fixing this was beyond my ability, so I opened [a JIRA ticket](https://bugs.swift.org/browse/SR-4088). Within a week or so, [Slava came to the rescue with a fix](https://github.com/apple/swift/pull/7887). In the final release of Xcode 8.3, my project compiled.

Fast forward to a few weeks ago, and [the bug](https://bugs.swift.org/browse/SR-4088?focusedCommentId=25528&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-255288) reappeared in Xcode 9 beta 1 (`9M136h`) &mdash; a regression in the compiler. This time it was partially my fault &mdash; adding this project to swift-source-compat-suite had been on my *Todo* list for weeks. It would have caught this bug sooner. It is exactly the kind of project that should have been added seeing how it *literally exposed a source compatibility regression* in a previous Xcode beta. [*Fool me once*](http://idioms.thefreedictionary.com/Fool+me+once,+shame+on+you;+fool+me+twice,+shame+on+me), right? I [re-opened](https://bugs.swift.org/browse/SR-4088) the original task but there was not much activity on JIRA from the Swift team.

Shortly after this, I [opened a pull request](https://github.com/apple/swift-source-compat-suite/pull/54) to add my project to the source compatibility suite. After it was merged, a week later [Luke commented](https://bugs.swift.org/browse/SR-4088?focusedCommentId=25990&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-25990) on JIRA in the afternoon that they were hitting this bug in the source-compat suite. This seemed to get everyone's attention almost immediately. 😊 Remember, this is a high priority for Swift 4. By midnight that same day, [Slava had a fix ready](https://github.com/apple/swift/pull/10440)! Again!

In Xcode 9 beta 3 (`9M174d`), not only does this library compile again but now *we know the compiler will not regress again* for this specific issue &mdash; at least not without setting off alarms on [the Swift CI servers](https://ci.swift.org).

### Adding your project

Adding my project was easy. If you have not added your open source projects, you should. It will take you all of 5 minutes and about 20 lines of JSON. The return on this investment will be a much better experience migrating between Swift versions in the future, and you will be helping to prevent regressions in the compiler. All of the details are on [the Source Compatibility site](https://swift.org/source-compatibility/) and there are [plenty of examples](https://github.com/apple/swift-source-compat-suite/pulls?q=is%3Apr+is%3Aclosed) if you need them.

Here's what [my commit](https://github.com/apple/swift-source-compat-suite/pull/54) included:

{% highlight json %}
{
    "repository": "Git",
    "url": "https://github.com/jessesquires/JSQDataSourcesKit.git",
    "path": "JSQDataSourcesKit",
    "branch": "master",
    "maintainer": "[my email]",
    "compatibility": {
      "3.0": {
        "commit": "b764e341713d67ab9c8160929f46e55ad1e2ca07"
      }
    },
    "platforms": [
      "Darwin"
    ],
    "actions": [
      {
        "action": "BuildXcodeProjectTarget",
        "project": "JSQDataSourcesKit.xcodeproj",
        "target": "JSQDataSourcesKit-iOS",
        "destination": "generic/platform=iOS",
        "configuration": "Release"
      },
      {
        "action": "TestXcodeProjectScheme",
        "project": "JSQDataSourcesKit.xcodeproj",
        "scheme": "JSQDataSourcesKitTests",
        "destination": "platform=iOS Simulator,name=iPhone 6s"
      }
    ]
}
{% endhighlight %}

First, you define all of the metadata about your project and find a commit that compiles with Swift 3. If you tag your releases in git, this is as simple as navigating to your most recent [Swift 3-compatible](https://github.com/jessesquires/JSQDataSourcesKit/releases/tag/6.0.0) release and clicking on [the commit](https://github.com/jessesquires/JSQDataSourcesKit/commit/b764e341713d67ab9c8160929f46e55ad1e2ca07) in the GitHub web interface. This will show you the full commit SHA that you can copy and paste. If you don't tag releases, simply [browse through your commits](https://github.com/jessesquires/JSQDataSourcesKit/commits/develop) until you find one that is suitable.

Next, you define "actions" which are just `xcodebuild` commands. Fill-in the blanks for your project, target, destination, and scheme. That's all. You can compare the JSON above with the [project](https://github.com/jessesquires/JSQDataSourcesKit) that it's describing to learn more.

### Third time's a charm

It is clear to me that swift-source-compat-suite is extremely valuable. Without it there would be no way to guarantee that my project would not break *a third time* and that the Swift compiler would not regress *again*. I'm really glad the Swift team took the initiative to start this project and involve the community. Also, huge thanks to [Slava](https://twitter.com/slava_pestov) for saving my project &mdash; *twice*!
