---
layout: post
categories: [software-dev]
tags: [series-reactive-collections-kit, ios, uikit, open-source, collection-view, swift]
date: 2025-02-19T19:29:42-08:00
title: Type erasure for Equatable and Hashable types in Swift
subtitle: Lessons from ReactiveCollectionsKit
---

[Type erasure](https://en.wikipedia.org/wiki/Type_erasure) is a method to abstract and encapsulate heterogenous generic types inside a single non-generic concrete type. In programming languages with generic types, this is a mechanism for runtime polymorphism which allows you circumvent the constraints of generics at compile time. In the early days of Swift, generics were more challenging to work with --- in particular, protocols with [associated types](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics/#Associated-Types). As of Swift 5.7 (and [*SE-0309: Unlock existentials for all protocols*](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0309-unlock-existential-types-for-all-protocols.md)), type erasure is now a feature of the Swift compiler. However, there are still situations where you may need to manually write your own type-erased wrappers.

<!--excerpt-->

In this post, I'm going to use [ReactiveCollectionsKit](https://github.com/jessesquires/ReactiveCollectionsKit) as a case study for some of the challenges you may face with generic programming in Swift and how we can use type erasure to solve them. I'd recommend reading the [other posts in my series]({{ "series-reactive-collections-kit" | tag_url }}) on ReactiveCollectionsKit.

The idea behind type erasure is that you need to "erase" the type information for multiple heterogenous types in order to refer to them as a single homogenous type. In other words, type erasure allows you to hide differing underlying types behind a single type.

### A brief overview and history of type erasure in Swift

This is a brief and incomplete overview of type erasure in Swift. I will be glossing over many details in order to establish a rudimentary understanding of core concepts for the purposes of this post.

Before [SE-0309](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0309-unlock-existential-types-for-all-protocols.md) (see also: [SE-0353](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0353-constrained-existential-types.md) and [SE-0346](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0346-light-weight-same-type-syntax.md)), the only option was to write your own type-erased wrapper types. Even if you have never manually implemented type erasure in your own projects, you _have_ used it. The Swift Standard Library has a number of type-erased types. One of the most common is probably [`AnyHashable`](https://developer.apple.com/documentation/swift/anyhashable) because of its use with `Dictionary`. There's also [`AnyCollection`](https://developer.apple.com/documentation/swift/anycollection), [`AnySequence`](https://developer.apple.com/documentation/swift/anysequence), [`AnyIndex`](https://developer.apple.com/documentation/swift/anyindex), and many more. If you're curious how these are implemented, you can view [the Standard Library source code](https://github.com/swiftlang/swift/tree/main/stdlib).

The convention is to prefix these wrapper types with "Any". The strategy for implementing them is essentially copying all properties and functions from the generic type into the "Any" type, or simply storing an `Any` property and forwarding all members of the wrapper type to the underlying type.

Let's use `AnyHashable` as a quick example. Below is a simplified implementation to demonstrate core concepts. Note that the [actual implementation](https://github.com/swiftlang/swift/blob/main/stdlib/public/core/AnyHashable.swift) is significantly more complex.

```swift
struct AnyHashable: Hashable {
    var base: Any

    init<H: Hashable>(_ base: H) {
        self.base = base
    }
}
```

Notice that the initializer is generic. It receives a concrete type, `H`, that conforms to `Hashable`. However, it stores the `base` property as `Any`, thus _erasing_ the concrete type. Importantly, `AnyHashable` also conforms to `Hashable`. The purpose of this is to forward the `Hashable` implementation to the underlying property stored in `base`.

But how do we forward the `Hashable` implementation to `base` if it is declared as `Any`? If type erasure can be described as "boxing" up a type, then we need to "unbox" the type to transform it back to its concrete type. This process of opening an `Any` or `any` type is known as [reification](https://en.wikipedia.org/wiki/Reification_(computer_science)). In Swift, we do this using the `as?` operator.

Below is a simplified example of implementing `Hashable`, which includes the `hash(into:)` and `==` functions. These calls are forwarded to the underlying `base` property.

```swift
struct AnyHashable: Hashable {
    var base: Any

    init<H: Hashable>(_ base: H) {
        self.base = base
    }

    // Implement Hashable

    func hash(into hasher: inout Hasher) {
        guard let base = self.base as? (any Hashable) else {
            fatalError("base should be hashable")
        }

        hasher.combine(base)
    }

    static func == (left: Self, right: Self) -> Bool {
        guard let leftBase = left.base as? (any Equatable),
              let rightBase = right.base as? (any Equatable) else {
            return false
        }

        return _isEqual(lhs: leftBase, rhs: rightBase)
    }

    private static func _isEqual<T: Equatable, U: Equatable>(lhs: T, rhs: U) -> Bool {
        if let rhsAsT = rhs as? T {
            return lhs == rhsAsT
        }

        if let lhsAsU = lhs as? U {
            return lhsAsU == rhs
        }

        return false
    }
}
```

Equality is especially tricky. Notice that we have to attempt to cast each side to the same concrete type before continuing with the comparison. This is because the `==` operator operates on two values of the same type. Otherwise, `==` would not make any sense --- for example, attempting to compare an `Int` and a `String` is invalid.

Using `AnyHashable` allows us to store heterogenous types in a homogenous way. For example, `Array` can only store a collection of values of a single type. The following produces a compiler error:

```swift
let array = ["string", 42, 3.14, false]
```

However, we could instead store these values as `AnyHashable`, which works:

```swift
let array = [AnyHashable("string"), AnyHashable(42), AnyHashable(3.14), AnyHashable(false)]
```

Since Swift 5.7 and [*SE-0309: Unlock existentials for all protocols*](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0309-unlock-existential-types-for-all-protocols.md), type erasure is now a feature of the Swift compiler. This proposal introduced the `any` keyword, allowing you to write `any MyProtocol` to erase the generic constraints of `MyProtocol`. You no longer need to manually write these type-erased wrappers in most scenarios. Continuing with the `AnyHashable` example, you could instead write `any Hashable` and eliminate the need for the custom wrapper type.

However, while using `any Hashable` versus `AnyHashable` may seem equivalent, there are some important distinctions. Using `any Hashable` gives you an _existential_ type, an abstract representation, while `AnyHashable` is a _concrete type_. We can observe the difference in behavior by trying to compare values of each type.

```swift
let one: any Hashable = 1
let two: any Hashable = 2

one == two // Error: Binary operator '==' cannot be applied to two 'any Hashable' operands
```

Attempting to compare any two values of type `any <Some Protocol>` will always produce an error. As mentioned above, this is because the `==` operator compares two values of _the same (concrete) type_. At compile time, it is not known what is the actual type of `any <Some Protocol>`, which is abstract --- multiple concrete types could implement the protocol and different types cannot be `Equatable`, for example comparing a `String` and an `Int` does not make sense.

On the other hand, comparison of `AnyHashable` values works because it _is a concrete type_. That is, the `==` operator works given two `AnyHashable` values.

```swift
let one: AnyHashable = 1
let two: AnyHashable = 2

one == two // this works, returns false
```

Doug Gregor [wrote an excellent post on type erasure](https://www.douggregor.net/posts/swift-for-cxx-practitioners-type-erasure/) in Swift as part of his _"Swift for C++ Practitioners"_ series. While it is aimed at explaining Swift to C++ developers, it covers Swift in detail and I highly recommend reading it for a deeper dive. I also recommend reading [this post on type erasure](https://swiftrocks.com/whats-any-understanding-type-erasure-in-swift) from Bruno Rocha.

### Generics and type erasure in ReactiveCollectionsKit

Now let's dive into the details of [ReactiveCollectionsKit](https://github.com/jessesquires/ReactiveCollectionsKit) to see a real world example of the challenges presented by generic programming and how we can use type erasure to solve them. If you need a refresher on ReactiveCollectionsKit, you review [the other posts in this series]({{ "series-reactive-collections-kit" | tag_url }}).

The core component in ReactiveCollectionsKit is the `CellViewModel`, which represents a cell in a collection view. Clients can provide any type they want to the library, as long as it conforms to the [`CellViewModel` protocol](https://jessesquires.github.io/ReactiveCollectionsKit/Protocols/CellViewModel.html). Here's a simplified definition of `CellViewModel` for the purposes of this post. (You can find [the full source on GitHub](https://github.com/jessesquires/ReactiveCollectionsKit/blob/main/Sources/CellViewModel.swift).) For folks familiar with the library, `SupplementaryViewModel` follows a similar design.

```swift
protocol CellViewModel: DiffableViewModel {
    associatedtype CellType: UICollectionViewCell

    var shouldHighlight: Bool { get }

    func configure(cell: CellType)

    func didSelect()
}

protocol DiffableViewModel: Identifiable, Hashable {
    var id: AnyHashable { get }
}
```

Note that `CellViewModel` inherits from `DiffableViewModel`, which powers how diffing works in the library. Also notice that `CellViewModel` is generic on the type of cell this view model configures. This is important --- it allows clients to mix-and-match the types of cells they display in a collection and provides an ergonomic, type-safe API rather than having to cast from `UICollectionViewCell` to their specific cell subclass.

Here's an example concrete implementation of a `CellViewModel`.

```swift
struct PersonCellViewModel: CellViewModel {
    let person: PersonModel

    // MARK: CellViewModel

    var id: UniqueIdentifier { self.person.id }

    var shouldHighlight = true

    func configure(cell: PersonCell) {
        cell.title = self.person.name
        // additional configuration
    }

    func didSelect() {
        // handle selection
    }
}
```

All cells in a collection view belong to a section. In ReactiveCollectionsKit, sections are modeled by `SectionViewModel`. This is where the challenges arise from the `associatedtype` in `CellViewModel`.

The interface we want for `SectionViewModel` would look something like the following. Again, this definition is simplified for the purposes of this post. Note that sections are also diffable, thus `SectionViewModel` also inherits from `DiffableViewModel`.

```swift
struct SectionViewModel: DiffableViewModel {
    let cells: [CellViewModel] // Error due to generic constraints via associatedtype
}
```

This does not work, because of the generic constraints in `CellViewModel`. To solve this, we could make `SectionViewModel` generic on the type of cell:

```swift
struct SectionViewModel<Cell: CellViewModel>: DiffableViewModel {
    let cells: [Cell]
}
```

However, this defeats the entire purpose as it restricts a section to displaying a single type of cell. The solution offered by the compiler is to use `any`.

```swift
struct SectionViewModel: DiffableViewModel {
    let cells: [any CellViewModel]
}
```

This _almost_ works. In many contexts, you could stop here. However, this presents a new problem for ReactiveCollectionsKit. Sections and cells are diffable via `DiffableViewModel`, which inherits from `Equatable` and `Hashable`. Without being equatable and hashable, we have no mechanism to perform diffs on cells or sections.

As mentioned above, values with the type `any <Some Protocol>` are _not_ `Equatable` --- and thus, _not_ `Hashable`, which inherits from `Equatable`. The problem here is that `any CellViewModel` is not `Equatable`. This is why we need to introduce a new type-erased wrapper for `CellViewModel`. We'll call it `AnyCellViewModel`. This results in the following interface for `SectionViewModel`:

```swift
struct SectionViewModel: DiffableViewModel {
    let cells: [AnyCellViewModel]
}
```

Let's write an initial implementation of `AnyCellViewModel`.

```swift
struct AnyCellViewModel: CellViewModel {
    // MARK: DiffableViewModel

    var id: AnyHashable { self._id }

    // MARK: CellViewModel

    typealias CellType = UICollectionViewCell

    var shouldHighlight: Bool { self._shouldHighlight }

    func configure(cell: UICollectionViewCell) {
        self._configure(cell)
    }

    func didSelect() {
        self._didSelect(coordinator)
    }

    // MARK: Private

    private let _id: AnyHashable
    private let _shouldHighlight: Bool
    private let _configure: (CellType) -> Void
    private let _didSelect: () -> Void

    // MARK: Init

    init<T: CellViewModel>(_ viewModel: T) {
        self._id = viewModel.id
        self._shouldHighlight = viewModel.shouldHighlight
        self._configure = {
            viewModel.configure(cell: $0 as! T.CellType)
        }
        self._didSelect = {
            viewModel.didSelect()
        }
    }
}
```

The strategy here is to copy all properties and methods from the `CellViewModel` protocol. Properties are copied directly and methods are copied as closure properties. Next, `AnyCellViewModel` implements the `CellViewModel` protocol and forwards all implementations to the copied properties. Notice we have to force-cast the cell type in the `_configure()` closure from the generic `UICollectionViewCell` from `AnyCellViewModel` to the specific cell subclass provided by the concrete `CellViewModel` we receive in the initializer. This might seem dangerous, but we know this is a safe operation.

This works as far as it satisfies the type system. However, there is more to do. The above definition of `AnyCellViewModel` will not work for diffing. We need to implement `Equatable` and `Hashable`, and we need more information from the original `viewModel` instance to do it. So far, `AnyCellViewModel` only knows about the members of `CellViewModel`. Yet, clients can provide any type that conforms to `CellViewModel` to the library. Consider the example above using `PersonCellViewModel`:

```swift
struct PersonCellViewModel: CellViewModel {
    let person: PersonModel

    // ... implementation continues ...
}
```

In this situation, being `Equatable` and `Hashable` involves comparing the value stored in `let person: PersonModel`. We cannot store a `PersonModel` property on `AnyCellViewModel` --- that does not generalize. We also cannot make `AnyCellViewModel` generic, which defeats the entire purpose of type erasure. What we need to do is store the entire `PersonCellViewModel` inside `AnyCellViewModel` in a way that is generalized (though not using generics), but also allows us access `Equatable` and `Hashable`. That is, we cannot simply use `Any`.

What we can do is store the concrete view model as an `AnyHashable` value:

```swift
struct AnyCellViewModel: CellViewModel {
    // ... implementation continues ...

    private let _viewModel: AnyHashable

    init<T: CellViewModel>(_ viewModel: T) {
        self._viewModel = viewModel

        // ... implementation continues ...
    }
}
```

This erases the generic constraints of `viewModel` imposed by `CellViewModel` while preserving access to `Equatable` and `Hashable`. Now, we can simply forward the implementations from these two protocols:

```swift
extension AnyCellViewModel: Equatable {
    static func == (left: AnyCellViewModel, right: AnyCellViewModel) -> Bool {
        left._viewModel == right._viewModel
    }
}

extension AnyCellViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        self._viewModel.hash(into: &hasher)
    }
}
```

This resolves all of our issues. Clients receive an ergonomic, type-safe, generic API for `CellViewModel`. The library can successfully type erase all the values provided as `AnyCellViewModel`. And diffing _just works_ in any and every scenario using `Equatable` and `Hashable`.

We can provide a convenience method to facilitate type erasure:

```swift
extension CellViewModel {
    func eraseToAnyViewModel() -> AnyCellViewModel {
        // prevent "double erasure"
        if let erasedViewModel = self as? AnyCellViewModel {
            return erasedViewModel
        }
        return AnyCellViewModel(self)
    }
}
```

Additionally, you'll notice that [`SectionViewModel`](https://jessesquires.github.io/ReactiveCollectionsKit/Structs/SectionViewModel.html) provides a number of convenience initializers using generics. In scenarios where you _do not have mixed data types_, the generic initializers allow you ignore this implementation detail and the library handles the type erasure for you. Below is a simplified example of one convenience initializer for `SectionViewModel`.

```swift
extension SectionViewModel {
    init<Cell: CellViewModel>(cells: [Cell]) {
        self.cells = cells.map { $0.eraseToAnyViewModel() }
    }
}
```

This initializer receives a single concrete type, `Cell`, that conforms to `CellViewModel`. It performs the type erasure internally. This greatly improves the usability of the API and helps reduce the burden on clients of having to always convert to `AnyCellViewModel`.

### Conclusion

While generic programming is a powerful tool, there are often times where you may find yourself fighting with the type system. If your solution requires the use of generics but you are struggling to reconcile heterogenous types with generic constraints, a great tool to reach for is type erasure via `any`. If that does not work, like in the case of ReactiveCollectionsKit, you can write your own type-erased wrapper type. Importantly, if you need to preserve conformance to `Equatable` and `Hashable`, you can utilize `AnyHashable` as demonstrated above.
