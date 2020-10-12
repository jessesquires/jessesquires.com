#!/usr/bin/swift

/// Prints the current timestamp, formatted for jekyll

import Foundation

let fullDateTime = ISO8601DateFormatter.string(
    from: Date(),
    timeZone: .current,
    formatOptions: [.withFullDate, .withFullTime]
)

print(fullDateTime)
