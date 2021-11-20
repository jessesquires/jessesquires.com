---
layout: post
categories: [software-dev]
tags: [ios, macos, swiftui]
date: 2021-11-19T14:44:21-08:00
title: SwiftUI tips for organizing multiplatform projects
---

If you are working on a multiplatform SwiftUI project, you will start accumulating `#if os()` checks and `#if canImport()` checks. Overtime, these start to accumulate and &mdash; in addition to being unsightly &mdash; they make your code much more difficult to read. When possible, I have started to encapsulate these preprocessor directives to improve code organization and readability.

<!--excerpt-->

Consider the following example, where a view is constructed with additional `Spacer` views only on macOS.

```swift
struct ExampleView: View {
    var body: some View {
        Text("One")
    #if os(macOS)
        Spacer()
    #endif
        Text("Two")
    #if os(macOS)
        Spacer()
    #endif
        Text("Three")
    #if os(macOS)
        Spacer()
    #endif
    }
}
```

This is overwhelming and repetitive. Instead of repeatedly checking `#if os(macOS)`, we can encapsulate the spacer view code to make this more readable.

```swift
struct SpacerMacOSOnly: View {
    var body: some View {
    #if os(macOS)
        Spacer()
    #endif
    }
}
```

Using this new view results in a dramatic improvement.

```swift
struct ExampleView: View {
    var body: some View {
        Text("One")
        SpacerMacOSOnly()
        Text("Two")
        SpacerMacOSOnly()
        Text("Three")
        SpacerMacOSOnly()
    }
}
```

We can also use this approach for view modifiers that only exist on one platform. Consider building a `List` view where we want to hide the row separators, which only exist on iOS.

```swift
List {
    Text("Option 1")
    #if os(iOS)
        .listRowSeparator(.hidden)
    #endif
    Text("Option 2")
    #if os(iOS)
        .listRowSeparator(.hidden)
    #endif
    Text("Option 3")
    #if os(iOS)
        .listRowSeparator(.hidden)
    #endif
}
```

We can create a new view modifier and extension to encapsulate hiding the separators.

```swift
struct HideRowSeparator: ViewModifier {
    func body(content: Content) -> some View {
    #if os(iOS)
        content.listRowSeparator(.hidden)
    #else
        content
    #endif
    }
}

extension View {
    func hideRowSeparator() -> some View {
        modifier(HideRowSeparator())
    }
}
```

And then the original code can be simplified. Unfortunately, you currently cannot apply `.listRowSeparator(.hidden)` to the entire `List`.

```swift
List {
    Text("Option 1").hideRowSeparator()
    Text("Option 2").hideRowSeparator()
    Text("Option 3").hideRowSeparator()
}
```

Finally, what's better than encapsulating these various preprocessor directives into their own components? Avoiding them entirely, of course. You can achieve this by placing files in _only_ the target for the specific platform in which they are needed. For example, if you need to provide a `UIApplicationDelegate`, you can include that in only your iOS target. When you separate files into their respective targets, you don't need any checks at all. However, it is not always possible to structure your code in this way, such as the examples above.
