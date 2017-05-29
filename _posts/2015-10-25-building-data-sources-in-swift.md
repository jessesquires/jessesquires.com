---
layout: post
title: Building type-safe, composable data sources in Swift
subtitle: A modern approach to collection views and table views
redirect_from: /building-data-sources-in-swift/
---

In iOS development, the core of nearly every app rests on the foundations provided by `UICollectionView` and `UITableView`. These APIs make it simple to build interfaces that display the data in our app, and allow us to easily interact with those data. Because they are so frequently used, it makes sense to optimize and refine how we use them &mdash; to reduce the boilerplate involved in setting them up, to make them testable, and more. With Swift, we have new ways with which we can approach these APIs and reimagine how we use them to build apps.

<!--excerpt-->

### The common problem

Setting up a table view or collection view has always required a lot of boilerplate &mdash; re-implementing the [UITableViewDataSource](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UITableViewDataSource_Protocol/index.html#//apple_ref/occ/intf/UITableViewDataSource) and  [UICollectionViewDataSource](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UICollectionViewDataSource_protocol/index.html#//apple_ref/occ/intf/UICollectionViewDataSource) protocols time and time again. There are [strategies](https://www.objc.io/issues/1-view-controllers/lighter-view-controllers/) to abstract these protocols into separate data source objects, but until Swift they either had to be specialized for a specific type and thus not reusable, or reusable and not type-safe. Further, these protocols intermingle different responsibilities. As Ash Furrow [points out](http://ashfurrow.com/blog/protocols-and-swift/), it would be better to have many single-purpose protocols, instead of having one protocol that does everything.

### A modern solution

One of the first things I built with Swift (and just recently updated) was [JSQDataSourcesKit](https://github.com/jessesquires/JSQDataSourcesKit) because I wanted to address these issues. Inspired by Andy Matuschak's [gist](https://gist.github.com/andymatuschak/f1e1691fa1a327468f8e), the goals of the framework are the following:

- Remove the data source protocol boilerplate.
- Be data driven. That is, if you want to change your view then change your data or its structure.
- Protocol-oriented.
- Type-safe.
- [SOLID](https://en.wikipedia.org/wiki/SOLID_(object-oriented_design)), with a focus on single responsibility, interface segregation, and composition.
- *Pure* Swift (no `NSObject` and no `@objc`, when possible)

The framework is crafted of four main types of components: `SectionInfo`, `CellFactory`, `BridgedDataSource`, and `DataSourceProvider`. For each component, there is a corresponding protocol or type to use with both table views and collection views.

1. **`SectionInfo` &mdash;**
Section objects contain an array of your models. They represent one section of data. The framework provides `CollectionViewSection` and `TableViewSection` structs. However, they conform to the `CollectionViewSectionInfo` and `TableViewSectionInfo` protocols, respectively. This allows you to build your own.

2. **`CellFactory` &mdash;**
Cell factory objects are responsible for creating and configuring a cell for a given model. There are `CollectionViewCellFactory` and `TableViewCellFactory` structs, which conform to the `CollectionViewCellFactoryType` and `TableViewCellFactoryType` protocols, respectively. Again, this design allows you to build your own cell factory objects if you do not want to use the ones that the framework provides. For collection views only, there's also `CollectionSupplementaryViewFactory` which works similarly.

3. **`BridgedDataSource` &mdash;** These are actually opaque objects. They are `private` to the framework and not used by clients directly. Bridged data source objects implement the actual `UICollectionViewDataSource` or `UITableViewDataSource` protocols. The name refers to the fact that these objects are bridging the data source protocol methods from Objective-C classes (i.e., `NSObject` subclasses) to pure Swift classes. In order to implement  `UICollectionViewDataSource` or `UITableViewDataSource`, a class must also implement `NSObjectProtocol`, which essentially means inheriting from `NSObject`.
As mentioned above, I want to avoid the baggage of `@objc` and prevent `NSObject` from dragging its dirty fingers through the rest of my types, so it is all contained here.

4. **`DataSourceProvider` &mdash;** Data source provider objects are composed of an array of sections, a cell factory, and a bridged data source. (And for collection views, there's also a supplementary view factory.) A provider object orchestrates and mediates the communications between its constituent parts, which know nothing about each other. Finally, as the name suggests, it provides the data source for a table view or a collection view, which happens via its private bridged data source instance. To clients, it looks like this:

{% highlight swift %}

// TableViewDataSourceProvider
public var dataSource: UITableViewDataSource {
   return bridgedDataSource
}

// CollectionViewDataSourceProvider
public var dataSource: UICollectionViewDataSource {
   return bridgedDataSource
}

{% endhighlight %}

### Putting it all together

Let's take a look at how this works in practice. Here's an example for a simple collection view.

{% highlight swift %}

let section0 = CollectionViewSection(items: ViewModel(), ViewModel(), ViewModel())
let section1 = CollectionViewSection(items: ViewModel(), ViewModel())
let allSections = [section0, section1]

let cellFactory = CollectionViewCellFactory(reuseIdentifier: "CellId") { (cell, model, collectionView, indexPath) -> MyCell in
   // configure the cell with the model
   return cell
}

let headerFactory = CollectionSupplementaryViewFactory(reuseIdentifier: "HeaderViewId") { (headerView, model, kind, collectionView, indexPath) -> MyHeaderView in
   // configure the header view with the model
   return headerView
}

self.provider = CollectionViewDataSourceProvider(
                  sections: allSections,
                  cellFactory: cellFactory,
                  supplementaryViewFactory: headerFactory)

self.collectionView.dataSource = provider.dataSource

{% endhighlight %}

First, we populate our section objects with our models. Then we create our cell and header view factories. Finally, we pass all of these instances to our data source provider. That's all. The collection view will now display all of our data. The result is an elegant, composed, protocol-oriented, and testable system. You can independently test your models, test that each factory returns correctly configured views, and test that the `provider.dataSource` accurately responds to the `UICollectionViewDataSource` methods. Using this framework with table views follows similarly, with the main exception being that table views do not have supplementary views.

Also remember that the `CollectionViewDataSourceProvider` only speaks to protocols &mdash; not the concrete objects used in the example above. Its signature is the following.

{% highlight swift %}

public final class CollectionViewDataSourceProvider <
    SectionInfo: CollectionViewSectionInfo,
    CellFactory: CollectionViewCellFactoryType,
    SupplementaryViewFactory: CollectionSupplementaryViewFactoryType
    where CellFactory.Item == SectionInfo.Item, SupplementaryViewFactory.Item == SectionInfo.Item>

{% endhighlight %}

Do not be afraid! Before Brent Simmons accuses me of contributing to [angle-bracket-T blindness](http://inessential.com/2015/02/04/random_swift_things), let me explain. There are three generic type parameters. We specify that these three types must conform to the `CollectionViewSectionInfo`, `CollectionViewCellFactoryType`, and `CollectionSupplementaryViewFactoryType` protocols. Finally, the `where` clause specifies that each object must deal with the same kind of model objects (`Item`). This prevents us from trying to use a section of `ModelA` with a cell factory of `ModelB`.

### Additional features

The example above just scratches the surface of what this framework can do. It also integrates with Core Data and [NSFetchedResultsController](https://developer.apple.com/library/ios/documentation/CoreData/Reference/NSFetchedResultsController_Class/index.html). For this, instead of initializing a `DataSourceProvider` with an array of sections, you pass an `NSFetchedResultsController` instead. Even more, there are `FetchedResultsDelegateProvider` classes that encapsulate all of the [*tedious* boilerplate](https://developer.apple.com/library/ios/documentation/CoreData/Reference/NSFetchedResultsControllerDelegate_Protocol/index.html#//apple_ref/occ/intf/NSFetchedResultsControllerDelegate) for `NSFetchedResultsControllerDelegate` for table views **and** collection views. If you want to see more examples, I've put together a great [example app](https://github.com/jessesquires/JSQDataSourcesKit/tree/develop/Example) in the repo that exercises all functionality in the framework. You can find complete documentation [here](http://www.jessesquires.com/JSQDataSourcesKit/).

### Onward

I'm looking forward to building apps in Swift with patterns like this, and you should be too! If you have been confused by these hipsters talking about *protocol-oriented programming* and *composition over inheritance*, hopefully this serves as a practical example of what they mean. If you are working on an app in Swift, I encourage you try [JSQDataSourcesKit](https://github.com/jessesquires/JSQDataSourcesKit). Let me know what you think, and feel free to send me a pull request!
