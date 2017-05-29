---
layout: post
title: Swift enumerations and equatable
subtitle: Implementing equatable for enums with associated values
redirect_from: /swift-enumerations-and-equatable/
---

Recently, I came across a **case** (*pun intended*) where I needed to compare two instances of an `enum` type in Swift. However, it was an `enum` where some cases had [associated values](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Enumerations.html#//apple_ref/doc/uid/TP40014097-CH12-ID148). At first glance, it is not obvious how to do this.

<!--excerpt-->

As you likely know, if you want to compare two instances of a type in Swift, then that type must conform to the [Equatable](http://nshipster.com/swift-comparison-protocols/) protocol. In other words, you must define the `==` operator for the type.
If the enumeration does not have associated values or if it has a raw-value type, then you get the `==` operator for free from the Swift [Standard Library](https://developer.apple.com/library/prerelease/ios/documentation/General/Reference/SwiftStandardLibraryReference/index.html). For example:

{% highlight swift %}

// With a raw-value
// Double conforms to Equatable
enum Math: Double {
    case Pi = 3.1415
    case Phi = 1.6180
    case Tau = 6.2831
}

Math.Pi == Math.Pi // true
Math.Tau == Math.Phi // false
Math.Tau != Math.Phi // true

// Without a raw-value
enum CompassPoint: Equatable {
    case North
    case South
    case East
    case West
}

CompassPoint.North == CompassPoint.North // true
CompassPoint.South == CompassPoint.East // false

{% endhighlight %}

Comparing cases in these enumerations works *out-of-the-box* because enumerations that have cases of a raw-value type implicitly conform to the [RawRepresentable](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Reference/Swift_RawRepresentable_Protocol/index.html#//apple_ref/swift/intf/s:PSs16RawRepresentable) protocol. The Swift Standard Library provides implementations of the `==` operator for `RawRepresentable` types and generic `T` types.

{% highlight swift %}

// Used to compare 'Math' enum
func ==<T : RawRepresentable where T.RawValue : Equatable>(lhs: T, rhs: T) -> Bool

// Used to compare 'CompassPoint' enum
func ==<T : Equatable>(lhs: T?, rhs: T?) -> Bool

{% endhighlight %}

It is easy to see how and why this works. For the `RawRepresentable` type, as long as the `rawValue` conforms to `Equatable`, then all this function has to do is compare the raw-value from each type. Without a raw-value, the different enumeration members are fully-fledged values in their own right. But if the some cases of the enumeration have [associated values](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Enumerations.html#//apple_ref/doc/uid/TP40014097-CH12-ID148), then you must implement the `==` operator yourself. Consider the following example.

{% highlight swift %}

enum Barcode {
    case UPCA(Int, Int)
    case QRCode(String)
    case None
}

// Error: binary operator '==' cannot be applied to two Barcode operands
Barcode.QRCode("code") == Barcode.QRCode("code")
{% endhighlight %}

If you are well versed in Swift's pattern matching capabilities, then conforming to `Equatable` is very straightforward.

{% highlight swift %}
extension Barcode: Equatable {
}

func ==(lhs: Barcode, rhs: Barcode) -> Bool {
    switch (lhs, rhs) {
    case (let .UPCA(codeA1, codeB1), let .UPCA(codeA2, codeB2)):
        return codeA1 == codeA2 && codeB1 == codeB2

    case (let .QRCode(code1), let .QRCode(code2)):
        return code1 == code2

    case (.None, .None):
        return true

    default:
        return false
    }
}

Barcode.QRCode("code") == Barcode.QRCode("code") // true
Barcode.UPCA(1234, 1234) == Barcode.UPCA(4567, 7890) // false
Barcode.None == Barcode.None // true

{% endhighlight %}

Even with Swift 2.0, the syntax is a somewhat difficult to read and difficult to remember. We must pattern match on each case and then unpack the associated values (if any) to compare them directly. That's it! Now we can compare our custom enumerations.
