---
layout: post
categories: [software-dev]
tags: [series-reactive-collections-kit, ios, uikit, swiftui, open-source, collection-view]
date: 2024-10-18T12:30:18-07:00
title: Introducing ReactiveCollectionsKit
subtitle: A Swift replacement for IGListKit
---

I recently released a new open source project called [ReactiveCollectionsKit][3]. It is a modern, fast, and flexible library for building data-driven, declarative, reactive, and diffable collections and lists for iOS. This library is the culmination of everything I learned from building and maintaining [IGListKit][0], [ReactiveLists][1], and [JSQDataSourcesKit][2]. The 4th time's a charm! &#128517;  &#127808; I truly hope this is the last `UICollectionView` library I ever write and maintain. I think it will be. You can find [the documentation here](https://jessesquires.github.io/ReactiveCollectionsKit/).

<!--excerpt-->

### A very brief history

I started doing early prototyping for this library a few years ago, but then other projects (and life in general) took priority. I stopped working on it for a while. I finally came back to the project earlier this year and did a "soft" [initial release](https://github.com/jessesquires/ReactiveCollectionsKit/releases/tag/0.1.0) a few months ago. Since then, I've been steadily [working on improvements](https://github.com/jessesquires/ReactiveCollectionsKit/releases) and new features. I've also started to get some interest in the project and there have been a [few contributors](https://github.com/jessesquires/ReactiveCollectionsKit/graphs/contributors) helping out and making significant contributions. Notably, this library is now being used in [Duolingo](https://www.duolingo.com), which I helped initiate and integrate.

[ReactiveCollectionsKit][3] contains a number of improvements, optimizations, and refinements over the aforementioned libraries --- [IGListKit][0], [ReactiveLists][1], and [JSQDataSourcesKit][2]. I have incorporated what I think are the best ideas and architecture design elements from each of these libraries, while eliminating or improving upon the shortcomings. Importantly, this library uses modern [`UICollectionView`](https://developer.apple.com/documentation/uikit/uicollectionview) APIs (like [`UICollectionViewDiffableDataSource`](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource)), which were unavailable when the previous libraries were written.

ReactiveCollectionsKit has no third-party dependencies and is written in Swift.

### What about SwiftUI?

Of course, the obvious question is: _isn't SwiftUI the future?_ It probably _will be_ --- eventually. But the difficult truth is that [it simply isn't right now](https://github.com/jessesquires/TIL/blob/main/apple_platform/swiftui.md#known-issues--workarounds). Why build another UIKit-based library? SwiftUI performance is still a significant issue, not to mention all the bugs, missing APIs, and lack of back-porting new APIs to older OS versions. SwiftUI works best when you only use the latest SDKs and target the latest operating systems. Yet, most of us must support older versions of iOS. Even then, for any sufficiently advanced app SwiftUI alone will not suffice.

SwiftUI still does not provide a proper `UICollectionView` replacement. Yes, [`Grid`](https://developer.apple.com/documentation/swiftui/grid) exists but it is nowhere close to a replacement for `UICollectionView` and the power of `UICollectionViewLayout`. While SwiftUI's [`List`](https://developer.apple.com/documentation/swiftui/list) is pretty good much of the time, performance can still suffer. Also, both [`LazyVStack`](https://developer.apple.com/documentation/swiftui/LazyVStack) and [`LazyHStack`](https://developer.apple.com/documentation/swiftui/LazyHStack) suffer from severe performance issues when you have large amounts of data.

Luckily, SwiftUI provides solid APIs for [integration with UIKit](https://developer.apple.com/documentation/swiftui/uikit-integration) so you can easily use ReactiveCollectionsKit in a SwiftUI-based view or app.

### ReactiveCollectionsKit overview

The general idea behind ReactiveCollectionsKit is about declaratively defining your collection or list using an [MVVM-style](https://en.wikipedia.org/wiki/Model–view–viewmodel) separation of concerns. (This was largely inspired by ReactiveLists.) The library does not care what your data models are, you are only responsible for mapping your model objects to the view models that you then provide to the library.

Here's a brief example of building a list from an array of data models.

```swift
// array of some data models
let models = [MyModel(), MyModel(), MyModel()]

// create cell view models from the data
let cells = models.map { MyCellViewModel($0) }

// create the sections with cells
let section = SectionViewModel(id: "my_section", cells: cells)

// create the collection with sections
let collection = CollectionViewModel(sections: [section])

// initialize the driver with the view model and view
let listLayout = UICollectionViewCompositionalLayout.list(using: .init(appearance: .grouped))
let collectionView = UICollectionView(frame: frame, collectionViewLayout: listLayout)

let driver = CollectionViewDriver(view: collectionView, viewModel: collection)
```

The collection view is updated and animated automatically. When your data changes, simply regenerate your `CollectionViewModel` (like above) and send this to the `CollectionViewDriver` instance.

```swift
// when the models change, generate a new view model (like above)
let updated = CollectionViewModel(sections: [section1, section2])

driver.update(viewModel: updated)
```

There is also an extensive [example project](https://github.com/jessesquires/ReactiveCollectionsKit/tree/main/Example) included in the repo on GitHub.

### Architecture and design

I want to share some high-level notes on the architecture and core concepts in [ReactiveCollectionsKit][3], along with comparisons to the other libraries I have worked on --- [IGListKit][0], [ReactiveLists][1], and [JSQDataSourcesKit][2]. This section assumes some familiarity with all four libraries. However, even if you have never used them, it is still possible to follow along.

The [`CellViewModel`](https://jessesquires.github.io/ReactiveCollectionsKit/Protocols/CellViewModel.html) is the fundamental or "atomic" component in the library. It encapsulates all data, configuration, interaction, and view registration for a single cell. This is similar to ReactiveLists. In IGListKit, this component corresponds to `IGListSectionController`.

For brevity and clarity, here's a simplified definition of `CellViewModel`:

```swift
protocol CellViewModel {
    associatedtype CellType: UICollectionViewCell

    var id: UniqueIdentifier { get }

    var registration: ViewRegistration { get }

    func configure(cell: CellType)

    func didSelect(with coordinator: CellEventCoordinator?)
}
```

The [`CollectionViewModel`](https://jessesquires.github.io/ReactiveCollectionsKit/Structs/CollectionViewModel.html) defines the entire structure of the collection. It is an immutable representation of your collection of models, which can be anything. It is composed of [`SectionViewModel`](https://jessesquires.github.io/ReactiveCollectionsKit/Structs/SectionViewModel.html) objects that define sections, which are composed of the aforementioned `CellViewModel` objects. A section also defines headers, footers, and supplementary views.

The [`CollectionViewDriver`](https://jessesquires.github.io/ReactiveCollectionsKit/Classes/CollectionViewDriver.html) is the primary entry point into the library. This component owns the `CollectionViewModel`, is responsible for diffing and applying updates, and manages the `UICollectionView`. The "driver" terminology is borrowed from ReactiveLists. This component is more or less equivalent to the `IGListAdapter` found in IGListKit.

Together, these core components allow for uni-directional data flow. The general workflow is:

1. Fetch or update your data models
1. From those models, generate your `CellViewModel` objects
1. Construct your `SectionViewModel` objects and the final `CollectionViewModel`
1. Send the `CollectionViewModel` to the `CollectionViewDriver`, which will then perform a diff and update the view

### Review of prior art

Here I want to address some of the main the pros and cons of [IGListKit][0], [ReactiveLists][1], and [JSQDataSourcesKit][2]. Again, this section assumes some familiarity with all four libraries. But, it should still be possible to follow along.

#### IGListKit

The main shortcomings of [IGListKit][0] are the lack of expressivity in Objective-C's type system, some undesirable boilerplate set up, mutability, and using sections as the base or fundamental component of a list or collection. The library has added annotations to make interoperability with Swift significantly better, but it is not quite the same as a native Swift API. The extra boilerplate involved is also largely because of the nature of Objective-C, which is simply more verbose.

 While IGListKit is general-purpose, much of the design is informed by what we needed specifically at Instagram. It is centered around the concept of lists (like a News Feed) rather than grids or collections, for obvious reasons. A shortcoming of IGListKit is that the "atomic" component is an entire section of multiple items. The section-based design was informed by how lists were architected in the Instagram feed, where each post was its own section. A section in IGListKit _could_ have a single item and in this scenario it more closely resembles a `CellViewModel` in ReactiveCollectionsKit.

 What IGListKit got right was diffing --- in fact, we pioneered that entire idea. (H/T [Ryan Nystrom](https://www.threads.net/@_rnystrom)). The diffing APIs in UIKit _came after_ we released IGListKit and were heavily influenced by what we accomplished. IGListKit also manually implemented and supported many advanced layout features that are now provided out-of-the-box by [`UICollectionViewCompositionalLayout`](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout). IGListKit's section-based design was also largely a product of the limitations of the existing layout APIs. All we had back then was [`UICollectionViewFlowLayout`](https://developer.apple.com/documentation/uikit/uicollectionviewlayout).

IGListKit is very imperative and mutable. After you hook-up your `IGListAdapter` and `IGListSectionController` objects, you update sections in-place. IGListKit encourages immutable data models but this is not enforceable in Objective-C, nor is it enforced in the API. IGListKit _does_ have uni-directional data flow in some sense, but you provide your data imperatively via `IGListAdapterDataSource` which also requires you to manually manage a mapping of your data model objects to their corresponding `IGListSectionController` objects. With this section-based approach, clients are also responsible for manually reporting the number of items in the section.

ReactiveCollectionsKit removes all the boilerplate required by IGListKit. For example, determining the number of items in a section is derived automatically from the structure of the data itself.

#### ReactiveLists

The main shortcomings of [ReactiveLists][1] are that it uses older UIKit APIs and a custom, third-party diffing library. It maintains entirely separate infrastructure for tables and collections, which duplicates a lot of functionality. There's a `TableViewModel` for constructing table views and a `CollectionViewModel` for constructing collection views, which use `UITableView` and `UICollectionView` under-the-hood, respectively. This is because ReactiveLists pre-dates the modern collection view APIs for [diffing](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource) and making [list layouts](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout/3600951-list) using collection view. ReactiveLists is also a bit incomplete as we only implemented the APIs we needed at PlanGrid.

What ReactiveLists got right was a declarative API, defining an immutable model of your list or collection, using an individual cell as the base or fundamental component, and uni-directional data flow. With ReactiveLists, you declaratively define your entire collection view model and regenerate it whenever your underlying data model changes. ReactiveCollectionsKit borrowed this directly and improved upon it. Namely, ReactiveCollectionsKit uses generics to allow you to specify the exact type of `UICollectionViewCell` that your view model configures instead of having to cast (using `as!`) to your specific cell subclass.

#### JSQDataSourcesKit

[JSQDataSourcesKit][2] in some sense was always kind of experimental and academic. It doesn't do any diffing and also has separate infrastructure for tables and collections like ReactiveLists, as it similarly pre-dated those modern collection view APIs for making list layouts. It was primarily concerned with constructing type-safe data sources that eliminated the boilerplate associated with `UITableViewDataSource` and `UICollectionViewDataSource`. Ultimately, the generics were too unwieldy --- especially at the time, given the state of generics in Swift. See my post, _[Deprecating JSQDataSourcesKit](https://www.jessesquires.com/blog/2020/04/14/deprecating-jsqdatasourceskit/)_, for more details. What JSQDataSourcesKit got right was the idea of using generics to provide type-safety, though it was not executed very well.

### Goals

The primary goals of ReactiveCollectionsKit are to remove all of the boilerplate associated with building lists and collections, and making your views effortless to update. See the example code above.

UIKit has advanced a lot over the years, but correctly setting up a [`UICollectionViewDiffableDataSource`](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource) is quite a bit of work. It is tedious and still requires a lot of boilerplate. It is also error prone when it comes to getting diffing to work correctly. (More on that in a future post.)

More specifically, when using this library, you no longer need to interact with any of these collection view APIs:

- `reloadData()`
- `reconfigureItems(at:)`
- `reloadSections(_:)`
- `reloadItems(at:)`
- `performBatchUpdates(_:completion:)`
- All `UICollectionViewDataSource` methods
- All `UICollectionViewDelegate` methods

The benefit and delight in using ReactiveCollectionsKit is that you simply define the structure of your data. You create your collection of items, organize them into sections, and pass this to the library to handle everything else.

### Future Work

All of this experience and knowledge has culminated in me writing this new library. ReactiveCollectionsKit aims to keep all the good ideas and designs from these other libraries, while also addressing their shortcomings. I wrote or maintained all of them, so hopefully I got it right this time!

While this library is in a great state and ready for production, it is not yet finished. There is [plenty to do](https://github.com/jessesquires/ReactiveCollectionsKit/issues)! The most commonly used collection view APIs have been implemented, but there are some missing features --- like supporting expanding/collapsing sections, for example. Another big feature on my list is to implement a more SwiftUI-like API using Swift [result builders](https://www.hackingwithswift.com/swift/5.4/result-builders).

If you are interested in getting involved, please [open an issue](https://github.com/jessesquires/ReactiveCollectionsKit/issues) or send me a [pull request](https://github.com/jessesquires/ReactiveCollectionsKit/pulls)!

[0]:https://github.com/instagram/iglistkit
[1]:https://github.com/plangrid/reactivelists
[2]:https://github.com/jessesquires/JSQDataSourcesKit
[3]:https://github.com/jessesquires/ReactiveCollectionsKit
