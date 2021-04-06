---
layout: post
categories: [software-dev]
tags: [swift, closures, compilers]
date: 2021-04-05T17:46:59-07:00
date-updated: 2021-04-06T12:46:29-07:00
title: Why Swift closures are not Equatable
---

Despite the fact that closures (and functions) [are reference types](https://docs.swift.org/swift-book/LanguageGuide/Closures.html#ID104) in Swift, they cannot be compared using `==` or `===`. But why?

<!--excerpt-->

I went down a rabbit hole today, because I thought I needed this (I did not). In other languages, like Objective-C, comparing function pointers is simple to do. In Swift, you will get an error. Attempting to compare two closures (or functions) with the same signature using `==` will produce the compiler error "Binary operator '==' cannot be applied". If you try to use `===`, the compiler will produce the error "Cannot check reference equality of functions".

Searching for why, I eventually found [this thread on the Apple Developer Forums](https://developer.apple.com/forums/thread/666060?answerId=645336022#645336022). Ironically, it links [to this StackOverflow thread](https://stackoverflow.com/questions/24111984/how-do-you-test-functions-and-closures-for-equality), which links to [this old Apple Dev Forums thread](https://devforums.apple.com/message/1035180#1035180), which, of course, is now a broken link since no one at Apple could be bothered to do web development properly when [the new forums launched](https://developer.apple.com/news/?id=obvo7r3i) last year.

**Update:** A reader has kindly pointed out that the broken link to Chris’s post was not lost _last year_, but rather in the _previous transition_ from private to public forums, which happened some years earlier. I have lost count of how many times the Apple Dev Forums have undergone changes. [This thread on the forums](https://developer.apple.com/forums/thread/653468?answerId=620033022#620033022) has details. It is, of course, answered by none other than the valuable, legendary [Quinn](https://github.com/macshome/The-Wisdom-of-Quinn).

Anyway. Apparently, somewhere in the ether of the old forums exists the following answer from [Chris Lattner](https://twitter.com/clattner_llvm). (Thankfully, the person on StackOverflow directly quoted the forum thread instead of just posting a link.)

> This is a feature we intentionally do not want to support. There are a variety of things that will cause pointer equality of functions (in the swift type system sense, which includes several kinds of closures) to fail or change depending on optimization. If "===" were defined on functions, the compiler would not be allowed to merge identical method bodies, share thunks, and perform certain capture optimizations in closures. Further, equality of this sort would be extremely surprising in some generics contexts, where you can get reabstraction thunks that adjust the actual signature of a function to the one the function type expects.

Not only can you not compare function pointers, if you could, you are asking for a world of trouble.

{% include break.html %}

Now, you _could_ dive into Swift's "unsafe" APIs, create an `UnsafePointer`, compare them, etc. But that is a very bad idea.&#8482; Even if you end up writing something that passes a unit test, it will probably not work with optimizations turned on &mdash; or worse, it will only sometimes work. Or, it will break in the future.

Like I said, it turned out that I _did not_ need to actually compare function pointers after all. There was a much better solution. You may think you need this. You (almost certainly) do not.
