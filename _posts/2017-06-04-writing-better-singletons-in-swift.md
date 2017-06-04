---
layout: post
title: Writing better singletons in Swift
subtitle: Avoiding common pitfalls
---

In a [previous post](/blog/refactoring-singletons-in-swift/) I discussed strategies for using singletons in a cleaner, more modular way. [Singletons](https://en.wikipedia.org/wiki/Singleton_pattern) are a fact of software development, especially in iOS. *Sometimes* the design pattern actually *is* the right tool for the job. In those situations, how we can improve the way we write our own singleton classes?

<!--excerpt-->

### The case for the singleton

Generally, I'm not enthusiastic about singletons. In most situations I consider them to be an [anti-pattern](https://en.wikipedia.org/wiki/Anti-pattern). However, there are certainly valid use cases. In the Cocoa and Cocoa Touch frameworks, there are quite a few singletons that we interact with regularly &mdash; `UIApplication.shared`, `FileManager.default`, `NotificationCenter.default`, `UserDefaults.standard`, `URLSession.shared`, and others. These singletons make sense. They manage a shared resource or manage access to a shared resource of which there is only one, or (*usually*) only should be one. If this is the conceptual model you are working with, then a singleton might be a decent solution.

The reason we dislike singletons is because they grow in scope and responsibility over time. They end up owning and managing way too much state, they collect random business or application logic, they accumulate a litany of static methods, and their pervasive, implicit use throughout a codebase entangles and demoralizes your object graph. (Addressing how to disentangle them was the subject of my [earlier post](/blog/refactoring-singletons-in-swift/).) In other words, all of the problems we face with singletons arise from abuse and negligence. With a few tweaks to how we approach writing singletons, we can dramatically improve or even avoid such situations.

### Extracting the 'singleton-ness'

A brief look at Cocoa and Cocoa Touch reveal a clue. Take a look at [`FileManager`](https://developer.apple.com/reference/foundation/filemanager) and [`URLSession`](https://developer.apple.com/reference/foundation/urlsession). Notice anything? Both have an `init()` method &mdash; you can initialize **non-singleton instances** of these classes. That is, you can **create an instance** of `FileManager` and `URLSession` rather than use the singleton (`.default` or `.shared`). This is perhaps the most important and powerful aspect of their design, yet it is often overlooked. (Rarely do we opt out of using these singletons, but there are scenarios where it may be appropriate.)

What this reveals is that "singleton-ness" is not hard-coded into the design of these classes. The essence of a singleton is not an intrinsic aspect of the class, but merely an option. You can allocate and initialize a regular instance of the class with no global state, use it and discard it later.

**This** is how we should write singletons &mdash; as regular classes with a single designated `init()` and a [single responsibility](https://en.wikipedia.org/wiki/Single_responsibility_principle). After writing and unit testing the class, *then* add a `.shared` class property for clients to use. Then you can either remove `init()`, make it `private`, or put this class in its own framework and make it `internal` to restrict access. Swift makes creating lightweight micro-libraries easy. Moving the class to its own framework will add an additional barrier to prevent adding unrelated functionality and state over time.

Create a singleton, **but only when there is no other solution**. And when you do, do it right:

1. Create a normal class with a single `init()` and single responsibility
2. Write unit tests
3. Put this class and tests in their own framework / micro-library
4. Add a `.shared` class property to "make it a singleton"
5. Either mark `init()` as `internal`, remove it altogether, or mark it as `private` to prevent clients from allocating an instance. (I would recommend `internal` so that `init()` is accessible within the test target of the framework, allowing you to maintain your test suite while ensuring clients can only access the singleton.)
