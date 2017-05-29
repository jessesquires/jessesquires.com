---
layout: post
title: Swift documentation, Part 2
subtitle: Generating and publishing docs in Swift
redirect_from: /swift-documentation-part-2/
---

I previously wrote about [writing great documentation in Swift](/swift-documentation/). If you haven't read that post, head there now to catch up. This post is a follow-up with updates for GitHub's new way [to publish docs](https://github.com/blog/2228-simpler-github-pages-publishing). This is how I've setup all of my Swift open source projects.

<!--excerpt-->

### Generating docs

As I mentioned before, you'll want to use Realm's [jazzy](https://github.com/realm/jazzy) &mdash; *Soulful docs for Swift and Objective-C*. Here's an example of the docs script that I use for [PresenterKit](https://github.com/jessesquires/PresenterKit):

{% highlight bash %}
jazzy \
    --clean \
    --author 'Jesse Squires' \
    --author_url 'https://twitter.com/jesse_squires' \
    --github_url 'https://github.com/jessesquires/PresenterKit' \
    --module 'PresenterKit' \
    --source-directory . \
    --readme 'README.md' \
    --documentation 'Guides/*.md' \
    --output docs/ \
{% endhighlight %}

You need to tell jazzy where your source code is and provide some basic author information. It couldn't be easier. Run `jazzy --help` to see all of the possible usage options.

> **New!** With the latest version of jazzy, you can pass `--documentation` and provide additional, custom markdown docs. In PresenterKit, this is used to generate the [*Getting Started*](http://www.jessesquires.com/PresenterKit/getting-started.html) guide.

### Publishing docs

In the previous post, publishing docs with GitHub was a somewhat clunky process where you had to create an [orphan branch](https://git-scm.com/docs/git-checkout#git-checkout---orphanltnewbranchgt) named `gh-pages`. Now, [all you need to do](https://github.com/blog/2228-simpler-github-pages-publishing) is put your documentation in a top-level `docs/` directory on your `master` branch. Notice the output directory in the jazzy script above: `--output docs/`.

### Complete workflow

Once you've made changes to your code and header docs, run [your script](https://github.com/jessesquires/PresenterKit/blob/develop/build_docs.sh) to generate the documentation which should dump everything into `docs/`. Then simply commit your changes and push to GitHub, where your documentation will be [rendered automatically](http://www.jessesquires.com/JSQCoreDataKit/).
