#!/usr/bin/env DYLD_FRAMEWORK_PATH=/System/Library/Frameworks /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift

/// NOTE: the above shebang is a workaround.
/// See: https://github.com/apple/swift/issues/68785
///      https://github.com/apple/swift/issues/68785#issuecomment-1904624571

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

NSPasteboard.general.clearContents()
NSPasteboard.general.setString(text, forType: .string)
print("Copied to clipboard!")
print("✅ Done!")
print("\n‼️  ⚠️  Has this bug be resolved yet? https://github.com/apple/swift/issues/68785\n")
