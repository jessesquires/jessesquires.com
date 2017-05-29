---
layout: post
title: "Enums as configuration&#58; the anti-pattern"
subtitle: Implementing the open/closed principle
redirect_from: /enums-as-configs/
---

One of the most common patterns I see in software design with Objective-C (and sometimes Swift), is the use of enumeration types (`enum`) as configurations for a class. For example, passing an `enum` to a `UIView` to style it in a certain way. In this article, I explain why I think this is an [anti-pattern](https://en.wikipedia.org/wiki/Anti-pattern) and provide a more robust, modular, and extensible approach to solving this problem.

<!--excerpt-->

### The configuration problem

Let's first define the problem we're solving. Suppose we have a class that is used in a few different contexts, where each usage needs a slightly different configuration. That is, in each unique context the behavior of the class should be different. This class could represent a view, a networking client, or anything else. When instantiated, users need to be able to specify or modify the behavior of the class for the current context without knowing or modifying any of the class's implementation details.

> **Note:** the following examples will be in Swift (3.0), but this applies to Objective-C as well. In fact, this discussion is relevant for any programming language with similar concepts.

Let's use a simple, familiar example &mdash; a [`UITableViewCell`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UITableViewCell_Class/). Suppose we have a cell layout with an image, a couple of labels, and an accessory view. The layout is pretty generic, and we want to reuse the same cell across different views in our app. Suppose our *login view* styles all of its cells with specific colors, fonts, etc. However, when we reuse these cells in our *settings view* we want all of our fonts, colors, etc. to be *different*. All views that use this cell need the same basic cell layout and subviews, but different visual treatments.

### Using an `enum` for configuration

Given the problem above, we may design something like the following:

{% highlight swift %}
enum CellStyle {
    case login
    case profile
    case settings
}

class CommonTableCell: UITableViewCell {
    var style: CellStyle {
        didSet {
            configureStyle()
        }
    }

    // ...

    func configureStyle() {
        switch cellStyle {
        case .login:
            // configure style for login view
            textLabel?.textColor = .red()
            textLabel?.font = .preferredFont(forTextStyle: UIFontTextStyleBody)

            detailTextLabel?.textColor = .blue()
            detailTextLabel?.font = .preferredFont(forTextStyle: UIFontTextStyleTitle3)

            accessoryView = UIImageView(image: UIImage(named: "chevron"))
        case .settings:
            // configure style for settings view
            textLabel?.textColor = .purple()
            textLabel?.font = .preferredFont(forTextStyle: UIFontTextStyleTitle1)

            detailTextLabel?.textColor = .green()
            detailTextLabel?.font = .preferredFont(forTextStyle: UIFontTextStyleCaption1)

            accessoryView = UIImageView(image: UIImage(named: "checkmark"))
         case .profile:
            // configure style for profile view
            // ...
        }
    }

    // ...
}

class SettingsViewController: UITableViewController {
   // ...

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      // create and configure cell
      cell.style = .settings
      return cell
   }

   // ...
}
{% endhighlight %}

