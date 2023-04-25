---
layout: post
categories: [software-dev]
tags: [ios, macos, uikit, appkit, textkit]
date: 2023-04-25T10:22:55-07:00
title: "How to prevent orphan words in text views on iOS and macOS"
---

When you display text in your app, you might come across situations where the text layout produces undesirable results under certain layout constraints. The text could wrap on smaller devices or be truncated in certain localizations. At this point, we are well-equipped with adaptive APIs to make our layouts work on all screen sizes --- for example, we have [Dynamic Type](https://developer.apple.com/documentation/uikit/uifont/scaling_fonts_automatically), [Auto Layout](https://developer.apple.com/documentation/uikit/view_layout), and [`UITraitCollection`](https://developer.apple.com/documentation/uikit/uitraitcollection).

<!--excerpt-->

However, some situations require fine tuning the formatting and layout of text using TextKit. Text layout APIs on Apple Platforms are provided by TextKit, which is available as part of [UIKit](https://developer.apple.com/documentation/uikit/textkit) and [AppKit](https://developer.apple.com/documentation/appkit/textkit). TextKit is what powers [`UITextView`](https://developer.apple.com/documentation/uikit/uitextview) and [`NSTextView`](https://developer.apple.com/documentation/appkit/nstextview).

One scenario where adaptivity APIs will not help is when you layout a body of text that results in an orphan word on the final line. Often, this simply looks bad. The text does not look balanced. Orphaned words are not aesthetically pleasing. This is especially true if you have only two lines of text, where the second line contains a single word. It is even worse if the text is center-aligned. How can we solve this issue?

Image our text view is laying out text like this:

```
TextKit manages text storage and performs layout of text-based content on iOS and
macOS.
```

The TextKit APIs we need to use are part of [`NSParagraphStyle`](https://developer.apple.com/documentation/uikit/nsparagraphstyle). The first API you might try to use is [`NSLineBreakMode`](https://developer.apple.com/documentation/uikit/nslinebreakmode) which has been available since iOS 6 and macOS 10. The `.lineBreakMode` of an `NSParagraphStyle` specifies what happens when a line is too long for a container. Your options are `.byWordWrapping`, `.byCharWrapping`, `.byClipping`, and more. However, none of these will address the issue of orphan words.

```swift
let textView = UITextView()
var text = AttributedString("TextKit manages text storage and performs layout of text-based content on iOS and macOS.")

// Does Not Work!
var paragraphStyle = NSMutableParagraphStyle()
paragraphStyle.lineBreakMode = .byWordWrapping

text.paragraphStyle = paragraphStyle
textView.attributedText = NSAttributedString(text)
```

The `NSParagraphStyle` API we need to use is the similarly named, but much newer [`LineBreakStrategy`](https://developer.apple.com/documentation/uikit/nsparagraphstyle/linebreakstrategy), which was added in iOS 14 and macOS 11. This property specifies how the text system breaks lines while laying out paragraphs. The option we want is [`.pushOut`](https://developer.apple.com/documentation/uikit/nsparagraphstyle/linebreakstrategy/3667460-pushout), which _"pushes out individual lines to avoid an orphan word on the last line of the paragraph."_

```swift
let textView = UITextView()
var text = AttributedString("TextKit manages text storage and performs layout of text-based content on iOS and macOS.")

// Fixed!
var paragraphStyle = NSMutableParagraphStyle()
paragraphStyle.lineBreakStrategy = .pushOut

text.paragraphStyle = paragraphStyle
textView.attributedText = NSAttributedString(text)
```

This will adjust the layout so that there are at least two words on the second line:

```
TextKit manages text storage and performs layout of text-based content on iOS
and macOS.
```
