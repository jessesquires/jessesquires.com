---
layout: post
categories: [software-dev]
tags: [ios, swiftui, uikit]
date: 2023-07-18T08:49:58-07:00
title: How to customize NavigationLink accessory views in SwiftUI
---

In UIKit, `UITableViewCell` has a customizable accessory view. You can use one of the few accessory options that is provided by iOS by setting the [`accessoryType`](https://developer.apple.com/documentation/uikit/uitableviewcell/1623228-accessorytype) property, or you can provide a custom view using [`accessoryView`](https://developer.apple.com/documentation/uikit/uitableviewcell/1623219-accessoryview), which can be any `UIView`. The equivalent of constructing a `UITableViewCell` with a [chevron accessory](https://developer.apple.com/documentation/uikit/uitableviewcell/accessorytype/disclosureindicator) in SwiftUI is using a [`NavigationLink`](https://developer.apple.com/documentation/swiftui/navigationlink). Unfortunately, however, SwiftUI does not provide an API to customize the accessory view for a `NavigationLink` --- you are stuck with the default chevron.

<!--excerpt-->

Leading by example, UIKit demonstrates the need for different accessory views to communicate to the user what to expect when they tap a table view cell. You can find all the different accessory types in use in the apps built-in to iOS --- chevrons, the information icons ("i" with a circle), and checkmarks. It is very common for apps to customize the accessory view for cells in a `UITableView` or views in a SwiftUI `List`. It is surprising that SwiftUI still lacks an official API for this.

What's worse than a default chevron that cannot be customized is that there is also no API to opt-out and simply hide it. And what's even worse than _that_ is that the default chevron for a `NavigationLink` is **different** than the chevron provided by SFSymbols. If used together, they clash and it's ugly.

So, like many things in SwiftUI, we have to resort to hacks and obscure workarounds to achieve decades-old UIKit behavior. The best way I've found to hide the default chevron in a `NavigationLink` is to hide the entire thing underneath another view using a `ZStack`.

Suppose we are using a `NavigationLink` to display an "About" view in our app:

```swift
// HACK: ZStack with zero opacity + EmptyView
// Hides default chevron accessory view for NavigationLink
ZStack {
    NavigationLink {
        AboutView()
    } label: {
        EmptyView()
    }
    .opacity(0)

    Label(title: "About", icon: Image(systemName: "info.circle"))
}
```

This allows you to provide an entirely custom `View` for the `NavigationLink`. In this case, that's the foremost `Label` in the `ZStack`. Obviously, you would not want to copy and paste this snippet every time you need a `NavigationLink`, so we can write a better version of `NavigationLink` to encapsulate this for us. We can mimic the `NavigationLink` API.

```swift
struct BetterNavigationLink<Label: View, Destination: View>: View {
    let label: () -> Label
    let destination: () -> Destination

    init(@ViewBuilder label: @escaping () -> Label,
         @ViewBuilder destination: @escaping () -> Destination) {
        self.label = label
        self.destination = destination
    }

    var body: some View {
        // HACK: ZStack with zero opacity + EmptyView
        // Hides default chevron accessory view for NavigationLink
        ZStack {
            NavigationLink {
                self.destination()
            } label: {
                EmptyView()
            }
            .opacity(0)

            self.label()
        }
    }
}
```

With that, we have a drop-in replacement for `NavigationLink` and can update all call sites to use `BetterNavigationLink` instead.

```swift
BetterNavigationLink {
    Label(title: "About", icon: Image(systemName: "info.circle"))
} destination: {
    AboutView()
}
```

{% include break.html %}

I think `NavigationLink` can be made significantly better with some small changes. First, I do not think there should be _any_ accessory view by default --- accessories should be opt-in, just like with `UITableViewCell`. Second, I think `NavigationLink` should allow you to set _any_ SFSymbol as the accessory. Perhaps this could be a new view modifier for `NavigationLink`.

```swift
NavigationLink {
    AboutView()
} label: {
    Text("About")
}
.navigationAccessory(Image(systemName: "info.circle"))
```

Wouldn't that be nice?
