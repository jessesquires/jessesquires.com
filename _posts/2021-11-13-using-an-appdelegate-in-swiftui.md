---
layout: post
categories: [software-dev]
tags: [ios, macos, swiftui]
date: 2021-11-13T12:50:08-08:00
title: The obscure solution to using an AppDelegate in SwiftUI
---

As of iOS 14 and macOS 11, you can define the entry-point and app lifecycle of your app in SwiftUI with the [`App`](https://developer.apple.com/documentation/swiftui/app) protocol instead of using the traditional [`UIApplicationDelegate`](https://developer.apple.com/documentation/uikit/uiapplicationdelegate) protocol from UIKit. However, SwiftUI is still missing the majority of APIs from UIKit. For any serious app, you'll need to provide an app delegate.

<!--excerpt-->

I went down this path [while investigating this bug]({% post_url 2021-11-13-xcode-13-device-orientation-bug %}). It turns out I don't need this solution. However, I learned some useful information to share and it helped me articulate some of SwiftUI's shortcomings.

You can provide an app delegate using the [`@UIApplicationDelegateAdaptor` property wrapper](https://developer.apple.com/documentation/swiftui/uiapplicationdelegateadaptor).

```swift
@main
struct MyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            // do something
            return true
    }

    // Other delegate methods here...
}
```

This is such a clever and elegant solution. It balances the "purity" of a SwiftUI app with the necessity of interacting with UIKit. It puts "the seam" in exactly the right place, obviating the need for any real compromises within your SwiftUI app structure. Anything else would be cumbersome and garish. Whoever thought of this on the SwiftUI team deserves applause.

I'm not sure if I would have arrived at this solution &mdash; which made me realize: this is _rather obscure_ when you think about it. This situation highlights two significant problems with SwiftUI: discoverability of SwiftUI APIs and the framework's sparse documentation.

As your app gets sufficiently advanced, it becomes more and more difficult to solve problems and implement new functionality. That's true of any app, but with UIKit I know where to look in the documentation for help. I can ask _"what can `UIApplicationDelegate` do?"_ and the [documentation](https://developer.apple.com/documentation/uikit/uiapplicationdelegate) for `UIApplicationDelegate` answers that question precisely.

When working with SwiftUI, I often feel like I'm flying blind. The [documentation](https://developer.apple.com/documentation/swiftui/uiapplicationdelegateadaptor) for `@UIApplicationDelegateAdaptor` is sufficient. The problem is knowing that `@UIApplicationDelegateAdaptor` exists at all! I would expect [the documentation for `App`](https://developer.apple.com/documentation/swiftui/app) to mention `@UIApplicationDelegateAdaptor` &mdash; that seems _very relevant_. And yet, there is no mention of it.

The main difficulty in using SwiftUI is discerning whether or not the APIs you need are available in SwiftUI or if you have to use UIKit instead. Then you need to figure out exactly what those equivalent APIs are, or discover the correct "escape hatches" into UIKit. Without knowing about `@UIApplicationDelegateAdaptor`, my first thought would be to abandon SwiftUI's `App` and rewrite my app with a "UIKit shell" by switching to `UIApplicationDelegate`.

All of this emphasizes the nascent framework's continued reliance on UIKit. Despite having the nice solution provided by `@UIApplicationDelegateAdaptor`, I would still be hesitant to use it. If you need a lot of functionality from `UIApplicationDelegate`, you might as well just start with that in the first place. As [I've written previously]({% post_url 2021-11-12-first-impressions-of-swiftui %}), UIKit is usually the better choice for complex apps. I will continue using the "UIKit shell with some SwiftUI" approach. We are far from being able to write a "100% pure SwiftUI" app.
