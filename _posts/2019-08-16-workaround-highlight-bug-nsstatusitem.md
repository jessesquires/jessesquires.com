---
layout: post
categories: [software-dev]
tags: [macos, debugging]
date: 2019-08-16T08:00:00-07:00
title: Workaround for highlight bug in NSStatusItem
---

Continuing from my [previous post]({% post_url_absolute 2019-08-15-implementing-right-click-for-nsbutton %}), there is a bug in `NSStatusItem` that I forgot to mention. Thanks to [Michael Tsai](https://mjtsai.com/blog) ([tweet](https://twitter.com/mjtsai/status/1162075417601294336)) for pointing out this workaround.

<!--excerpt-->

When handling left-click and right-click differently for an `NSStatusItem`, the highlight state gets out of sync. The expected behavior is: you click (left or right) on the icon in the menu bar on your mac, it highlights on mouse-down, the action is performed (i.e., your function is called), then the icon unhighlights on mouse-up.

The bug is that when you right-click, the `NSStatusItem` stays highlighted until you click it again. When clicking for the second time it only unhighlights the button, no action is triggered which leaves the app feeling unresponsive or glitchy. The next click will then call your action method.

`NSStatusItem` is a subclass of `NSObject`, which has an `NSStatusBarButton` property, which is an `NSButton`. It seems like `NSStatusBarButton` manages or overrides the highlight behavior that is causing the bug &mdash; that's my guess.

The workaround is to send the action on `.rightMouseUp` instead of `.rightMouseDown`. This is odd, but in practice I think it feels fine and provides a much better user experience.

Notably, this bug does not occur when using control-click.

```swift
extension NSEvent {
    var isRightClickUp: Bool {
        let rightClick = (self.type == .rightMouseUp)
        let controlClick = self.modifierFlags.contains(.control)
        return rightClick || controlClick
    }
}

let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
statusItem.button?.target = self
statusItem.button?.action = #selector(doSomething)
statusItem.button?.sendAction(on: [.leftMouseDown, .rightMouseUp])

@objc
func doSomething() {
    if let event = NSApp.currentEvent, event.isRightClickUp {
        // handle right-click (up)
    } else {
        // handle left-click
    }
}
```
