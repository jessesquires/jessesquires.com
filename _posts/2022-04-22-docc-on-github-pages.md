---
layout: post
categories: [software-dev]
tags: [docc, documentation, github, jazzy, open-source, swift]
date: 2022-04-22T12:58:41-07:00
title: Using DocC on GitHub Pages
date-updated: 2022-04-25T10:27:23-07:00
subtitle: Pros and Cons
---

When [I first wrote about DocC]({% post_url 2021-06-29-apple-docc-great-but-useless-for-oss%}), I lamented the fact that it was incompatible with static hosting on [GitHub Pages](https://pages.github.com). Much has changed since my [last post]({% post_url 2021-06-29-apple-docc-great-but-useless-for-oss%}), so let's take a fresh look. While there have been many welcome improvements to the tool, there are a few remaining issues that prevent me from adopting it for my open source projects.

<!--excerpt-->

My previous post mentioned a few community projects that preceded DocC, but the most popular one --- and the one that I use --- is [Jazzy](https://github.com/realm/jazzy). Thus, much of my feedback here will be in relation to how DocC compares to Jazzy.

### The good

As promised at last year's WWDC, [DocC is now open source](https://www.swift.org/blog/swift-docc/). You can find [the repo here](https://github.com/apple/swift-docc). DocC is bundled with the [Xcode 13.3 release](https://developer.apple.com/documentation/xcode-release-notes/xcode-13_3-release-notes). There's also a [Swift Package Manager plugin](https://github.com/apple/swift-docc-plugin) to generate documentation for your package using DocC, which even includes [a guide for publishing to GitHub Pages](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/publishing-to-github-pages/). This guide and the [primary docs for the plugin](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin) are, of course, generated using DocC. Apple is clearly eating their own dog food. There's a lot to love about the tool.

The generated docs are beautiful. I love the design and aesthetic. Dark mode is built-in, natch. The generated docs are nearly identical to Apple's official SDK documentation. Take a look at the [Swift DocC Plugin docs](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/) and compare it to [UIKit](https://developer.apple.com/documentation/uikit). This is great for open source maintainers, because your documentation will fit right in and be immediately familiar to other Apple platform developers.

I [previously wrote]({% post_url 2021-06-29-apple-docc-great-but-useless-for-oss%}): _"The integration with Xcode’s Editor and Documentation Viewer is excellent. There is a command-line tool included, `xcodebuild docbuild`, which you can invoke from automation scripts. The overall workflow for generating and exporting documentation is built-in to Xcode and its build process, making it very easy to use."_ This is still true, but now it also integrates directly with the Swift Package Manager via [the aforementioned plugin](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/).

Adding the Swift DocC Plugin to your package is easy:

```swift
let package = Package(
    // name, platforms, products, etc.
    dependencies: [
        // other dependencies
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        // targets
    ]
)
```

And then you can write a small script to generate docs for GitHub Pages:

```bash
#!/bin/zsh

swift package \
    --allow-writing-to-directory ./docs \
    generate-documentation --target MySwiftPackage \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path MySwiftPackage \
    --output-path ./docs
```

I setup an example project and repo to experiment with DocC and GitHub pages. [You can find it here](https://github.com/jessesquires/my-swift-package). For a more in-depth look at hosting on GitHub pages, I recommend [Joseph Heck's excellent post](https://rhonabwy.com/2022/01/28/hosting-your-swift-library-docs-on-github-pages/).

Finally, you [can easily preview](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/previewing-documentation) your static site with the Swift DocC Plugin.

```bash
swift package --disable-sandbox preview-documentation --target MySwiftPackage
```

This runs a local web server, and you navigate to `localhost:8000/documentation/MySwiftPackage` to preview your docs.

### The Bad

Below are the main issues and pain points I experienced while experimenting with DocC as a possible replacement for [Jazzy](https://github.com/realm/jazzy).

#### DocC URL schemes are... strange

I strongly dislike the URL schemes that DocC produces. My first gripe is, admittedly, purely cosmetic. Consider my example project on GitHub at [`github.com/jessesquires/my-swift-package`](https://github.com/jessesquires/my-swift-package). Normally, a GitHub Pages site root is hosted at `USERNAME.github.io/REPO_NAME`. However, a DocC site changes this to `USERNAME.github.io/REPO_NAME/documentation/PACKAGE_NAME`. That is, the path appends `/documentation` and `/PACKAGE_NAME`. Typically, the repo name and package name are the same, so you end up with an ugly URL like `jessesquires.github.io/MyLibrary/documentation/MyLibrary`. I much prefer the shorter, cleaner URLs.

Aside from being ugly, there are some usability issues. Firstly, navigating to the normal GitHub pages root at `jessesquires.github.io/MyLibrary` loads a completely blank HTML page (_not_ a 404), which is very confusing. However, navigating to `jessesquires.github.io/MyLibrary/documentation` (without appending the final `/MyLibrary`) _does_ result in a 404. Sure, you just need to know and link to the correct URL, but it's weird --- especially if you are familiar with GitHub Pages.

To recap:

- The project repo is at: <https://github.com/jessesquires/my-swift-package>
- The GitHub Pages site root is at: <https://jessesquires.github.io/my-swift-package/>
- The DocC site root is at: <https://jessesquires.github.io/my-swift-package/documentation/my_swift_package/>

For this specific example, I should also note another quirk about DocC --- it transforms dashes into underscores. Notice that my repo and package are titled `my-swift-package` (with dashes), but the final path component in the DocC URL is `my_swift_package` (with underscores). This isn't terrible, but I was really confused when my site was not working at first. Then I realized that I was using the wrong URL with `my-swift-package` at the end instead of `my_swift_package`.

#### Quirks with migrating from Jazzy

The other issue with this URL scheme is migrating existing projects. Currently, all of my Apple platform projects use [Jazzy](https://github.com/realm/jazzy) and host docs at `jessesquires.github.io/PROJECT_NAME`. For example, [Foil](https://github.com/jessesquires/Foil) which has docs at [`jessesquires.github.io/Foil`](https://jessesquires.github.io/Foil/). If I immediately switched over to using DocC, I would break the documentation links for all of my projects --- an Internet sin, to be sure. But it's actually worse than that, because with DocC the root of the GitHub Pages site is just a blank page, as mentioned above.

The obvious workaround here is to add a redirect. But because we're in a static hosting environment, we can only accomplish this with `meta` tags. This is not ideal, but it works.

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Redirecting</title>
    <!--
      Redirect
      FROM: jessesquires.github.io/my-swift-package
      TO: jessesquires.github.io/my-swift-package/documentation/my_swift_package
    -->
    <meta http-equiv="refresh" content="0; URL=https://jessesquires.github.io/my-swift-package/documentation/my_swift_package">
    <link rel="canonical" href="https://jessesquires.github.io/my-swift-package/documentation/my_swift_package">

    <!-- existing DocC code... -->
   </head>
   <body>
     <!-- DocC body... -->
   </body>
</html>
```

The above code should be added to the DocC generated `docs/index.html` file. However, there's a major caveat. You will need to edit the root `docs/index.html` **every time** you regenerate your documentation to add this redirect. You could automate adding the redirect as part of the script that generates your documentation, but that's also not ideal.

#### DocC generation is not stable

This brings me to another issue with DocC. Its documentation generation is not stable. That is, it produces a diff on every single run. With Jazzy, if you generate your docs, commit the changes, and immediately run Jazzy again it will not produce a diff. In contrast, DocC _always_ produces a diff. Specifically, the various JSON files output to `docs/data/...` change every single time.

Aside from being a nuisance, this has implications for automation and scripting. Suppose you want to automatically generate documentation via GitHub Actions after every push to `main`, and have a bot commit the doc updates. You will quickly accumulate a bunch of unnecessary commits. The ideal scenario would be that documentation generation is stable, and only produces a diff if the documentation has actually changed. Then, in automation scenarios, doc generation could no-op and avoid all these extra commits.

#### DocC local previews require a web server

I mentioned above that DocC docs can be previewed easily via the Swift DocC Plugin, which I appreciate. It is easy and convenient enough. It works. However, it would be nice if it did not require running a web sever to do so. Isn't this supposed to be a static site?

This gets to the core of why DocC is a difficult drop-in replacement for Jazzy. While static hosting with DocC now _works_, it was not originally built with this in mind. Thus, it doesn't behave like you would expect a static site to behave. The `--transform-for-static-hosting` flag is really just a hack, a workaround for static hosting environments like GitHub Pages. You cannot simply open `docs/index.html` or `docs/documentation/MyLibrary/index.html` because your local paths do not match the paths on the server. This is why a local web server is necessary for previews. The result is static hosting feeling like a second-class citizen.

To compare with Jazzy, all you need to do is open `docs/index.html` directly in Safari and you can quickly preview your entire site. No web server needed.

#### Other missing features

DocC is missing a handful of useful features from Jazzy that I would like to see it adopt.

Jazzy reports documentation coverage. If you look at the [docs for Foil](https://jessesquires.github.io/Foil/), you'll see it is 100% documented. Similarly, the [docs for Quick](http://quick.github.io/Quick/) report it is currently 88% documented. Even better, Jazzy outputs a `docs/undocumented.json` file which specifies all undocumented symbols and their precise file and line location in the codebase. This is incredibly helpful for maintainers like me who strive for 100% documentation to avoid "[No Overview Available](https://github.com/nooverviewavailable/NoOverviewAvailable.com)". Because Jazzy outputs structured data in `undocumented.json`, you can build automation around this, like [a Danger plugin](https://github.com/fwal/DangerJazzy) that reports if your pull request added new APIs without documenting them. One last benefit is that contributors can also see which symbols need documentation --- often, an easy first-time contribution for folks wishing to get involved.

Jazzy docs include a prominent "View on GitHub" link in the site header that takes you directly to the GitHub repo. This is particularly convenient if someone first lands on your documentation pages instead of your repo.

Jazzy includes a client-side search. It's a bit simplistic and basic --- limited by the static environment of GitHub Pages --- but it works pretty well in practice and is nice to have.

### Conclusion

I think DocC offers a lot of value and has some really cool features like [interactive tutorials](https://developer.apple.com/videos/play/wwdc2021/10235/), and it looks like the best option available if you do not need a static site. However, DocC static hosting imposes _just enough_ inconvenience to my existing setup and workflow to make switching away from Jazzy not worth the effort --- for now. I might consider using DocC for new projects, but migrating existing projects would be more trouble than it is worth.

The main improvement I would like to see with DocC static hosting is making this feature a first-class citizen --- fix the quirky URL scheme and don't require a web server to make it a truly static site. As for DocC features in general, the most important one for me would be reporting documentation coverage.

{% include updated_notice.html
date="2022-04-25T10:27:23-07:00"
message="
Thanks to [Ethan Kusters](https://twitter.com/ethankusters) for sharing [some updates and feedback](https://twitter.com/ethankusters/status/1517620941848678402) on this post:

- To workaround the unstable JSON output, you can set the env variable `export DOCC_JSON_PRETTYPRINT=\"YES\"` as [seen here](https://github.com/apple/swift-markdown/blob/main/bin/update-gh-pages-documentation-site#L36).
- Turns out DocC _is not_ transforming dashes into underscores. That's Swift doing that, which makes sense now because you have to `import my_swift_package`. My mistake there!
- For search, Swift-DocC has a [sidebar in active development](https://forums.swift.org/t/swift-docc-sidebar/55250) that offers some basic filtering.

The team is actively working on improving the UX with DocC. I'm excited to see what they come up with!
" %}
