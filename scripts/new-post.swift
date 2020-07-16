#!/usr/bin/swift

import Foundation

enum Category: String {
    case dev = "software-dev"
    case essay = "essays"
    case readingNotes = "reading-notes"

    init(_ choice: String?) {
        let value = Int(choice ?? "0")!
        switch value {
        case 1: self = .dev
        case 2: self = .essay
        case 3: self = .readingNotes
        default:
            fatalError("Invalid category choice: \(value)")
        }
    }
}

print("=== New Post ===\n")

print("""
Category options:
    1. \(Category.dev)
    2. \(Category.essay)
    3. \(Category.readingNotes)
""")
print("Choice:", terminator: " ")
let choice = readLine()
let category = Category(choice)

print("Enter title:", terminator: " ")
let title = (readLine() ?? "untitled").trimmingCharacters(in: .whitespacesAndNewlines)

let fullDateTime = ISO8601DateFormatter.string(
    from: Date(),
    timeZone: .current,
    formatOptions: [.withFullDate, .withFullTime]
)

let postTemplate = """
---
layout: post
categories: [\(category.rawValue)]
tags: [TODO]
date: \(fullDateTime)
title: \(title)
subtitle: null
image:
    file: TODO
    alt: TODO
    caption: null
    source_link: null
    half_width: false
---

> TODO: excerpt

<!--excerpt-->

{% include post_image.html %}

> TODO: content

<!-- image example -->
{% include image.html
    file=TODO
    alt=TODO
    caption=null
    source_link=null
    half_width=false
%}

<!-- break example -->
{% include break.html %}

<!-- links example -->
{% raw %}
posts: [link]({{ site.url }}{% post_url 2000-01-01-my-blog-post-title %})
images: {{ site.url }}{{ site.img_url}}/path-to/image.png
{% endraw %}

"""

let postData = postTemplate.data(using: .utf8)

let dateOnly = ISO8601DateFormatter.string(
    from: Date(),
    timeZone: .current,
    formatOptions: [.withFullDate]
)

let dashedTitle = title.localizedLowercase.replacingOccurrences(of: " ", with: "-")

let filePath = "./_posts/\(dateOnly)-\(dashedTitle).md"

print("\nCreating file: \(filePath)")

let result = FileManager.default.createFile(atPath: filePath, contents: postData, attributes: nil)
if !result {
    print("🚫 Error creating file \(filePath)")
} else {
    print("Opening...")
    let proc = Process()
    proc.launchPath = "/usr/bin/env"
    proc.arguments = ["open", filePath]
    proc.launch()
    proc.waitUntilExit()
}

print("Done.")
