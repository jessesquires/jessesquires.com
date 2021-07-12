---
layout: post
categories: [software-dev]
tags: [ios, uikit, collection-view, bugs]
date: 2021-07-11T17:05:25-07:00
title: Debugging a DiffableDataSource CellProvider
---

I was recently working on a project that uses [modern collection views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views) on iOS &mdash; that is, using [diffable data sources](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource), [snapshots](https://developer.apple.com/documentation/uikit/nsdiffabledatasourcesnapshot), and [cell providers](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource/cellprovider). I hooked up all the components and my collection view was working, or so I thought. I started to notice some very odd, unpredictable behavior when the collection view was updated. Some of the time, the cells were updated correctly. Other times, I would see duplicates and missing data. Here's what went wrong.

<!--excerpt-->

I have simplified the problem for this blog post so that the sample code is easy to follow. The project that I'm working on uses view models to simplify and encapsulate much of the functionality for the collection view and its configuration.

Here is the original view model and diffable data source code, distilled to its essence:

```swift
struct ViewModel {
    // other view model code here

    func dequeueAndConfigureCellFor(collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        // create, configure, and return a cell
        let cellConfig = self.cellConfiguration(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellConfig.cellId, for: indexPath)
        cell.configure(with: cellConfig)
        return cell
    }
}

typealias DiffableDataSource = UICollectionViewDiffableDataSource<String, String>

extension DiffableDataSource {
    convenience init(collectionView: UICollectionView, viewModel: ViewModel) {
        self.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return viewModel.dequeueAndConfigureCellFor(collectionView: collectionView, at: indexPath)
        }
    }
}
```

The `ViewModel` encapsulates a lot of data, configuration, and functionality. The important aspect to call out here is that `ViewModel` handles all of the cell configuration. Next, we can pass an instance of `ViewModel` to our `DiffableDataSource` and in the data source's `CellProvider` closure, we use the view model to dequeue and configure the cell. Finally, in our view controller we can hook everything up.

```swift
class ViewController: UICollectionViewController {
    var viewModel = ViewModel()

    lazy var dataSource: DiffableDataSource = {
        DiffableDataSource(collectionView: self.collectionView, viewModel: self.viewModel)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self.dataSource
    }
}
```

Once we create our `DiffableDataSource`, we set it on the collection view. At first glance, everything seemed to be working correctly. However, when I started updating the collection view by applying new [snapshots](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource/3375795-apply), I was seeing some strange behavior. Suppose I had 4 cells in the collection, `[A, B, C, D]`. After updating, I would get results like `[A, B, B, D]` or `[B, B, D, C]` or `[A, C, D, D]`. So... what was happening?

The issue is that `ViewModel` is a `struct` &mdash; a value type &mdash; and it was being captured in the `CellProvider` closure and thus never updated beyond the initial load. I happened to always have the same amount of items in the collection view, thus no out-of-bounds errors ever occurred, which probably would have tipped me off sooner. It is worth reiterating that the actual code was much more complex than the sample code above. And so, what is perhaps quite obvious in this example was not at all obvious in the actual application code.

How can we fix the bug? We need to avoid capturing the view model. There are a couple possible solutions. First, you could rework `ViewModel` to be a `class` &mdash; a reference type. In my case, this was not an option because `ViewModel` is intended to be stateless and is generated from an underlying model type. The other solution is to capture a reference type that _owns_ the view model. If there is not already a clear owner, you could wrap `ViewModel` in some kind of container class. In the example above, the real issue was the `convenience init` defined in the extension on `DiffableDataSource`. That is where the incorrect capture occurred. We should remove that, use the primary designated initializer instead, and then capture the view controller in the closure.

```swift
class ViewController: UICollectionViewController {
    var viewModel = ViewModel()

    lazy var dataSource: DiffableDataSource = {
        DiffableDataSource(collectionView: self.collectionView) { [unowned self] view, indexPath, itemId in
            self.dequeueAndConfigureCellFor(collectionView: view, at: indexPath)
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = dataSource
    }

    func dequeueAndConfigureCellFor(collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        self.viewModel.dequeueAndConfigureCellFor(collectionView: collectionView, at: indexPath)
    }
}
```

With this code, we properly capture `self`, the view controller (and reference type) that owns `viewModel`. When the `dataSource` calls the cell provider to configure a cell, it will reference the new method on the view controller, which forwards the call to the view model. This ensures that the latest version of the view model &mdash; which is frequently regenerated based on underlying data &mdash; will always be referenced.

Also note that we capture `self` as `unowned` instead of `weak` in the `CellProvider` closure &mdash; which prevents a retain cycle, but is "less safe" than using `weak` because it behaves like an implicitly unwrapped optional. We can reason that we can safely use `unowned` here, because `self` owns the `dataSource`, thus `self` will always exist for the lifetime of `dataSource` and the lifetime of the closure.

Again, this sample code has been simplified to illustrate the problem. In your own projects, you probably want to encapsulate all of your view model and data source code _outside_ of your view controller.

The important takeaway here is to be sure that you are **not capturing value types** in the cell provider closures that you pass to your diffable data sources. I enjoy using the "modern collection view" APIs as opposed to implementing the old school [`UICollectionViewDataSource` protocol](https://developer.apple.com/documentation/uikit/uicollectionviewdatasource), but they do introduce a different kind of complexity and new opportunities to make subtle mistakes.
