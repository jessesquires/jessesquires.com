---
layout: post
categories: [software-dev]
tags: [swift, concurrency]
date: 2024-06-05T10:30:35-07:00
date-updated: 2024-06-05T18:24:16-07:00
title: "Swift concurrency hack for passing non-sendable closures"
subtitle: Uncheck yourself before you wreck yourself
---

If you have attempted to adopt [Swift Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/) in your codebase, you have certainly needed to address dozens --- likely, hundreds --- of warnings and errors. Sometimes the issues can be resolved by addressing them directly. That is, your code was incorrect and you simply have to fix it to make it correct. In other scenarios, the resolution is not so straightforward. In particular, it is difficult to satisfy the compiler when working with APIs that you do not own that have not been updated for concurrency. Or, you may have found yourself in a situation where _you_ know your code is correct, but _the compiler_ is unable to verify its correctness --- either because of a few remaining bugs in Swift Concurrency, or because you are using `@preconcurrency` APIs.

<!--excerpt-->

One of the warnings you have probably seen multiple times is _"Capture of 'variable' with non-sendable type in a `@Sendable` closure."_ I was confronted with this warning in a project recently and I want to share the hack for how I worked around it. The issue was the result of a combination of factors I mentioned above. I was interacting with `@preconcurrency` APIs **and** I knew my code was concurrency-safe, but I was unable to accurately express that to the compiler.

### Background

First, let's discuss the context in which I was dealing with this concurrency warning. I have been working on a project that uses `UICollectionViewDiffableDataSource` and I am wrapping the UIKit APIs with something more user-friendly. For the purposes of this post, I have omitted much of the complexity to provide a clear, simple example.

I have a custom diffable data source that performs the diffing on a background thread:

```swift
@MainActor
final class DiffableDataSource: UICollectionViewDiffableDataSource<String, String> {
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, String>

    typealias SnapshotCompletion = @MainActor () -> Void

    let diffingQueue = DispatchQueue(label: "diffingQueue")

    func applyDiff(snapshot: Snapshot, animated: Bool = true, completion: SnapshotCompletion? = nil) {
        self.diffingQueue.async {
            self.apply(snapshot, animatingDifferences: animated, completion: completion)
        }
    }
}
```

Per [the documentation](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource/3375795-apply), the `completion` closure is always called on the main queue and you can call `apply(_:animatingDifferences:completion:)` from a background queue:

> [...]
>
> **completion**<br>
> A closure to execute when the animations are complete. This closure has no return value and takes no parameters. The system calls this closure from the main queue.
>
> [...]
>
> You can safely call this method from a background queue, but you must do so consistently in your app. Always call this method exclusively from the main queue or from a background queue.

Also note that `UICollectionViewDiffableDataSource` is annotated with `@MainActor @preconcurrency`.

With the strictest concurrency checking enabled, the code above produces 2 warnings:

```swift
func applyDiff(snapshot: Snapshot, animated: Bool = true, completion: SnapshotCompletion? = nil) {
    self.diffingQueue.async {
        self.apply(snapshot, animatingDifferences: animated, completion: completion)
        //                                                               ^
        // Capture of 'completion' with non-sendable type 'DiffableDataSource.SnapshotCompletion?' (aka 'Optional<@MainActor () -> ()>') in a `@Sendable` closure
        // Converting function value of type '@MainActor () -> Void' to '() -> Void' loses global actor 'MainActor'; this is an error in Swift 6
    }
}
```

One solution would be to make the completion closure `@Sendable`:

```swift
func applyDiff(snapshot: Snapshot, animated: Bool = true, completion: @escaping @Sendable () -> Void) {
    self.diffingQueue.async {
        self.apply(snapshot, animatingDifferences: animated, completion: completion)
    }
}
```

(Note that we cannot use the defined typealias `SnapshotCompletion` in this case, and it must not be optional.)

However, this will not work. This API updates the collection view to reflect the state of the data in the snapshot and, as mentioned, `completion` is called on the main thread. Callers of `applyDiff(snapshot:)` do additional UI updates and animations, or otherwise deal with `@MainActor` members and types in this completion closure. Those members and types cannot be marked as `@Sendable`. For example, the owner of the `DiffableDataSource` instance could be a view controller. Furthermore, I do not want to impose a `@Sendable` restriction upon callers.

Thus, making the closure `@Sendable` produces the following kinds of errors at the call site:

```swift
self.dataSource.applyDiff(snapshot: snapshot) {

    // Call to main actor-isolated instance method 'someMethod()' in a synchronous nonisolated context

    // Main actor-isolated property 'someProperty' can not be referenced from a Sendable closure; this is an error in Swift 6
}
```