We create our usual `UITableViewCell` and [`UITableViewController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UITableViewController_Class/) subclasses, and define a style `enum`. Within each view controller we set the appropriate style when we create and configure the cell. Easy enough, right?

### Why `enum` configurations are bad

If writing a library or framework, the "`enum` as configuration" pattern is often promoted as flexible for clients &mdash; *"Look at all of these configuration options provided for you!"* It is certainly a well-intentioned design, but don't be fooled. Rather than provide a truly modular and adaptable API, the result is unnecessarily limiting, cumbersome to maintain, and highly error-prone.

The notion that this design is flexible because you can *"set any style you want"* is ironic, because an `enum` is **inflexible by definition** &mdash; there are a finite number of values. In this example, a finite number of cell styles. If this were part of your app, each time you encounter a new context where you want to use this cell, you would need to add a new `case` to `CellStyle` and update the enormous `switch` statement.

If this were a library, there would be no way for clients to add a new `case` or define their own style. Clients would have to request a new style be added and/or submit a pull request to implement it. Further, adding a new value to the `enum` is technically a **breaking** change for your library &mdash; if a client is using this `enum` in a `switch` statement in other parts of their application then the addition of a new `case` will be an error since Swift requires `switch` statements to be exhaustive.

It's even worse in Objective-C &mdash; there are no errors or warnings for incomplete `switch` statements and it is too easy to omit a `break;` and accidentally fall through to the next `case`. Of course, you can mitigate these deficiencies (and more) by enabling a few clang warnings: `-Wcovered-switch-default`, `-Wimplicit-fallthrough`, `-Wassign-enum`, `-Wswitch-enum`. But I digress.

This approach is fragile, [imperative](https://en.wikipedia.org/wiki/Imperative_programming), and produces a lot of duplicate code. We can do better.

### Configuration models

Rather than obfuscate what's happening by exposing merely an `enum`, we can open up our API using a technique known as [inversion of control](https://en.wikipedia.org/wiki/Inversion_of_control). Continuing with our example, what if we create an entirely new model to represent our cell style? Consider the following:

{% highlight swift %}
struct CellStyle {
    let labelColor: UIColor
    let labelFont: UIFont
    let detailColor: UIColor
    let detailFont: UIFont
    let accessory: UIImage
}

class CommonTableCell: UITableViewCell {
    // ...

    func apply(style: CellStyle) {
        textLabel?.textColor = style.labelColor
        textLabel?.font = style.labelFont

        detailTextLabel?.textColor = style.detailColor
        detailTextLabel?.font = style.detailFont

        accessoryView = UIImageView(image: style.accessory)
    }

    // ...
}
{% endhighlight %}

Instead of an `enum`, we can create a `struct` that represents our cell style. Not only does this clearly define all attributes of the style, but we can now **map this value directly onto** the cell in a less procedural, more [declarative](https://en.wikipedia.org/wiki/Declarative_programming) way. In other scenarios, we could pass a configuration to a class's designated initializer.

We've eliminated a ton of code and complexity from this class, leaving it smaller, easier to read, and easier to reason about. There is a well-defined, one-to-one mapping from the style attributes to the cell attributes. We no longer have the maintenance burden of the giant `switch` statement, nor its proclivity towards introducing errors. Finally, not only can clients express infinitely many styles, but introducing new styles **no longer results in changing the original class**, nor does it result in breaking changes if creating a library.

### Providing default and custom values

Another reason this design is superior is because it allows us to provide sensible default values, and add new styles in a purely additive, non-breaking way. Some of Swift's features really shine here &mdash; default parameter values, [extensions](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Extensions.html), and [type inference](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Types.html#//apple_ref/doc/uid/TP40014097-CH31-ID457). The language is so conducive to these types of patterns, whereas Objective-C feels clumsy, tedious, and verbose.

In Swift, we can provide default values in the initializer:

{% highlight swift %}
struct CellStyle {
    let labelColor: UIColor
    let labelFont: UIFont
    let detailColor: UIColor
    let detailFont: UIFont
    let accessory: UIImage

    init(labelColor: UIColor = .black(),
         labelFont: UIFont = .preferredFont(forTextStyle: UIFontTextStyleTitle1),
         detailColor: UIColor = .lightGray(),
         detailFont: UIFont = .preferredFont(forTextStyle: UIFontTextStyleCaption1),
         accessory: UIImage) {
        self.labelColor = labelColor
        self.labelFont = labelFont
        self.detailColor = detailColor
        self.detailFont = detailFont
        self.accessory = accessory
    }
}
{% endhighlight %}

And for our library-provided styles that we previously defined using an `enum`, we can define properties in an extension:

{% highlight swift %}
extension CellStyle {
    static var settings: CellStyle {
        return CellStyle(labelColor: .purple(),
                         labelFont: .preferredFont(forTextStyle: UIFontTextStyleTitle1),
                         detailColor: .green(),
                         detailFont: .preferredFont(forTextStyle: UIFontTextStyleCaption1),
                         accessory: UIImage(named: "checkmark")!)
    }
}

// usage:
cell.apply(style: .settings)
{% endhighlight %}

Notice the call site can actually remain *unchanged* due to Swift's type inference. Previously `.settings` referred to the `enum` value, but it now refers to the `static var` property in the extension. We can provide a more modular, extensible API without sacrificing conciseness or clarity.

As mentioned above, clients can now effortlessly provide their own styles by adding an extension. Even more, they can choose to only override some of the default properties:

{% highlight swift %}
extension CellStyle {
    static var custom: CellStyle {
        // uses default fonts
        return CellStyle(labelColor: .blue(),
                         detailColor: .red(),
                         accessory: UIImage(named: "action")!)
    }
}
{% endhighlight %}

### Configurations as behaviors

While our example focused on styling a view, I want to reiterate that this is a powerful pattern for modeling general behaviors. Consider a class responsible for networking. Its configuration could specify the protocol, retry policy for failures, cache expiration, and more. Where you previously would have had a litany of individual properties, you can now bundle these attributes into a single cohesive unit, provide default behaviors, and allow for customization.

### Real world examples

A savvy reader would likely realize by now that this is exactly how the [`URLSession`](https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSURLSession_class/) and [`URLSessionConfiguration`](https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSURLSessionConfiguration_class/index.html#//apple_ref/occ/cl/NSURLSessionConfiguration) APIs are designed. Among others, this is one reason to celebrate this API over the now obsolete [`NSURLConnection`](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSURLConnection_Class/). Notice how `URLSessionConfiguration` provides three configurations: `.default`, `.ephemeral`, and `.background(withIdentifier:)`. It also allows you to customize individual properties. Imagine how limiting this API would be if it were merely an `enum`.

Let's look at another example on the other side of the spectrum &mdash; [`UIPresentationController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIPresentationController_class/). This API allows us to provide custom presentations for view controllers by creating custom presentation controllers. Previously, this API was limited to... an `enum`! The only presentation styles available were those defined by [`UIModalPresentationStyle`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/index.html#//apple_ref/swift/enum/c:@E@UIModalPresentationStyle). As we've explored above, this incredibly inflexible for clients. However, `UIKit` unfortunately did not get this new API 100% correct. There are parts of the public API that still depend on `UIModalPresentationStyle` values:

{% highlight swift %}
func adaptivePresentationStyle(for traitCollection: UITraitCollection) -> UIModalPresentationStyle
{% endhighlight %}

This method requires you to return a `UIModalPresentationStyle` value for the specified `UITraitCollection`. What we *should* be able to do here is return any arbitrary `UIPresentationController`. If you want to learn more, see [my talk](/swifty-presenters/) about these APIs.

For our final example, let's look at the evolution of [JSQMessagesViewController](http://www.jessesquires.com/JSQMessagesViewController/). A **very old** version of this library [provided](https://github.com/jessesquires/JSQMessagesViewController/blob/e6b9413f49605e3ec9cb70991f73f20de900c1e7/JSMessagesViewController/Classes/JSMessagesViewController.h#L23-L48) an `enum` to determine how timestamps were displayed in the messages view, `JSMessagesViewTimestampPolicy`. Today, there's a [data source](https://github.com/jessesquires/JSQMessagesViewController/blob/develop/JSQMessagesViewController/Model/JSQMessagesCollectionViewDataSource.h#L114-L126) and [delegate](https://github.com/jessesquires/JSQMessagesViewController/blob/develop/JSQMessagesViewController/Model/JSQMessagesCollectionViewDelegateFlowLayout.h#L38-L50) method for determining what text should be displayed above the message bubbles and when it should be displayed. Not only can clients specify exactly when to show these labels, but they do not even have to contain timestamps! The API just asks for any arbitrary text. In this case, you'll notice that we don't provide a configuration object for clients like what we describe above. Instead, data source and delegate objects fulfill this role &mdash; this is another method by which we can [invert control](https://en.wikipedia.org/wiki/Inversion_of_control) to provide more powerful and simpler APIs for clients for custom configuration and custom behavior.

### Conclusion

What we've explored in this post is a manifestation of the [open/closed principle](https://en.wikipedia.org/wiki/Open/closed_principle) &mdash; the "O" in [SOLID](https://en.wikipedia.org/wiki/SOLID_(object-oriented_design)).

> Software entities should be open for extension, but closed for modification. That is, such an entity can allow its behavior to be extended without modifying its source code.

We've seen that attempting to implement this principle via enumeration types is limiting for clients, error-prone, and a maintenance burden. By using configuration and behavior objects or data sources and delegates, we can simplify our code, eliminate errors, maintain concision and clarity, provide a modular and extensible API for clients, and avoid breaking changes.

What kind of styles, configurations, or behaviors can you identify in your app? Time to refactor. 🤓
