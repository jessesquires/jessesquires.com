---
layout: post
title: Debugging a subtle Swift bug that will make you facepalm
image:
    file: swift-function-ref.jpg
    half_width: false
---

The other day I was debugging a crash in a UI test for an open pull request at work. The bug turned out to be extremely subtle and difficult to notice. I spent way too much time staring at the changes, trying to understand what was wrong. Let's see if you can spot the error.

<!--excerpt-->

Here's the problematic line:

{% highlight swift %}
func toDictionary() -> [String: Any] {
    var dict: [String: Any] = [:]

    // code setting other keys and values...

    dict[JSONKeys.dateClosed] = self.dateClosed?.toMongoDate

    return dict
}
{% endhighlight %}

The details here don't matter. This is some legacy JSON serialization code, predating the introduction of `Codable` ([SE-0166](https://github.com/apple/swift-evolution/blob/master/proposals/0166-swift-archival-serialization.md) and [SE-0167](https://github.com/apple/swift-evolution/blob/master/proposals/0167-swift-encoders.md)). This function serializes the object to a JSON dictionary, `self.dateClosed` is a `Date` type, and `JSONKeys.dateClosed` is a `String` constant.

But what's the bug? Let's look at the definition of `toMongoDate` (also some legacy code).

{% highlight swift %}
extension Date {
    func toMongoDate() -> [String: Any] {
        // return date in expected mongo date format
    }
}
{% endhighlight %}

Seems fine, right? Everything compiles. There's no issue with putting a `[String: Any]` dictionary as the value in another `[String: Any]` dictionary. `Any` can be *any* type. But that's what the problem turned out to be.

Let's look at that line again: `self.dateClosed?.toMongoDate`. This returns *the function* `toMongoDate`. That is, the reference type `() -> [String: Any]` &mdash; **not** the *result* of calling the function. I forgot the parentheses `()`. That line should read `self.dateClosed?.toMongoDate()`. However, this worked and the compiler did not complain because functions are first class types, and setting a function as the value of a `[String: Any]` dictionary is valid. This is clearly an argument for adopting [`Codable`](https://developer.apple.com/documentation/swift/codable), which would have prevented this mistake.

What's worse: this exact error has happened in our code base in at least one other scenario. It's so easy to overlook.

Much faceplam.

{% include post_image.html %}
