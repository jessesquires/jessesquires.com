---
layout: post
categories: [software-dev]
tags: [xcode, ios]
date: 2019-09-30T17:00:00-07:00
title: A script to automate overriding iOS simulator status bar values
date-updated: 2019-09-30T19:00:00-07:00
---

I recently [wrote about]({% post_url_absolute 2019-09-26-overriding-status-bar-settings-ios-simulator %}) overriding iOS simulator status bar display settings using `simctl status_bar`. In that post I provided some ways we can improve the tool, but I realized we can do even better.

<!--excerpt-->

[My previous solution]({% post_url_absolute 2019-09-26-overriding-status-bar-settings-ios-simulator %}), was to wrap `simctl status_bar` in a custom command to make it easier to use:

```bash
$ fix_status_bar "iPhone 11"
```

A noted improvement, but after some use I'm tired of having to specify the simulator name &mdash; especially when I need to fix the status bars on multiple simulators, or if a default simulator has a long name, like `"iPad Pro (12.9-inch) (3rd generation)"`. Luckily, everything we need to do this is already part of `xcrun simctl`.

Running `xcrun simctl list devices` will print a list of all simulators and their status. The output looks something like this:

```
-- iOS 12.0 --
    iPhone X (10939DAA-4FBA-489A-AAF3-555E224146B1) (Shutdown)
-- iOS 13.0 --
    iPhone 8 (A2F89D01-006F-4439-8F30-7EDB809E8E68) (Shutdown)
    iPhone Xs (9F75F237-564D-449C-8AB8-7D1C1380E214) (Booted)
    iPhone 11 (BFD3E2D2-86B3-477E-AEB2-2CC6CFA50A53) (Booted)
    iPhone 11 Pro Max (637F617E-F3A9-43AF-92DE-B11DF82C2586) (Shutdown)
    iPad Pro (12.9) (98D6FBA0-EDB8-4B8F-A8AD-64A6B000B448) (Shutdown)
-- tvOS 13.0 --
    Apple TV (395B73E3-EA43-480B-BD2E-636C9D223CC9) (Shutdown)
    Apple TV 4K (14E57D08-CE8B-4A1B-932C-594F8D6ED86A) (Shutdown)
-- watchOS 6.0 --
    Apple Watch Series 5 - 44mm (78017ABD-4500-4A22-BA15-EAEEF313E222) (Shutdown)
```

For each runtime, it prints the device name, identifier, and status ("Booted" or "Shutdown"). Another limitation of `simctl status_bar` that I failed to mention before is that you can only run it for simulators that are currently running. This list provides us with all the information we need to automatically fix the status bars for all open simulators.

Let's write a script in Swift to do this.

### Executing `xcrun` in Swift

The first step is to run `xcrun simctl list devices`, which we can do by creating an instance of `Process`. Then we can capture and parse the output.

```swift
extension Process {
    /// Creates a process to execute `xcrun`.
    ///
    /// - Parameter args: The arguments to pass to `xcrun`.
    func xcrun(_ args: String...) -> String {
        self.launchPath = "/usr/bin/xcrun"
        self.arguments = args

        let pipe = Pipe()
        self.standardOutput = pipe

        self.launch()
        self.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()

        guard let output = String(data: data, encoding: .utf8) else {
            return ""
        }
        return output
    }

    /// Executes `xcrun simctl list devices`
    func xcrun_list_devices() -> String {
        return self.xcrun("simctl", "list", "devices")
    }
}
```

### Parsing the devices list

{% include updated_notice.html
update_message="
There is an easier way to parse the device list. As [Marcelo Fabri](https://twitter.com/marcelofabri_/status/1178840949134200832) noted on Twitter, you can pass `-j` to `xcrun simctl list devices` to get a JSON representation of devices. I have updated [the script on GitHub](https://github.com/jessesquires/Nine41) to use this method instead. However, I'll leave the rest of this post as it was. The parsing of devices is just an implementation detail.
" %}

Next we need to parse the list of devices. There are 3 distinct pieces of information: name, identifier, and status. A device name could be *anything*, which means we cannot expect it to follow any specific format. In fact, in the example output above there are multiple variations. The most reliable way to retrieve each piece of information is to write a regular expression to match the device identifier.

```swift
/// == Example ==
/// input: "iPhone X (10939DAA-4FBA-489A-AAF3-555E224146B1) (Shutdown)"
/// match: "(10939DAA-4FBA-489A-AAF3-555E224146B1)"
let regex = try! NSRegularExpression(pattern: #"(\(([\w\-]{36})\))"#, options: [])
```

Once we know the location of the identifier in the string, we can easily extract the name, identifier, and status separately. Before we start parsing, we need to run the command, and split the output into an array of strings, where each element is one line of the output.

```swift
let devicesList = Process().xcrun_list_devices()
let devices = devicesList.split(separator: "\n").map { String($0) }
```

Then we can parse each line.

```swift
let count = line.count

let rangeOfMatch = regex.rangeOfFirstMatch(in: line, options: [], range: line.nsRange)

if rangeOfMatch.location != NSNotFound {
    let deviceName = line.dropLast(count - rangeOfMatch.location).byTrimmingWhiteSpace

    let deviceID = line
        .dropFirst(rangeOfMatch.lowerBound + 1) // + 1 to remove the "("
        .dropLast(count - rangeOfMatch.lowerBound - rangeOfMatch.length + 1) // +1 to remove the ")"
        .byTrimmingWhiteSpace

    let deviceStatus = line.dropFirst(rangeOfMatch.upperBound).byTrimmingWhiteSpace
}
```

Once we have that, we need to be able to run `simctl status_bar` with the overrides to apply to the status bars.

```swift
extension Process {
    /// Executes `xcrun simctl status_bar` on the specified device.
    ///
    /// - Parameter device: The device for which status bar values should be overridden.
    func xcrun_fix_status_bar(_ device: String) -> String {
        return self.xcrun(
            "simctl", "status_bar", device, "override",
            "--time", "9:41",
            "--dataNetwork", "wifi",
            "--wifiMode", "active",
            "--wifiBars", "3",
            "--cellularMode", "active",
            "--cellularBars", "4",
            "--batteryState", "charged",
            "--batteryLevel", "100"
        )
    }
}
```

For any device that is booted, we call `xcrun_fix_status_bar(:)` with the device identifier.

```swift
if deviceStatus.contains("Booted") {
    Process().xcrun_fix_status_bar(deviceID)
}
```

I've posted the full script on GitHub under [a new project called Nine41](https://github.com/jessesquires/Nine41). The following is an example run, which outputs the name of each simulator that was found and fixed.

```bash
$ ./nine41.swift
Fixing status bars...
✅ iPhone 8, A2F89D01-006F-4439-8F30-7EDB809E8E68
✅ iPhone Xs, 9F75F237-564D-449C-8AB8-7D1C1380E214
✅ iPhone 11, BFD3E2D2-86B3-477E-AEB2-2CC6CFA50A53
```

Like I mentioned in my previous post, you can create a custom command for this if you like:

```bash
function fix-status-bars() {
    Path/To/Your/Script/nine41.swift
}
```

Or, you could compile it and put the binary in your `PATH`. Enjoy!
