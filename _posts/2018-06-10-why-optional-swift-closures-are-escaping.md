---
layout: post
categories: [software-dev]
tags: [swift, open-source, design]
date: 2018-06-10T10:00:00-07:00
title: Why optional closures in Swift are escaping
---

In a recent episode of [the podcast](https://spec.fm/podcasts/swift-unwrapped/144991), JP and I discussed the implicit escaping of closures in Swift. As Swift has matured and evolved, the default behavior of closure parameters in functions has changed. Prior to Swift 3, closures parameters were *escaping* by default. After [SE-103](https://github.com/apple/swift-evolution/blob/master/proposals/0103-make-noescape-default.md), the default was changed to *non-escaping*.

<!--excerpt-->

In Swift 3, to opt out of the default behavior you could annotate the function parameter with `@noescape`. Now that this is the default, you need to specify `@escaping` to make a closure escaping. Greg Heo provides [a great explanation over on Swift Unboxed](https://swiftunboxed.com/lang/closures-escaping-noescape-swift3/).

Anyway, our episode focused on a newly found issue in the Swift compiler where a no-escape closure bridged from Swift could end up escaping in Objective-C. [Doug Gregor explained the problem](https://forums.swift.org/t/implicit-escaping-of-closures-via-objective-c/12025) in detail on the Swift forums. During our discussion on the show, there was another piece of the "escaping closure" story about which JP and I were unsure.

Putting aside all of these rules and changes, *optional* closure parameters are not allowed to be annotated because they are **always implicitly escaping**. But why?

On Twitter, [David Hart explained](https://twitter.com/dhartbit/status/998605843846311942):

> It doesn’t make sense to add escaping annotations to optional closures because they aren’t function types: they are basically an `enum` (Optional) containing a function, the same way you would store a closure in any type: it’s implicitly escaping because it’s owned by another type.

This seems so obvious to me now, but I honestly had no idea why optional closures were treated differently. Optionals are [just a 2-case enum](https://github.com/apple/swift/blob/master/stdlib/public/core/Optional.swift#L122-L133). Like any other type that owns a closure, that closure is by definition escaping. Thus, an optional closure isn't much different from a struct that has a closure property:

{% highlight swift %}
typealias Handler = () -> Void

struct Closure {
    let handler: Handler
}
{% endhighlight %}

And more to the point, it doesn't make sense to annotate non-function types as `@escaping`. Of course, it's quite easy to verify this ourselves:

{% highlight swift %}
func performWorkOptional(handler: Handler?) {
    print(type(of: handler))
}

performWorkOptional { /* ... */ }

// prints: Optional<() -> ()>
{% endhighlight %}

And for the non-optional case:

{% highlight swift %}
func performWork(handler: @escaping Handler) {
    print(type(of: handler))
}

performWork { /* ... */ }

// prints: () -> ()

{% endhighlight %}
