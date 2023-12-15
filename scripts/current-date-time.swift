#!/usr/bin/swift

/// Prints the current timestamp, formatted for Jekyll.
/// Copies it and the update notice include to the clipboard.

import AppKit
import Foundation

let fullDateTime = ISO8601DateFormatter.string(
    from: Date(),
    timeZone: .current,
    formatOptions: [.withFullDate, .withFullTime]
)

let text = """

date-updated: \(fullDateTime)

{% include updated_notice.html
date="\(fullDateTime)"
message="
Update message goes here.
" %}

"""

print(text)

// NSPasteboard.general.clearContents()
// NSPasteboard.general.setString(text, forType: .string)
// print("Copied to clipboard!")
print("NOT copied to clipboard. Bug: https://github.com/apple/swift/issues/68785")
