---
layout: post
title: Testing and mocking without OCMock
subtitle: For Swift and Objective-C
redirect_from: /testing-without-ocmock/
---

[OCMock](http://ocmock.org) is a powerful [mock object](https://en.wikipedia.org/wiki/Mock_object) unit testing library for Objective-C. Even if you are using Swift, as long as your classes inherit from `NSObject`, you can use [some of its features](http://ocmock.org/swift/). But what if you are writing pure Swift code which does not have access to the dynamic Objective-C runtime? Or, what if you don't want your Swift code to be [hampered](/avoiding-objc-in-swift/) by `NSObject` subclasses and `@objc` annotations? Perhaps, you merely want to avoid dependencies and use 'plain old' `XCTest` with Objective-C. It's relatively easy and lightweight to achieve the same effect in some testing scenarios *without* using `OCMock`.

<!--excerpt-->

### Testable code

I'm generally not a fan of mocking, and would usually prefer to avoid it altogether. The need for mocking is often (but not always) a warning sign of untestable code. If your code is impossible to test, then it likely suffers from [design deficiencies](https://en.wikipedia.org/wiki/Anti-pattern). I'm not merely talking about the testability of your code for the sake of testing, but rather deeper, architectural design issues &mdash; ones that are only revealed once you attempt to write a test. Of course, you could ignore the warnings, but in the coming months (or years!) you will have to reconcile that debt when the system you've built requires a change that cannot be accommodated due to its flawed design.

However, writing testable code and mock-free unit tests is not always possible, especially in a [legacy codebase](https://www.amazon.com/dp/0131177052). In this case, you'll often need to mock the hell out of everything while you refactor towards a more maintainable and malleable system.

### Avoiding mocks

There are a couple of strategies to avoid mocking:

1. Use actual instances of classes. For example, if you have a `User` class, then simply construct a `User` in your test instead of mocking. If using Swift, this is exceedingly easy if you make heavy use of value types (`struct`, `enum`, etc.), which cannot be mocked in the first place. If using a persistence framework like [Core Data](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreData/index.html), then you can write test helpers to generate fake models, which you can use in your tests. (See also: [Fox](https://github.com/jeffh/Fox))
2. Use protocols. If a function or class receives a protocol instead of a concrete type, then your `XCTestCase` can conform to that protocol to provide fake inputs. For example, if you have a `UserDataSource` protocol that provides and array of `User` objects, then your test case can conform to that protocol and generate an array of users to pass into the function or class.

### Common uses for mocking

The most common &mdash; and highly suitable &mdash; uses for mocking are for networking events, analytics logging, and user interaction events that utilize the [observer pattern](https://en.wikipedia.org/wiki/Observer_pattern), such as [delegation in Cocoa](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/Delegation.html). Diving into the details of each of these is beyond the scope of this post. For now, let's look at an example with delegation.

### Example: protocols and `XCTestExpectation`

Suppose we have a view controller that displays a "Yes/No" prompt to the user. After the user selects an option, we need to notify another class of the action taken. This class will perform some operations and then update the UI. We want to test that when an option is tapped that the correct delegate method is called.

{% highlight swift %}
protocol ControllerProtocol: class {
    func controllerDidSelectYes(_ controller: Controller) -> Void
    func controllerDidSelectNo(_ controller: Controller) -> Void
}

class Controller: UIViewController {
    weak var delegate: ControllerProtocol?

    func didTapYes(sender: UIButton) {
        delegate?.controllerDidSelectYes(self)
    }

    func didTapNo(sender: UIButton) {
        delegate?.controllerDidSelectNo(self)
    }
}
{% endhighlight %}

We could mock `ControllerProtocol` with OCMock in an Objective-C test:

{% highlight objc %}
#import <MyApp/MyApp-Swift.h>

- (void)test {
    id mockProtocol = [OCMockObject niceMockForProtocol:@protocol(ControllerProtocol)];
    // write test...
}
{% endhighlight %}

But we want to write our tests in Swift, and it would be nice to avoid another dependency. Let's use `XCTestExpectation`. In our test, we can create a class that conforms to `ControllerProtocol` and has an `XCTestExpectation` property for each protocol method. Each protocol method implementation simply calls `fulfill()` on the appropriate expectation.

{% highlight swift %}
class FakeDelegate: ControllerProtocol {
    var yesExpectation: XCTestExpectation?
    var noExpectation: XCTestExpectation?

    func controllerDidSelectYes(_ controller: Controller) {
        yesExpectation!.fulfill()
    }

    func controllerDidSelectNo(_ controller: Controller) {
        noExpectation!.fulfill()
    }
}
{% endhighlight %}

Now we can use `FakeDelegate` in our test:

{% highlight swift %}
func testDidTapYes() {
    let controller = Controller()

    // trigger viewDidLoad:
    controller.beginAppearanceTransition(true, animated: false)

    // setup the delegate
    let delegate = FakeDelegate()
    delegate.yesExpectation = expectation(description: "yes expectation")
    controller.delegate = delegate

    // helper extension method to "tap" the yes button
    controller.yesButton.simulateTap()

    // wait for our delegate method to be called
    waitForExpectations(timeout: 5, handler: nil)
}
{% endhighlight %}

If the test fails, that means tapping this button *does not* notify the delegate.

<span class="text-muted"><b>Note:</b> we can write the same test code in pure Objective-C, too.</span>

### Testing all the things

This method of testing keeps our tests rather simple and straightforward, and gives us a kind of "mocking" in Swift. The tests are easy to read and edit, and they have no external dependencies. Anyone on your team could easily fix a broken test. The major drawback of this approach is that it introduces some boilerplate, which can be tedious to write if you are writing a lot of tests. However, a benefit here is that we can concretely see how our system works. As mentioned above, writing a test can reveal troublesome designs in our code and in this case we *also* have to implement our protocol (`ControllerProtocol`). If you find that implementing the protocol is difficult &mdash; that using it is somehow cumbersome or intertwined with other dependencies &mdash; then you should probably reconsider and redesign.

Depending on your uses and the context of your app, the value you gain from this approach to testing may vary. That's particularly true for the example above &mdash; since UI is susceptible to frequent change &mdash; but it's merely an example. If you use this approach for testing your networking, logging, or other aspects of your app that change *infrequently*, then it should carry its weight better. I especially find this valuable for testing self-contained libraries and frameworks. When a library has no dependencies, it's nice to avoid testing dependencies as well.

Finally, I want to make it clear that `OCMock` is a **great** tool. **You should use it** when it makes sense: when you need its advanced features, when working with legacy code, etc. But if your use cases are simple, then `XCTestExpectation` can get the job done. And if you want to stay in the Swift world, then you don't have a choice. :)
