---
layout: post
categories: [software-dev]
tags: [ios, macos, swift, foundation]
date: 2023-08-17T17:32:52+02:00
title: Swift URL absoluteString versus path
subtitle: null
---

Foundation's [`URL`](https://developer.apple.com/documentation/foundation/url) (née `NSURL`) is a nearly ubiquitous API on Apple platforms. One of its shortcomings is that it is heavily overloaded -- an instance of `URL` could represent a _web_ URL or a _file_ URL. While there are many similarities between accessing resources on a local disk or on a web server, I think there should be explicit types for each, say `WebURL` and `FileURL`.

<!--excerpt-->

What makes `URL` more confusing is how _other_ APIs often interchangeably use `String` and `URL` or provide multiple APIs with the same functionality where some use `URL` and others use `String`. The best example of this is [`FileManager`](https://developer.apple.com/documentation/foundation/filemanager), which can't seem to decide on one or the other. You can construct a `URL` from a single `String` or build a `URL` incrementally from multiple `String` values, and you can convert a `URL` back to a `String`. Also when working with networking APIs, it is common to move back and forth between `String` and `URL`.

Even after years of working with [Foundation](https://developer.apple.com/documentation/foundation) on Apple platforms, I make the same mistake using `URL` with files all the time. When you are working with networking code and you need a string representation of a URL, you need to call [`URL.absoluteString`](https://developer.apple.com/documentation/foundation/url/1779984-absolutestring). This is so common and it is always the first thing I reach for --- it even has "string" in the name! But when working with file URLs and `FileManager`, this is **not** what you want.

I was recently writing some code dealing with files using `FileManager` and, out of habit, I tried to pass `URL.absoluteString` to an API that needed a `String` file path. It took way too long for me to figure out the bug, because I am so used to seeing and using `absoluteString`. It was not an obvious error.

For file URLs, `URL.absoluteString` will produce:

```
file:///Users/jsq/Documents/file.txt
```

Note that the string includes the `file://` scheme. For file-based APIs that require a `String` file path, passing the value returned by `absoluteString` will fail.

However, [`URL.path`](https://developer.apple.com/documentation/foundation/url/1779812-path) will produce the full file path _without_ the `file://` scheme prefix.

```
/Users/jsq/Documents/file.txt
```

When working with _file_ URLs, the correct way to convert to a `String` value is to use `URL.path`. This is confusing, because `URL.path` for _web_ URLs means something very different. And this helps illustrate the problem with the overloaded behavior of `URL` --- many of the APIs behave differently depending on the type of `URL` you have. Even more confusing, some APIs do not make sense to include for both kinds of URLs. For example, `URL.host` and `URL.query` do not apply to file URLs.

Of course, [`URL.isFileURL`](https://developer.apple.com/documentation/foundation/url/1780396-isfileurl) exists to allow you to distinguish between the two if needed, but this further exposes the poor design of `URL` and emphasizes the need for two explicit types. Using `FileManager` would be much more intuitive if all of its APIs worked with a single `FileURL` type instead of mixing `String` and `URL`.
