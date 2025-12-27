---
layout: post
categories: [software-dev]
tags: [swift, ios, macos]
date: 2020-10-08T12:35:42-07:00
title: Swift deinit is (sometimes) not called for throwing or failable initializers
---

I was [never a fan of failable initializers]({% post_url 2014-10-22-swift-failable-initializers %}) in Swift. I do not think this is the correct place to fail and return `nil` *most of the time*. Of course, there are exceptions where a failable initializer is appropriate. But there is another behavior of which to be aware. When constructing a class via a failable initializer, `init?()` &mdash; or a throwing initializer, `init() throws` &mdash; the deinitializer, `deinit`, is **not called** if initialization fails or throws, respectively.

<!--excerpt-->

Surprisingly, in the [Swift Programming Language Guide](https://docs.swift.org/swift-book/) the sections on [Failable Initializers](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID224), [Deinitialization](https://docs.swift.org/swift-book/LanguageGuide/Deinitialization.html), and [Error Handling](https://docs.swift.org/swift-book/LanguageGuide/ErrorHandling.html#) do not mention this edge case where `deinit` will not be called. At first glance, it is quite unintuitive &mdash; shouldn't `deinit` *always* get called? After you learn why `deinit` may not be called, it makes sense, but it is not obvious and can lead to incorrect code. Because of this, I think it should be highlighted in the text as a "note" or a "warning" like so:

> <small><b>NOTE</b></small><br>
> If you return `nil` from a failable initializer, `init?()`, or if you throw an error from a throwing initializer, `init() throws`, then `deinit` will **not** get called. This means you must clean up any manually allocated memory or other resources *before* you return `nil` or `throw`.

As dangerous as this may seem, it is correct behavior. It is not memory-safe to call `deinit` if the object (or any part of the hierarchy) is uninitialized. Upon realizing this, it is trivial to come up with examples where calling `deinit` would crash after returning `nil` from `init?()` or throwing an error from `init() throws`.

Rather than provide a new example, let's have a history lesson and travel back in time to the early days of Swift.

{% include break.html %}

A quick aside: I took notes on this topic years ago, when it came up in 2016 on the Swift mailing lists. (Remember [those](https://lists.swift.org/pipermail/swift-evolution/)?) I meant to write a blog post then. But, well... here we are. &#x1F605; I am writing this post now, because it recently came up again in a [discussion on Twitter](https://mobile.twitter.com/steipete/status/1297917648102195200).

### Failable initializers and `deinit`

[Failable initializers debuted](https://developer.apple.com/swift/blog/?id=17) with Swift 1.1, which shipped with Xcode 6.1 in 2014. (Just typing that sentence makes me feel so old.) This was the era of the Swift mailing lists, before [the forums](https://forums.swift.org) existed. Our friend [Chris Eidhof](http://www.eidhof.nl) noticed this edge case with `deinit` in January 2016 and [wrote to the mailing list](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20160125/007763.html) to discuss it. [Doug Gregor](https://twitter.com/dgregor79), a Core Team member, kindly [replied](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20160125/007769.html).

I'll reproduce the messages here for readability and posterity:

**From Chris:** ([link](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20160125/007763.html))

> Now that we can return `nil` from a failable initializer without having initialized all the properties, it’s easier to make a mistake. For example, consider the following (artificial) code:

```swift
class MyArray<T> {
    var pointer: UnsafeMutablePointer<T>
    var capacity: Int

    init?(capacity: Int) {
        pointer = UnsafeMutablePointer.alloc(capacity)
        if capacity > 100 {
            // Here we should also free the memory.
            // In other words, duplicate the code from deinit.
            return nil
        }
        self.capacity = capacity

    }

    deinit {
        pointer.destroy(capacity)
    }
}
```

> In the `return nil` case, we should really free the memory allocated by the pointer. Or in other words, we need to duplicate the behavior from the `deinit`.
>
> Before Swift 2.2, this mistake wasn’t possible, because we knew that we could count on `deinit` being called, *always*. With the current behavior, return `nil` is easier, but it does come at the cost of accidentally introducing bugs. As Joe Groff pointed out, a solution would be to have something like "deferOnError" (or in this case, "deferOnNil"), but that feels a bit heavy-weight to me (and you still have to duplicate code).
>
> In any case, I think it's nice that we can now return `nil` earlier. I don't like that it goes at the cost of safety, but I realize it's probably only making things less safe in a small amount of edge cases.

**From Doug:** ([link](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20160125/007769.html))

> Let’s re-order the statements in your example:

```swift
class MyArray<T> {
    var pointer: UnsafeMutablePointer<T>
    var capacity: Int

    init?(capacity: Int) {
        if capacity > 100 {
            // Here we should also free the memory.
            // In other words, duplicate the code from deinit.
            return nil
        }
        self.capacity = capacity
        pointer = UnsafeMutablePointer.alloc(capacity)
    }

    deinit {
        pointer.destroy(capacity)
    }
}
```

> If the initializer returns `nil` and we still call `deinit`, we end up destroying a pointer that was never allocated.
>
> If you come from an Objective-C background, you might expect implicit zeroing of the allocated block to help here. However, Swift doesn’t have that, because many Swift types don’t have a “zero” state that’s safe to destroy. For example, anything with a member of non-optional reference type, e.g.,

```swift
class ClassWrapper {
  var array: MyArray<String>

  init(array: MyArray<String>) {
    self.array = array
  }

  deinit {
    print(array) // array is a valid instance of MyArray<String>
  }
}
```

> A valid `ClassWrapper` instance will always have an instance of `MyArray<String>`, even throughout its deinitializer.
>
> The basic property here is that one cannot run a deinitializer on an instance that hasn't been fully constructed (all the way up the class hierarchy).

The same discussion, though more concise, also took place [on this Twitter thread](https://twitter.com/chriseidhof/status/692003288804413440) on the same day, when Chris posted about what he found. Doug [also replied there](https://twitter.com/dgregor79/status/692005967467163648).

> *26 Jan 2016* <br>
> [**@chriseidhof**](https://twitter.com/chriseidhof/status/692003288804413440) <br>
> It looks like Swift 2.2 doesn't call deinit when you return nil from a failable initializer. That looks dangerous. Is this expected?

> [**@dgregor79**](https://twitter.com/dgregor79/status/692005967467163648) <br>
> it's correct behavior, because it's not memory-safe to call deinit if any part of the hierarchy is uninitialized

> [**@chriseidhof**](https://twitter.com/chriseidhof/status/692006263576731649) <br>
> right. But it's a subtle non-obvious thing, now you can e.g. alloc something without the corresponding free if you return nil.

> [**@dgregor79**](https://twitter.com/dgregor79/status/692048367568887809) <br>
> one has to be very careful if you're explicitly managing resources (via deinit) and you have throwing/failing initializers.

Notably, Doug also mentions that the same edge case exists for throwing initializers in this last tweet.

{% include break.html %}

Now, let's return to 2020. About a month ago our friend [Peter Steinberger](https://steipete.me) discovered this again.

> *24 Aug 2020* <br>
> [**@steipete**](https://mobile.twitter.com/steipete/status/1297917648102195200) <br>
> Is deinit called if the initializer is failable?

It brought me joy to see [Doug Gregor come to the rescue again](https://mobile.twitter.com/dgregor79/status/1297919970005811200) with the answer, over **four years later**. &#x1F602;

> [**@dgregor79**](https://mobile.twitter.com/dgregor79/status/1297919970005811200) <br>
> That’s correct. If an initializer throws or fails, the initialized stored properties of the partially-constructed self will be torn down but the deinit will not be called (because that would violate memory safety).

### Conclusion

I hope this post clarifies the potential memory-safety issues regarding failable and throwing initializers and how they interact with `deinit`. Hopefully this can serve as documentation for this edge case.

In 2024, the next time someone asks about this, just send them this link.
