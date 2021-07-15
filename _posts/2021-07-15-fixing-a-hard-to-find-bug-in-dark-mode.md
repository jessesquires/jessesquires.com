---
layout: post
categories: [software-dev]
tags: [ios, uikit, bugs, dark-mode]
date: 2021-07-15T13:14:32-07:00
title: Fixing a hard-to-find bug in Dark Mode
---

I previously [wrote about implementing Dark Mode]({% post_url 2020-03-23-implementing-dark-mode-with-cgcolor %}) in an older codebase, specifically how Dark Mode works (or doesn't) with `CGColor`. I recently fixed a bug in the same project that was difficult to track down because it manifested in such a strange way. After finding the problematic code, I realized that it is an extremely common scenario in iOS codebases &mdash; so you might have this bug in your code as well!

<!--excerpt-->

### Background

First, let me set the scene with a brief background on this app. This project has a custom `UIButton` subclass that implements a skeuomorphic design where the button contains a border and a lip such that it resembles and behaves similar to a physical button. It appears to be raised and depresses when tapped. The button is constructed with a primary color, which is then used to derive the border and lip colors, which could be slightly darker or slightly lighter than the primary color depending on the design and usage. Let's take a look at the distilled, simplified code:

```swift
class CustomButton: UIButton {

    func configureWith(color: UIColor) {
        self.backgroundColor = color
        self.borderColor = color.darkened(amount: 0.2)
        self.lipColor = color.darkened(amount: 0.2)
    }
}
```

Similar to UIKit's [`withAlphaComponent(_:)`](https://developer.apple.com/documentation/uikit/uicolor/1621922-withalphacomponent), which returns the same color with a modified `alpha`, this `darkened(amount:)` method returns the same color after adjusting the `brightness` of the color. There is also a corresponding method to lighten a color, `lightened(amount:)`, which is used for other button styles.

### Bug behavior

When launching the app in either Light Mode or Dark Mode, the appearance of all UI elements were correct. You could change your device appearance via Control Center while the app is running, and that also appeared to work &mdash; except for these buttons in some scenarios. The main button background color would adapt correctly, but the border and lip colors would "get stuck" with the previous color value. For example, if a button is blue in Light Mode and dark gray in Dark Mode, what you would see is a dark gray button with a blue border and lip, or a blue button with a dark gray border and lip. In other words, the primary background color and border/lip colors would get out-of-sync &mdash; one would be the Light Mode variant, the other would be the Dark Mode variant, depending on which mode was set when the app first launched. To make it more confusing, if you performed an action to trigger a redraw or refresh of the UI, the button colors for these buggy buttons would get back in sync with the correct colors. For example:

1. Put your device in Light Mode and launch the app
2. Navigate to a view with one of these buttons
3. Switch to Dark Mode using Control Center
4. The button colors get out of sync (the primary background color changes correctly, but the lip and border colors get "stuck")
5. Dismiss this view
6. Return back to the view
7. The button colors are all correct

And finally, because the button styles varied so much throughout the app, some buttons behaved correctly in every scenario! Only _some_ buttons exhibited this bug.

### Finding the problem

What could be causing this issue? Like I [wrote before]({% post_url 2020-03-23-implementing-dark-mode-with-cgcolor %}), when using `CGColor` you do not get dynamic appearance updates for free, you must manually redraw the views. However, I triple checked that no `CGColor` instances were involved. I verified that I was, in fact, passing dynamic colors with correct Light and Dark variants to these buttons. Moreover, these dynamic colors were constants that were being used elsewhere in the app to style _other_ UI components, which were behaving just fine. I spent hours trying to figure out what was going wrong. It did not make sense. This is the worst kind of bug: sometimes it works, sometimes it doesn't.

Let's take a look at those extension methods:

```swift
extension UIColor {
    func darkened(amount: CGFloat) -> UIColor {
        let delta = -min(max(0, amount), 1)
        return self.withBrightnessDelta(delta)
    }

    func lightened(amount: CGFloat) -> UIColor {
        let delta = min(max(0, amount), 1)
        return self.withBrightnessDelta(delta)
    }

    private func withBrightnessDelta(_ delta: CGFloat) -> UIColor {
        var hue = CGFloat(0)
        var saturation = CGFloat(0)
        var brightness = CGFloat(0)
        var alpha = CGFloat(1)

        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        brightness *= (1 + delta)

        let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        return color
    }
}
```

I know these are very common extensions to write on `UIColor` (or even `NSColor`). I have seen these utility methods in **many** iOS codebases over the years. In fact, I would say almost _every_ iOS codebase I have worked on has implemented something nearly identical.

Everything seems to be ok &mdash; but wait... the color that is returned is **not dynamic**! Passing a color through `darkened(amount:)` or `lightened(amount:)` is losing the dynamic color information. That explains every aspect of the strange behavior that the bug produced.

And now I can reveal that not _all_ buttons used these color extensions for styling, but instead provided custom (and dynamic) colors for their lip and border. That is why the bug only occurred for a subset of buttons in the app.

Let's fix it.

### Implementing the fix

Fixing this was surprisingly more involved than you might anticipate. Both of these color extensions are used _heavily_ throughout the codebase, so the fix needed to happen within these methods to ensure that all bugs were fixed everywhere &mdash; imagine all the other similar bugs that we had not noticed yet! These buttons happened to be the most popular UI component throughout the app.

First, let's make it easy to construct a dynamic color.

```swift
extension UIColor {
    static func dynamic(light: UIColor, dark: UIColor) -> UIColor {
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
}

// usage:
let myColor = UIColor.dynamic(light: myLightColor, dark: myDarkColor)
```

Next, we need a way to _extract_ both color variants from a dynamic color. UIKit provides this functionality via [`resolvedColor(with:)`](https://developer.apple.com/documentation/uikit/uicolor/3238042-resolvedcolor). But we can make it easier to use:

```swift
extension UIColor {
    var light: UIColor {
        let lightAppearance = UITraitCollection(userInterfaceStyle: .light)
        return self.resolvedColor(with: lightAppearance)
    }

    var dark: UIColor {
        let darkAppearance = UITraitCollection(userInterfaceStyle: .dark)
        return self.resolvedColor(with: darkAppearance)
    }
}
```

Now we can update our darkening and lightening methods to return dynamic colors. We need to extract the two color mode variants, individually modify the brightness for each, then construct and return a new dynamic color.

```swift
extension UIColor {
    func darkened(amount: CGFloat) -> UIColor {
        let change = -min(max(0, amount), 1)

        let lightMode = self.light.withBrightnessDelta(change)
        let darkMode = self.dark.withBrightnessDelta(change)
        return UIColor.dynamic(light: lightMode, dark: darkMode)
    }

    func lightened(amount: CGFloat) -> UIColor {
        let change = min(max(0, amount), 1)

        let lightMode = self.light.withBrightnessDelta(change)
        let darkMode = self.dark.withBrightnessDelta(change)
        return UIColor.dynamic(light: lightMode, dark: darkMode)
    }
}
```

If you have similar color extensions in your codebase and your app supports Dark Mode, now would be a good time to audit that code to see if you have the same issue. It is so easy to overlook that you may not have noticed the bug yet! If your codebase does have the bug, I hope this post helps.
