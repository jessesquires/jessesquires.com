---
layout: post
categories: [software-dev]
tags: [swift]
date: 2020-12-28T13:39:28-08:00
title: The different types of self in Swift
---

As a brief follow-up to [my previous post]({% post_url_absolute 2020-12-22-swift-self-executing-anonymous-closures %}), I thought it would be helpful to enumerate the various types of "self" in Swift. It is an overloaded term. As we've seen, it can be quite confusing.

<!--excerpt-->

#### Prefix `self.`

The "prefix self", or `self.`, is the main `self`, the primary `self` &mdash; it is **the self** with which you are most familiar. Other programming languages call it `this` and it refers to the instance of the enclosing type. You use it, either explicitly or implicitly, when referring to members of the enclosing type.

**Example:**

```swift
struct Person {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}
```

#### Postfix `.self`

This version of self, the postfix `.self`, refers to the metatype type of the type on which it is called. 

From the [Swift Programming Language Book](https://docs.swift.org/swift-book/ReferenceManual/Types.html#ID455):

> You can use the postfix `self` expression to access a type as a value. For example, `SomeClass.self` returns `SomeClass` itself, not an instance of `SomeClass`. And `SomeProtocol.self` returns `SomeProtocol` itself, not an instance of a type that conforms to `SomeProtocol` at runtime.

**Example:**

```swift
class SomeClass { }

SomeClass.self
```

#### `Self` Type

Capitalized `Self` is not actually a type at all, but a "placeholder" for a specific type at runtime.

From the [Swift Programming Language Book](https://docs.swift.org/swift-book/ReferenceManual/Types.html#ID610):
> The `Self` type isn’t a specific type, but rather lets you conveniently refer to the current type without repeating or knowing that type’s name.
>
> In a protocol declaration or a protocol member declaration, the `Self` type refers to the eventual type that conforms to the protocol.

**Example:**

```swift
extension FloatingPoint {
    static var one: Self {
        Self(1)
    }
}

// usage
Double.one
Float.one
CGFloat.one
```

#### `- [NSObject self]`

Ok, this one does not really have anything to do with Swift &mdash; except when it does. This was the culprit of the bug described in [the previous post]({% post_url_absolute 2020-12-22-swift-self-executing-anonymous-closures %}). This is the [instance method](https://developer.apple.com/documentation/objectivec/1418956-nsobject/1418954-self?language=objc) `self` on `NSObject`, which is part of the Objective-C runtime. It exists in Swift because of the interoperability between the two languages. However, as we have seen, this is nothing but a nuisance in Swift when interfacing with subclasses of `NSObject`.

[Objective-C](https://developer.apple.com/documentation/objectivec/1418956-nsobject/1418954-self?language=objc) docs:

```objc
/// Returns the receiver.
- (instancetype)self;

// usage
[MyClass self];
```

[Swift](https://developer.apple.com/documentation/objectivec/1418956-nsobject/1418954-self?language=swift) docs:

```swift
/// Returns the receiver.
func `self`() -> Self

// usage
MyClass.`self`
```
