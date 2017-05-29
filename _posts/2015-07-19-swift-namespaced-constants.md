---
layout: post
title: Namespaced constants in Swift
subtitle: Using nested types for clarity
date-updated: 23 July 2015
redirect_from: /swift-namespaced-constants/
---

Mike Ash has a great [Friday Q&A](https://www.mikeash.com/pyblog/friday-qa-2011-08-19-namespaced-constants-and-functions.html) on namespaced constants and functions in C. It is a powerful and elegant technique to avoid using `#define` and verbose Objective-C prefixes. Although Swift types are namespaced by their module, we can still benefit from implementing this pattern with `struct` and `enum` types. I've been experimenting with this approach for constants in Swift and it has been incredibly useful.

<!--excerpt-->

### Icon image assets

We are all familiar with handling assets, particularly icons, using the `UIImage(named:)` API. And since iOS 7, many icons have two distinct visual states &mdash; *lined* and *filled*, or *normal* and *selected*. Thus, we find ourselves with two versions of each icon, for example `UIImage(named:"music")` and `UIImage(named:"music-selected")`.

<img class="img-thumbnail img-responsive center" src="{{ site.img_url }}/tabbar.png" title="iOS Tab Bar" alt="iOS Tab Bar"/>
<small class="text-muted center">iOS Tab Bar, taken from <a href="https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/Bars.html#//apple_ref/doc/uid/TP40006556-CH12-SW1" target="_blank">iOS Human Interface Guidelines</a>.</small>

In the past, we strove to avoid [stringly-typed](https://corner.squareup.com/2014/02/objc-codegenutils.html) Objective-C in Cocoa by creating constants or categories. But rather than apply these same techniques in Swift with an `extension`, we can do something more sophisticated.

{% highlight swift %}

enum Icon: String {
    case Music
    case Movies
    case TVShows
    case Search
    case More

    func image(selected selected: Bool = false) -> UIImage {
        return UIImage(named: selected ? self.rawValue + "-selected" : self.rawValue)!
    }
}

// Usage
let icon = Icon.Music.image() // "music" icon
let iconSelected = Icon.Music.image(selected: true) // "music-selected" icon

{% endhighlight %}

In this example, we are using the new [default enum naming](http://ericasadun.com/2015/07/08/swift-new-stuff-in-xcode-7-beta-3/) for enums with a string raw type. This alone makes a huge difference &mdash; no explicit, hard-coded strings at all! We now have constants for all of our icon names, and the `image(selected:)` method will return the correct `UIImage`.

You may be thinking that we could implement an extension on `UIImage` instead. But the goal here is proper namespacing, which makes our code easier to read and easier to write. With an extension, we are essentially in the `UIImage` namespace and I would argue that this functionality is not really appropriate to add to the `UIImage` class globally. By creating a new type, we create our own namespace. We immediately know we are dealing with icon assets when reading and writing code. We can get precise code-completion suggestions from our editor without having to remember what kind of naming conventions our teammate used for the new methods on `UIImage` &mdash; was it *musicIcon* and *musicSelectedIcon*, or *iconMusic* and *iconMusicSelected*? Instead, we can simply begin typing `Icon.` and let the editor tell us what icons are available.

### Custom colors

Another common use case for constants, or a Swift extension are for the custom colors in an app. It would be nice to be able to use an enum in this scenario, but an enum raw value type must be a **value type** &mdash; sorry `UIColor`. Alternatively, we can use structs and nested structs.

{% highlight swift %}

struct ColorPalette {
    static let Red = UIColor(red: 1.0, green: 0.1491, blue: 0.0, alpha: 1.0)
    static let Green = UIColor(red: 0.0, green: 0.5628, blue: 0.3188, alpha: 1.0)
    static let Blue = UIColor(red: 0.0, green: 0.3285, blue: 0.5749, alpha: 1.0)

    struct Gray {
        static let Light = UIColor(white: 0.8374, alpha: 1.0)
        static let Medium = UIColor(white: 0.4756, alpha: 1.0)
        static let Dark = UIColor(white: 0.2605, alpha: 1.0)
    }
}

// Usage
let red = ColorPalette.Red
let darkGray = ColorPalette.Gray.Dark

{% endhighlight %}

Again, we should not add our custom colors to `UIColor` globally via an extension. For colors, using an extension presents even more challenges regarding naming. For example if you have a custom red color, you cannot name the method `redColor()` because `UIColor` already defines this class method. Do you name your method `red()`? That's kind of awkward. Do you prefix the method name like you would in Objective-C, `jsq_redColor()`? That's *more* awkward in Swift. Given light and dark versions of colors, do you use `darkPurple()`, or `purpleDark()`? If you have many dark and light variants, it might be better to use the `{colorName}{variant}` naming convention. Regardless, everyone on your team will have different opinions on naming &mdash; and they will *__all__ be great!*

Luckily we can avoid the naming wars (hopefully). Using nested structs gives us our own namespace with much richer semantics, avoids naming collisions with `UIColor`, and provides precise code-completion from our editor.

### Storyboards and beyond

What is most interesting here is realizing how **extensions can limit our design space**. (And the same applies to categories in Objective-C.) It is not hard to imagine how we could apply these techniques with regard to other resources in our apps: storyboards, xibs, or sound effects. You could even nest enums inside of structs, or enums inside of enums. So far, I've found this pattern of namespaced constants to be extremely useful.

Let me know what you think! You can find me [on Twitter](http://twitter.com/jesse_squires).

<span class="text-muted">**Note:** There have been some attempts to automate something similar to what I have described, like [swiftrsrc](https://github.com/indragiek/swiftrsrc) and [Natalie](https://github.com/krzyzanowskim/Natalie), but not exactly. Some of the deeper nesting might be difficult to automate, but I have yet to try this.</span>

<p class="alert alert-danger">
   <strong>Update</strong> <span class="pull-right"><em>{{ page.date-updated }}</em></span>
   <br />
   Inspired by this post, <a href="https://twitter.com/leemorgan" class="alert-link" target="_blank">Lee Morgan</a> has written a build script that generates a Swift source file based on Xcode assets. Checkout the repo <a href="https://github.com/leemorgan/AutoAssets" class="alert-link" target="_blank">AutoAssets</a> on GitHub. Thanks Lee!
</p>