Callers could wrap the offending lines in `Task { @MainActor in }` or `MainActor.assumeIsolated { }` to silence these issues. But, that's a burden for callers. Not to mention, the wrapper API does not accurately communicate what is happening here. We do not want a `@Sendable () -> Void` closure. We want a `@MainActor () -> Void` closure.

So, we have situation where the Swift compiler is telling us that the closure being captured needs to be `@Sendable` but we cannot make it `@Sendable`. It is also telling us that the closure loses its `@MainActor` but we know that the closure will always be called from the main queue. Because of these two problems, we need to find a way to work around the warnings and coerce the compiler into doing what we want.

### Solution (It's a hack)

We can wrap the completion closure in another type that is `@unchecked Sendable`.

```swift
struct UncheckedCompletion: @unchecked Sendable {
    typealias Block = () -> Void

    let block: Block?

    init(_ block: Block?) {
        if let block {
            self.block = {
                dispatchPrecondition(condition: .onQueue(.main))
                block()
            }
        } else {
            self.block = nil
        }
    }
}
```

This will silence the warning about _"capturing a non-sendable type in a `@Sendable` closure."_ Again, UIKit guarantees that this completion closure will always be called on the main thread, and we can use a `dispatchPrecondition()` to verify this is happening.

We can update our API to use this new `UncheckedCompletion` wrapper.

```swift
func applyDiff(snapshot: Snapshot, animated: Bool = true, completion: UncheckedCompletion) {
    self.diffingQueue.async {
        self.apply(snapshot, animatingDifferences: animated, completion: completion.block)
    }
}
```

However, exposing `UncheckedCompletion` to callers is also not a great API. We should hide this detail. We can wrap this `applyDiff()` method with another that uses the original `SnapshotCompletion` typealias.

```swift
func applyDiff(_ snapshot: Snapshot, animated: Bool = true, completion: SnapshotCompletion? = nil) {
    self.applyDiff(snapshot: snapshot, animated: animated, completion: UncheckedCompletion(completion))
    //                                                                 ^ wrapped in UncheckedCompletion
}

private func applyDiff(snapshot: Snapshot, animated: Bool, completion: UncheckedCompletion) {
    self.diffingQueue.async {
        self.apply(snapshot, animatingDifferences: animated, completion: completion.block)
        //                                                               ^ access underlying closure
    }
}
```

And now, the public API looks exactly the same as before to callers, but they can safely use `@MainActor` members and types in the completion closure without any warnings or errors.

```swift
self.dataSource.applyDiff(snapshot: snapshot) {
    // do anything here safely with @MainActor with no warnings or errors
}
```

### Is this good?

Is this a good idea? I am actually not sure! But, it seems like the best thing to do in this scenario. If you are facing a similar situation --- namely, **you know** a captured closure is always called on the main thread and you cannot make it `@Sendable` --- this might be a good solution for you too! However, this is probably _a bad idea_ to attempt to generalize. Use wisely!

{% include updated_notice.html
date="2024-06-05T18:24:16-07:00"
message="
As anticipated, [Matt Massicotte](https://mastodon.social/@mattiem) has come to the rescue, [offering a simpler solution here](https://mastodon.social/@mattiem/112565464652182320). While my clever hack works, we can instead make the closure both `@Sendable` **and** `@MainActor`. After that, we can simply wrap calling the completion closure in `MainActor.assumeIsolated { }`. Here are the changes needed:

```swift
// The addition of @Sendable is bizarre, but Swift 5.10 needs it.
// Swift 6 (via SE-0434) will make it unnecessary.
typealias SnapshotCompletion = @Sendable @MainActor () -> Void

func applyDiff(snapshot: Snapshot, animated: Bool = true, completion: SnapshotCompletion? = nil) {
    self.diffingQueue.async {
        // UIKit guarantees `completion` is called on the main queue.
        self.apply(snapshot, animatingDifferences: animated, completion: {
            // when you know its on the main actor, perhaps from documentation, but it isn't
            // encoded in the API, you can use dynamic isolation to make it work
            MainActor.assumeIsolated {
                completion?()
            }
        })
    }
}
```

This is great. It is much less code. I'm not sure why I didn't _try_ using `@Sendable @MainActor` for the closure. It's probably because I assumed that `@MainActor` _implied_ `@Sendable` --- which apparently _it should_ and _it will_ after [SE-0434](https://github.com/apple/swift-evolution/blob/main/proposals/0434-global-actor-isolated-types-usability.md) in Swift 6.

Anyway, the general idea of this hack might still be useful in other contexts or scenarios --- especially if you cannot adopt Swift 6 and need to stay on Swift 5.10.
" %}
