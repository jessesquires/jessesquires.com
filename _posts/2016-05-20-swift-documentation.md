---
layout: post
title: Swift documentation
subtitle: Writing, generating, and publishing great docs in Swift
redirect_from: /swift-documentation/
---

The Swift community is ecstatic about Swift. There are so many new libraries being released each week that some have created [package indexes](https://swiftmodules.com) &mdash; even [IBM](https://developer.ibm.com/swift/products/package-catalog/). But of course, a library is only as great as its documentation.

<!--excerpt-->

### Successful open source projects

With open source, I've learned that if you want to encourage adoption of your library, then you need a few things:

1. A great library that solves a real problem for developers (of course!)
2. You need to build an open and supportive community around your project
3. Write excellent documentation that's easily accessible

If you look at any popular project (even outside of the Swift/Objective-C/Cocoa community), you'll find these common attributes. See [Alamofire](https://github.com/Alamofire/Alamofire), [CocoaPods](https://cocoapods.org), and [JSQMessagesViewController](https://github.com/jessesquires/JSQMessagesViewController).

This post will focus on the third item in that list above &mdash; documentation. First, we'll look at each step of creating documentation and then I'll share my complete workflow.

### Writing docs

Writing clear, understandable documentation is not easy to learn and it's more difficult to explain. The best way to learn write documentation is to *read* documentation. If writing a library for iOS, allow the [iOS documentation](https://developer.apple.com/library/ios/navigation/) to guide you. If writing a library in Swift, allow the [Swift documentation](https://developer.apple.com/library/ios/documentation/General/Reference/SwiftStandardLibraryReference/) to guide you. How do *those* authors explain certain concepts or parameter values? Search for APIs that are similar to the ones you have written for your library, and begin writing by mimicking others &mdash; whether that's Apple or other open source authors. Iterate until you arrive at something that unambiguously explains your API.

Here's an example from [JSQMessagesViewController](http://cocoadocs.org/docsets/JSQMessagesViewController/7.2.0/Protocols/JSQMessagesCollectionViewDataSource.html#//api/name/collectionView:messageDataForItemAtIndexPath:). It's not Swift, but it illustrates these ideas.

{% highlight objc %}
/**
 *  Asks the data source for the message data that corresponds to the specified item at indexPath in the collectionView.
 *
 *  @param collectionView The collection view requesting this information.
 *  @param indexPath      The index path that specifies the location of the item.
 *
 *  @return An initialized object that conforms to the `JSQMessageData` protocol. You must not return `nil` from this method.
 */
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath;
{% endhighlight %}

This reads very similarly to the `UICollectionViewDataSource` method `- collectionView: cellForItemAtIndexPath:`. It follows the precedent set by UIKit, not only in terms of the API design but also the documentation. Doing this allows your library to feel natural and familiar to users.

After enough imitation, you'll eventually find your own voice and get enough experience that you won't need to reference others' documentation in order to write your own. Writing documentation will begin to flow naturally. It might even be fun! 😉

Also, strive to provide [100% coverage](https://twitter.com/orta/status/471009574276050944). This is relatively easy to do. It's much easier than having 100% test coverage, for example. It's something to be proud of, and it will make you and your library feel complete.

One final tip &mdash; use [Wei Wang](https://github.com/onevcat)'s plug-in, [VVDocumenter-Xcode](https://github.com/onevcat/VVDocumenter-Xcode). This Xcode plug-in will generate the doc comment templates for you. All you have to do is type `///` above any method or class and then fill-in the docs.

<img class="img-thumbnail img-responsive center" src="{{ site.img_url }}/feels_good_docs.jpg" title="100% docs" alt="100% docs"/>

### Generating docs

By far, the best way to generate docs for Swift (and Objective-C!) libraries is by using Realm's [jazzy](https://github.com/realm/jazzy) &mdash; *Soulful docs for Swift and Objective-C*. It's an amazing project and one of my favorite open source tools, maintained by [JP Simard](https://github.com/jpsim) and [Samuel Giddins](https://github.com/segiddins).

Once installed, just run `jazzy` from the command line with a few configuration parameters and you'll have beautifully generated docs in seconds. The [README](https://github.com/realm/jazzy/blob/master/README.md) has all of the details, but here's an example from [PresenterKit](https://github.com/jessesquires/PresenterKit):

{% highlight bash %}
jazzy --swift-version 2.2 -o ./ \
      --source-directory PresenterKit/ \
      --readme PresenterKit/README.md \
      -a 'Jesse Squires' \
      -u 'https://twitter.com/jesse_squires' \
      -m 'PresenterKit' \
      -g 'https://github.com/jessesquires/PresenterKit'
{% endhighlight %}

You need to specify a version of Swift, tell jazzy where your source code is, and provide some basic author information. It couldn't be easier. Run `jazzy --help` to see all of the possible usage options.

### Publishing docs

Publishing is the final piece to this puzzle. If you are distributing your library with CocoaPods, then you'll get [CocoaDocs](http://cocoadocs.org) for free. Thanks [Orta](https://twitter.com/orta)! Note that CocoaDocs uses jazzy for Swift pods.

However, with [server-side Swift](https://developer.ibm.com/swift/) or projects that do not use CocoaPods you'll need another solution. Even the [Swift Package Manager](https://github.com/apple/swift-package-manager) does not provide any solutions for documentation. The best solution I've found for publishing is [GitHub Pages](https://pages.github.com). All you need to do is create an orphan branch in git named `gh-pages`, push some html or markdown using [Jekyll](https://jekyllrb.com), and your site will be published at `username.github.io/repository`. (In fact, [this site](https://github.com/jessesquires/jessesquires.github.io) is hosted on GitHub pages and created using Jekyll.) What I like most about using GitHub Pages for docs is that it keeps everything contained within a single repository. So you not only have version control for your source code, but also for your documentation.

But if your source code and docs live in separate disjoint branches, then how do you coordinate between them to keep your docs up-to-date? That's what we'll discuss next.

<p class="text-muted"><b>Note:</b> Even though CocoaDocs provides docs for free, I still prefer using jazzy and GitHub Pages in addition to this. One small shortcoming of CocoaDocs is the inability to update documentation independent of a version release. Suppose you release <code>v1.0</code> of your library and then discover errors in your documentation. To update CocoaDocs, you'll need to push another version, say <code>v1.0.1</code>, to CocoaPods. In any case, it's nice to have documentation in both places. Whether a user discovers your library via GitHub or CocoaPods, the docs are right there.</p>

### Complete workflow

We've covered writing, generating, and publishing. Now let's find out how we can coordinate these into a seamless, mostly automated workflow. I'll share how I set this up for all of my libraries. We'll use [JSQCoreDataKit](https://github.com/jessesquires/JSQCoreDataKit) as an example.

#### Branches

- The [develop](https://github.com/jessesquires/JSQCoreDataKit) branch contains the library, an example app, a readme, and other supporting files like the `.podspec` and `.travis.yml`.
- The [gh-pages](https://github.com/jessesquires/JSQCoreDataKit/tree/gh-pages) branch only contains documentation and scripts for generating it.

#### Directories

On my machine I checkout the repo *twice*. One checkout for both the *develop* and *gh-pages* branches.

- `~/GitHub/JSQCoreDataKit` is the checkout for *develop*
- `~/GitHub-Pages/JSQCoreDataKit` is the checkout for *gh-pages*

This setup allows me to more easily develop and write docs, and quickly build and preview the generated docs. Constantly having to switch branches would cause a lot of churn, since the *gh-pages* branch doesn't contain the library source.

#### Submodules

This is where it all comes together. On the *gh-pages* branch, I add the *develop* branch of the library as a [git submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules). By running `git submodule update`, the *gh-pages* branch can pull in the library source without including it in the git history. Now, we can run `jazzy` from the root directory of the *gh-pages* checkout and provide the submodule directory as the `--source-directory`.

#### Automation

On the [gh-pages](https://github.com/jessesquires/JSQCoreDataKit/tree/gh-pages) branch of [JSQCoreDataKit](https://github.com/jessesquires/JSQCoreDataKit), you'll find two small bash scripts.

The first is [build_docs.sh](https://github.com/jessesquires/JSQCoreDataKit/blob/gh-pages/build_docs.sh), which will update the submodule and build the docs. These can then be previewed in Safari by opening `index.html`.

{% highlight bash %}
git submodule update --remote

jazzy --swift-version 2.2 -o ./ \
      --source-directory JSQCoreDataKit/ \
      --readme JSQCoreDataKit/README.md \
      -a 'Jesse Squires' \
      -u 'https://twitter.com/jesse_squires' \
      -m 'JSQCoreDataKit' \
      -g 'https://github.com/jessesquires/JSQCoreDataKit'
{% endhighlight %}

The second is [publish_docs.sh](https://github.com/jessesquires/JSQCoreDataKit/blob/gh-pages/publish_docs.sh) which will first call the build script, then push the docs to GitHub.

{% highlight bash %}
./build_docs.sh
git add .
git commit -am "auto-update docs"
git push
git status
{% endhighlight %}

#### Workflow

With all of this in place, updating the documentation for my library is painless. I write code and docs, then push to *develop*. Then I switch directories to the *gh-pages* checkout and run `./publish_docs.sh`.

{% highlight bash %}
cd ~/GitHub/JSQCoreDataKit
# write code and docs
# commit
git push

cd ~/GitHub-Pages/JSQCoreDataKit
./publish_docs.sh # update docs
{% endhighlight %}

Right now, I prefer running the `publish_docs.sh` script manually so that the docs only update when I want them to &mdash; for corrections and major releases. However, you could easily do this in the `after_success:` step of your [Travis-CI](https://travis-ci.org) script.

Here's the [final product](http://www.jessesquires.com/JSQCoreDataKit/) for JSQCoreDataKit.

### It's easy

Writing, even if technical, is a great way to take a break from coding &mdash; which I think we can all agree is a good thing to do. The workflow I've outlined above is how I setup *all* of my libraries now. When we have the tools that make this *so easy*, there are no excuses to not do it!
