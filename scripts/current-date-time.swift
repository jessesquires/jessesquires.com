#!/usr/bin/swift

/// Prints the current timestamp, formatted for jekyll.
/// Copies it to the clipboard.

import Foundation

let fullDateTime = ISO8601DateFormatter.string(
    from: Date(),
    timeZone: .current,
    formatOptions: [.withFullDate, .withFullTime]
)

print(fullDateTime)

print("Copying to clipboard...")

let pipe = Pipe()

let echo = Process()
echo.launchPath = "/usr/bin/env"
echo.arguments = ["echo", fullDateTime]
echo.standardOutput = pipe

let pbcopy = Process()
pbcopy.launchPath = "/usr/bin/env"
pbcopy.arguments = ["pbcopy"]
pbcopy.standardInput = pipe

echo.launch()
pbcopy.launch()
pbcopy.waitUntilExit()

print("Done!")
