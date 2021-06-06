---
layout: post
categories: [software-dev]
tags: [ios, open-source, uikit]
date: 2020-04-14T16:29:42-07:00
title: Deprecating JSQDataSourcesKit
---

Today I am deprecating my open source library, [JSQDataSourcesKit](https://github.com/jessesquires/JSQDataSourcesKit). I have already marked the CocoaPod as deprecated and archived the repo on GitHub. I will not be taking additional contributions.

<!--excerpt-->

I am not sure how many folks are using this library. Maybe a few dozen? A few hundred? They only way I could track this before was with CocoaPods stats, which has been dead for a while now.

Anyway, I have not made any substantial contributions [since version 7.0.0](https://github.com/jessesquires/JSQDataSourcesKit/releases/tag/7.0.0) was released over **two years ago**. Subsequent releases were just upgrading Swift versions and dropping support for older OS versions. So really, it has been in a minimal maintenance mode for some time now.

My thanks goes out to [all of the contributors](https://github.com/jessesquires/JSQDataSourcesKit/graphs/contributors) over the years, in particular [Panagiotis Sartzetakis](https://github.com/psartzetakis), [David Snabel-Caunt](https://github.com/dcaunt), and [Kevin](https://github.com/kevnm67).

{% include break.html %}

If you aren't familiar with this library, [this post]({% post_url_absolute 2015-10-25-building-data-sources-in-swift %}) has a good overview. It was an interesting approach to solving the "data source boilerplate" problem for `UITableView` and `UICollectionView` for iOS apps. However, it was not really a sustainable or practical design, which eventually [backed me into a corner](https://github.com/jessesquires/JSQDataSourcesKit/issues/113). It became difficult to modify, which is a [code smell](https://en.wikipedia.org/wiki/Code_smell).

The main problem was all the [generics and protocols with associated types](https://jessesquires.github.io/JSQDataSourcesKit/Classes/DataSourceProvider.html). It was a cool idea, and interesting academically, but ultimately it proved too difficult to use in most real-world cases. If you were able to declare all the components in-line, it was very elegant as Swift could infer all the types (though early version of Swift [struggled with this](https://speakerdeck.com/jessesquires/pushing-the-limits-of-protocol-oriented-programming)). However, you pretty much always needed to declare properties, resulting in code like this:

```swift
// For a view controller with a collection view
typealias Source = DataSource<CellViewModel>
typealias CollectionCellConfig = ReusableViewConfig<CellViewModel, CollectionViewCell>
typealias HeaderViewConfig = TitledSupplementaryViewConfig<CellViewModel>

let dataSourceProvider: DataSourceProvider<Source, CollectionCellConfig, HeaderViewConfig>
```

The type aliases help, but all the generics are simply overwhelming and unwieldy.

The other main issue was mapping a view model type to a cell type, and restricting the entire table view or collection view to a single cell type and thus, a single view model type. In other words, your data and cells had to be entirely homogeneous. But in practical iOS apps, as you know, you almost always need to display heterogeneous data and cells in a table view or collection view. There [were workarounds for this](https://github.com/jessesquires/JSQDataSourcesKit/issues/57), but they were not great. And let's be honest, this should not be something you have to "work around" in a library like this.

Interestingly, certain aspects of this library informed the design of [IGListKit](https://www.github.com/Instagram/IGListKit), which I co-authored with [Ryan](https://twitter.com/_ryannystrom). It also helped inform improvements to parts of [ReactiveLists](https://github.com/plangrid/reactivelists), after I joined PlanGrid and started contributing to that project. Overall, it at least turned out to be a great learning experience.

{% include break.html %}

If you are currently using this library, I would suggest migrating to something else **eventually** &mdash; however, I do not think there is any reason to rush. It still works, but it will not be updated again. If you need to patch it, you can fork it on GitHub. It has very good test coverage at 90 percent.

You may be wondering, what would I do differently if I had to build this library again? **Well, I have good news, too**. I am working on a replacement. After writing, maintaining, and/or contributing to three different "list" libraries for iOS ([JSQDataSourcesKit](https://github.com/jessesquires/JSQDataSourcesKit), [IGListKit](https://www.github.com/Instagram/IGListKit), [ReactiveLists](https://github.com/plangrid/reactivelists)), I think the fourth time is the charm. So stay tuned.
