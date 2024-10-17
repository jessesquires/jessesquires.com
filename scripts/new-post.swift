#!/usr/bin/swift

/// Generates a new post from a template.
/// Prompts user for category, title, draft status

import Foundation

func exitOnInvalidInput() -> Never {
    print("\n⚠️  Invalid selection. Oops.\n")
    exit(1)
}

enum Category: String {
    case dev = "software-dev"
    case essay = "essays"
    case readingNotes = "reading-notes"

    init(_ choice: String?) {
        let value = Int(choice ?? "0") ?? -1
        switch value {
        case 1: self = .dev
        case 2: self = .essay
        case 3: self = .readingNotes
        default:
            exitOnInvalidInput()
        }
    }
}

print("\n=== New Post ===\n")

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

print("Draft or Post? (d/p):", terminator: " ")
let draftOrPostChoice = (readLine() ?? "").lowercased()
if draftOrPostChoice != "d" && draftOrPostChoice != "p" {
    exitOnInvalidInput()
}
let isDraft = (draftOrPostChoice == "d")

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

{% raw %}
{% include post_image.html %}
{% endraw %}

> TODO: content

<!-- image example -->
{% raw %}
{% include blog_image.html
    file=TODO
    alt=TODO
    caption=null
    source_link=null
    half_width=false
%}
{% endraw %}

<!-- break example -->
{% include break.html %}

<!-- links example -->
{% raw %}
link to post: [post]({% post_url 2001-01-01-blog-post-title %})
link to page: [page]({% link page.md %})
{% endraw %}

"""

let postData = postTemplate.data(using: .utf8)

let dateOnly = ISO8601DateFormatter.string(
    from: Date(),
    timeZone: .current,
    formatOptions: [.withFullDate]
)

let dashedTitle = title.localizedLowercase.replacingOccurrences(of: " ", with: "-")

let filePath = "./\(isDraft ? "_drafts" : "_posts")/\(dateOnly)-\(dashedTitle).md"

print("\nCreating new \(isDraft ? "draft" : "post"): \(filePath)")

let result = FileManager.default.createFile(atPath: filePath, contents: postData, attributes: nil)
if !result {
    print("🚫  Error creating file \(filePath)")
    exit(1)
} else {
    print("Opening...")
    let proc1 = Process()
    proc1.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    proc1.arguments = ["nova", "."]

    let proc2 = Process()
    proc2.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    proc2.arguments = ["open", filePath]
    do {
        try proc1.run()
        proc1.waitUntilExit()

        try proc2.run()
        proc2.waitUntilExit()
        print("Done. 🎉\n")
    } catch {
        print("Error: \(error)\n")
    }
}
