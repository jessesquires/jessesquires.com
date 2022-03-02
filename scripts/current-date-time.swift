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

let updateNoticeText = """
{% include updated_notice.html
date="\(fullDateTime)"
message="
Update message goes here.
" %}
"""

print(fullDateTime)
print("")
print(updateNoticeText)
print("")

NSPasteboard.general.clearContents()
NSPasteboard.general.setString(
    "date-updated: \(fullDateTime)\n\n\(updateNoticeText)",
    forType: .string
)

print("Copied to clipboard!")
