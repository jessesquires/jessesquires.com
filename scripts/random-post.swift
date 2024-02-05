#!/usr/bin/env DYLD_FRAMEWORK_PATH=/System/Library/Frameworks /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift

/// NOTE: the above shebang is a workaround.
/// See: https://github.com/apple/swift/issues/68785
///      https://github.com/apple/swift/issues/68785#issuecomment-1904624571

import AppKit
import Foundation

let allPosts = try! FileManager.default.contentsOfDirectory(atPath: "./_posts/")
let post = allPosts.randomElement()!

print("\nRandom Post: \(post)")

let data = FileManager.default.contents(atPath: "./_posts/\(post)")!
let contents = String(data: data, encoding: .utf8)!
let lines = contents.split(separator: "\n")
let titleFrontMatter = lines.first(where: { $0.hasPrefix("title:") })!
let postTitle = titleFrontMatter.replacingOccurrences(of: "title: ", with: "")

let startIndex = post.startIndex
let endIndex = post.endIndex

let dateIndex = post.index(startIndex, offsetBy: 10)
let date = String(post[startIndex...dateIndex]).replacingOccurrences(of: "-", with: "/")

let titleIndex = post.index(dateIndex, offsetBy: 1)
let title = String(post[titleIndex..<endIndex]).replacingOccurrences(of: ".md", with: "")

let url = "https://www.jessesquires.com/blog/\(date)\(title)/"
print("URL: \(url)\n")

let tweet = """
From the archive:

\(postTitle)
\(url)
"""

print(tweet)
NSPasteboard.general.clearContents()
NSPasteboard.general.setString(tweet, forType: .string)
print("\nCopied to clipboard!")
print("✅ Done!")

print("\n‼️  ⚠️  Has this bug be resolved yet? https://github.com/apple/swift/issues/68785\n")
