---
layout: post
title: Functional notifications
subtitle: Exploring the flexibility of Swift micro-libraries
redirect_from: /functional-notifications/
---

The [observer pattern](http://en.wikipedia.org/wiki/Observer_pattern) is a powerful way to decouple the sending and handling of events between objects in a system. On iOS, one implementation of this pattern is via [NSNotificationCenter](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSNotificationCenter_Class). However, the `NSNotificationCenter` APIs are kind of cumbersome to use and require some boilerplate code. Luckily, Swift gives us the tools to improve `NSNotificationCenter` with very little code.

<!--excerpt-->

### Out with the old

A while back, [objc.io](http://www.objc.io) posted functional [snippet 16](http://www.objc.io/snippets/16.html), on *Typed Notification Observers*. I had already been working on a generic, reusable way to observe notifications in iOS, but this snippet really pointed me in the right direction. One major motivation here is to remove the boilerplate of handling notifications. A typical example would be a view controller that registers to observe a notification and implements an instance method to be called when the notification is received.

{% highlight objc %}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// ... a bunch of view controller code ...

- (void)handleNotification:(NSNotification *)notification {
    // handle notification
}

{% endhighlight %}

This is problematic for a few reasons.

1. We need to remember to explicitly add and remove `self` as an observer. Forgetting to remove `self` in `dealloc` is a bug.
2. The code that actually handles the notification is in a totally different area (the `handleNotification:` method). As more code is added to this class, it becomes more difficult to see what is happening and when.
3. Because this is Objective-C, there is no type-safety. An `NSNotification` can have an *object* (`id`) property and *userInfo* (`NSDictionary`) property. If accessing the object, we must know how cast it. And if accessing the dictionary, we must know what it contains.
4. We must duplicate this pattern across all parts of our app, proliferating issues (1), (2), and (3).

### A new micro-library

Say hello to [JSQNotificationObserverKit](https://github.com/jessesquires/JSQNotificationObserverKit), a Swift framework based on [snippet 16](http://www.objc.io/snippets/16.html). This framework remedies the issues described above with a *tiny* API that is *extremely* flexible. As you'll notice from the [documentation](http://www.jessesquires.com/JSQNotificationObserverKit), there is only 1 class, 1 struct, and 1 function. This is all we need, which is as awesome as it is surprising. Let's see how it works.

We begin by creating a `Notification`. This struct has two type parameters: a value `V` and sender `S`. The type of value `V` that the notification sends is a [phantom type](http://www.objc.io/snippets/13.html), while `S` is the type of sender associated with the notification. A `Notification` also has a `name` property and an optional `sender` property.

{% highlight swift %}

// 1. Suppose we have a UIView that posts a notification when its size changes
let myView = UIView()

// 2. This notification posts a CGSize value from a UIView sender
let notification = Notification<CGSize, UIView>(name: "NewViewSizeNotif", sender: myView)

{% endhighlight %}

Next, we create our `NotificationObserver`, which is initialized with the notification described above and a closure to be called when the notification is received. Instantiating this observer automatically adds it to `NSNotificationCenter` for the notification `name` and `sender` specified by the `Notification` function parameter. Because `NotificationObserver` has the same type parameters as `Notification`, it can *only* observe that *specific* kind of notification.

{% highlight swift %}

// 3. This observer listens for the notification described above
var observer: NotificationObserver<CGSize, UIView>?

// 4. Register observer, start listening for the notification
observer = NotificationObserver(notification: notification) { (value: CGSize, sender: UIView?) in
    // handle notification
}

{% endhighlight %}

Finally, we post the notification using the `postNotification(_:value:)` function. Again, this function has the same type parameters as `Notification`, which enforces sending a value of the type specified by the phantom type of `Notification`. In this example, we can **only** send a `CGSize` as the value. Anything else would result in a compiler error.

{% highlight swift %}

// 5. Post the notification with the updated CGSize value
postNotification(notification, value: CGSizeMake(200, 200))

{% endhighlight %}

When the observer is set to `nil` (when it is deallocated), then it is removed from `NSNotificationCenter`.

{% highlight swift %}

// 6. Unregister observer, stop listening for notifications
observer = nil

{% endhighlight %}

That's all. Each of the aforementioned issues have been resolved. Registering and unregistering for a notification is now as simple as creating and destroying an observer object. The code for the registration and handling of the notification is all in one place. We have type-safety, and a reusable solution for the rest of our app.

### Tiny, but flexible

So how flexible is this small API? The example above works for a notification with a sender and a value, but what about a notification that only has a value? Or a notification that only has a sender? Or a notification that has neither? What about supporting more typical Cocoa notifications that send a *userInfo* dictionary? We can do it all.

A notification can be configured in 4 different ways:

1. It can have a specific sender and value (as in the example above)
2. It can have only a sender. For example, `UIApplicationDidReceiveMemoryWarningNotification` does not send any data in the *userInfo* dictionary.
3. It can only have a value. Sometimes observers do not care which object posted a given notification.
4. It can have neither a sender, nor a value. Sometimes a notification may be posted to notify of an event, and either there isn't an associated sender, or the observer does not care.

For notifications without a sender, or for which the observer does not care about the sender, we can specify a sender of type `AnyObject`. When we initialize a `Notification`, we can omit the `sender` parameter which defaults to `nil`. The semantics here are great. *Any object* can send this notification, it does not matter to the observer.

{% highlight swift %}

let myValue = MyValueType()

let notification = Notification<MyValueType, AnyObject>(name: "Notification")

postNotification(notification, value: myValue)

{% endhighlight %}

For notifications without a value, we simply specify a value type of `Void`. Then when the notification is posted we send the empty tuple, `()`. Remember, the empty tuple is equivalent to `Void`.

{% highlight swift %}

let notification = Notification<Void, MyObjectType>(name: "Notification", sender: MyObject)

postNotification(notification, value: ())

{% endhighlight %}

From here, it is easy to see how we can construct and post a notification with neither a value nor a sender. Furthermore, the value type could be a `Dictionary` which allows this API to conform to the existing patterns in Cocoa. For more examples on usage, see the unit tests included with [JSQNotificationObserverKit](https://github.com/jessesquires/JSQNotificationObserverKit).

### Less is more

It really is incredible how much we can accomplish with so little &mdash; 1 class, 1 struct, and 1 function. An equivalent API in Objective-C would have been more than double the size and still not type-safe. I think the [objc.io snippets](http://www.objc.io/snippets/) are absolutely great, but they are often deceptively simple. The power and flexibility of these functional patterns is not always obvious to a tenured Objective-C developer. If you want to learn even more about micro-libraries, check out Chris Eidhof's talk on [*Tiny Networking*](http://realm.io/news/chris-eidhof-micro-libraries-swift).
