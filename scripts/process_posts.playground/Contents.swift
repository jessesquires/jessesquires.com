/*
 This playground is a 'scratch pad' for batch editing / manipulating posts.
 For example, adding a 'tags:' variable to the Front Matter.
 */

import Cocoa
import PlaygroundSupport

let fm = FileManager.default

// ~/Documents/Shared Playground Data/
let sharedDir = playgroundSharedDataDirectory
let postsDir = sharedDir.appendingPathComponent("_posts", isDirectory: true)
let processedDir = sharedDir.appendingPathComponent("processed", isDirectory: true)

let allPosts = try! fm.contentsOfDirectory(
    at: postsDir,
    includingPropertiesForKeys: nil,
    options: [.skipsHiddenFiles, .skipsPackageDescendants]).sorted()

func processRedirectsForNewURLs() {
    print("Running \(#function)")
    allPosts.forEach { eachFile in
        let fileName = eachFile.lastPathComponent
        let lengthOfDate = 10
        let date = fileName.dropLast(fileName.count - lengthOfDate).replacingOccurrences(of: "-", with: "/")
        let postURLName = fileName.dropFirst(lengthOfDate + 1).replacingOccurrences(of: ".md", with: "")

        print("Redirect 301 /\(postURLName) /blog/\(date)/\(postURLName)")
    }
}

func processNewFrontMatter() {
    print("Running \(#function)")
    allPosts.forEach { eachFile in
        let fileName = eachFile.lastPathComponent
        print("Processing \(fileName)...")

        let lengthOfDate = 10
        let date = fileName.dropLast(fileName.count - lengthOfDate)
        let contents = try! String(contentsOf: eachFile, encoding: .utf8)

        // adding `date:` front matter
        let newFrontMatterWithDate = "\ndate: \(date)T10:00:00-07:00\ntitle:"
        let modifiedContents = contents.replacingOccurrences(of: "\ntitle:", with: newFrontMatterWithDate)

        let processedURL = processedDir.appendingPathComponent(fileName, isDirectory: false)
        try! modifiedContents.write(to: processedURL, atomically: true, encoding: .utf8)

        print("Finished! \(fileName)\n")
    }
}

// Call functions here 👇

print("Completed.")
