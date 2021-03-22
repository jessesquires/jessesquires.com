#!/usr/bin/swift

/// Prints the current timestamp, formatted for jekyll.
/// Copies it to the clipboard.

import AppKit
import Foundation

let fullDateTime = ISO8601DateFormatter.string(
    from: Date(),
    timeZone: .current,
    formatOptions: [.withFullDate, .withFullTime]
)

print(fullDateTime)

NSPasteboard.general.clearContents()
NSPasteboard.general.setString(fullDateTime, forType: .string)

print("Copied to clipboard!")
