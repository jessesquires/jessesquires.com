---
layout: post
categories: [software-dev]
tags: [xcode, swift, macos, bugs, swift-scripting]
date: 2024-01-22T14:31:32-08:00
title: "Workaround: Swift scripts importing Cocoa frameworks broken on macOS 14"
---

On macOS 14 Sonoma there is a regression in Swift 5.9 which causes Swift scripts that import Cocoa frameworks to fail. This issue was first reported by [@rdj](https://github.com/rdj). I discovered it myself shortly after. There is a ticket open at [#68785](https://github.com/apple/swift/issues/68785) on the main Swift repo on GitHub to track the issue.

<!--excerpt-->

Considering the following Swift script:

```swift
#!/usr/bin/swift

import AppKit
import Foundation

NSPasteboard.general.clearContents()
NSPasteboard.general.setString("Hello, Swift!", forType: .string)

print("Hello, Swift!")
```

You can run directly from the command line:

```bash
$ ./hello.swift
Hello, Swift!
```

On macOS 13 and earlier, this works. Unfortunately, on macOS 14 it now fails with an error: _"JIT session error: Symbols not found"_.

```
JIT session error: Symbols not found: [ _OBJC_CLASS_$_NSPasteboard, _NSPasteboardTypeString ]
Failed to materialize symbols:

[...]
```

The [current workaround](https://github.com/apple/swift/issues/68785#issuecomment-1904624571) (also posted by [@rdj](https://github.com/rdj)) is to update the shebang, `#!/usr/bin/swift`, by replacing it with the following:

```bash
#!/usr/bin/env DYLD_FRAMEWORK_PATH=/System/Library/Frameworks /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift
```

**Note:** you must also have Xcode installed for this to work.

I've verified that this does indeed fix the problem!
