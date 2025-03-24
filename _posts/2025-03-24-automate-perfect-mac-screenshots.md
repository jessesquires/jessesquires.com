---
layout: post
categories: [software-dev]
tags: [xcode, macos, mac-app-store, automation, screenshots, ui-testing]
date: 2025-03-24T11:21:37-04:00
title: How to automate perfect screenshots for the Mac App Store (and beyond)
image:
    file: mac-screenshot-retrobatch.jpg
    alt: Retrobatch workflow
    caption: Retrobatch workflow
    source_link: null
    half_width: false
---

Meeting the [requirements for screenshots]({% post_url 2024-01-16-app-store-screenshot-requirements %}) is a frustrating experience. On iOS, tooling like [SimulatorStatusMagic](https://github.com/shinydevelopment/SimulatorStatusMagic), [Nine41](https://github.com/jessesquires/nine41), and [fastlane snapshot](https://docs.fastlane.tools/actions/snapshot/) help make the process easier. However, on macOS there is much less support (and, sadly, demand) for automated tooling --- so you are kind of on your own to figure it out. I spent some time recently solving this process for myself. I want to share how I have managed to automate perfect screenshots for the Mac App Store.

<!--excerpt-->

### Screenshot composition

In a [previous post]({% post_url 2024-01-16-app-store-screenshot-requirements %}), I discussed how you have two basic "formats" or compositions for Mac app screenshots. The first is taking a screenshot of your app in fullscreen mode, capturing only the app window. The second is capturing your app running on a full Mac desktop where the app is not in fullscreen --- that is, capturing the entire desktop with your app window(s), the menu bar, dock, and desktop background photo.

Fullscreen Mac app screenshots are much simpler and easier. All you have to do is screenshot your app window and you're finished. My focus for this post (and my goal for my screenshots) is to capture full Mac desktop screenshots. Similar to iOS, I want a "perfect" menu bar with no extra icons and a clock showing [9:41 AM](https://github.com/jessesquires/nine41), and a nice desktop background photo.

### Current options for Mac app screenshots

Unfortunately, fastlane snapshot simply does not work for macOS. (See [#11092](https://github.com/fastlane/fastlane/issues/11092), [#11092-comment-349012721](https://github.com/fastlane/fastlane/issues/11092#issuecomment-349012721), [#11092-comment-349273411](https://github.com/fastlane/fastlane/issues/11092#issuecomment-349273411), [#19864](https://github.com/fastlane/fastlane/pull/19864)) You could probably get it working on your own, but the maintainers seem uninterested in dedicated long-term support for macOS. So I decided to look for alternatives.

Another possibility is to manually take screenshots of your Mac app and optionally bring those into Photoshop, Acorn, Gimp, or any other image editor for additional editing. This was my approach before, but I found it to be too tedious --- even when using some Photoshop templates to make it easier. I need something that can be fully (or mostly) automated.

### Automatic screenshots via Xcode

As of Xcode 9, [Xcode UITest](https://developer.apple.com/documentation/XCUIAutomation) allows you to [capture screenshots](https://developer.apple.com/documentation/xctest/xcuiscreenshot) during tests. This is the API that fastlane uses under-the-hood for iOS. Again, because fastlane is not an option for macOS, you can implement this yourself. Xcode makes this process rather simple and easy. Here's a helper method that saves a screenshot.

```swift
func saveScreenshot(name: String) {
    let app = XCUIApplication()
    let screenshot = app.windows["main-window"].screenshot()
    let attachment = XCTAttachment(
        uniformTypeIdentifier: "public.png",
        name: name,
        payload: screenshot.pngRepresentation,
        userInfo: nil
    )
    attachment.lifetime = .keepAlways
    self.add(attachment)
}

// usage
saveScreenshot(name: "screenshot-01")
```

You can write normal UI tests and take screenshots when desired. When the test suite completes, you can navigate to the test results window in Xcode, find the screenshots, and save them.

This solves the problem of automating generating the raw screenshots. Unfortunately, once you have these raw screenshots, you will need to do some post-processing. The screenshots from XCUITest have ugly artifacts in the window corners. They are not correctly cropped and clipped with a transparent background, like when you take a screenshot via the built-in functionality in macOS. See the image below for an example.

{% include blog_image.html
    file="mac-screenshot-process.jpg"
    alt="Screenshot images from Xcode and and macOS"
    caption="From left to right: raw output from Xcode UI Test, the same image after processing, the output from taking a screenshot in macOS."
    source_link=null
    half_width=false
%}

The fist image is what screenshotting via Xcode produces --- ugly corners that will display whatever is in the background when your app runs via the UI test suite. The second image is the result after manually processing the image to remove the artifacts. The final image is the output of taking a standard screenshot on macOS. As you can see, my processing is _not quite exact_, but it is close enough.

### Post-processing Xcode screenshots

You could use an image editor like Photoshop, Acorn, or Gimp to round off these corners, but that is quite tedious. I used to use Photoshop with a smart object that would do this. However, that's still quite manual. The best tool for this is [Retrobatch](https://flyingmeat.com/retrobatch/) from Gus Mueller --- and **it is incredible**. I love this app.

Using Retrobatch, I created a workflow to round the corners. Through trial and error, I arrived at a corner radius of 24 points. Again, not _quite_ exact (see screenshot above), but close enough for our purposes here. Windows in macOS also have a subtle 1-point border that have a hex color value of `#D9D9D9` in light mode and `#636363` in dark mode. Retrobatch can also take care of this.

This gives us screenshots of our app windows that are (mostly) equivalent to taking screenshots manually via macOS. First, we use Xcode UITests to get the raw screenshots, then we drop them into Retrobatch for this clean up task. Now we need to get our desktop background.

### Perfect menu bar and desktop background

To get a perfect Mac desktop background, I created a new account on my Mac to avoid having to change any of my own preferences. In the fresh account, I set the wallpaper, configured the menu bar, and set the time manually to 9:41 AM, and then took a screenshot. Here's an example using Finder as the active app. However, for each of my apps I will install them and make them active so their name displays in the menu bar.

{% include blog_image.html
    file="mac-screenshot-background.jpg"
    alt="Blank Mac desktop screenshot background"
    caption="Blank Mac desktop screenshot background"
    source_link=null
    half_width=false
%}

I use the amazing [Aqueux wallpapers by Hector Simpson](https://hector.me/aqueux) --- a wonderful throwback to Mac OS X Tiger. (Back when macOS was actually good.) Note you'll need to create these backgrounds in both light mode and dark mode if you provide screenshots in both modes for your app.

### The final product

Now we have all the pieces we need: the app window screenshots and the desktop background. Before, I was using a Photoshop template to assemble these. Again, that's too tedious. This is where Retrobatch _really shines_. Below is a screenshot of my entire Retrobatch workflow.

{% include post_image.html %}

Here is what's happening:

1. The raw screenshots from Xcode are read from the specified input folder.
1. The corners get rounded correctly.
1. It checks if the filename contains "dark". This is part of my file naming scheme. For screenshots in dark mode, I append "-dark". The workflow branches based on if the screenshots are in light mode or dark mode, but the steps are equivalent.
1. The 1-point border is added using the correct color based on light mode or dark mode.
1. A subtle drop shadow gets added, roughly equivalent to how macOS renders. Again through trial and error, I arrived at a `(0,-50)` offset, a 70-point blur radius, and 60% opacity.
1. Next is the overlay step. This overlays the app window screenshot over the desktop background and centers it. The light mode and dark mode branches of the workflow have their respective light and dark desktop backgrounds.
1. The metadata is deleted, to reduce file size and unnecessary data.
1. The final images get written to the specified output folder. These images are the full resolution of my 14-inch M3 MacBook Pro desktop. (I use these screenshots to embed in device frames for promotional images on my website.)
1. There is one final branch that resizes and crops all screenshots to `2880x1800 px` because of the
[archaic requirements]({% post_url 2024-01-16-app-store-screenshot-requirements %}) of App Store Connect. The Mac App Store does not accept screenshots using the default resolutions of modern M-series MacBooks.

And that's everything. There was some upfront effort to put all of this together, but now my workflow for generating Mac app screenshots is incredibly simple with minimal manual steps.

1. Run my Xcode UI test suite to generate the screenshots.
1. Extract the screenshots from the test results and save them to my Retrobatch input folder.
1. Run the Retrobatch workflow, which saves everything to the output folder.

Here's an example of the final product using my app, [Taxatio](https://hexedbits.com/taxatio/).

{% include blog_image.html
    file="mac-screenshot-finished.jpg"
    alt="Finished screenshot for Taxatio"
    caption="Finished screenshot for Taxatio"
    source_link=null
    half_width=false
%}
