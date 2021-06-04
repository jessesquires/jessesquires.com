---
layout: post
categories: [software-dev]
tags: [xcode, sublime-text, editors, fonts, typefaces]
date: 2020-02-25T10:45:55-08:00
title: JetBrains Mono and disabling font ligatures
date-updated: 2020-03-23T17:30:19-07:00
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

{% include updated_notice.html
date="2020-02-26"
update_message="
There is [an open issue](https://github.com/JetBrains/JetBrainsMono/issues/19) on GitHub discussing providing a version without ligatures.
" %}

{% include updated_notice.html
update_message='
Good news! JetBrains has <a href="https://github.com/JetBrains/JetBrainsMono/releases/tag/v1.0.4">released a no ligature version (1.0.4)</a>. It is called <i>JetBrains Mono NL</i>.
' %}
