---
layout: post
categories: [software-dev]
tags: [ios, macos, swiftui]
date: 2024-06-29T14:25:23-07:00
title: "SwiftUI app lifecycle: issues with ScenePhase and using AppDelegate adaptors"
---

SwiftUI introduced the [`ScenePhase`](https://developer.apple.com/documentation/swiftui/scenephase) API in iOS 14 and macOS 11. This was SwiftUI's answer to handling application lifecycle events. At the same time, SwiftUI introduced [`UIApplicationDelegateAdaptor`](https://developer.apple.com/documentation/swiftui/uiapplicationdelegateadaptor) for iOS and [`NSApplicationDelegateAdaptor`](https://developer.apple.com/documentation/swiftui/nsapplicationdelegateadaptor) for macOS, which allow you to provide an `AppDelegate` on both platforms to receive additional application lifecycle events and other events that were missing from SwiftUI at the time. Unfortunately, many of those application event APIs are still missing and `ScenePhase` has a number of bugs (or at least, unexpected behavior).

<!--excerpt-->

### Limitations of `ScenePhase` events (and view lifecycle events)

The issue with `ScenePhase` is that it is too limited, having only 3 states: `active`, `inactive`, and `background`. In a perfect world, an application should not _necessarily_ need to know whether it is launching for the first time or being terminated. In practice, however, these are extremely relevant and important application events. There are many scenarios in which knowing the distinction between a first (or "cold") launch and merely returning to the active state is helpful. Similarly, there are good reasons to treat a background state and termination differently.

I think `ScenePhase` should expand to include both `didLaunch` and `willTerminate` events, because attempting to infer these states is cumbersome and error prone, if not impossible. Or even better, what I would really like is a separate `AppPhase` API that allows you to handle application-level lifecycle events separately from window scenes.

The concept of "scenes" really centers around _windows_, not the _entire application_, and that is part of the problem with the API. The scene phases correlate to and model the lifecycle of application windows. It just so happens that on iOS your app only ever has a single window, so the `ScenePhase` API is a better fit on that platform --- and, in fact, it does work better on iOS. (Yes, iPadOS can now have multiple windows, but let's not get into that mess.) The differences between all the various platforms make working with `ScenePhase` even more difficult because it feels like SwiftUI is trying to force a uniform model across all platforms, despite key differences in their paradigms.

The `ScenePhase` [documentation](https://developer.apple.com/documentation/swiftui/scenephase/background) states that you should _"expect an app that enters the background phase to terminate."_ This is unfortunate because it is possible (and probably common) for users to switch between apps and quickly return to your app. If there is no distinction between temporarily being in the background and a complete termination, then your app could end up doing a lot of unnecessary tear down and set up work. As you'll see below, this is actually terrible advice for a macOS app.

UIKit and AppKit both provide additional granularity on top of these 5 main events, with "will" and "did" APIs. For example, `applicationWillResignActive()` and `applicationDidResignActive()`. I can see the motivation for simplifying the SwiftUI APIs, but there are scenarios where SwiftUI is too limiting and it is valuable to know that an event _is about to happen_ versus knowing an event _has already happened_.

The same limitations exist with SwiftUI's [view lifecycle](https://developer.apple.com/documentation/swiftui/view-fundamentals#responding-to-view-life-cycle-updates) methods, [`onAppear()`](https://developer.apple.com/documentation/swiftui/view/onappear(perform:)) and [`onDisappear()`](https://developer.apple.com/documentation/swiftui/view/ondisappear(perform:)) --- which, according to the docs these should be more accurately named `willAppear()` and `didDisappear()`. The fact that `onAppear()` is called _before_ a view appears, but `onDisappear()` is called _after_ a view disappears is inconsistent and confusing.

### Bugs and quirks with `ScenePhase`

Aside from being too limited, there are also a number of bugs with `ScenePhase` in SwiftUI. Perhaps some of this behavior is intended, but if so, it is certainly unexpected.

Here is a minimal implementation of `ScenePhase` to demonstrate. Note that this snippet is printing the results of all changes to `scenePhase` so that you can observe what is happening.

```swift
@main
struct MyApp: App {
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase, initial: true) { oldValue, newValue in
            print("ScenePhase: \(oldValue) -> \(newValue)")
        }
    }
}
```

#### Behavior on iOS

On iOS, `onChange(of:)` works mostly as expected. Here are some common scenarios and the associated scene phase transitions:

- Initial app launch: `inactive` > `active`.
- Move to background: `active` > `inactive` > `background`.
- Return to foreground: `background` > `inactive` > `active`.
- Temporary background (like toggling Control Center): toggles between `active` and `inactive`.
- App termination: if currently `active`, then `inactive` > `background`. Notably, if the app is already in the background and you force quit it, then no scene phase transitions occur. This means you must treat all `background` events as if the app is being terminated. As mentioned above, this is not optimal in all scenarios.

One quirk in behavior depends on whether you opt to receive the initial value, or not by passing `true` or `false` to the `initial:` parameter. If you pass `true`, then the first `onChange(of:)` event for `ScenePhase` is from `inactive` to `inactive`, then you receive the update to transition to `active`.

Unexpectedly, the main view receives `onAppear()` **before** your app receives the scene phase change. In the sample above, that would be `ContentView`. That's like receiving `viewWillAppear()` on your root view controller **before** `application(_:didFinishLaunchingWithOptions:)` gets called. That sequence of events does not make sense to me and raises concerns about how you should accurately architect your app startup flow in SwiftUI.

The sparse `ScenePhase` transitions above stand in stark contrast to the rich and granular events provided by `UIApplicationDelegate`.

#### Behavior on macOS

On macOS, the behavior of `onChange(of:)` is very different and very unexpected. Here are a similar set of scenarios as above and the associated scene phase transitions:

- Initial app launch: `active` > `active`. (what? lol)
- Move to background (making a different application front most and active): **no events**.
    - Return to foreground: **no events**.
- Move to background (by hiding the application, cmd-H): `active` > `background`.
    - Return to foreground: `background` > `active`.
- Closing the main window (but keep application running): no scene phase events. But you do receive `onDisappear()` for the main view.
- App termination (via cmd-Q): **no events**.

As mentioned above, the `ScenePhase` [documentation](https://developer.apple.com/documentation/swiftui/scenephase/background) states that you should _"expect an app that enters the background phase to terminate."_ That is a terrible assumption for a Mac app, based on the transitions listed above. Hiding the application (cmd-H) is the only way I have found to trigger a `background` scene phase on macOS. Preparing for termination when the user simply hides your app does not make sense. What a terrible user experience that would be!

If you pass `false` to the `initial:` parameter on macOS, you receive no initial scene phase change.

In my testing, I have never been able to get a macOS app to transition to the `inactive` scene phase. It is not clear if this is by design, or if this is a bug. It seems like a bug.

Unlike on iOS, macOS receives `onAppear()` for the main view in the correct order. That is, the scene phase becomes `active` _and then_ the app receives `onAppear()` for the main view. But unexpectedly, when hiding the application on macOS, you _do not_ receive the `onDisappear()` event. You only receive `onDisappear()` when closing a window, and notably, _no_ scene phase events occur.

If it isn't obvious, it is actually impossible to rely solely on `ScenePhase` in a macOS application where you need access to application lifecycle events, or even reliable app window lifecycle events. On macOS `ScenePhase` events are outright insufficient and stand in even starker contrast to the rich and granular events provided by `NSApplicationDelegate` and, of course, [`NSWindowDelegate`](https://developer.apple.com/documentation/appkit/nswindowdelegate).

### App delegate adaptors are discouraged

Despite all of the shortcomings and unreliable behavior in the APIs I have listed above, the documentation for both
[`UIApplicationDelegateAdaptor`](https://developer.apple.com/documentation/swiftui/uiapplicationdelegateadaptor) on iOS and [`NSApplicationDelegateAdaptor`](https://developer.apple.com/documentation/swiftui/nsapplicationdelegateadaptor) on macOS, both _discourage_ their use with a big scary warning:

> **Important**
>
> Manage an app’s life cycle events without using an app delegate whenever possible. For example, prefer to handle changes in `ScenePhase` instead of relying on delegate callbacks [...]

This is interesting, especially on macOS, where `ScenePhase` literally just does not work and cannot replace delegate callbacks at all. In my experience, on both platforms but mostly on macOS, you must use an app delegate if you need reliable and granular app lifecycle events.

### Using app delegate adaptors (and their issues)

If you instead want to respond to application lifecycle events _outside_ of SwiftUI, you can provide an app delegate. First, you need to create the properties in your SwiftUI app.

```swift
#if canImport(AppKit)
@NSApplicationDelegateAdaptor var appDelegate: NSAppDelegate
#endif

#if canImport(UIKit)
@UIApplicationDelegateAdaptor var appDelegate: UIAppDelegate
#endif
```

Then you can implement an `AppDelegate` for iOS:

```swift
import UIKit

final class UIAppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print(#function)
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print(#function)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print(#function)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print(#function)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print(#function)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print(#function)
    }
}
```

And you can implement an `AppDelegate` for macOS:

```swift
import AppKit

final class NSAppDelegate: NSObject, NSApplicationDelegate {

    func applicationWillFinishLaunching(_ notification: Notification) {
        print(#function)
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        print(#function)
    }

    func applicationWillHide(_ notification: Notification) {
        print(#function)
    }

    func applicationDidHide(_ notification: Notification) {
        print(#function)
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        print(#function)
    }

    func applicationWillResignActive(_ notification: Notification) {
        print(#function)
    }

    func applicationDidResignActive(_ notification: Notification) {
        print(#function)
    }

    func applicationWillTerminate(_ notification: Notification) {
        print(#function)
    }
}
```

Pro tip: because app delegates are defined as protocols, you could instead create a single class that conforms to both protocols. This can be a good strategy for sharing code between platforms.

On macOS, you receive all the `NSApplicationDelegate` callbacks as expected. Everything works. Contrary to the documentation, I would _avoid_ attempting to use `ScenePhase` _at all_ on macOS.

On iOS, app delegate adapters are a different story. They don't work as I would expect. Of all the callbacks defined in the `UIApplicationDelegate` above, only `application(_:didFinishLaunchingWithOptions:)` and `applicationWillTerminate(_:)` are called in a SwiftUI app. This behavior occurs even if you have _opted out_ of multiple window support on iOS by providing the correct plist values for [`UIApplicationSceneManifest`](https://developer.apple.com/documentation/bundleresources/information_property_list/uiapplicationscenemanifest).

If you want more granular scene events on iOS, you must provide a `SceneDelegate` class that conforms to [`UIWindowSceneDelegate`](https://developer.apple.com/documentation/uikit/uiwindowscenedelegate). You can still [turn off multiple windows](https://developer.apple.com/documentation/bundleresources/information_property_list/uiapplicationscenemanifest/uiapplicationsupportsmultiplescenes), but you must provide a scene configuration and `UISceneDelegateClassName` in your plist. Only then will you receive the corresponding callbacks.

Here's an example plist:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>UIApplicationSceneManifest</key>
    <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <false/>
        <key>UISceneConfigurations</key>
        <dict>
            <key>UIWindowSceneSessionRoleApplication</key>
            <array>
                <dict>
                    <key>UISceneConfigurationName</key>
                    <string>Default Configuration</string>
                    <key>UISceneDelegateClassName</key>
                    <string>$(PRODUCT_MODULE_NAME).SceneDelegate</string>
                </dict>
            </array>
        </dict>
    </dict>
</dict>
</plist>
```

And an updated app delegate, along with a default scene delegate:

```swift
final class UIAppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print(#function)
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print(#function)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print(#function)
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print(#function)
    }
}

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        print(#function)
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print(#function)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print(#function)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print(#function)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print(#function)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print(#function)
    }
}
```

Note that for SwiftUI, all you need to do is declare the same `@UIApplicationDelegateAdaptor` above for this all to work. The scene delegate is determined from your app plist and everything seems to "just work" in terms of setting up the delegates.

### Conclusion

In the code above, I have used `print(#function)` to print all the events to the console as they happen. This was very instructive for discerning how all of these APIs work together --- or, sometimes, don't. I encourage you to put it all together in a sample app if you are curious to experiment with and visualize the sequence of callbacks as they happen.

On one hand, the `ScenePhase` APIs can get you somewhat far on iOS. But if you need more granular control, you need to define an app delegate, a scene delegate, and provide the corresponding scene manifest in your app's plist. If you are going through all that trouble, you might as well structure your app to have a UIKit shell instead of trying to rely entirely on SwiftUI. On the other hand, the `ScenePhase` APIs are essentially useless on macOS and you must use an app delegate --- although this is much easier to set up. For complex Mac apps, an AppKit shell is probably the best approach.

There are probably some simple utility apps on both platforms that will never need to worry about all the issues I have described here, but for serious applications, you will run into these issues. Furthermore, there are _even more_ roles and responsibilities that app delegates have that I have not discussed here --- if you need any of that functionality for your app, then you _really must_ have an app delegate no matter what.

After all these years, it is disappointing that SwiftUI still does not offer these necessary and fundamental APIs for building applications on both platforms. SwiftUI needs more robust and reliable APIs for managing the app lifecycle, window lifecycles, and view lifecycles.
