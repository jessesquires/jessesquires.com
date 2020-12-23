---
layout: post
categories: [software-dev]
tags: [ios, swift, closures, debugging, uikit]
date: 2020-12-22T18:24:28-08:00
title: What type is self in a Swift self-executing anonymous closure used to initialize a stored property?
subtitle: The answer might surprise you
---

In JavaScript, this [pattern is called](https://developer.mozilla.org/en-US/docs/Glossary/IIFE) an Immediately Invoked Function Expression (IIFE) or a Self-Executing Anonymous Function. Swift doesn't have an "official" name for this, but IIFE works as well as "immediately executed anonymous closure" or "self-executing anonymous closure". (Thanks to folks on Twitter for helping with this.)

<!--excerpt-->

Most Swift developers have seen and used this now-common approach to initialize properties for a type:

```swift
class MyClass {

    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = .medium
        df.dateStyle = .long
        return df
    }()
    
    // other members here...
}
```

It is a convenience and concise pattern that helps organize your code. This approach is especially popular when working with UIKit and defining custom views. It simplifies type initializers and is generally easy to read. Recently, I was using this approach and discovered a bug in my code, some very unexpected behavior in Swift, and *maybe* a bug in Swift.

I was building a typical table view which contained cells that had a button subview. Tapping the entire cell and tapping the button within the cell performed different actions. You have probably built something similar before. Here is simplified sample code to illustrate:

```swift
class MyTableCell: UITableViewCell {

    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Title", for: .normal)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.button)
        // add constraints, other setup, etc ...
    }

    @objc 
    func didTapButton(_ sender: UIButton) {
        // do something
    }
}
```

I was building such a routine, mundane feature that I completed a large portion of the code before even running and testing it. I've written code like this thousands of times. So, you can imagine my surprise when the button inside the cell was not triggering the action. Tapping the button did nothing, but everything else seemed to work as expected. There's a bug in that code above. Can you find it? I scoured line after line, trying to find what I missed. What I had overlooked out of habit?

The problem was the call to `addTarget(_:, action:, for:)`. Moving this line to the initializer fixed the issue, and everything worked as expected.

```swift
override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.contentView.addSubview(self.button)
    
    // fix: add target/action here
    self.button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    
    // add constraints, other setup, etc ...
}
```

Upon discovering *what* the problem was, it was now time to ask *why*. My initial intuition was the following:

1. The `button` is a stored constant property that gets initialized immediately via a self-executing anonymous closure
1. Swift's initialization rules mean that stored properties (with values, like this one) *must* be initialized *before* the type that owns them
1. Thus, at the time that `button` is initialized (when the closure is executed), `self` must be `nil`
1. The method `addTarget(_:, action:, for:)` accepts `Any?` for the target parameter, so passing `nil` would be ok
1. Conclusion: `self` was just `nil` the whole time! What a goofy mistake!

However, that was not the case. Specifically, `self` **was not** `nil`. Not only that, but `self` wasn't the `self` I expected. Looking at this snippet, can you determine what type `self` is and why?

```swift
class MyTableCell: UITableViewCell {

    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Title", for: .normal)
        
        // what is self?
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        
        return button
    }()
}
```

I paused execution in the debugger to check if `po self` printed `nil`. Instead, it printed `(Function)`. In Swift, [closures are first-class reference types](https://docs.swift.org/swift-book/LanguageGuide/Closures.html). Thus, I concluded that `self` is referring to **the closure**, which is the type `() -> UIButton`. Right? Actually... no. 

Continuing the investigation, I printed `type(of: self)` which returned `(MyTableCell) -> () -> MyTableCell`. What?! This is a closure that receives a `MyTableCell` instance and returns a closure with the type `() -> MyTableCell`, which accepts nothing and returns a `MyTableCell`. I do not understand why this is the case. 

I think most devs would share my initial intuition that `self` refers to `MyTableCell` here, because that is true in other patterns that *look similar* to this one, like [computed properties](https://docs.swift.org/swift-book/LanguageGuide/Properties.html#ID259). Despite this, once realizing that `self` is a function, I think most devs would also intuit that the type **must** be `() -> UIButton`. 

This raises some interesting questions. 

First, I realize that the `#selector` construct, which was introduced by [SE-0022](https://github.com/apple/swift-evolution/blob/main/proposals/0022-objc-selectors.md), has limited abilities. As mentioned in the ["Alternatives considered"](https://github.com/apple/swift-evolution/blob/main/proposals/0022-objc-selectors.md#alternatives-considered) section of the proposal, `#selector` is **not** type-safe. However, *it is* capable of determining if a selector is in scope. If you attempt to pass a selector from another class, the compiler will provide a warning. For example, considering the following:

```swift
class OuterClass {
    func button() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }
    
    class InnerClass {
        @objc
        func didTapButton(_ sender: UIButton) {
            // do something
        }
    }
}
```

This produces the expected error: `Cannot find 'didTapButton' in scope`. It is not clear to me how this is distinct from the `MyTableCell` example regarding the scope of the selector. How is `didTapButton(_:)` in scope for `self` if `self` **is not** an instance of `MyTableCell`? Is this a bug with `#selector`?

Second, why is `self` an instance of `(MyTableCell) -> () -> MyTableCell` and **not** `() -> UIButton`? Is this a bug in Swift? 

I'm hoping someone can answer these two questions and explain what is happening. If so, I'll update this post!

In any case, referencing `self` in self-executing anonymous closures for stored properties should be avoided! That `self` is not the `self` you might have been expecting. Watch yourself.

**UPDATES:**

If you declare `button` as `lazy var` instead of `let`, then the expected behavior occurs. That is, `self` is an instance of `MyTableCell` within the self-executing anonymous closure and the call to `addTarget(_:, action:, for:)` works. (Thanks [@Geri_Borbas](https://twitter.com/Geri_Borbas/status/1341594268293586944).) Also noteworthy, in this situation the initializer for `MyTableCell` gets called **before** the `button` closure is executed. However, this makes the situation more confusing &mdash; using `let` versus `lazy var` produces significantly different behavior that is not intuitive at all.

The type `(MyTableCell) -> () -> MyTableCell` appears to refer to the initializer for `MyTableCell`. (Thanks [@eneko](https://twitter.com/eneko/status/1341605571984642048).)
