---
layout: post
title: Shipping Swift 3.0
subtitle: An update on my open source libraries
redirect_from: /shipping-swift-3/
---

I'm happy to share that all of my open source Swift libraries have (finally) been updated for Swift 3. If you've been waiting for any of these final releases, you can now run `pod update` or `carthage update` and relax &mdash; sorry it took so long! I wrote about [migrating to Swift 3](/migrating-to-swift-3/) a few months ago and this post shares the final results of the process that I outlined in there.

<!--excerpt-->

### New major releases

Each of my libraries have two new major releases &mdash; one for Swift 2.3 and one for Swift 3. This means if you were using version 3.x of a library, then the 4.0 release is for Swift 2.3 and the 5.0 release is for Swift 3. [Semantic versioning](http://semver.org) is key here. These are *major* new releases to prevent breaking clients. This means `pod update` won't pull these versions automatically, but it should notify you that new releases are available. You'll need to specify these new versions in your `Podfile` (or `Cartfile`).

This will allow you to update these libraries on your own time, without forcing you to migrate to Swift 3 immediately. However, note that **all future development** will be using **Swift 3** or higher. I will not be maintaining Swift 2.3 versions &mdash; these are merely intermediate releases to help you migrate to Swift 3 according to your own project's needs and timeline. New features and fixes will only be applied to the latest version of each library.

- [JSQDataSourcesKit](https://github.com/jessesquires/JSQDataSourcesKit/releases)
- [JSQCoreDataKit](https://github.com/jessesquires/JSQCoreDataKit/releases)
- [PresenterKit](https://github.com/jessesquires/PresenterKit/releases)
- [JSQWebViewController](https://github.com/jessesquires/JSQWebViewController/releases)
- [DefaultStringConvertible](https://github.com/jessesquires/DefaultStringConvertible/releases) (Note: this library was not updated to Swift 2.3, only Swift 3.0)

Updating so many libraries is time consuming, but the branching model outlined in [my previous post](/migrating-to-swift-3/) made it simple. Here's the final git flow:

1. The `swift2.3` branch is finished and ready
2. Squash and merge `swift2.3` into `develop`
3. Merge `develop` into `master`
4. Tag and release a new version for Swift 2.3
5. Rebase the `swift3.0` branch onto `develop` and resolve conflicts
6. The `swift3.0` branch is finished and ready
7. Squash and merge `swift3.0` into `develop`
8. Merge `develop` into `master`
9. Tag and release a new version for Swift 3.0

If the library was initially at version 2.0, here's the gist of what this looks like:

{% highlight bash %}
       v2 (Swift 2.2)       v3 (Swift 2.3)      v4 (Swift 3.0)
o------o--------------------o--------------------o--------------> develop/master
        \                  /                    /
         o--- swift2.3 ---o                    /
                           \                  /
                            o--- swift3.0 ---o
{% endhighlight %}

### Deprecations

Also note that a few of my libraries have been deprecated, which I wrote about [here](/swift-3-sherlocked-my-libraries/). These libraries were no longer valuable in general, or no longer needed in Swift 3.

- [GrandSugarDispatch](https://github.com/jessesquires/GrandSugarDispatch)
- [JSQNotificationObserverKit](https://github.com/jessesquires/JSQNotificationObserverKit)
- [JSQActivityKit](https://github.com/jessesquires/JSQActivityKit)

### Contribute

If you find any bugs or have any questions, please send me a pull request or open an issue!
