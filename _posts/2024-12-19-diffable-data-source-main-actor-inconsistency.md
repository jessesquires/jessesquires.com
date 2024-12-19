---
layout: post
categories: [software-dev]
tags: [xcode, ios, uikit, swift, concurrency]
date: 2024-12-19T11:54:07-08:00
title: UIKit DiffableDataSource API inconsistencies with Swift Concurrency annotations explained
---

UIKit provides two diffable data source APIs, one for [collections](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource-9tqpa) and one for [tables](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource-2euir).
Recently, while working on [ReactiveCollectionKit]({% post_url 2024-10-18-introducing-reactivecollectionskit %}), I noticed that the APIs were updated for Swift Concurrency in the iOS 18 SDK, but the annotations were inconsistent with the documentation.

<!--excerpt-->

The main entry point into working with snapshots is the `apply(_:animatingDifferences:completion:)` method. There's one for [`UICollectionViewDiffableDataSource`](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource-9tqpa/apply(_:animatingdifferences:completion:)) and one for [`UITableViewDiffableDataSource`](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource-2euir/apply(_:animatingdifferences:completion:)). The method signatures and docs are identical for both. They were both updated with `@MainActor` and `@preconcurrency` annotations for iOS 18.

```swift
@MainActor @preconcurrency
func apply(
    _ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
    animatingDifferences: Bool = true,
    completion: (() -> Void)? = nil
)
```

However, the documentation states:

> You can safely call this method from a background queue, but you must do so consistently in your app. Always call this method exclusively from the main queue or from a background queue.

This is a problem if you were calling these methods from a background queue and attempted to upgrade to Swift 6. This is because Swift 6 Concurrency makes calling this method from a background queue impossible. The compiler will not let you do it because it is `@MainActor` rather than `nonisolated`. So... what's the deal?

I reached out to [Tyler Fox](https://mas.to/@smileyborg/) from the UIKit team on Mastodon to ask if this was a mistake. As it turns out, it is not a mistake and his reply was incredibly helpful and insightful. For posterity and documentation purposes (and because social media is ephemeral and unreliable), I'm going to reproduce [his entire response here](https://mas.to/@smileyborg/113427085770601417):

> The main actor annotation is intentional, see the full explanation attached. There isn't a perfect solution here though, unfortunately.
>
> Also be sure to refer [to this documentation](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/updating_collection_views_using_diffable_data_sources) for additional best practices around diffable data source, especially around using proper identifiers (instead of lightweight data structures) as this is key to efficient performance with large data sets.
>
> This was an intentional change made to the diffable data source API in the iOS 18 SDK. The existing diffable data source API and implementation has strict concurrency requirements that do not translate into Swift Concurrency (specifically, it must be used from a single dispatch queue, which nonisolated cannot express).
>
> We have seen a number of issues stemming from usage of diffable data source on background queues/threads, and the performance benefits of doing this are generally minimal due to the fact that only the diffing of identifiers in the old & new snapshots happens on the background queue/thread; the work to set up and execute the Ul updates and animations for cells always happens on the main thread. Therefore, we made the decision to restrict diffable data source to the main actor when using Swift Concurrency, as this ensures correctness in all cases and is nearly always the best approach anyways. If you were previously applying snapshots from a background queue, we recommend you update your implementation to do so on the main queue instead.
>
> If you are concerned about performance, you should measure and profile your app with large data sets using Instruments (e.g. Time Profiler). You will almost certainly find that the diffing portion of the work (which was the only portion eligible to occur off the main thread) is negligible compared to the work involved in creating cells, measuring their sizes, performing layout, etc as part of Ul updates. If you do see any significant work happening during the diffing process, make sure you are using proper identifiers, and revisit the hashing and equality implementations of your identifiers. If your snapshots contain tens or hundreds of thousands of items (or more), you may wish to use techniques such as pagination to reduce the total number of items populated in the Ul at once.
>
> Finally, if you do discover a use case where you believe background queue diffing is essential, please do submit feedback so we can understand the use case and make recommendations or consider potential enhancements to the AP to better support it.

If you were running into issues with these APIs or were confused by the discrepancy in the docs, I hope this helps! The inconsistency remains in the written documentation, which is not ideal. But, I'm very grateful that Tyler took the time to reply and clear up the confusion. Thanks Tyler!
