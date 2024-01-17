---
layout: post
categories: [software-dev]
tags: [swift]
date: 2024-01-17T10:40:34-08:00
title: Swift protocol requirement quirks
---

Perhaps "quirks" is not the correct description, but I recently encountered some unexpected behavior when modifying a protocol in Swift. While I was initially slightly confused, how Swift handles protocol requirements does make sense --- conformances are more lenient than you might think!

<!--excerpt-->

I was updating one of my open source Swift packages, [Foil](https://github.com/jessesquires/foil), which provides a `UserDefaults` property wrapper. Prior to [the latest release](https://github.com/jessesquires/Foil/releases/tag/5.0.0), it defined the following protocol:

```swift
protocol UserDefaultsSerializable {
    associatedtype StoredValue

    var storedValue: StoredValue { get }

    init(storedValue: StoredValue)
}
```

And I was changing the protocol to make the initializer [failable](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/initialization/#Failable-Initializers).

```diff
- init(storedValue: StoredValue)
+ init?(storedValue: StoredValue)
```

I anticipated getting lots of compiler errors (or at least warnings) about conformers who declared `init` instead of `init?` --- but that did not happen. It turns out, this is by design. In some situations, protocol witnesses (values or types that satisfy protocol requirements) do not have to exactly match a protocol requirement. Protocol witnesses can sometimes mismatch requirements with more "lenient" alternatives. You can see this in the example above: a non-failable `init` still satisfies the protocol requirements when a failable `init?` is specified. It might seem like a mistake at first, but this makes sense.

Consider another scenario in Swift: a non-optional value can be passed to an optional parameter in a function or set to an optional property, but not the other way around --- that is, you _cannot_ pass an _optional_ value to a function parameter that accepts a _non-optional_ value.

Many thanks to [Olivier Halligon](https://mastodon.social/@aligatr@ohai.social/111728768518347308), [Jordan Rose](https://mastodon.social/@jrose@belkadan.com/111739119102582991), and [Ole Begemann](https://mastodon.social/@ole@chaos.social/111739130657945322) for the help in understanding this in our discussion on Mastodon. You can find a thorough discussion on the Swift Forums in this post, [_Protocol Witness Matching Roadmap_](https://forums.swift.org/t/protocol-witness-matching-roadmap/60297), started by Suyash Srijan.

A handful of protocol witness mismatches are currently allowed:

- Non-failable initializers can satisfy failable initializer protocol requirements (as I encountered above)
- Non-throwing functions can satisfy throwing function protocol requirements
- Non-escaping closure parameters can satisfy `@escaping` protocol requirements
- Generic functions can satisfy non-generic protocol requirements
- Non-mutating functions can satisfy `mutating` protocol requirements
- Enum cases can satisfy `static` function protocol requirements
- Synchronous methods can satisfy `async` protocol requirements

Most other protocol witness mismatches are forbidden and will produce a compiler error.

An easy way to think about this is that the requirements above can be satisfied by _more specific_ or _more specialized_ declarations, but not _less specific_ or _less constrained_ declarations. A square is a rectangle, but a rectangle is not a square.

The [forum discussion](https://forums.swift.org/t/protocol-witness-matching-roadmap/60297) outlines further details and potential plans for the future. I recommend reading it!
