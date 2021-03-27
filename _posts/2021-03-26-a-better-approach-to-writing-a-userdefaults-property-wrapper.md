---
layout: post
categories: [software-dev]
tags: [swift, property-wrapper, userdefaults, ios, macos, open-source]
date: 2021-03-26T21:05:50-07:00
title: A better approach to writing a UserDefaults Property Wrapper
---

[UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults) is one of the most misused APIs on Apple platforms. Specifically, most developers do not handle default values correctly. In fact, I have never worked on a single production codebase at a company where this was done accurately. Most libraries get it wrong, too.

<!--excerpt-->

Since [property wrappers](https://nshipster.com/propertywrapper/) were introduced in Swift, one of the most common (and best) use cases has been to implement a property wrapper where the underlying value is stored in `UserDefaults`. This is a convenient approach and removes common boilerplate for saving and retrieving values from `UserDefaults`. Unfortunately, most libraries and codebases implement default values incorrectly, which often also leads to a poor design regarding optional and non-optional values that are stored in `UserDefaults`. There is even a somewhat recent [thread on the Swift forums](https://forums.swift.org/t/recommended-way-to-provide-default-value-for-nsdefault/32380) about this exact issue.

### Default values done right

If you think you know everything there is to know about `UserDefaults`, wait until you read David Smith's excellent ("unofficial") documentation, [*NSUserDefaults in Practice*](http://dscoder.com/defaults.html). You will likely learn something new. 

The "default value problem" manifests in two ways. The first way is to check for `nil` and return a default value if needed.

```swift
// option 1: check for nil and return a default
return UserDefaults.standard.object(forKey: "my-key") ?? defaultValue
```

The second way is to check for `nil` and explicitly set a default value.

```swift
// option 2: set a default if nil is found
let defaults = UserDefaults.standard
if defaults.object(forKey: "my-key") == nil {
    defaults.set(initialValue, forKey: "my-key")
}
return defaults.object(forKey: "my-key")
```

Both of these options are problematic, though option 2 is significantly worse, as David points out:

> [...] this has a subtle long-term flaw: if you ever want to change what the initial value is, you have no way to distinguish between a value set by the user (which they would like to keep) or the initial value that you set (which you'd like to change).

Although option 1 avoids this initial value flaw, it could instead make use of the API that `UserDefaults` provides for [exactly this situation](https://developer.apple.com/documentation/foundation/userdefaults/1417065-register).

```swift
UserDefaults.standard.register(defaults: ["my-key": defaultValue])
```

Again, [David writes](http://dscoder.com/defaults.html):

> This has a multitude of advantages:
>
> - It's never stored to disk, so it's impossible to confuse it with a value set by a user
> - It's automatically overridden by anything the user sets, so there's no need to wrap it in an if statement to check if you should avoid doing it
> - It avoids doing disk writes during app launch, which slow things down and wears out disks
>
> You can call `-registerDefaults:` as many times as you like, and it will combine the dictionaries that you pass it, which means you can keep registration of settings near the code that cares about them.

Surprisingly, SwiftUI provides an [@AppStorage property wrapper](https://developer.apple.com/documentation/swiftui/appstorage) that also gets default values wrong. If using this, you would need to manually call `register(defaults:)` with all of your key-value pairs somewhere during your app startup flow. Also, it is only available in iOS 14 and above.

### The optionals problem

Related to the "default value problem" is the use of optionals. Most developers agree that we should try to [eliminate optionals in Swift as much as possible]({{ site.url }}{% post_url 2015-04-06-swift-failable-initializers-revisited %}). If you provide a default value using `register(defaults:)`, then retrieving it will *always* return *something* (i.e., a non-optional value). This means that in many cases we can be sure a value exists in `UserDefaults`.

A common problem I see in codebases is a key-value pair for determining if the app is being launched for the first time by a user. Usually this takes the form of an "isFirstAppLaunch" key with a `Bool` value. Often, some manually written wrappers around `UserDefaults` will generically use `object(forKey:)` to get the value, which leaves you with a "truthy" result of either `true`, `false`, or `nil`. Despite the fact that `bool(forKey:)` exists to solve this specific problem, I still see this happen in large codebases.

In any case, without making use of `register(defaults:)`, we are left with a number of workarounds to handle (what may or may not legitimately be) `nil` values.

### A survey of existing libraries

There are a few libraries that currently provide a property wrapper for `UserDefaults`. However, the ones that I know about each have a combination of the following issues: (1) default values are not registered, (2) optionals are not handled nicely, (3) the library is extremely complicated for such a simple task.

[SwiftyUserDefaults](https://github.com/sunshinejr/SwiftyUserDefaults) is probably the most popular. It is an interesting library that showcases advanced Swift Language features like `@dynamicMemberLookup`. However, it is much too complicated for my uses. I think it tries to do too much, especially when all I need is a property wrapper. Notably, it **does not** make use of `register(defaults:)`.

Sindre Sorhus's [Defaults](https://github.com/sindresorhus/Defaults) library is quite similar to SwiftyUserDefaults. It is also very complex and does a lot of things. However, it **does** correctly use `register(defaults:)`.

In addition to providing the core functionality of a `UserDefaults` property wrapper, these libraries also provide an entire infrastructure for observing changes via KVO. I do not think this should be part of the library. I think most developers fall into a few categories: (1) they do not need this type of observation, (2) they explicitly avoid KVO in their codebase, or (3) if a codebase makes extensive use of KVO, it probably has a generic observer or other wrapper already implemented. Furthermore, `UserDefaults` also allows [observation via notifications](https://developer.apple.com/documentation/foundation/userdefaults/1408206-didchangenotification). Thus, I think observation is a task for clients to handle &mdash; if they need it at all &mdash; which they can implement by using notifications, by using reactive extensions like RxSwift, by using a generic KVO wrapper, or by writing the KVO code by hand, which is only a few lines and not too difficult (especially with Swift's improvements on the Objective-C API).

Another issue is that these libraries support `Codable` and `NSCoding` types, which I think is a bad thing to encourage. `UserDefaults` is not intended to store large `data` blobs. You should be using a proper database, or simply writing these `Codable` and `NSCoding` types to disk.

Again, from [*NSUserDefaults in Practice*](http://dscoder.com/defaults.html):

> `NSUserDefaults` is intended for relatively small amounts of data, queried very frequently, and modified occasionally. Using it in other ways may be slow or use more memory than solutions more suited to those uses.
>
> [...]
>
> Only types that can be stored in plists can be stored in `NSUserDefaults`. If you want to store arbitrary objects, you'll need to use `NSKeyedArchiver` or similar to make an `NSData` from them first. Often this means you're trying to store something other than user settings...

Finally, there Guillermo Muntaner's [Burritos](https://github.com/guillermomuntaner/Burritos) library, which is collection of many different property wrappers. It is by far [the simplest implementation](https://github.com/guillermomuntaner/Burritos/blob/master/Sources/UserDefault/UserDefault.swift), which I appreciate. Still, it does not handle default and optional values how I would like. And overall, this project feels more like a showcase of examples.

### A new library: Foil

I decided to write my own small library for this called [Foil](https://github.com/jessesquires/foil), which addresses all the issues I have discussed so far.

1. Correctly handle default values using `register(defaults:)`
1. Eliminates having to deal with optionals when possible
1. Provide a practical, simple, and lightweight implementation

Foil provides support for all property list types capable of being stored in `UserDefaults`, including `RawRepresentable` types which means it works with `enum` types out-of-the-box. It explicitly omits support for `Codable` and `NSCoding`. A single `UserDefaultsSerializable` protocol can be implemented for custom types, although this is discouraged. Any sort of observation is left up to the client. 

### Implementing the property wrapper

The code for the property wrapper is small and likely similar to other implementations that you have seen.

```swift
@propertyWrapper
public struct WrappedDefault<T: UserDefaultsSerializable> {
    private let _defaultValue: T
    private let _userDefaults: UserDefaults

    public let key: String

    public var wrappedValue: T {
        get {
            self._userDefaults.fetch(self.key)
        }
        set {
            self._userDefaults.save(newValue, for: self.key)
        }
    }

    public init(keyName: String,
                defaultValue: T,
                userDefaults: UserDefaults = .standard) {
        self.key = keyName
        self._defaultValue = defaultValue
        self._userDefaults = userDefaults
        userDefaults.registerDefault(value: defaultValue, key: keyName)
    }
}
```

Note that the default value is immediately registered during initialization. The extension methods `fetch()` and `save()` on `UserDefaults` encapsulate handling the optionals (by force-unwrapping since we know it is safe to do). You can pass a custom store, for example `UserDefaults(suiteName: "someDomain")`, if needed. Finally, the type you store must conform to `UserDefaultsSerializable`. Default conformances are provided for builtin types. Because we provide a default value, we know it will never be `nil`.

In some cases, `nil` may be a valid value for your key. In that case, a second property wrapper `@WrappedDefaultOptional` is provided, which allows the value to be `nil` and omits the `defaultValue:` parameter (which defaults to `nil`).

### Using Foil

Using Foil is as simple as declaring properties that use the wrapper. It is recommended that you define some central location to store all of your settings, like this:

```swift
// define centralized settings
final class AppSettings {
    static let shared = AppSettings()

    @WrappedDefault(keyName: "flagEnabled", defaultValue: true)
    var flagEnabled: Bool

    @WrappedDefaultOptional(keyName: "timestamp")
    var timestamp: Date?
}

// elsewhere...
// get or set properties
AppSettings.shared.flagEnabled
AppSettings.shared.timestamp
```

Part of keeping the library small means omitting some kind of global entry point like the `DefaultsAdapter` component in [SwiftyUserDefaults](https://github.com/sunshinejr/SwiftyUserDefaults), which I find a bit awkward and cumbersome. A class like `AppSettings` that I have defined above is easy enough to write, but more importantly, clients likely already use their own abstraction.

### Handling keys

You may be wondering about those "stringly-typed" keys. If using this (recommended) implementation that centralizes all of your settings, there is no need define an `enum` for all of your key names. You only need to declare the properties and then access them via `AppSettings.shared`. I think this works for the vast majority of projects. However, if you want to define your keys as an `enum`, you can write a small extension:

```swift
enum AppSettingsKey: String {
    case flagEnabled
    case timestamp
}

extension WrappedDefault {
    init(key: AppSettingsKey, defaultValue: T) {
        self.init(keyName: key.rawValue, defaultValue: defaultValue)
    }
}
```

Then you can use your `enum` values for the keys:

```swift
@WrappedDefault(key: .flagEnabled, defaultValue: true)
var flagEnabled: Bool

@WrappedDefaultOptional(key: .timestamp)
var timestamp: Date?
```

Finally, there is one potential source of bugs to point out. You could accidentally define two properties with the same key name but **different** default values. The default value of the second property initialized would overwrite the first. Christian Tietze [writes about this issue here](https://christiantietze.de/posts/2019/12/userdefaults-property-wrappers/), but mistakenly argues that SwiftyUserDefaults fixes this by defining the key name and the default value together. Unfortunately, in SwiftyUserDefaults there is nothing stopping you from writing something like this:

```swift
// SwiftyUserDefaults
extension DefaultsKeys {
    var launchCount: DefaultsKey<Int> { 
        DefaultsKey("launchCount", defaultValue: 0)
    }

    var launchCount2: DefaultsKey<Int> { 
        DefaultsKey("launchCount", defaultValue: 99)
    }
}
```

Foil, despite also defining the key name and the default value together, is susceptible to this bug, which is simply inherent to using string-based keys &mdash; which is just how `UserDefaults` works. You can easily introduce the same bug by using the `UserDefaults` API directly. The only way to avoid this bug is to ensure that all key names are unique and to centralize the definition of all key-value pairs, like I have done with the `AppSettings` class in the example above.

#### Storing `URL` is special

One final note: `URL` is special when in comes to `UserDefaults`. When I was writing Foil, I came across a strange bug. When attempting to save a `URL` I was hitting an assert with the error: "Attempt to insert non-property list object, NSInvalidArgumentException". I had to force Swift to use the [`URL`-specific method](https://developer.apple.com/documentation/foundation/nsuserdefaults/1414194-seturl?language=objc) for setting a `URL` instead of using the generic `set(_:, forKey:)` API.

```swift
UserDefaults.standard.set(someURL as? URL, forKey: key)
```

When attempting to read the value back, I hit another assert with the error: "Could not cast value of type `_NSInlineData` to `NSURL`". Again, I had to use the [`URL`-specific method](https://developer.apple.com/documentation/foundation/userdefaults/1408648-url) for getting a `URL` instead of the generic `object(forKey:)` API.

```swift
let url = UserDefaults.standard.url(forKey: key)
```

All other types can use the generic methods `set(_:, forKey:)` and `object(forKey:)` and work as expected. Very strange. Upon re-reading [NSUserDefaults in Practice](http://dscoder.com/defaults.html), I learned why:

> The `-setURL:forKey:` method does what it says on the tin, but is unique in that it's the only `NSUserDefaults` method that lets you store a non-plist type. If you want to store `NSURL`s, you have to use it rather than `-setObject:forKey:`

Based on the error message above, it looks like internally, `UserDefaults` is converting `URL` to/from a private subclass of `Data` named `_NSInlineData`.

The more you know. (Remember when I said you will likely learn something new?)

### Conclusion

That's it! Foil is a library that encapsulates my preferred approach to writing a `UserDefaults` property wrapper. The code is [on GitHub](https://github.com/jessesquires/Foil) and contributions are welcome!
