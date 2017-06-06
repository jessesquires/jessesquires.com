---
layout: post
title: Protocol composition in Swift and Objective-C
subtitle: Designing optional semantics without optional methods
---

[Protocols](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/Protocol.html) in Swift and Objective-C are a powerful tool to decouple your code. They allow you to specify a contract between classes that consume them, but defer a concrete implementation to conformers. They allow you to [segregate interfaces](https://en.wikipedia.org/wiki/Interface_segregation_principle) and [invert control](https://en.wikipedia.org/wiki/Dependency_inversion_principle). One interesting aspect of protocols in Swift and Objective-C is that protocol members can be *optional* (`optional` in Swift or `@optional` in Objective-C). Unfortunately, this comes with a number of disadvantages and diminishes the robustness of your code, so it is often avoided. However, having optional members is sometimes the right conceptual model for your design. How can you design your protocols to provide optional semantics without specifying them as `optional` or `@optional`?

<!--excerpt-->

### The problem with `@optional`

Let's begin with Objective-C. Optional protocol methods were introduced in Objective-C 2.0 and are used heavily in Cocoa and Cocoa Touch. You implement protocols with optional methods all the time while working with UIKit, for example. But despite their prevalence, they are widely discouraged and considered a poor design. This is because you forgo compile-time checks for `@optional` protocol methods in Objective-C. If a method is optional, then the compiler has no way to enforce that the conformers implement it. On the other hand, it is an error if you declare protocol conformance but fail to implement the required methods. Thus, it is the *caller's responsibility* to check [`-respondsToSelector:`](https://developer.apple.com/reference/objectivec/1418956-nsobject/1418583-respondstoselector) before calling an optional method. If you forget this check and the class does not implement the optional method, you'll crash at runtime with a 'does not respond to selector' exception.

Consider the following example:

{% highlight objc %}
@protocol MyViewControllerDelegate <NSObject>

- (void)didDismissController:(MyViewController *)controller;

@optional
- (void)controller:(MyViewController *)controller didSelectItem:(MyItem *)item;

@end


@interface MyViewController : UIViewController

@property (nonatomic, weak) id<MyViewControllerDelegate> delegate;

@end
{% endhighlight %}

Calling required methods on the `delegate` is straightforward:

{% highlight objc %}
[self.delegate didDismissController:self];
{% endhighlight %}

With optional methods, not only do you forgo help from the compiler, but you incur the additional runtime cost of checking `-respondsToSelector:` every time you need to message the `delegate` object.

{% highlight objc %}
if ([self.delegate respondsToSelector:@selector(controller:didSelectItem:)]) {
    [self.delegate controller:self didSelectItem:item];
}
{% endhighlight %}

### The problem with `optional`

Swift addresses the safety problems above and offers a convenient `?` syntax for optional members:

{% highlight swift %}
delegate?.controller?(self, didSelect: item)
{% endhighlight %}

In this case, you do not have to worry about runtime crashes in Swift, but there is another problem. In Swift, `optional` is *not really* "part of the language" or "pure Swift" &mdash; the feature relies on the Objective-C runtime and **it only exists for interoperability with Objective-C**. Any protocol in Swift that contains optional members must be marked as `@objc`. I have [written before](/avoiding-objc-in-swift/) about avoiding `@objc` in your Swift code as much as possible. When `@objc` infiltrates your object graph, nearly everything must inherit from `NSObject` which means you cannot use Swift structs, enums, or other nice features. This leaves you not writing Swift, but merely "Objective-C with a new syntax". Clearly, `optional` isn't much of an option in Swift.

### The 'never optional' solution

One naive solution is to simply never use `optional` or `@optional`. This is easy and straightforward. It's great for simple cases. You provide a strict contract and avoid the shortcomings mentioned above, but in many cases this places an unnecessary burden on classes that conform to the protocol. You end up with a slew of empty methods, or methods that return sentinel values like `nil`, `-1`, or `false`. Consider the familiar [`UITableViewDataSource`](https://developer.apple.com/reference/uikit/uitableviewdatasource) protocol. It has two required methods and **nine** optional methods. Imagine if these were all `@required` but you wanted to opt-out of those behaviors. You would have nine empty method stubs, or you would have to return `nil` for methods like [`tableView(_: titleForHeaderInSection:) -> String?`](https://developer.apple.com/reference/uikit/uitableviewdatasource/1614850-tableview).

### Using multiple protocols and properties

A better approach is to split up large protocols into smaller ones, and provide a unique property (like a delegate) for each one. Again, consider [`UITableViewDataSource`](https://developer.apple.com/reference/uikit/uitableviewdatasource). There are clear semantic groupings for these methods. It could easily be broken up into multiple protocols and `UITableView` could have a property for each one. Ash Furrow [has a great article](https://ashfurrow.com/blog/protocols-and-swift/) on doing exactly that. Thus, we could reimagine these APIs in the following way:

{% highlight swift %}
class TableView {
    weak var dataSource: TableViewDataSource?
    weak var titlesDataSource: TableViewTitlesDataSource?
    weak var reorderingDataSource: TableViewReorderingDataSource?

    // And so on...
}

protocol TableViewDataSource: class {
    func numberOfSections(in tableView: UITableView) -> Int
    func tableView(tableView: TableView, numberOfRowsInSection section: Int) -> Int
    func tableView(tableView: TableView, cellForRowAtIndexPath indexPath: IndexPath) -> TableViewCell
}

protocol TableViewTitlesDataSource: class {
    func tableView(tableView: TableView, titleForHeaderInSection section: Int) -> String?
    func tableView(tableView: TableView, titleForFooterInSection section: Int) -> String?
}

protocol TableViewReorderingDataSource: class {
    func tableView(tableView: TableView, canMoveRowAtIndexPath indexPath: IndexPath) -> Bool
    func tableView(tableView: TableView, moveRowAtIndexPath sourceIndexPath: IndexPath, toIndexPath destinationIndexPath: IndexPath)
}

// And so on...
{% endhighlight %}

This design transfers the "optional-ness" from the protocol itself to an additional optional property on the class. If you want headers and footers in your table view, you can opt-in to those by setting `titlesDataSource`. To opt-out, you can set this property to `nil`. The same applies to `reorderingDataSource`, and so on. This design feels appropriate for `UITableView` at first. Many of the methods are not directly related to one another and there are clear semantic groupings. In practice, however, it feels awkward having to access multiple separate properties to query the same underlying data source.

{% highlight swift %}
// access sections via `dataSource`
let sections = dataSource?.tableView(tableView: self, numberOfRowsInSection: 0)

// access titles via `titlesDataSource`
let headerTitle = titlesDataSource?.tableView(tableView: self, titleForHeaderInSection: 0)

// access reordering via `reorderingDataSource`
let canMove = reorderingDataSource?.tableView(tableView: self, canMoveRowAtIndexPath: IndexPath(row: 0, section: 0))
{% endhighlight %}

Having these disjoint protocols and properties is not desirable. Despite having nice semantic groupings, all of these methods *are related* in the sense that they all need access to *the same underlying data* in order to work properly together. To accommodate the complete `UITableViewDataSource` protocol, there would be five distinct protocols, each with a corresponding property on `UITableView`. Then you could reorganize the [`UITableViewDelegate`](https://developer.apple.com/reference/uikit/uitableviewdelegate) protocol in the same way, which would have at least 10 protocols and properties. Having this many `dataSource` and `delegate` properties is unintuitive and cumbersome. How can we improve this?

### Composing protocols

Instead of numerous disjoint protocols, you can design a union of protocols. This provides a single, top-level "entry point" to reference. You can extract the optional members of a protocol into a new protocol, then add an optional property for this new protocol on the original protocol. The result is a comprehensive top-level protocol and a set of "nested" protocols.

Adjusting the table view example above:

{% highlight swift %}
class TableView {
    weak var dataSource: TableViewDataSource?
}

protocol TableViewDataSource: class {
    func numberOfSections(in tableView: UITableView) -> Int
    func tableView(tableView: TableView, numberOfRowsInSection section: Int) -> Int
    func tableView(tableView: TableView, cellForRowAtIndexPath indexPath: IndexPath) -> TableViewCell

    var titles: TableViewTitlesDataSource? { get }
    var reordering: TableViewReorderingDataSource? { get }
}

// And so on...
{% endhighlight %}

Now the table view has a single `dataSource` property. The other protocols still exist, but they are absorbed into the `titles` and `reordering` properties. Another positive aspect of this design is that the opt-in/opt-out behavior for the nested protocols is explicitly declared. The conformer to `TableViewDataSource` can return `nil` to opt-out or return `self` to opt-in to these additional methods.

{% highlight swift %}
class MyDataSource: TableViewDataSource, TableViewTitlesDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        // return sections
    }

    func tableView(tableView: TableView, numberOfRowsInSection section: Int) -> Int {
        // return rows per section
    }

    func tableView(tableView: TableView, cellForRowAtIndexPath indexPath: IndexPath) -> TableViewCell {
        // configure and return a cell
    }

    var titles: TableViewTitlesDataSource? {
        // opt-in to headers and footers
        return self;
    }

    func tableView(tableView: TableView, titleForHeaderInSection section: Int) -> String? {
        // return header title
    }

    func tableView(tableView: TableView, titleForFooterInSection section: Int) -> String? {
        // return footer title
    }

    var reordering: TableViewReorderingDataSource? {
        // opt-out of reordering
        return nil
    }
}
{% endhighlight %}

Accessing these nested members goes through a single point of access:

{% highlight swift %}
let sections = dataSource?.tableView(tableView: self, numberOfRowsInSection: 0)

let headerTitle = dataSource?.titles?.tableView(tableView: self, titleForHeaderInSection: 0)

let canMove = dataSource?.reordering?.tableView(tableView: self, canMoveRowAtIndexPath: IndexPath(row: 0, section: 0))
{% endhighlight %}

This reduces the API surface area of `UITableView` by only having a single `dataSource` property instead of five &mdash; not to mention the 10 potential `delegate` properties there could have been after splitting up `UITableViewDelegate`. It unifies all of the methods of the data source protocol without resorting to using `optional`, while allowing you to opt out of the additional behavior in a concise way. In the case of Objective-C, the check for `-respondsToSelector:` becomes a simple check for `nil` instead, and the compiler can enforce that the entire protocol is implemented. Overall, it feels cleaner and much more cohesive, especially at the call site.

**UPDATE:**  [@IanKay](https://twitter.com/IanKay/status/871773445373149184) pointed out that you [can further reduce boilerplate](https://gist.github.com/IanKeen/68eba888221a1a8de03dbbdd8a4dfcf1) from the child protocols by using protocol extensions. For example:

{% highlight swift %}
extension TableViewDataSource {
    var titles: TableViewTitlesDataSource? { return nil }
    var reordering: TableViewReorderingDataSource? { return nil }
}
{% endhighlight %}

See [the full gist](https://gist.github.com/IanKeen/68eba888221a1a8de03dbbdd8a4dfcf1) for more details.

### Conclusion

As we've explored, there are a number of ways to design a solution to the "optional protocol problem". You can design a model that avoids optionality altogether, you can provide many protocols with corresponding properties, or you can design a "nested composition" of protocols. Every situation is different, but I often find this nested composition approach to be the most elegant, powerful, and intuitive.
