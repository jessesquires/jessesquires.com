---
layout: post
categories: [software-dev]
tags: [xcode, ios, macos, testing, ui-testing]
date: 2024-07-09T12:45:08-07:00
title: UI testing improvements in Xcode 16
---

While the new [Swift Testing](https://developer.apple.com/xcode/swift-testing/) framework announced this year at WWDC24 is getting a lot of attention, there are some notable improvements coming to UI testing in [XCTest](https://developer.apple.com/documentation/xctest/user_interface_tests) in Xcode 16.

<!--excerpt-->

Xcode 16 [introduces two new APIs](https://developer.apple.com/documentation/xcode-release-notes/xcode-16-release-notes#XCTest) in XCTest for UI testing.

The first is [`waitForNonExistence(withTimeout:)`](https://developer.apple.com/documentation/xctest/xcuielement/4391535-waitfornonexistence), which provides the inverse of the existing `waitForExistence(timeout:)` API. Finally! This is such a welcome change. Often in UI testing it is more semantic to wait for an element to _disappear_ rather than _appear_ --- for example, waiting for a loading indicator or waiting for a [`UIContentUnavailableView`](https://developer.apple.com/documentation/uikit/uicontentunavailableview) to disappear. Previously, you would have to roll your own implementation or awkwardly use `waitForExistence(timeout:)` and negate the result --- both options are cumbersome and inefficient.

Here's an example. Suppose your view displays an initial loading state while fetching data, which then disappears once loading completes.

```swift
func testLoadingView() throws {
    let app = XCUIApplication()
    app.launch()

    let contentView = app.otherElements["content_view"]
    XCTAssertTrue(contentView.waitForExistence(timeout: 1), "Content view should appear")

    let loadingView = app.staticTexts["loading_view"]
    XCTAssertTrue(loadingView.exists, "Content should be loading initially")

    XCTAssertTrue(loadingView.waitForNonExistence(withTimeout: 2), "Loading should complete")
    XCTAssertFalse(loadingView.exists)
}
```

Side note: the inconsistency in the naming of the `timeout:` parameter label for these two functions is a bit odd. The new method uses `withTimeout` instead of `timeout`. I would prefer if they were both consistently named `timeout`.

```swift
func waitForExistence(timeout: TimeInterval) -> Bool

func waitForNonExistence(withTimeout timeout: TimeInterval) -> Bool
```

The second new API is [`wait(for:toEqual:timeout:)`](https://developer.apple.com/documentation/xctest/xcuielement/4395161-wait), which waits for a property value of an element to equal a new value. This is useful for when the contents of an existing view should be updated and you want to verify the update happened. The most common use case here is likely for checking the contents of labels, text fields, or text views that change based on state updates or user interaction. Previously, there was not a great way to achieve this without introducing artificial timeouts in your test, or changing the UI element's [`.accessibilityIdentifier`](https://developer.apple.com/documentation/uikit/uiaccessibilityidentification/1623132-accessibilityidentifier) in your app when its contents updated and then checking for the existence of the new identifier.

Continuing with the example above, suppose your loading view does not disappear but instead updates with a new message. Initially, the view displays _"Loading..."_ and then displays _"Loading Complete!"_ when data is finished loading.

```swift
func testLoadingView() throws {
    let app = XCUIApplication()
    app.launch()

    let contentView = app.otherElements["content_view"]
    XCTAssertTrue(contentView.waitForExistence(timeout: 1), "Content view should appear")

    let loadingView = app.staticTexts["loading_view"]
    XCTAssertTrue(loadingView.exists, "Content should be loading initially")
    XCTAssertEqual(loadingView.label, "Loading...", "Label should initially display 'Loading...'")

    XCTAssertTrue(
        loadingView.wait(for: \.label, toEqual: "Loading Complete!", timeout: 3),
        "Label should update when loading is done to say 'Loading Complete!'"
    )
}
```

Additionally, you could test for failure states as well. In this scenario, perhaps when data fails to load, you could display _"Oops, there was an error!"_ in the label. You could write a similar UI test for this situation.

Unfortunately, in my testing [`wait(for:toEqual:timeout:)`](https://developer.apple.com/documentation/xctest/xcuielement/4395161-wait) did not work as expected. In fact, the sample test above will fail. In order to get this test to pass, I had to introduce an artificial timeout before calling and checking `wait(for:toEqual:timeout:)`.

```swift
_ = loadingView.waitForExistence(timeout: 1)

XCTAssertTrue(
    loadingView.wait(for: \.label, toEqual: "Loading Complete!", timeout: 3),
    "Label should update when loading is done to say 'Loading Complete!'"
)
```

Hopefully this bug gets fixed before the final release of Xcode 16.
