---
layout: post
categories: [software-dev]
tags: [swift, swiftui, ios, macos]
date: 2024-09-09T07:32:37-07:00
title: SwiftUI's Observable macro is not a drop-in replacement for ObservableObject
---

SwiftUI's new [`@Observable` macro](https://developer.apple.com/documentation/Observation/Observable()) is not a drop-in replacement for [`ObservableObject`](https://developer.apple.com/documentation/Combine/ObservableObject). I learned of a subtle difference in behavior the hard way. Hopefully, I can save you from the same headache I experienced and save you some time.

<!--excerpt-->

### Background

The new `@Observable` macro was introduced last year with iOS 17 and macOS 14. It was advertised as (mostly) a drop-in replacement for `ObservableObject`, but there is a significant behavior difference regarding initialization. You need to use the [`@StateObject` property wrapper](https://developer.apple.com/documentation/swiftui/stateobject) with `ObservableObject` and use the [`@State` property wrapper](https://developer.apple.com/documentation/swiftui/state) with `@Observable`. This is the key difference and the underlying cause for the difference in initialization behavior. In other words, the issue is _not really_ with `ObservableObject` and `@Observable`, but with their associated property wrappers.

The `@StateObject` property wrapper initializer has the definition:

```swift
init(wrappedValue thunk: @autoclosure @escaping () -> ObjectType)
```

The `@State` property wrapper initializer has the definition:

```swift
init(wrappedValue value: Value)
```

I think the [official migration guide](https://developer.apple.com/documentation/swiftui/migrating-from-the-observable-object-protocol-to-the-observable-macro) should have a loud warning about this, but unfortunately it does not.

This is a **significant** difference. `@StateObject` receives an `@autoclosure` for the `wrappedValue` parameter while `@State` simply receives the value. The result is that `@StateObject` can not only defer initialization of the received value, but it will only ever initialize the value once. When using `@State`, the initializer for `Value` will be called every single time SwiftUI destroys and rebuilds the view hierarchy. Depending on how you've constructed your views and types, this is either a non-issue or results in incredibly confusing and buggy behavior that is not obvious unless you are aware of this subtle difference.

### Example

Let's look at a brief example of the differences. First, we'll consider the "old" way of doing things using `ObservableObject` and `@StateObject`.

```swift
class MyModel: ObservableObject {
    @Published var value = MyValue()
    // ...
}

@main
struct MyApp: App {
    @StateObject private var model = MyModel()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(model)
        }
    }
}
```

Next, let's convert this example to use `@Observable` and `@State` by following the [migration guide](https://developer.apple.com/documentation/swiftui/migrating-from-the-observable-object-protocol-to-the-observable-macro).

```swift
@Observable
class MyModel {
    var value = MyValue()
    // ...
}

@main
struct MyApp: App {
    @State private var model = MyModel()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(model)
        }
    }
}
```

### The bug

Unfortunately, switching to `@Observable` caused a significant and difficult to debug problem in my app. There were three issues with how I had architected my app using `ObservableObject`.

1. First, unlike the example code above, I was declaring my `@StateObject` from within my main root `View` object --- **not** at the `App` level.
2. Next, in the initializer of my `ObservableObject`, I was loading cached data from `UserDefaults` and storing these values in my `@Published` properties.
3. Finally, my `ObservableObject` was registered to listen for the `NS/UIApplication.willTerminateNotification` notification and saved its data back to `UserDefaults` when quitting the app.

Here's a simplified version of what the code looked like _after_ migrating to `@Observable`.

```swift
@Observable
class MyModel {
    var value = MyValue()

    // ...

    init() {
        // read cached values from UserDefaults
        value = UserDefaults.standard.object(forKey: "my_value")

        NotificationCenter.default
            .publisher(for: .willTerminateNotification)
            .sink {
                // save values to UserDefaults
                UserDefaults.standard.set(value, forKey: "my_value")
            }
            .store(in: &cancellables)
    }
}

struct MainView: View {
    @State private var model = MyModel()

    var body: some View {
        // ...
    }
}
```

When using `ObservableObject` before the migration, the code above behaved as you would expect. My data would load and save correctly. I was using `UserDefaults` because I only needed to store a few lightweight values and I wanted to keep everything simple. I was using app lifecycle notifications because [SwiftUI scene phase does not work]({% post_url 2024-06-29-swiftui-scene-phase %}).

The result of migrating to `@Observable` (using the code above) was unpredictable behavior because of the changes in initialization that I described above. Previously, my `ObservableObject` (remember, using `@StateObject`) was _only ever initialized once_, because the initializer for `@StateObject` receives an `@autoclosure`. This meant that reading from `UserDefaults` only occurred once and registering for the notifications only occurred once for the lifetime of the app.

However, with `@Observable` (and thus, `@State`), the initializer for `MyModel` is called _every single time SwiftUI decides to rebuild the view._ Under-the-hood, when state changes occur, SwiftUI will destroy and rebuild the view. This means your view struct (in this case, `MainView`) will get re-initialized often. This implicitly re-initializes all `@State` variables, too. However, SwiftUI preserves the _original_ `@State` property value and applies that value before initialization completes. The flow looks like this:

1. Initialize the `@State` variables (these are _new_ objects)
2. Call the `View` initializer
3. Reset the `@State` variables back to the _previously initialized and stored_ objects (discarding objects initialized in step 1)
4. Initialization is complete
5. Execute the view's `body` (using the correct values from step 3)

What I observed is that all those new, initial instances of `MyModel` (from step 1 above) **linger around in memory indefinitely**. I verified this via logging and Xcode's memory graph debugger. Occasionally and non-deterministically, some of those `MyModel` instances will get deallocated. This seems like a bug in SwiftUI.

Note that the `View` still displays the correct data because the original object is reset to the `@State` property (step 3 above).

The reason this became a problem in my particular situation was because my model object was listening for the notification, `NS/UIApplication.willTerminateNotification`. All those extra instances of `MyModel` lingering around in memory were still observing this notification. When triggered, each instance would save whatever data it had to `UserDefaults`, resulting in a non-deterministic "last write wins" scenario. Upon relaunching the app, who knows was random data would load from `UserDefaults`. Yikes. This was admittedly not the best design, but it worked well for my purposes.

### The fix

I suppose the moral of this story is, _"I was holding it wrong."_ But honestly, if you cannot design your API such that a user is _unable_ to hold it wrong in the first place, then it is not entirely the user's fault when things go wrong. However, I do think the fact that random `@State` objects linger around somewhere in memory in the opaque abyss of SwiftUI's state management mechanism is a real problem.

The correct way to architect your app is to store all `@State` properties in your top-level `App` struct, which does not get repeatedly destroyed and rebuilt like SwiftUI `View` objects. (And really, your `@StateObject` properties should also be declared in your `App` struct too.) There were some technical reason why I did not initially do this, but the details are not important. I was able to rework my design to make it work. If you cannot do that, then you need to ensure whatever object you store in `@State` _does nothing_ in `init()` and does not manage any state in response to app lifecycle notifications or something similar. Because scene phase is broken in a number of ways, I [recommend using `NS/UIApplicationDelegateAdaptor` instead]({% post_url 2024-06-29-swiftui-scene-phase %}).

An aside: when using `@State` you will also want to ensure that your object's initializer does not perform any _expensive_ operations either. That will also result in a very bad time for you.

### Additional reading

These posts on other initialization quirks of `@State` and `@StateObject` are also worth reading.

- [Be Careful When You Initialize a State Object](https://jaredsinclair.com/2024/03/14/state-object-autoclosure.html)
- [Do NOT init State externally in SwiftUI](https://samwize.com/2024/05/08/do-not-init-state-externally-in-swiftui-view/)
