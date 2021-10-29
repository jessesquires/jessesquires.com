---
layout: post
categories: [software-dev]
tags: [ios, ui-testing, ci, xcode]
date: 2021-10-25T11:36:45-07:00
title: Deleting your app from the iOS simulator during UI tests
---

In last week's issue of [iOS Dev Weekly](https://iosdevweekly.com/issues/530#code), Dave linked to [this tweet](https://twitter.com/azamsharp/status/1449467728796999687) from Mohammad Azam, which linked to [this StackOverflow post](https://stackoverflow.com/questions/33107731/is-there-a-way-to-reset-the-app-between-tests-in-swift-xctest-ui) on resetting your app between UI tests by completely deleting it. It's a very clever idea! This post offers an improved version of the code and some thoughts on when to use this.

<!--excerpt-->

I hope this post also serves as a better bookmark than a tweet, which isn't as reliable of a reference or as easy to find. It's also a reminder for my future self.

The various snippets on StackOverflow and Twitter had a few issues that would make them prone to error and flakiness. The StackOverflow post was particularly outdated, as deleting an app on iOS is now a 4-step process.

Here's the refined snippet:

```swift
extension XCUIApplication {
    func uninstall(name: String? = nil) {
        self.terminate()

        let timeout = TimeInterval(5)
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

        let appName: String
        if let name = name {
            appName = name
        } else {
            let uiTestRunnerName = Bundle.main.infoDictionary?["CFBundleName"] as! String
            appName = uiTestRunnerName.replacingOccurrences(of: "UITests-Runner", with: "")
        }

        /// use `firstMatch` because icon may appear in iPad dock
        let appIcon = springboard.icons[appName].firstMatch
        if appIcon.waitForExistence(timeout: timeout) {
            appIcon.press(forDuration: 2)
        } else {
            XCTFail("Failed to find app icon named \(appName)")
        }

        let removeAppButton = springboard.buttons["Remove App"]
        if removeAppButton.waitForExistence(timeout: timeout) {
            removeAppButton.tap()
        } else {
            XCTFail("Failed to find 'Remove App'")
        }

        let deleteAppButton = springboard.alerts.buttons["Delete App"]
        if deleteAppButton.waitForExistence(timeout: timeout) {
            deleteAppButton.tap()
        } else {
            XCTFail("Failed to find 'Delete App'")
        }

        let finalDeleteButton = springboard.alerts.buttons["Delete"]
        if finalDeleteButton.waitForExistence(timeout: timeout) {
            finalDeleteButton.tap()
        } else {
            XCTFail("Failed to find 'Delete'")
        }
    }
}
```

The first improvement is using `waitForExistence()`, which is a robust way to wait for an element to appear on screen before attempting to interact with it. (Never use `sleep()`.) The second improvement is propagating clear failures via `XCTFail()` if something goes wrong. And finally, we can attempt to automatically derive the app name from the main bundle. Otherwise, you can pass a specific name. You can drop this extension into your project without any modifications.

Regarding deriving the app name, typically `Bundle.main.infoDictionary?["CFBundleName"]` would return the name of your app. For example, `"MyApp"`. However, UI tests run in their own process, so what we receive here instead is `"MyAppUITests-Runner"`. Assuming a typical iOS project setup, all we need to do is remove the "UITests-Runner" suffix. If you have some custom configuration, then you may have to manually provide your app name.

Here's an example usage:

```swift
class MyAppUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        app.uninstall()
        // OR use: app.uninstall(name: "MyApp")
    }

    func test_example() throws {
        // tests go here
    }
}
```

{% include break.html %}

So when should you use this? I think mostly sparingly. This shouldn't be something you need to do that frequently. However, it does seem like a great solution for testing a "clean install", especially if you want to test something like keychain credentials persisting after an uninstall and reinstall.

Other use cases, like what [Mohammad mentioned](https://twitter.com/azamsharp/status/1449467728796999687), include removing all app data like databases and other saved files. In particular, I think this solution is much better than implementing `if IS_UI_TEST { }` type of hacks in your application code, including using [`.launchArguments`](https://developer.apple.com/documentation/xctest/xcuiapplication/1500477-launcharguments) or [`.launchEnvironment`](https://developer.apple.com/documentation/xctest/xcuiapplication/1500427-launchenvironment) to reset state.

However, I think much of the time you'll be better off using official APIs like [`.launchArguments`](https://developer.apple.com/documentation/xctest/xcuiapplication/1500477-launcharguments) and [`.launchEnvironment`](https://developer.apple.com/documentation/xctest/xcuiapplication/1500427-launchenvironment) to pass specific data to your app or to modify its behavior, like skipping an onboarding flow.
