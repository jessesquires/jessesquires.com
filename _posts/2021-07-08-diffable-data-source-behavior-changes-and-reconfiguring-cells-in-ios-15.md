---
layout: post
categories: [software-dev]
tags: [collection-view, table-view, ios, wwdc, uikit, documentation]
date: 2021-07-08T16:27:41-07:00
title: Diffable data source behavior changes and reconfiguring cells in iOS 15
---

This year at WWDC, some significant improvements and changes were announced for `UICollectionView` and `UITableView`. You can watch [_10252: Make blazing fast lists and collection views_](https://developer.apple.com/videos/play/wwdc2021/10252/) for all the details, but I want to highlight some of them here.

<!--excerpt-->

### Diffable data source changes

Tables and collections have nearly identical APIs for diffable data sources. The behavior of both has changed. To apply a snapshot to your diffable data source, you call [`apply(_:animatingDifferences:completion:)`](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource/3375795-apply). Prior to iOS 15, passing `true` to `animatingDifferences` would apply the diff and animate updates in the UI, while passing `false` was equivalent to calling [`reloadData()`](https://developer.apple.com/documentation/uikit/uicollectionview/1618078-reloaddata). As of iOS 15, applying a snapshot using this API will **always** perform a diff, optionally animate the UI updates based on the value of `animatingDifferences`. To explicitly reload without diffing, you can now call [`applySnapshotUsingReloadData(_:completion:)`](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource/3804470-applysnapshotusingreloaddata) instead. (I should also note that there are `async` versions of all these APIs as well.)

This means, if you had hacks in your code base to apply diffs **without** animations, you can remove them. For example, this is no longer necessary:

```swift
// apply diff without animations
UIView.performWithoutAnimation {
    dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
}
```

To make development easier, you can write some extensions for compatibility until you drop iOS 14 support:

```swift
extension UICollectionViewDiffableDataSource {
    func reloadData(
        snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
        completion: (() -> Void)? = nil
    ) {
        if #available(iOS 15.0, *) {
            self.applySnapshotUsingReloadData(snapshot, completion: completion)
        } else {
            self.apply(snapshot, animatingDifferences: false, completion: completion)
        }
    }

    func applySnapshot(
        _ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
        animated: Bool,
        completion: (() -> Void)? = nil) {

        if #available(iOS 15.0, *) {
            self.apply(snapshot, animatingDifferences: animated, completion: completion)
        } else {
            if animated {
                self.apply(snapshot, animatingDifferences: true, completion: completion)
            } else {
                UIView.performWithoutAnimation {
                    self.apply(snapshot, animatingDifferences: true, completion: completion)
                }
            }
        }
    }
}
```

You can write a similar extension for `UITableViewDiffableDataSource`.

When possible, you should always prefer diffing by applying snapshots instead of reloading data, which completely resets your collection or table view &mdash; that throws away any existing cells and other data that UIKit might be caching. The primary use cases for reloading data are when you want to apply a completely different set of data, completely change your cell classes, or apply a huge set of changes that would degrade performance using diffing.

### Reconfiguring cells

The other notable change in iOS 15 is a new API to reconfigure cells. If using diffable data sources, you can use [`reconfigureItems(_:)`](https://developer.apple.com/documentation/uikit/nsdiffabledatasourcesnapshot/3804468-reconfigureitems). Otherwise, there are APIs for both [collection view](https://developer.apple.com/documentation/uikit/uicollectionview/3801889-reconfigureitems) and [table view](https://developer.apple.com/documentation/uikit/uitableview/3801923-reconfigurerows). Using reconfigure results in much better performance than reload data, because it reuses the existing cell rather than dequeuing and configuring a brand new cell. Per [the docs](https://developer.apple.com/documentation/uikit/nsdiffabledatasourcesnapshot/3804468-reconfigureitems), you should "choose to reconfigure items instead of reloading items unless you have an explicit need to replace the existing cell with a new cell." Reconfiguring cells is much less invasive and more efficient than reloading them.

Prior to iOS 15, you could achieve this "reconfigure" behavior with some workarounds:

```swift
extension UICollectionView {
    func reconfigureCell(at indexPath: IndexPath) {
        let visibleIndexPaths = self.indexPathsForVisibleItems
        let foundIndexPath = visibleIndexPaths.first { $0 == indexPath }

        if let foundIndexPath = foundIndexPath {
            let cell = self.cellForItem(at: foundIndexPath)
            // get model that corresponds to index path
            // reconfigure the cell using the model
        }
    }
}
```

You can write a similar extension for table view. However, as you will see, this is not quite an exact replacement for the new reconfigure behavior in iOS 15 because of how tables and collections cache their cells behind the scenes.

One thing not mentioned in the docs or the WWDC video is how reconfigure works internally. Luckily, [Tyler Fox](https://mobile.twitter.com/smileyborg/) from the UIKit team published [a thread on Twitter](https://mobile.twitter.com/smileyborg/status/1403908057185144832) with some details (which I will summarize and rephrase into proper sentences).

If there is no existing cell (for your diffable identifier or for your index path), then reconfigure is a no-op. I think this makes sense, although it is not entirely clear under what circumstances a cell may not exist. The [reconfigure docs](https://developer.apple.com/documentation/uikit/nsdiffabledatasourcesnapshot/3804468-reconfigureitems) do not elaborate on this. I assume this only occurs if your identifier is invalid (meaning it does not exist in your snapshot) or your index path is invalid (meaning it is out of range). Interestingly, the docs for [`UICollectionView.cellForItem(at:)`](https://developer.apple.com/documentation/uikit/uicollectionview/1618088-cellforitem) have been updated and give us a clue:

> `func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell?`
>
> Gets the cell object at the index path you specify.
>
> **Return Value**<br/>
> The cell object at the corresponding index path. In versions of iOS earlier than iOS 15, this method returns `nil` if the cell isn't visible or if `indexPath` is out of range. In iOS 15 and later, this method returns a non-`nil` cell if the collection view retains a prepared cell at the specified index path, even if the cell isn't currently visible.
>
> **Discussion**<br/>
> In iOS 15 and later, the collection view retains a prepared cell in the following situations:
> - Cells that the collection view prefetches and retains in its cache of prepared cells, but that aren't visible because the collection view hasn't displayed them yet.
> - Cells that the collection view finishes displaying and continues to retain in its cache of prepared cells because they remain near the visible region and might scroll back into view.
> - The cell that contains the first responder.
> - The cell that has focus.

I assume these are the same criteria for how reconfigure works. Thus, a no-op is determined by a combination of: (1) the validity of your identifier or index path, (2) whether or not a cell is cached, and (3) the visibility of the cell.

Back to [Tyler's thread](https://mobile.twitter.com/smileyborg/status/1403908057185144832):

If an existing cell is found, then reconfigure succeeds. The table or collection view will call your cell provider again, but with special behavior to return the existing cell when you dequeue one for that index path. The view will re-run your normal cell configuration code using the existing cell. Depending on how you have your table or collection setup, this will be one of the following: a [cell registration](https://developer.apple.com/documentation/uikit/uicollectionview/cellregistration), a diffable [cell provider](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource/cellprovider), or an old-school data source [`cellForItemAt:`](https://developer.apple.com/documentation/uikit/uicollectionviewdatasource/1618029-collectionview) implementation. This means your existing cell configuration code can now update cells later.

After cells are reconfigured, they are always self-sized again. Any changes to the content which affect cell sizing will be automatically taken into account and the cell resized as necessary. When reconfiguring a cell, you **must** dequeue the **same type of cell** to get the existing cell back, and you **must** return that same cell back to the collection view or table view. This means that if you need to _change the cell type_, you **cannot** use reconfigure. You must use reload in that scenario instead.

**There is one particularly important reason to prefer reconfigure:** it will preserve existing prepared cells &mdash; cached cells which were either already prefetched, or already displayed and are waiting to become visible again. Using reload will discard those cells, which wastes valuable work.

This last part of Tyler's thread combined with the docs for [`UICollectionView.cellForItem(at:)`](https://developer.apple.com/documentation/uikit/uicollectionview/1618088-cellforitem) that I mentioned above helps give us a deeper understanding of what's going on.

Lastly, it is important to note that reconfigure **is not** a replacement for reload. As discussed above, there are still valid use cases where you should continue using reload.
