#!/usr/bin/swift

/// Updates the date for a post
///
/// - Renames the file (in place) with current date
/// - Updates `date:` front matter with current date

import Foundation

if CommandLine.argc == 1 {
    print("\n⚠️  Invalid usage. Must pass path to post markdown file.\n")
    print("Example: \(CommandLine.arguments.first!) PATH_TO_POST.MD\n")
    exit(1)
}

let postToUpdate = URL(fileURLWithPath: CommandLine.arguments[1])
print("Updating date for: \(postToUpdate)\n")

let filePath = postToUpdate
let filename = postToUpdate.lastPathComponent
let containingDirectoryPath = postToUpdate.deletingLastPathComponent()

let dateOnlyText = ISO8601DateFormatter.string(
    from: Date(),
    timeZone: .current,
    formatOptions: [.withFullDate]
)

let fullDateTimeText = ISO8601DateFormatter.string(
    from: Date(),
    timeZone: .current,
    formatOptions: [.withFullDate, .withFullTime]
)
print("New date: \(fullDateTimeText)")

let start = filename.startIndex
let end = filename.index(filename.startIndex, offsetBy: 9)
let rangeOfDate = start...end
let newFileName = filename.replacingCharacters(in: rangeOfDate, with: dateOnlyText)
let newFilePath = containingDirectoryPath.appendingPathComponent(newFileName)
print("Moving to: \(newFilePath)")

do {
    try FileManager.default.moveItem(at: filePath, to: newFilePath)

    let fileContents = try String(contentsOf: newFilePath, encoding: .utf8)

    let lines = fileContents.split(separator: "\n").map { String($0) }
    let dateLineIndex = lines.firstIndex { $0.hasPrefix("date:") }!
    let dateString = lines[Int(dateLineIndex)]

    let newDateString = "date: \(fullDateTimeText)"
    let modifiedContents = fileContents.replacingOccurrences(of: dateString, with: newDateString)
    try modifiedContents.write(to: newFilePath, atomically: true, encoding: .utf8)
} catch {
    print("🚫  Error: \(error)")
    exit(1)
}

print("Done. 🎉\n")
