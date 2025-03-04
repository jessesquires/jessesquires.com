---
layout: post
categories: [software-dev]
tags: [ai, politics, automation, code-review]
date: 2025-03-04T12:44:26-08:00
title: AI Code review is always wrong
---

I work on a team that has enabled an AI code review tool. And so far, I am unimpressed. Every single time, the code review comments the AI bot leaves on my pull requests are not just wrong, but laughably wrong. When its suggestions are not completely fucking incorrect, they make no sense at all.

<!--excerpt-->

For example, in Swift you can use [optional-chaining](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/optionalchaining/) or you can unwrap optionals.

```swift
struct Job {
    let title: String
}

struct Person {
    let name: String
    let job: Job?
}

let john = Person(name: "John", job: Job(title: "Programmer"))

// Non-optional: access directly
let name = john.name

// Optional-chaining: maybe nil
let jobTitle = john.job?.title

// Unwrapped optional
if let job = john.job {
    print(job.title)
} else {
    print("job is nil")
}
```

On one of my pull requests, the AI bot recently suggested: _"Consider using optional chaining to safely handle nil values. This prevents potential crashes if the value is nil while maintaining the same logical flow."_ This would be a good suggestion if you wrote code that force-unwrapped an optional.

```swift
// Force-unwrapped: will crash if nil
let jobTitle = john.job!.title
```

Not only were no values force-unwrapped in the code, but the property the bot mentioned was **_not_ optional**. The code in question contained two similarly named properties. One of them was optional, one of them was not. The optional property was being unwrapped correctly. The non-optional property was being accessed directly and thus --- by definition --- did not need to be unwrapped. The bot fundamentally misunderstood this entire concept.

But this is worse than being wrong, because the bot writes with so much conviction and assurance. If I were early in my career, perhaps an intern or a student still learning, I might be persuaded by its imitation intelligence and counterfeit confidence. LLMs are not "intelligent" --- they are statistical regurgitation machines whose core features are plagiarism and hallucinations, _at best_.

**These contextless, pretend code reviews are wasting my time.** What are we even doing in this industry? Isn't every corporation in Silicon Valley jam-packed with "the smartest people in the world"? Doesn't every corporation in Silicon Valley have "job offer rates more competitive than Stanford acceptance rates"? Why can't one of those people give me a goddamn code review?

Fad-driven development and anti-thought is our new gospel.
