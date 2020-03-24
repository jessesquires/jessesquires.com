---
layout: post
categories: [software-dev]
tags: [ios, uikit, xcode, debugging]
date: 2020-03-23T18:25:11-07:00
title: Implementing Dark Mode and using CGColor
---

For an iOS project that I am currently working on, I am implementing Dark Mode. The codebase is approaching 7 years old, it is mostly Swift with some legacy Objective-C, and it currently supports iOS 11 and above. Aside from the tedium of ensuring the updated colors are being used throughout the codebase, I expected this task to be straight-forward. However, there were some unanticipated issues.

<!--excerpt-->

In iOS 13, `UIColor` received a [new initializer](https://developer.apple.com/documentation/uikit/uicolor/3238041-init):

```swift
init(dynamicProvider: @escaping (UITraitCollection) -> UIColor)
```

This initializer receives a closure that takes a trait collection and returns a color. In the closure, you can switch on trait collection's [new property](https://developer.apple.com/documentation/uikit/uitraitcollection/1651063-userinterfacestyle), `userInterfaceStyle`, and provide a unique value for a light appearance and a dark appearance. Because this app still supports iOS 11 and 12, I wrote a wrapper to handle the API availability.

```swift
extension UIColor {
     static func dynamic(light: UIColor, dark: UIColor) -> UIColor {

         if #available(iOS 13.0, *) {
             return UIColor(dynamicProvider: {
                 switch $0.userInterfaceStyle {
                 case .dark:
                     return dark
                 case .light, .unspecified:
                     return light
                 @unknown default:
                     assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                     return light
                 }
             })
         }

         // iOS 12 and earlier
         return light
     }
}
```

One important thing to note is that this initializer returns instances of a new type, `UIDynamicProviderColor`. Depending on the initializer used, a `UIColor` initializer normally returns instances of `UIDeviceRGBColor`, `UICachedDeviceRGBColor`, `UIDeviceWhiteColor`, `UICachedDeviceWhiteColor`, or `UIDisplayP3Color`. (And perhaps others.) This is mostly an implementation detail, but if you happen to be comparing color objects (`UIColor` *does* conform to `Equatable`!), then you will start to notice failures because `UIDynamicProviderColor != UIDeviceRGBColor`.

Luckily, this codebase has a mostly well-defined color palette, so most changes looked like this:


```swift
extension UIColor {
     private static let _customColor = UIColor(...)

     private static let _customColorDarkMode = UIColor(...)

     static let customColor = UIColor.dynamic(light: _customColor, dark: _customColorDarkMode)
)
```

With this approach, we are able to keep a well-defined color palette of light and dark colors using private properties, then we can compose the dynamic colors from these and only expose the dynamic colors in the public API.

However, after making these changes to our palette and testing the changes, I noticed that some colors were not updating. When the app was launched in either mode all colors were correct, but if Dark Mode was toggled while the app was running then some colors would get "stuck" in whichever mode the app was launched.

This codebase has a lot of custom drawing code or minor tweaks to UI elements that manipulate a `UIView`'s underlying `CALayer`. Most commonly, that code looks something like this:

```swift
self.view.layer.borderColor = UIColor.customColor.cgColor
```

And here is the problem. `CGColor` is a [Core Graphics](https://developer.apple.com/documentation/coregraphics/cgcolorref?language=objc) primitive, a plain C struct. It does not have `UIColor`'s new dynamic behavior in iOS 13, because it cannot. It is not an object like `UIColor`, but just a group of floating-point values.

Thus, when your app is launched, views that are customized using `CGColor` will look correct. However, if you change the appearance setting while the app is running, every `CGColor` instance will be "stuck" in the wrong appearance since `CGColor` cannot respond to trait collection changes.

To fix this, we need to extract this kind of code into a separate method and then call this method from `traitCollectionDidChange()` in our custom view or view controller objects.

```swift
private func _updateColors() {
    self.layer.borderColor = UIColor.customColor.cgColor
}

override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    self._updateColors()
    self.setNeedsDisplay()
}
```

When you go to implement Dark Mode in your apps, beware of custom view drawing code. If you find bugs like I have described, try searching for usage of `.cgColor`. Good luck, and welcome to the dark side.
