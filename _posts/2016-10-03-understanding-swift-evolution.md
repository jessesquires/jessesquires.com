---
layout: post
title: Understanding Swift Evolution
subtitle: What can we learn by analyzing the proposals?
redirect_from: /understanding-swift-evolution/
---

I recently [spoke at the FrenchKit conference](/speaking-at-frenchkit/) about [Swift Evolution](https://github.com/apple/swift-evolution). The [talk](https://speakerdeck.com/jessesquires/140-proposals-in-30-minutes), *140 proposals in 30 minutes*, was originally intended to be an overview of the process and each of the proposals. However, as I was writing the talk, it evolved into something much more interesting. I ended up writing some code to analyze the proposals instead.

<!--excerpt-->

### Raw proposals

All of the proposals are publicly [available on GitHub](https://github.com/apple/swift-evolution/tree/master/proposals), but they are just markdown files &mdash; plain text. Because of this, there isn't an easy or efficient way to query or filter them. We can't filter them based on author. We can't group them by the Swift version in which they were implemented. We can't query their contents. And on and on...

### Proposal analyzer

Now we can do all of these things, and more &mdash; *interactively* via Swift playgrounds.

The [swift-proposal-analyzer](https://github.com/jessesquires/swift-proposal-analyzer) project repository contains a number of components. (Everything is written in Swift, of course.) I'll refer you to the [README](https://github.com/jessesquires/swift-proposal-analyzer/blob/master/README.md#setup) for details, but here's the basic flow for how everything works:

1. It syncs/fetches the proposals from the main [apple/swift-evolution](https://github.com/apple/swift-evolution) repo
2. It does some processing and parsing of the proposals
3. You end up with a playground that lets you interact with the proposals
4. The playground contains all of the proposals as raw resource files, as well as playground pages

> Note: some playground pages do not render properly from the original proposal markdown. I've filed a few radars: [rdar://28589341](https://openradar.appspot.com/radar?id=6066152501411840), [rdar://28589062](https://openradar.appspot.com/radar?id=6673199689367552), [rdar://28589211](https://openradar.appspot.com/radar?id=5050621174480896). Please dupe them.

In the playground, you are presented with an array of `Proposal` objects, which contain most of the proposal metadata, as well as the raw file contents.

{% highlight swift %}

final class Proposal {

    let title: String
    let seNumber: String // SE-0001, etc.

    let authors: [Author]
    let status: Status // Accepted, Rejected, etc.

    let fileName: String
    let fileContents: String
    let wordCount: Int
}

{% endhighlight %}

A `Proposal` has a title and SE number, an array of `Author` objects (1 or more), a `Status`, a filename, the file contents, and the total (rough) word count.

For now, `Author` only contains the author's name.

{% highlight swift %}

struct Author {
    let name: String
}

{% endhighlight %}

The `Status` of a proposal is defined as an `enum`:

{% highlight swift %}

enum Status {
    case inReview
    case awaitingReview
    case accepted
    case implemented(SwiftVersion)
    case deferred
    case rejected
    case withdrawn
}

{% endhighlight %}

We've gone from a directory of plain text files to structured data that we can query and filter. 😎

### Examples

Here are a few brief examples to show what kinds of questions we can ask and answer.

{% highlight swift %}

// Find proposals implemented in Swift 3.0
let implementedInSwift3: [Proposal] = analyzer.proposalsWith(status: .implemented(.v3_0))

{% endhighlight %}

{% highlight swift %}

// Find proposals authored or co-authored by Chris Lattner
let proposalsByLattner: [Proposal] = analyzer.proposals.filter { p -> Bool in
    p.writtenBy("Chris Lattner")
}

{% endhighlight %}

{% highlight swift %}

// Find total mentions of "Objective-C" across all proposals
let count: Int = analyzer.occurrences(of: "Objective-C")

{% endhighlight %}

### Querying the data

These examples show very basic queries, but we can build upon these to derive much more sophisticated data describing how proposals vary over time. For example, we could plot an author's influence over time. Is she writing fewer or more proposals for each version of Swift? Or, how is Swift itself evolving over time? Does each version of Swift include more or fewer proposals than the previous one? At what rate are proposals increasing or decreasing?

Since this is such a targeted set of data, we can use word count as a rough metric for complexity, i.e. the longer a proposal is, the more likely it is to be a larger, more complex change. For example, [SE-0107: *UnsafeRawPointer API*](https://github.com/apple/swift-evolution/blob/master/proposals/0107-unsaferawpointer.md) comes in at around 7,300 words, while [SE-0114: *Updating Buffer "Value" Names to "Header" Names*](https://github.com/apple/swift-evolution/blob/master/proposals/0114-buffer-naming.md) is only about 167 words. The latter is simply a renaming, while the former made significant changes to the lower-level `UnsafePointer` APIs. How does the complexity of proposals vary over time?

Because we have the entire file contents available for each proposal, we could even do some [natural language processing](https://en.wikipedia.org/wiki/Natural_language_processing), like categorizing proposals based on [topic models](https://en.wikipedia.org/wiki/Topic_model).

I haven't had time to dive this deeply into Swift Evolution, but maybe someone from the community will. Swift is only about 2 years old, so we probably can't conclude *that* much yet. In any case, it's fun to play around with the data.

### Current stats

Of course, my talk is already out-dated and it will be a few more weeks until the videos are available. 😂 I guess the Swift Evolution process is just as fast as Swift itself. And now this article has turned so meta I can't even. 😄

Here are some interesting things about Swift Evolution that the [status page](http://apple.github.io/swift-evolution/) can't tell you:

- **75%** of all proposals have been accepted. **70%** of these have been implemented.
- Swift 2.2 to Swift 3.0 saw a **1,012%** increase in proposals.
- There are **79** unique authors.
- Most proposals have 1 or 2 authors, but [there's one](https://github.com/apple/swift-evolution/blob/master/proposals/0023-api-guidelines.md) that has **9** authors.
- [Erica Sadun](http://ericasadun.com) has authored or co-authored more proposals *than anyone*, including *everyone* on the Core Team.

The following are the top 10 authors, and the number of proposals that they have written or co-written. Note that **half** of them do not work at Apple (that I know of, at least). These individuals were certainly influential in Swift 3.

1. Erica Sadun, 25
2. Doug Gregor, 15
3. Joe Groff, 12
4. Dave Abrahams, 10
5. Chris Lattner, 10
6. Dmitri Gribenko, 7
7. Jacob Bandes-Storch, 6
8. David Hart, 6
9. Austin Zheng, 5
10. Kevin Ballard, 5

### Conclusion

Contributing to Swift isn't just about writing compiler code. It's also about ideas. You don't have to be a compiler expert to have ideas. And you don't need to write C++ to have an influence on Swift. All you need is a great idea to make the language better for everyone.

Like I mentioned above, Swift is still young &mdash; and our dataset of proposals is quite small. We should be cautious with any conclusions, but there's a lot here to think about and a lot more we can learn! Send me a [pull request](https://github.com/jessesquires/swift-proposal-analyzer/compare?expand=1), there's plenty [to work on](https://github.com/jessesquires/swift-proposal-analyzer/issues)! 😄
