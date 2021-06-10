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
print("")
print("""
{% include updated_notice.html
message="
Copy this. Text goes here.
" %}
""")
print("")

NSPasteboard.general.clearContents()
NSPasteboard.general.setString("date-updated: \(fullDateTime)", forType: .string)

print("Copied to clipboard!")
