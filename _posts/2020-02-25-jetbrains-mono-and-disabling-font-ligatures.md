---
layout: post
categories: [software-dev]
tags: [xcode, sublime-text, editors, fonts, typefaces]
date: 2020-02-25T10:45:55-08:00
title: JetBrains Mono and disabling font ligatures
---

JetBrains recently released [a new typeface for developers](https://www.jetbrains.com/lp/mono/) and I wanted to give it a try. I switched to JetBrains Mono in my two primary editors, Xcode and [Sublime Text](https://www.sublimetext.com). Much to my surprise, I really enjoyed it.  I think it is a great typeface. But I quickly discovered that I hate ligatures.

<!--excerpt-->

There was no way (that I could find) to select JetBrains Mono in Xcode and disable ligatures. If anyone knows how to do that, please let me know. For now, I will stick with SF Mono in Xcode.

In Sublime Text, you can add the following options to your preferences file to disable ligatures.

```json
"font_face": "JetBrains Mono",
"font_options": ["no_liga", "no_clig", "no_calt"],
```

And now your eyes can rest. If you prefer ligatures, don't @ me.

**Update:** There is [an open issue](https://github.com/JetBrains/JetBrainsMono/issues/19) on GitHub discussing providing a version without ligatures.
