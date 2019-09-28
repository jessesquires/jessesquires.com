/*
 This playground is a 'scratch pad' for batch editing / manipulating posts.
 For example, to add a 'tags:' variable to the Front Matter.
 */

import Cocoa
import PlaygroundSupport

extension URL: Comparable {
    public static func < (lhs: URL, rhs: URL) -> Bool {
        return lhs.absoluteString < rhs.absoluteString
    }
}

let fm = FileManager.default

// ~/Documents/Shared Playground Data/
let sharedDir = playgroundSharedDataDirectory

// ~/Documents/Shared Playground Data/posts/
let postsDir = sharedDir.appendingPathComponent("posts", isDirectory: true)
let processedDir = sharedDir.appendingPathComponent("processed", isDirectory: true)

let allPosts = try! fm.contentsOfDirectory(
    at: postsDir,
    includingPropertiesForKeys: nil,
    options: [.skipsHiddenFiles, .skipsPackageDescendants]).sorted()

allPosts.forEach { eachFile in
    let fileName = eachFile.lastPathComponent
    print("Processing \(fileName)...")

    let lengthOfDate = 10
    let date = fileName.dropLast(fileName.count - lengthOfDate)
    let postURLName = fileName.dropFirst(lengthOfDate + 1).replacingOccurrences(of: ".md", with: "")
    let contents = try! String(contentsOf: eachFile, encoding: .utf8)

    // adding `date:` front matter
    let newFrontMatterWithDate = "\ndate: \(date)T10:00:00-07:00\ntitle:"
    let modifiedContents = contents.replacingOccurrences(of: "\ntitle:", with: newFrontMatterWithDate)

    let processedURL = processedDir.appendingPathComponent(fileName, isDirectory: false)
    try! modifiedContents.write(to: processedURL, atomically: true, encoding: .utf8)

    print("Finished! \(fileName)\n")
}

print("Completed.")
