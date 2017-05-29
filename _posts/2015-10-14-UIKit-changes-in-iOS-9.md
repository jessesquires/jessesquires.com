---
layout: post
title: UIKit changes in iOS 9
subtitle: Goodbye non-zeroing weak references
redirect_from: /UIKit-changes-in-iOS-9/
---

Surprisingly, I have not seen anyone talking about what I just discovered in the [iOS 9.0 API Diffs](https://developer.apple.com/library/prerelease/ios/releasenotes/General/iOS90APIDiffs/index.html#//apple_ref/doc/uid/TP40016222). (Well, actually what [Max von Webel](https://twitter.com/343max/status/654513094559817728) discovered.) There's a hidden gem in the [UIKit diffs](https://developer.apple.com/library/prerelease/ios/releasenotes/General/iOS90APIDiffs/Objective-C/UIKit.html). We no longer have to suffer through tracking down obscure bugs due to non-zeroing weak references.

<!--excerpt-->

### Non-zeroing weak references

What are non-zeroing weak references? Mike Ash's Friday Q&A on [Automatic Reference Counting](https://mikeash.com/pyblog/friday-qa-2011-09-30-automatic-reference-counting.html) covers this and everything else you ever wanted to know about ARC. You should probably read this now, even if you have before. It's great.

Briefly, there are `strong` references and `weak` references in ARC. These describe the ownership behavior of a pointer. Either an object **owns** the pointed-to object (`strong`, increments the retain count), or it **does not own** the pointed-to object (`weak`, the retain count is unchanged). Then, `weak` references can be *zeroing* or *non-zeroing*, meaning that when the pointed-to object is deallocated, the pointer is zeroed out or not.

The issue is that a non-zeroing reference ends up pointing to invalid memory (because the reference is not zeroed out), thus when you attempt to access that memory (by sending the object a message) &mdash; you'll crash. Mike puts it nicely in his post:

>You must ensure that you never use such a pointer (preferably by zeroing it out manually) after the object it points to has been destroyed. Be careful, as non-zeroing weak references are playing with fire.

### Playing with fire

Why do these details about weak references matter? Because up until iOS 8, UIKit views that have a `delegate` or `dataSource` property have been declared as the following.

{% highlight swift %}

// UITableView iOS 8 and below
@property(nonatomic, assign) id<UITableViewDataSource> dataSource
@property(nonatomic, assign) id<UITableViewDelegate> delegate

// UICollectionView iOS 8 and below
@property(nonatomic, assign) id<UICollectionViewDelegate> delegate
@property(nonatomic, assign) id<UICollectionViewDataSource> dataSource

{% endhighlight %}

<span class="text-muted"><b>Note:</b> this extends well beyond UITableView and UICollectionView. UIBarButtonItem.target is assign. UIGestureRecognizer.delegate is assign. UIActionSheet.delegate is assign. UIAccelerometer.delegate is assign. The list goes on, everywhere in UIKit.</span>

These references are `assign` (non-zeroing). That is, _**not**_ `weak` (zeroing). Have you ever had a bug because of this? [I have](https://github.com/jessesquires/JSQMessagesViewController/issues/201). What happens is the `dataSource` or `delegate` object is deallocated *before* the view, and then the view attempts to send a message to an object that has been destroyed, and you crash. And then you confusingly look through obscure stack traces and repeatedly fail to reproduce the issue. You lie awake at night, unable to sleep.

For correctness, you should be setting these to `nil` in `dealloc`. In the comments of Mike's post, he [explains further](https://mikeash.com/pyblog/friday-qa-2011-09-30-automatic-reference-counting.html#comment-4010c9e897b775d2d9a6f2eca3baa77e):

>You're correct that __unsafe_unretained is the same as a regular assignment done the old way, but most Cocoa programmers don't exercise the caution they should when using those. How much code have you seen that manually zeroes out delegate and data source pointers in a window controller's -dealloc. It's almost unheard of. And yet, it's absolutely required for correctness, because you can't know the order of object destruction, and the view might message its data source or delegate after the controller has been destroyed. In practice, this happens rarely, but it does happen, and is really annoying to track down.

### Deliver us from evil

As of iOS 9, the aforementioned APIs have changed. In fact, all of UIKit looks like it [has been audited](https://developer.apple.com/library/prerelease/ios/releasenotes/General/iOS90APIDiffs/Objective-C/UIKit.html). Everywhere I looked, `assign` was replaced with `weak, nullable`.

{% highlight swift %}

// UITableView iOS 9
@property(nonatomic, weak, nullable) id<UITableViewDataSource> dataSource
@property(nonatomic, weak, nullable) id<UITableViewDelegate> delegate

// UICollectionView iOS 9
@property(nonatomic, weak, nullable) id<UICollectionViewDelegate> delegate
@property(nonatomic, weak, nullable) id<UICollectionViewDataSource> dataSource

{% endhighlight %}

I can't say for certain, but my guess is that we can thank Swift for this. Swift was the impetus for [nullability annotations](https://developer.apple.com/swift/blog/?id=25) and generics in Objective-C, and we know the teams at Apple have been [working hard](https://developer.apple.com/swift/blog/?id=31) to update all of the Cocoa frameworks with these features. Maybe `assign` affects interoperability with Swift? In any case, non-zeroing weak references are finally gone. As developers, we can finally get some sleep.
