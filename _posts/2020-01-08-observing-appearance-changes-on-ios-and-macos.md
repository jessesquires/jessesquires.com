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

After some searching online, I found that the [`UserDefaults`](https://developer.apple.com/documentation/foundation/userdefaults) key for the appearance setting on macOS is `"AppleInterfaceStyle"`. Of course, this is not officially documented. But this is the only solution I could find without having a proper API like iOS.

If you did not know, you can respond to changes in `UserDefaults` via [key-value observing](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html) and [since iOS 9.3 and macOS Sierra](http://dscoder.com/defaults.html) KVO will notify of changes made by other programs. That is exactly what I needed.

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

This works reliably, though in my testing it can take a few seconds before `observeValue(forKeyPath: of: change: context:)` gets called. But the bug is fixed. Now my menu bar icon will stay in sync with the current appearance setting.

Considering dark mode came to macOS first (in Mojave), it is disappointing that there is no official API for this like there is for UIKit on iOS 13. It makes AppKit and macOS feel second-class.






















