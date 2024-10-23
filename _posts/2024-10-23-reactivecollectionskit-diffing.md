---
layout: post
categories: [software-dev]
tags: [series-reactive-collections-kit, ios, uikit, swiftui, open-source, collection-view]
date: 2024-10-23T12:43:45-07:00
title: Diffing in ReactiveCollectionsKit
subtitle: Understanding Identity and Equality
---

Welcome to the next post in [my series about ReactiveCollectionsKit]({{ "series-reactive-collections-kit" | tag_url }}). Today I want to discuss diffing. Understanding diffing requires understanding two core concepts: **identity** and **equality**. These are two ideas that are also relevant and applicable to programming in general, and can often be confusing for newcomers.

<!--excerpt-->

In [ReactiveCollectionsKit](https://github.com/jessesquires/ReactiveCollectionsKit), diffing is modeled by the [`DiffableViewModel`](https://jessesquires.github.io/ReactiveCollectionsKit/Protocols/DiffableViewModel.html) protocol, which encapsulates the definitions of both identity and equality.

```swift
typealias UniqueIdentifier = AnyHashable

protocol DiffableViewModel: Identifiable, Hashable, Sendable {
    var id: UniqueIdentifier { get }
}
```

All view model types in the library inherit from `DiffableViewModel` --- this includes `CellViewModel`, `SupplementaryViewModel`, `SectionViewModel`, and `CollectionViewModel`. As you can see, diffability is composable. Cells and supplementary views make up a section, while sections make up a collection. Each level of your model can be diffed.

This protocol builds upon the Swift Standard Library. It requires you to provide a single `id` property, which can be _anything_ that is hashable. This property is inherited from the [`Identifiable`](https://developer.apple.com/documentation/swift/identifiable) protocol, which is generic. Thus, ReactiveCollectionsKit refines the definition to enforce that `id` is an instance of [`AnyHashable`](https://developer.apple.com/documentation/swift/anyhashable). Most commonly, the identifier is a `String`, but it could be an `Int` or any custom type. In fact, you could return `self` for this property in your `CellViewModel` definition.

The protocol also inherits from [`Hashable`](https://developer.apple.com/documentation/Swift/Hashable), which inherits from [`Equatable`](https://developer.apple.com/documentation/swift/equatable). This enforces that user-defined view model instances are both hashable and equatable. In Swift, the compiler can synthesize these protocol requirements for you if all properties of a type are `Hashable` as well. This helps remove a lot of boilerplate in ReactiveCollectionsKit when defining your `CellViewModel` types.

Altogether, this means diffing requires three pieces of information in order to work correctly, `id`, `==`, and `hash(into:)`.

```swift
// Identifiable
var id: UniqueIdentifier { get }

// Hashable
func hash(into hasher: inout Hasher)

// Equatable
static func == (left: Self, right: Self) -> Bool
```

### Identity

_Identity_ concerns itself with **permanently** and **uniquely** identifying a single instance of an object. An identity _never_ changes. Identity answers the question _"who is this?"_ For example, a passport encapsulates the concept of _identity_ for a person. A passport permanently and uniquely identifies and corresponds to a single person. (For the sake of this example, let's pretend that people cannot have multiple passports.) Identity is captured by the `Identifiable` protocol and the corresponding `id` property.

### Equality

_Equality_ concerns itself with **ephemeral** _traits_ or _properties_ of a single unique object that _change_ over time. Equality answers the question _"which of these objects with this specific `id` is the most up-to-date?"_ For example, a person is a unique entity, but they can change their hairstyle, they can wear different clothes, and can generally change any aspect of their physical appearance. While we can uniquely identify a person using their passport on any day, their physical appearance changes day-to-day or year-to-year. Equality is captured by the `Hashable` (and `Equatable`) protocol and the corresponding `==` and `hash(into:)` functions.

### Becoming diffable

Using this example, consider constructing a list of people to display in a collection. We can uniquely identify each person (using `id`) in the collection. This allows us to determine (1) if they are present, (2) their precise position, (3) if they have been inserted, deleted, or moved. Next, we can determine if they have changed (using `==`) since we last saw them. This allows us to determine when a unique person in the collection needs to be reloaded or reconfigured.

In other words, _identity_ concerns itself with the _structure_ of the collection --- _where is each item located (or not)?_ On the other hand, _equality_ concerns itself with the individual _state_ of each item --- _is that item up-to-date?_

Both [IGListKit](https://github.com/instagram/iglistkit) and [ReactiveLists](https://github.com/plangrid/reactivelists) got this correct, but their implementations are more cumbersome and manual. ReactiveCollectionsKit improves upon both of these implementations with the `DiffableViewModel` protocol above, and by harnessing Swift's type system. Identifiers can be _anything_ that is hashable and because Swift can automatically synthesize conformances to `Hashable` and `Equatable`, clients can get all of that functionality for free.

If you need to optimize your `Hashable` and `Equatable` implementations, you can manually implement the protocols in your view models. The primary motivation for overriding your `Hashable` and `Equatable` implementations is **performance**. You want your equality comparisons for diffing to be fast. This also includes your `id` property from `DiffableViewModel`. These three definitions --- `id`,  `==`, and `hash(into:)` --- will be the main bottleneck for performance when it comes to diffing. Make sure they are fast.

### Shortcomings in UIKit

Most importantly, this brings me to why a library like ReactiveCollectionsKit is necessary.

The collection view diffing APIs in UIKit **do not handle _equality_**. [`UICollectionViewDiffableDataSource`](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource) **only concerns itself with _identity_**. That is, it handles the structure (inserts/deletes/moves) for you, but you must handle reload (or reconfigure) for item property changes. (See: [Tyler Fox](https://mobile.twitter.com/smileyborg/status/1402164265897758720).) In my opinion, UIKit got this _wrong_. The diffing APIs should have also handled _equality_, like IGListKit and ReactiveLists.

If you use `UICollectionViewDiffableDataSource` out-of-the-box and do not check for item equality and reconfigure those items, then the data in your collection or list **will not update**. The _structure_ of your collection will update --- that is, items will be correctly inserted, deleted, or moved, but an item will not refresh if it has been updated in-place.

Correctly checking _equality_ for cells, supplementary views, and sections in order to reload or reconfigure them accordingly is not a trivial task. You can [find the source code here](https://github.com/jessesquires/ReactiveCollectionsKit/blob/main/Sources/DiffableDataSource.swift). I've annotated it heavily with comments to explain what is happening and why.

This is one of the primary motivations for this library. It does not merely wrap the underlying diffing APIs and reduce boilerplate, it provides critical functionality for making lists and collections work _fully_ and _correctly_. When using `UICollectionViewDiffableDataSource`, you must track property changes for all items in the collection on your own, and then reload or reconfigure those items accordingly. When using ReactiveCollectionsKit, all of this work is handled automatically for you.
