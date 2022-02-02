---
layout: post
categories: [software-dev]
tags: [floating-point, swift, ios, macos]
date: 2022-02-01T21:53:54-08:00
title: When should you use Decimal instead of Double?
---

In Swift there are 13 numeric types. Like most other programming languages, Swift provides signed integers of various sizes, corresponding unsigned integers, and a few floating-point types. But if you've been developing apps for Apple platforms for any amount of time, you'll recognize another numeric type --- [`Decimal`](https://developer.apple.com/documentation/foundation/decimal) (aka [`NSDecimalNumber`](https://developer.apple.com/documentation/foundation/nsdecimalnumber?language=objc)). When we build the model layer of an app, it's important to choose the right type for the task we want to accomplish. For example, if we are counting ticket sales for an event, then `Int` (or possibly `UInt`) would be the most appropriate type. But if we are calculating sales tax, then we'll need to use a floating-point type. You likely know that `Double` is more precise than `Float`, but what about `Decimal`? When should you reach for `Decimal` instead?

<!--excerpt-->

I was recently facing this question, and this post is a summary of everything I've learned. I could not find many resources on the web explaining the differences and benefits of `Double` versus `Decimal`, so I asked the Apple dev community [on Twitter](https://mobile.twitter.com/jesse_squires/status/1487593653438582787) instead. The resulting thread was extremely helpful. But, social media is ephemeral and impossible to search --- not to mention, I [periodically delete my tweets]({% post_url 2021-03-16-deleting-tweets-and-other-social-media-content%}) --- so that's where this post comes in. I hope this post can serve as a good reference on when and why you might want to use `Decimal` instead of `Double`.

### Background

I'm currently working on a project that primarily deals with money calculations and money estimations. I started out using `Double` for the values that the user enters and for all calculations. I knew `Decimal` was an option --- and perhaps more appropriate for this context --- but I decided I would investigate this later and refactor if needed. Much to my surprise, `Decimal` **is not** a drop-in replacement for `Double`. I realized that using `Decimal` was going to require more significant refactoring than I had anticipated. If I did not _need_ to use `Decimal`, then it would not be a valuable use of my time to refactor this entire project to use it when I could simply stick with `Double`. So, as I mentioned, I [asked for help](https://mobile.twitter.com/jesse_squires/status/1487593653438582787) on Twitter.

### Floating-point types

In 2017, I wrote a post titled [_Floating-point Swift, ulp, and epsilon_]({% post_url 2017-10-01-floating-point-swift-ulp-and-epsilon %}), which explored floating-point precision in general and Swift's numerics implementation. I later [gave a talk](https://speakerdeck.com/jessesquires/exploring-swifts-numeric-types-and-protocols) on the same topic at iOS Conf Singapore. If you are not familiar with floating-point types and representation in computing, I recommend checking out those links before continuing with this post. While I have a good understanding of floating-point values in computing, I lacked the equivalent knowledge about `Decimal`.

The extremely brief summary is that floating-point values in computing are inherently imprecise because not all rational and irrational numbers can be accurately represented in base-2 and with a fixed number of bits. And, to make matters worse, rounding errors compound as the distance between representable values increases.

[Slide 11 from my talk](https://speakerdeck.com/jessesquires/exploring-swifts-numeric-types-and-protocols?slide=11) contains a diagram of Swift's [protocol-based numerics](https://developer.apple.com/documentation/swift/swift_standard_library/numbers_and_basic_values/numeric_protocols) implementation. It begins with the [`Numeric` protocol](https://developer.apple.com/documentation/swift/numeric) at the root and ends with the concrete numeric types at the leaves --- `Int`, `UInt`, `Float`, `Double`, etc. What you'll notice is that `Decimal` is nowhere to be found. This is because `Decimal` is _not_ a built-in Swift type, but rather part of the Foundation framework.

### Decimal

More importantly, `Decimal` **does not** conform to either [`BinaryFloatingPoint`](https://developer.apple.com/documentation/swift/binaryfloatingpoint) or [`FloatingPoint`](https://developer.apple.com/documentation/swift/floatingpoint), but begins its protocol conformance at [`SignedNumeric`](https://developer.apple.com/documentation/swift/signednumeric), which has the [single requirement](https://developer.apple.com/documentation/swift/signednumeric/2883859-negate) to implement `func negate()`. This reveals why `Decimal` cannot be a drop-in replacement for any of Swift's floating-point types --- most functionality is defined in the lower floating-point protocols. Similar to how mixing numeric types like `Int` and `Double` in a single expression is a compiler error in Swift, `Decimal` does not play nicely with the other numerics. Additionally, some common functionality is missing. For example, `Decimal` does not conform to `Strideable` like the other numerics, which means you cannot create ranges of `Decimal` values. Depending on your problem domain, `Decimal` can be difficult to adopt.

The documentation for [`Decimal`](https://developer.apple.com/documentation/foundation/decimal) and [`NSDecimalNumber`](https://developer.apple.com/documentation/foundation/nsdecimalnumber?language=objc) is sparse, though `NSDecimalNumber` has a bit more detail.

> An object for representing and performing arithmetic on base-10 numbers.
>
> `NSDecimalNumber`, an immutable subclass of `NSNumber`, provides an object-oriented wrapper for doing base-10 arithmetic. An instance can represent any number that can be expressed as `mantissa x 10^exponent` where `mantissa` is a decimal integer up to 38 digits long, and `exponent` is an integer from –128 through 127.

The main thing to note is that `Decimal` represents and performs **base-10 arithmetic**. This is distinct from floating-point types, which are base-2. This explains the differences between the types and why they are not interchangeable, but the documentation fails to explain _when_ or _why_ you might want to use `Decimal`.

### When to use Decimal

Given the above explanations and background information, let's return to our original question --- when and why should you use `Decimal`? If you are looking for a definitive answer, you'll be disappointed. Like so many aspects of programming, the short answer is: _it depends_.

Deciding which type to use depends on your context and problem domain. Are you working exclusively with base-10 decimal values and solving decimal-centric problems? How critical is precision to your context? Will rounding in binary negatively impact your results? Or, are you working with a lot of rational values that are not conveniently expressed in base-10? These are the kinds of questions you should consider.

For my project, I've decided that `Double` is, in fact, sufficient for my needs. While I am working with money, the calculations are already estimations, so any rounding errors are tolerable in my context and won't have a significant impact.

Below I have reproduced some of the responses and discussion [from the Twitter thread](https://mobile.twitter.com/jesse_squires/status/1487593653438582787), so you can read them directly. _[Editor's note: I've taken the liberty to correct typos and form complete sentences to improve clarity where needed.]_

[Rob Napier](https://mobile.twitter.com/cocoaphony/status/1487596770188304396):

> `Decimal` is for when you care about *decimal* values. Money is a very common example. If it's critical that 0.1 + 0.2 is *precisely* 0.3, then you need a `Decimal`. If, on the other hand, you need 1/3 * 3 to *precisely* equal 1, then you need a rational type.
>
> No number system is perfectly precise. There is always some rounding. The big question is whether you want the rounding to be in binary or decimal. Rounding in binary is more efficient, but rounding in decimal is more useful for certain decimal-centric problems.
>
> (But I don't generally recommend `Decimal` for money. I recommend `Int`, and store everything in the base unit, most commonly "cents." It's more efficient and often easier to use. Dollars or Euros are for formatting, not computation.)
>
> If you want to handle all the national currencies (except the recent El Salvador experiment), you need 3 decimal places rather than 2, but 2 will get you most of them. So you can work in 0.1 units and convert from there for the whole world.
>
> Double isn't an imprecise number format. It's *extremely* precise. It just isn't in base-10, so some common base-10 values are repeating fractions. If 1/3 were a really common value, then base-10 would be horrible, and we'd talk about storing in base-3 to avoid losing precision.

[Robb Böhnke](https://mobile.twitter.com/DLX/status/1487596281165930499):

> Yeah, it can represent base ten decimals without approximation; e.g. 0.3 will have a slight error in IEEE floats you can explore [**here**](https://h-schmidt.net/FloatConverter/IEEE754.html). So when should you use it? If you want more precise calculations for things that come in increments of `1/10^n`; If someone owes you 1/3 dollars (repeating fraction in base 10) or `sqrt(2)` euros (irrational number), you're still hosed though.

[Matt Galloway](https://mobile.twitter.com/mattjgalloway/status/1488054166077464578):

> Money yeah. I use it for example in my “cgtcalc” project which helps calculate UK capital gains tax. With `Double` it would have rounding problems all over the place.
>
> Agree. You’re right @jesse_squires that it wouldn't affect too much, but I was having rounding issues where it would make a test fail because the result after going around the house was not e.g exactly 12. Made it hard to be confident in the software.

[Jindy Helldap](https://mobile.twitter.com/luketoop/status/1487598611751784454):

> One of the most fun bugs I ever dealt with: displaying returns in a betting app. Rewrote the calculations engine to use `NSDecimal` because there were too many edge cases with floats --- for example, division by 27 or 3^3 is difficult to express in powers of 2!

[Rob Ryan](https://mobile.twitter.com/robertmryan/status/1487624401356943360):

> Two benefits of `Decimal`:
>
> 1. You can do precise decimal calculations. e.g. add `Double` of 0.1 ten times ≠ 1.0 (!)
> 2. You want to enjoy more significant digits. e.g. print `Double` representation of 12345678901234567890 and it’s not actually 12345678901234567890.

_Thank you to [Rob Napier](https://robnapier.net) ([@cocoaphony](https://mobile.twitter.com/cocoaphony)), [Robb Böhnke](https://robb.is) ([@DLX](https://mobile.twitter.com/DLX)), [Matt Galloway](https://www.galloway.me.uk) ([@mattjgalloway](https://mobile.twitter.com/mattjgalloway)) in particular for their help understanding this. And thanks to all the other folks on Twitter for contributing to the discussion._
