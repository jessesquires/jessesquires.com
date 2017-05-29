---
layout: post
title: Migrating to Swift 3
subtitle: Advice, tips, and warnings
redirect_from: /migrating-to-swift-3/
---

I spent most of my free time last weekend and a few days of last week on migrating my Swift code to Swift 3.0 &mdash; I migrated my open source projects as well as my private side projects. Overall, I would say my experience was "OK". It definitely could have been better, but I think the largest problem was overcoming the cognitive hurdle of seeing all the changes and errors from Xcode's migration tool at once. The best thing to do is wipe away the tears, put your headphones on, and start hacking. 🤓

<!--excerpt-->

<img class="img-thumbnail img-responsive center" src="{{ site.img_url }}/eidhof-programmer.jpg" title="A Swift programmer" alt="A Swift programmer"/>
<small class="text-muted center">A real-life Swift programmer, ready for migration. Photo taken just before migrating to Swift 3.0. (<a href="http://www.itworld.com/article/2892928/music-to-get-you-into-the-coding-groove.html">Source</a>)</small>

### Open source migration strategy

Here's my basic git workflow for migrating my open source libraries:

1. All normal development happens on the `develop` branch
2. Create a `swift2.3` branch from `develop` and run Xcode's migrator for Swift 2.3
3. Create a `swift3.0` branch **from the `swift2.3` branch** and run Xcode's migrator for Swift 3.0

This creates the following model:

{% highlight bash %}
o-----o develop (swift 2.2)
       \
        o-----o swift2.3
               \
                o-----o swift3.0
{% endhighlight %}

My plan for now is to keep these branches in sync like what you see above. That is, `swift2.3` will be ahead of `develop` and `swift3.0` will be ahead of `swift2.3`. The end goal will be to merge changes from each branch back into a single squashed commit on `develop` when the final release of Xcode 8 is out.

{% highlight bash %}
                           merge 2.3           merge 3.0
o------o                    o                    o-----------o develop
        \                  /                    /
         o--- swift2.3 ---o                    /
                           \                  /
                            o--- swift3.0 ---o
{% endhighlight %}

Each merge into `develop` will be a major release of the library. For example, if the library is currently at `v2.0`, then the Swift 2.3 merge will result in `v3.0` of the library and the Swift 3.0 merge will result in `v4.0` of the library. This ensures [semantic versioning](http://semver.org) and allows clients to safely migrate between versions *at their own pace* as they adopt the next version of Swift.

### Private projects

For my private projects, I migrated directly to Swift 3.0. I use [CocoaPods](https://cocoapods.org), so I migrated my dependencies first. This means following the steps above for each open source library (or private pod).

So far, the only dependencies I have for this project are my own libraries, which made this quite easy since I control all of the code. However, if you have third-party dependencies, then I would recommend opening an issue on the project to discuss migration plans with the current maintainers. I expect most popular projects are doing something similar to what I described above. For example, [AlamoFire](https://github.com/Alamofire/Alamofire) has a `swift2.3` and `swift3.0` branch. If needed, you can fork and migrate third-party libraries yourself &mdash; then submit a pull request or use your fork until the maintainers offer a solution. However, you should definitely reach out to project maintainers before submitting a pull request for migration.

Until Xcode 8 is final, you'll need to point your pods to these new branches:

{% highlight ruby %}
pod 'MyLibrary', :git => 'https://github.com/username/MyLibrary.git', :branch => 'swift3.0'
{% endhighlight %}

This tells CocoaPods to fetch the latest on the `swift3.0` branch, instead of the latest published version.

Once your dependencies and `Podfile` are updated, you can run `pod update` to bring in the Swift 3.0 versions of each library. *Then* you can migrate your main app. I suggest commiting all of this migration in a single commit &mdash; update all dependencies, migrate your app, then commit &mdash; to keep your history clean.

### Tips

These things probably go without saying, but it doesn't hurt to reiterate.

1. Make sure you have decent test coverage on the code you are migrating. The changes are **massive** and having a list of green checkmarks once the migration is over is the best way to ensure you haven't broken anything. ✅
2. Resist doing any other refactoring during the migration. Migrate, commit, **then** make *Swifty API* changes in a follow-up commit to bring your code up-to-date with the latest [API guidelines](https://swift.org/documentation/api-design-guidelines/).
3. If you haven't migrated yet, wait until *right after* the next beta. I made the mistake of migrating during beta 2 after it had been out for two weeks. The next day, beta 3 was released. 😅 The changes between the betas weren't as large as the initial migration, but they weren't trivial either &mdash; <strike>and the migrator doesn't work between betas, so you have to apply each Xcode fix-it individually.</strike> **Update: [the migrator does work between betas](https://twitter.com/clattner_llvm/status/757626936810057728), but you have to run it manually. (I thought I tried this, but I might be mistaken.)** I would rather have waited the extra day to migrate all at once with beta 3, then tackle the changes in beta 4 two weeks later.
4. **Do not** migrate everything in a single day. Accept that this is a multi-day task. I did one or two libraries in a day and then spent a few days migrating the full app. Commit or `git stash` a work-in-progress and resume the next day.
5. When in doubt about how to properly migrate a piece of code, consult the new swift-evolution [proposal status page](http://apple.github.io/swift-evolution/) to find the corresponding proposal. In the *Implemented for Swift 3* section, you'll find all of the proposals that have been implemented for Swift 3. Note that not all of these may be in the current beta yet.

### Bugs

Xcode's migration tool is not perfect. 😱 It would sometimes fail to migrate test targets, or only partially migrate app and framework targets. When this happens, you can attempt to run the tool again, but it's probably best to make changes manually. Here are some of the specific issues that I saw:

- Some expressions inside of `XCTAssert*()` did not migrate.
- Some expressions inside closures did not migrate.
- Sometimes `waitForExpectations(timeout:)` did not migrate.
- Migrating `NSIndexPath` to `IndexPath` when used in certain contexts often resulted in derpy things like `(indexPath as! NSIndexPath).section`.
- Enums with associated `NSDate` values migrated to `case myCase(Foundation.Date)` instead of `case myCase(Date)`.
- Sometimes `optional` protocol methods did not migrate, which can produce hard-to-find bugs.

### Conclusion

Migrating Swift code is as fun as fixing your CI servers for the *Nth* time and as exciting as waiting for an hours-long test suite to run on your local machine. Even [waiting for your code to compile](https://xkcd.com/303/) is probably more fun than migrating to Swift 3. 😄 When you first see all the changes and errors that the migrator produces, it will be cognitive overload. It's a lot to absorb at once. You can always find comfort in `git reset --HARD`, but you will have to migrate eventually. And when you finish, you'll feel great.

*This weekend* I got to spend my time writing Swift 3.0 code &mdash; not migrating it &mdash; and it was awesome.
