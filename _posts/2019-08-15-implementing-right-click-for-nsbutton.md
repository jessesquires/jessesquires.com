---
layout: post
categories: [software-dev]
tags: [macos, appkit, uikit, apps]
title: Implementing right-click for NSButton
---

This isn't complicated, but I found it confusing. Perhaps I am spoiled by the more modern APIs in `UIKit`. When writing [Lucifer](https://www.hexedbits.com/lucifer), a menu bar app, I wanted to have different actions for left-clicking and right-clicking on the button in the menu bar. To my surprise, this was much more cumbersome than I expected.

<!--excerpt-->

<span class="text-muted">An aside: for a menu bar item, you create an `NSStatusItem` (a subclass of `NSObject`), which has an `NSStatusBarButton` property, which is an `NSButton`. A bit odd, similar to `UINavigationItem` on iOS, which also inherits from `NSObject`.</span>

In `UIKit`, responding to different events for the same button (or any `UIControl`) is straight-forward. You can add as many target-action pairs as you like, each responding to a specific `UIControl` event.

```swift
let button = UIButton(frame: frame)

button.addTarget(self, action: #selector(touchUp), for: .touchUpInside)

button.addTarget(self, action: #selector(touchDown), for: .touchDown)
```

Furthermore, in `UIKit` it is even possible to (optionally) pass the `UIControl.Event` to the specified selector. Conventionally, most people usually only pass the `sender`.

```swift
@objc
func onTouchEvent(sender: Any, action: UIControl.Event) {
    // do something
}
```

The APIs in `AppKit` are much less intuitive. A `UIControl` is only associated with a single `target` and `action`, and you cannot pass the event to the specified selector, only the sender.

```swift
let button = NSButton(title: title, target: self, action: #selector(onClick))
```

To achieve similar functionality as `UIKit` &mdash; specifically, responding differently to a left-click and right-click &mdash; you must specify on which events to send the action message.

```swift
button.sendAction(on: [.leftMouseDown, .rightMouseDown])
```

Then, in the function that you have specified to handle events, you must query `NSApp.currentEvent`.

```swift
extension NSEvent {
    var isRightClick: Bool {
        let rightClick = (self.type == .rightMouseDown)
        let controlClick = self.modifierFlags.contains(.control)
        return rightClick || controlClick
    }
}

@objc
func onClick() {
    if let event = NSApp.currentEvent, event.isRightClick {
        // handle right-click
    } else {
        // handle left-click
    }
}
```

This feels odd and clunky &mdash; maybe I am merely confronting the differences between developing for macOS instead of iOS &mdash; but it appears to be "the right way" to do this. I could not find much written about this online. If there is a better way to do this, please let me know. It would also be interesting to know why these APIs are designed this way.
