---
layout: post
categories: [software-dev]
tags: [xcode, ios, macos, xcode-tips]
date: 2025-02-24T10:59:46-05:00
title: "Xcode Tip: spell checking"
image:
    file: xcode-spell-check.jpg
    alt: Xcode spell checking
    caption: Xcode spell checking
    source_link: null
    half_width: false
---

Did you know that Xcode can spell check your code and comments? Based on my experience working on large teams and large Xcode projects, this is a little-known feature. I routinely find spelling errors, not only in code comments but in symbol names. For the latter, this is particularly frustrating when a misspelled symbol is widely used because correcting that error --- a rename that affects a substantial portion of the codebase --- produces a large diff. Once you notice that your entire team has been passing around a _"databaesQuery"_ for six months, it will drive you insane until fixed.

<!--excerpt-->

On large teams, large diffs are difficult to get reviewed. But more importantly, the probability for merge conflicts is high. Nothing is worse than having to resolve conflicts dozens of times before you are able to merge. A large rename to correct a spelling error can end up being the same experience has trying to merge a significant refactor --- a multi-day effort. That's not ideal.

Lucky for us, it's possible to (help) prevent typos from ever getting merged in the first place. In Xcode, you can enable spelling from the Edit menu, _Edit > Format > Spelling and Grammar > Check Spelling While Typing_. Just like a typical word processor, Xcode will helpfully underline misspelled words. Even better, Xcode understands variable names and will correctly identify errors in _camelCase_, _snake_case_, and other common identifier formats. You can right-click to apply corrections. You can also add words to the dictionary via _Right Click > Learn Spelling_, which can be useful for domain-specific abbreviations or other non-dictionary terms that are _not_ actual spelling errors.

The only caveat here is that everyone on your team must manually apply spelling corrections. However, perhaps this could be solved with a linter rule or Xcode extension.

{% include post_image.html %}
