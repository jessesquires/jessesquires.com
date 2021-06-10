---
layout: post
categories: [software-dev]
tags: [xcode, testing, ui-testing, ios, ci, uikit]
date: 2021-03-17T19:59:59-07:00
date-updated: 2021-03-18T10:44:22-07:00
title: Xcode UI testing reliability tips for iOS
---

Xcode's UI testing framework has had its ups and downs over the years. Most recently, it has been much more robust and reliable in my experience. However, tests still tend to flake sometimes. Here are some ways that I have been able to reduce flakiness in UI tests.

<!--excerpt-->

### Disabling animations

You can disable all animations in your app using [`UIView.setAnimationsEnabled(false)`](https://developer.apple.com/documentation/uikit/uiview/1622420-setanimationsenabled). This works for `UIKit` apps, but I am not sure if it will work for `SwiftUI`. And I do not know of an equivalent API for `AppKit`.

Note that this is not as simple as calling `UIView.setAnimationsEnabled(false)` at the start of your UI tests. You cannot run or access application code from within UI tests because they run in a separate process. This is easy to observe in the iOS simulator, which installs a runner app (`MyAppUITests-Runner.app`) alongside your actual app.

One easy way to achieve this is by passing launch arguments and parsing them in your app. You will usually want to do this from your `AppDelegate`.

```swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // app setup code...

        #if DEBUG
        if CommandLine.arguments.contains("-disableAnimations") {
            UIView.setAnimationsEnabled(false)
        }
        #endif

        return true
    }
}
```

Then you can pass the launch arguments in your UI tests.

```swift
// In your XCTestCase subclass

override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false

    let app = XCUIApplication()
    app.launchArguments.append("-disableAnimations")
    app.launch()
}
```

{% include updated_notice.html
message="
Thanks to [Peter Steinberger](https://mobile.twitter.com/steipete) for mentioning [on Twitter](https://mobile.twitter.com/steipete/status/1372460020730843136) that this might cause issues:

> I would not disable animation - this can change callback timing and might lead to missed bugs. Instead, accelerate animations via setting layer.speed on the window.

I have not encountered this issue, but it is good to be aware of. You can follow the same setup that I have described above. Instead of disabling animations, you can set `self.window.layer.speed`. Per the [`CAMediaTiming` docs](https://developer.apple.com/documentation/quartzcore/camediatiming/1427647-speed):

> **speed**<br/>
> Specifies how time is mapped to receiver’s time space from the parent time space.
>
> For example, if speed is 2.0 local time progresses twice as fast as parent time. Defaults to 1.0.

```swift
// in your AppDelegate or SceneDelegate

self.window?.layer.speed = 2.0
```
" %}

### Increasing timeouts

Another thing you can do is increase the timeouts when verifying the existence of UI elements in your tests. It is rudimentary, but effective in my experience. I use an extension method to easily apply a global default timeout.

```swift
let timeout = TimeInterval(10)

extension XCUIElement {

    @discardableResult
    func waitForExistence() -> Bool {
        self.waitForExistence(timeout: timeout)
    }
}

// usage
XCTAssertTrue(someUIElement.waitForExistence())
```

You can build on this to more gracefully handle tapping UI elements, which also improves the readability of your tests.

```swift
extension XCUIElement {

    func waitForExistenceThenTapOrFail(_ message: String? = nil, file: String = #file, line: Int = #line) {
        if self.waitForExistence() {
            self.tap()
        } else {
            let message = message ?? self.title
            XCTFail("\(file) \(line) \(message)")
        }
    }
}

// usage
someUIElement.waitForExistenceThenTapOrFail()
```
