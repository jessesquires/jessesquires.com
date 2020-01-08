---
layout: post
categories: [software-dev]
tags: [ios, macos, uikit, appkit]
date: 2020-01-08T08:37:35-08:00
title: Observing appearance changes on iOS and macOS
---

I recently needed to determine when the user has manually switched between dark mode and light mode on macOS. In my menu bar app, [Lucifer](https://www.hexedbits.com/lucifer/), the icon reflects the current appearance setting when you change it from the app &mdash; an inverted pentagram for dark mode and an upright pentagram for light mode. But there's a bug. If the user manually changes the appearance setting from System Preferences, or if they are using the new "auto" setting in macOS Catalina, the icon gets stuck in its previous state.

<!--excerpt-->

I needed to get notified when the system appearance changed. On iOS, this is very straight-forward and a first-class API. On iOS 13, the interface style is part of [`UITraitCollection`](https://developer.apple.com/documentation/uikit/uitraitcollection). In your view controllers, you can observe and respond to trait collection changes:

```swift
override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    switch self.traitCollection.userInterfaceStyle {
    case .dark:
        print("dark")
    case .light:
        print("light")
    case .unspecified:
        print("unspecified")
    @unknown default:
        fatalError()
    }
}
```

I was hoping to find an equivalent `NSTraitCollection` in AppKit, but unfortunately that does not exist. Solving this will require some creativity.

After some searching online, I found that the [`UserDefaults`](https://developer.apple.com/documentation/foundation/userdefaults) key for the appearance setting on macOS is `"AppleInterfaceStyle"`. Of course, this is not officially documented. If you did not know, you can respond to changes in `UserDefaults` via [key-value observing](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html) and [since iOS 9.3 and macOS Sierra](http://dscoder.com/defaults.html) KVO will notify of changes made by other programs.

```swift
// in a view controller or similar

private static var observerContext = 0

UserDefaults.standard.addObserver(self,
                                  forKeyPath: "AppleInterfaceStyle",
                                  options: [.new, .old, .initial, .prior],
                                  context: &Self.observerContext)

override func observeValue(forKeyPath keyPath: String?,
                           of object: Any?,
                           change: [NSKeyValueChangeKey: Any]?,
                           context: UnsafeMutableRawPointer?) {
    // respond to change...
}
```

This works but it is a hack. And in my testing it can take a few seconds before `observeValue(forKeyPath: of: change: context:)` gets called.

It turns out there is a better option. Instead, you can KVO on [`NSApp.effectiveappearance`](https://developer.apple.com/documentation/appkit/nsapplication/2967171-effectiveappearance). This is a much better and more reliable solution, and the observation closure is called immediately.

```swift
let observer = NSApp.observe(\.effectiveAppearance, options: [.new, .old, .initial, .prior]) { app, change in
    // respond to change...
}
```

That is exactly what I needed. Using KVO still does not feel great, but this is the best solution I could find without having an explicit API like iOS. The bug is fixed! Now my menu bar icon will stay in sync with the current appearance setting. I would still rather have an API similar to iOS, but this will do. Also note, if you are in the context of an `NSView` then you can implement [`viewDidChangeEffectiveAppearance()`](https://developer.apple.com/documentation/appkit/nsview/2977088-viewdidchangeeffectiveappearance).
