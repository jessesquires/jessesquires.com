---
layout: post
categories: [software-dev]
tags: [docc, documentation, github, jazzy, open-source, swift, wwdc]
date: 2021-06-29T16:55:17-07:00
date-updated: 2021-06-30T11:08:46-07:00
title: Apple's DocC is excellent, but unusable for open source projects
---

I was very excited at this year's WWDC when Apple [announced DocC](https://developer.apple.com/videos/play/wwdc2021/10166/), their new "Documentation Compiler" tool that generates documentation from comments in your source code. Unfortunately, it's not going to work for the majority of open source authors.

<!--excerpt-->

### A brief history

Many folks are probably unaware that the company shipped and maintained a similar tool before, the now-defunct [HeaderDoc](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/HeaderDoc/intro/intro.html), which had a final [stable release in 2009](https://en.wikipedia.org/wiki/HeaderDoc). Eventually, [Tomaz Kragelj](http://gentlebytes.com/contact/) wrote and released an open source replacement called [AppleDoc](http://gentlebytes.com/appledoc/), which became the standard way for Apple platform developers to publish documentation for their open source libraries. While AppleDoc began to languish from a lack of regular contributors, Swift was announced in 2014. AppleDoc was soon replaced by another community-built tool, [Jazzy](https://github.com/realm/jazzy), authored by [JP Simard](https://www.jpsim.com) and [maintained by various contributors](https://github.com/realm/jazzy/graphs/contributors). More recently, [Mattt](https://nshipster.com/authors/mattt/) took another approach at solving this problem with [swift-doc](https://github.com/SwiftDocOrg/swift-doc). After all these years of the open source community filling in the gaps and building their own tools, Apple finally announced a new first-party solution for generating documentation.

### Introducing DocC

Overall, there are many things to like about [DocC](https://developer.apple.com/videos/play/wwdc2021/10166/). The integration with Xcode's Editor and Documentation Viewer is excellent. There is a command-line tool included, `xcodebuild docbuild`, which you can invoke from automation scripts. The overall workflow for generating and exporting documentation is built-in to Xcode and its build process, making it very easy to use. Finally, the documentation itself looks incredible. It uses the same styling as Apple's official documentation, making it very familiar to any Apple platform developer. The design is clean and well-organized. You can even include supplemental resources, including [interactive tutorials](https://developer.apple.com/videos/play/wwdc2021/10235/).

The problem with DocC is [hosting and distribution](https://developer.apple.com/videos/play/wwdc2021/10236) &mdash; arguably the most important aspect of this type of tool! What's the point of generating amazing docs for your library or SDK if you can't easily distribute or publish them for your users? When you run DocC, it produces a `.doccarchive` package that includes all the HTML, CSS, JavaScript, and other resources for your documentation website. According to [the docs on distribution](https://developer.apple.com/documentation/Xcode/distributing-documentation-to-external-developers), you must host this `.doccarchive` on your web server and implement various rules to rewrite incoming URLs. The example provided defines rules in an `.htaccess` file for Apache.

```bash
# Enable custom routing.
RewriteEngine On

# Route documentation and tutorial pages.
RewriteRule ^(documentation|tutorials)\/.*$ MyProject.doccarchive/index.html [L]

# Route files and data for the documentation archive.
#
# If the file path doesn't exist in the website's root ...
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d

# ... route the request to that file path with the documentation archive.
RewriteRule .* MyProject.doccarchive/$0 [L]
```

The docs suggest keeping it up to date using a continuous integration workflow that generates and copies your `.doccarchive` to your web server. For additional information on hosting, see [this post on Hosting DocC Archives](https://josephduffy.co.uk/posts/hosting-docc-archives) by [Joseph Duffy](https://twitter.com/Joe_Duffy). Examples provided include Netlify, Vapor middleware, nginx, and Apache.

There is one last quirk. The default output location for the DocC archive is buried in Xcode's `DerivedData/` directory, which is... certainly a place to put it. Apple seems to think that's a good directory for a lot of things, but [I strongly disagree]({% post_url 2020-03-04-another-issue-with-swiftpm-xcode-integration %}). Luckily, you can specify another derived data directory location when using `xcodebuild docbuild`.

### Ignoring prior art

So far, this may not seem like an issue &mdash; unless you are an open source author and maintainer like me. There is a particularly vibrant community of open source iOS developers on GitHub. Most open source communities have standardized on GitHub, but especially the Apple developer community &mdash; everyone hosts their projects on GitHub. Because of that, we all [host our documentation alongside our projects](https://github.blog/2016-08-22-publish-your-project-documentation-with-github-pages/) using [GitHub Pages](https://pages.github.com). It is an incredibly valuable product and service that is easy to use. First, you generate your docs &mdash; we all use [Jazzy](https://github.com/realm/jazzy) &mdash; then you place them in `docs/` on your default branch. For an example, see the popular [Alamofire](https://github.com/Alamofire/Alamofire) library and [its documentation](https://alamofire.github.io/Alamofire/). I also [wrote about this]({% post_url 2016-05-20-swift-documentation %}) in 2016.

This is what nearly everyone does: host your project on GitHub, generate docs using Jazzy, and host your docs using GitHub Pages. In fact, no open source projects immediately come to mind that do not implement this workflow. I'm sure those projects exist, but they are the _exception_, not the norm. Even Apple [hosts their open source projects on GitHub](https://github.com/apple) now and uses GitHub Pages for [the Swift Evolution proposal site](https://apple.github.io/swift-evolution/). More ironically, some teams at Apple actually use Jazzy and publish docs on GitHub Pages like I've described for some of their open source Swift packages, like [SwiftNIO](https://github.com/apple/swift-nio) (see [the docs here](https://apple.github.io/swift-nio/docs/current/NIO/index.html)).

DocC fails to deliver for this extremely popular use case &mdash; in my opinion, the most popular. DocC **does not** work with GitHub Pages &mdash; a **significant** barrier for adoption for essentially all open source projects in the Apple developer community. I experimented with some hacks, but was unable to make DocC do what I need. The GitHub Pages server environment is a bit opaque to the user, but it is intended for [hosting static sites](https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages) ([Jekyll](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll), for example), which DocC does not produce. DocC creates a [Vue.js](https://vuejs.org) web app and requires that you run your own web server to dynamically serve it, as described above. The process feels clunky and overcomplicated compared to GitHub Pages.

**I badly want to use DocC.** I would love to be able to use DocC for all my projects &mdash; but I **cannot** in its current form, nor can most anyone else. Unless, of course, you want to setup, maintain, and pay for a web server to host docs for your open source project that you work on for free. Who is going to do that!? Again, [Joseph Duffy provided](https://josephduffy.co.uk/posts/hosting-docc-archives) great examples for hosting, but how practical is it really? You would have to setup a new site for hosting the docs for each project you maintain. That is not tenable. Generating docs with Jazzy and hosting via GitHub Pages works great. Plus, it's free.

Unless something significant changes in DocC, I will continue using Jazzy. I do not have much of a choice, sadly. At the very least, it would be nice if DocC provided an option to generate [a static site instead](https://stackoverflow.com/questions/68048298/running-xcode-docc-without-apache-server-htaccess). Aside from working with GitHub Pages, a static site would hopefully require much less JavaScript, of which there is currently a seemingly excessive amount. I think [Paul Hudson captured the core issue](https://www.hackingwithswift.com/articles/238/how-to-document-your-project-with-docc) well:

> As things stand, the generated documentation is effectively a sealed box [...] The web pages are also very heavy on the JavaScript and honestly I’m not sure why – the reference documentation and articles are simple beasts, and if DocC could flatten them to plain HTML then I imagine the rewrite rules would just go away. At the same time, Apple’s own documentation system is completely inaccessible with JavaScript turned off, so I don’t hold out a great deal of hope here.

### For whom is this intended?

This brings me to the final question at hand &mdash; *who is this tool for?* I'm not being sarcastic. I can think of two main groups of users for DocC: individual open source library authors and bigger companies that provide closed-source SDKs. I'm curious &mdash; what did the DocC team envision for this tool? It certainly does not feel like it was written for our community of open source library authors, and that is beyond frustrating and disappointing.

Could companies that distribute popular SDKs make use of DocC? I'm thinking of SDKs like [Paddle](https://developer.paddle.com/reference/sdks), [Segment](https://segment.com/docs/connections/sources/catalog/libraries/mobile/ios/), [Firebase](https://firebase.google.com/docs/ios/setup), and [Facebook](https://developers.facebook.com/docs/ios/). However, it seems unlikely that any of these companies would use DocC. They (obviously) already have custom tooling and workflows to generate and host their own custom-branded documentation. They are not going to use DocC unless it can be heavily themed, and even then that's probably not enough for them to switch from their current setup. [Paul Hudson also points this out](https://www.hackingwithswift.com/articles/238/how-to-document-your-project-with-docc):

> [...] the Apache rewrite rule references a theme-settings.json file, which suggest some customization is going to come, but I don’t know to what extent. I can imagine bigger companies wanting their corporate branding integrated, or their regular site navigation.

It is clear that the team behind DocC worked hard on this tool &mdash; it shows. Like I mentioned at the start, the breadth and depth of what DocC offers is impressive. Still, it feels like the creators were somewhat clueless about what third-party developers actually need, which [seems to be a trend]({% post_url 2020-03-04-another-issue-with-swiftpm-xcode-integration %}). It feels like Apple built DocC for _Apple_. We've been using Jazzy with GitHub Pages [since 2014](https://github.com/realm/jazzy/releases/tag/0.0.4) &mdash; even [CocoaDocs was using Jazzy](https://blog.cocoapods.org/CocoaDocs-Documentation-Sunsetting/). How could one overlook that when creating a new tool?

This would not be so upsetting if Apple's [developer relations](https://marco.org/2021/06/03/developer-relations) were not [abysmal]({% post_url 2020-09-15-why-is-apple-acting-like-an-asshole %}) &mdash; not to mention, ["the Elephant" at WWDC](https://eclecticlight.co/2021/06/13/last-week-on-my-mac-the-elephant-at-wwdc/). For years, our community has built and maintained its own tools that work _exactly_ how we need them. Then Apple (finally!) releases a first-party tool that is amazing for addressing 90% of the problem, but omits the most important 10% of the solution.

And so, we are unable to use the could-have-been-so-great tool that the highly-paid software engineers at Apple built because it _just barely_ misses the mark. We are left in stark contrast to continue maintaining our community-built tools, primarily with unpaid labor.

### To be open source

Finally, Apple mentioned that DocC will be open sourced later this year. Some folks in the community seem optimistic about what that means for the future of DocC &mdash; maybe some determined, enthusiastic open source contributor will submit a patch that implements a "static site mode" for DocC. But at that point, what have we actually gained?

{% include updated_notice.html
message="
This post was updated to include mentioning that Apple actually uses Jazzy and GitHub pages for some of its Swift packages, like SwiftNIO.

Additional updates:

JP and friends maintaining Jazzy have [opened an issue](https://github.com/realm/jazzy/issues/1256) to track adding support for ingesting DocC archives as input, instead of relying on [SourceKitten](https://github.com/jpsim/SourceKitten). So interestingly, what we may end up with is a community-built tool on top of DocC that provides the static site functionality we need.

[Sven Schmidt](https://twitter.com/_sa_s) who maintains the [Swift Package Index](https://swiftpackageindex.com) with [Dave](https://daveverwer.com), suggested [on Twitter](https://twitter.com/_sa_s/status/1410155365270966274) that the Swift Package Index could conceivably generate and host DocC documentation. That would be pretty awesome in my opinion &mdash; it would be [CocoaDocs](https://blog.cocoapods.org/CocoaDocs-Documentation-Sunsetting/) 2.0!

I think what I'm realizing is that community tooling is never going to be replaced by what Apple provides.
" %}

#### Further Reading

- [WWDC21: Meet DocC documentation in Xcode](https://developer.apple.com/videos/play/wwdc2021/10166/)
- [WWDC21: Host and automate your DocC documentation](https://developer.apple.com/videos/play/wwdc2021/10236)
- [WWDC21: Elevate your DocC documentation in Xcode](https://developer.apple.com/videos/play/wwdc2021/10167/)
- [WWDC21: Build interactive tutorials using DocC](https://developer.apple.com/videos/play/wwdc2021/10235/)
- [Apple: Distributing Documentation to External Developers](https://developer.apple.com/documentation/Xcode/distributing-documentation-to-external-developers)
- [Last Week on My Mac: The elephant at WWDC](https://eclecticlight.co/2021/06/13/last-week-on-my-mac-the-elephant-at-wwdc/)
- [Hosting DocC Archives](https://josephduffy.co.uk/posts/hosting-docc-archives)
- [How to document your project with DocC](https://www.hackingwithswift.com/articles/238/how-to-document-your-project-with-docc)
- [Xcode DocC - Getting Started](https://useyourloaf.com/blog/xcode-docc-getting-started/)
- [StackOverflow: Running Xcode DocC without Apache Server?](https://stackoverflow.com/questions/68048298/running-xcode-docc-without-apache-server-htaccess)
