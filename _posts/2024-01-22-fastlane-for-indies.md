---
layout: post
categories: [software-dev]
tags: [fastlane, automation, ios, macos, app-store, indie-dev, ruby]
date: 2024-01-22T10:57:55-08:00
title: A simple fastlane setup for solo indie developers
---

I recently setup [`fastlane`](https://fastlane.tools) for one of my indie apps, [Taxatio](https://www.hexedbits.com/taxatio/), to automate uploading builds and metadata to the App Store --- by far, one of the most tedious tasks of app development. While I had used `fastlane` extensively before when working on teams at companies, I had never actually set it up from scratch. In this post, I want to share how to do that, as well as a lightweight configuration that I think works well for solo indie developers --- folks on a team of one!

<!--excerpt-->

### Philosophy

My general philosophy when it comes to software development is _do the simplest thing first_. (Thanks to [Mike Krieger](https://www.fastcompany.com/3047642/do-the-simple-thing-first-the-engineering-behind-instagram) for that one.) The first step is to get something that works that is not complicated and not over-engineered. You can always make it complicated, incomprehensible, and over-engineer it later --- so why start now? &#x1F609;

In this particular situation with `fastlane`, this meant that I avoided setting it up for the initial 1.0 release. I knew I would likely run into issues with setup and configuration (_I did_) and I did not want to waste a bunch of time figuring out (somewhat unfamiliar) tooling when I could instead spend that time simply logging on to App Store Connect to manually input my metadata and upload screenshots.

After the initial release, I set out to get `fastlane` configured so that I would never have to do that manually again. And that's great, because App Store Connect is [not a very good website](https://lapcatsoftware.com/articles/crappstoreconnect3.html).

### No CI/CD service

Because I'm a team of one, I do not use any CI/CD service. If _a team_ (of at least a few people) told me they did not use a CI/CD service, I would scream and implement one on my first day. The benefits of using a CI/CD service with a team are clear. But there are good reasons _not_ to do this as a solo indie dev.

Initially, I was torn about this decision. After working on teams for years with robust CI/CD automation, I am convinced it is _the right way&trade;_ to do things. However, it simply does not make sense for a solo indie developer.

CI/CD services may not be _that_ expensive in terms of absolute value, depending on what you consider expensive. [GitHub Actions](https://github.com/features/actions) and [Bitrise](https://bitrise.io) both have free tiers, but they are pretty limited. You will likely out-grow these, especially if you are working on multiple projects. In the next tier, Bitrise charges $90/month, while GitHub charges $4/month for the first year (after which it is unclear what they charge). My experience with Bitrise in the past was great. They tend deploy timely updates for macOS and Xcode releases. GitHub on the other hand is an exercise in frustration --- their current default runners are using macOS 12, machines with macOS 13 _are still in beta_, and there is no mention of macOS 14, the latest release since last fall.

In order to determine if the cost of these services is worth it, you have to ask yourself what value do they provide? They will run your tests every time you push new commits or open a pull request, build your app, and upload your app to App Store Connect (either via their own infrastructure, or by running `fastlane`). But... couldn't I just do all of that myself? Running my unit tests locally is not a problem --- my projects are not massive like at big companies, so my test suites finish in a few minutes or less. Invoking `fastlane` locally is also fast and easy. I don't need some random machines on the internet to do this for me, especially not for $1,000 per year (with Bitrise).

More importantly, CI/CD services are a _maintenance burden_ --- a trade-off that does not make sense for a team of one. Even though I had a good experiences with Bitrise working on teams, it still broke occasionally. Updating a configuration would inadvertently break something, or communicating with App Store Connect would break (not Bitrise's fault), or codesigning and provisioning profiles would break, or our tests would be reported as passing even though a minor configuration change actually prevented them from running at all. On GitHub actions, you're dealing with constantly being multiple versions behind.

So, is a CI/CD service worth the _financial_ cost as well as the _maintenance_ cost? For me, the answer is a clear _no_. The cost-benefit ratio simply does not add up. I do not want to spend time maintaining a service that only I use, when I could be using that time to work on features and fix bugs. No longer do I have to suffer through _"it works on my machine, but **not** on CI"_ scenarios.

Rather than _complete automation_, which is what CI/CD services offer, I have opted for _human-initiated automation_. I run my tests locally during development. When ready to submit to the App Store, I simply run `fastlane`. I find this to be the best way to maximize the benefits of automation, while minimizing maintenance costs and financial costs.

### Initial setup for fastlane

While [`fastlane`](https://github.com/fastlane/fastlane) does seem to be actively maintained, my impression is that much of it feels like it is languishing in maintenance mode. The documentation feels quite dated, sometimes referencing Xcode 7 or 8. I also ran into a handful of tiny bugs and had to experiment with various parameters. But it does still work, so that's great!

For initial setup, [you can follow the docs](https://docs.fastlane.tools/getting-started/ios/setup/) and follow the prompts.

```bash
fastlane init
```

You'll be prompted to authenticate to App Store Connect. For now, you can just authenticate with your Apple ID when prompted. You can switch to using an API Key after initial setup.

If you already have App Store Connect configured with your app metadata and screenshots, `fastlane` can download this for you. The initial setup will prompt to do this for you, but I ran into issues. I would suggest doing this manually, especially if your app runs on multiple platforms.

```bash
# download metadata for each platform
fastlane deliver download_metadata --platform osx --use_live_version true
fastlane deliver download_metadata --platform ios --use_live_version true

# download screenshots for each platform
fastlane deliver download_screenshots --platform osx --use_live_version true
fastlane deliver download_screenshots --platform ios --use_live_version true
```

You'll only need to do this once to bootstrap your initial setup. Per the recommendations in the docs, I would git ignore the `fastlane/screenshots/` directory. These image files will be large, and they can easily be regenerated at any time.

### Notes on using bundler

The [docs](https://docs.fastlane.tools/getting-started/ios/setup/) encourage you to use [Bundler](https://bundler.io) with `fastlane`. I agree that this is important for teams and CI/CD setups to ensure everyone (and _everywhere_) is using the exact same versions of everything. However, as a solo indie dev working on only my own machine, I find this to be overkill --- especially for a single gem. I simply install `fastlane` and invoke it directly. Then I don't need to check-in a `Gemfile` and `Gemfile.lock` into git.

### Authentication

[Setting up an API Key](https://docs.fastlane.tools/app-store-connect-api/) is the easiest method of authentication with App Store Connect, especially when working on multiple apps. You will not be constantly prompted for your Apple ID credentials and you won't be bothered by 2-factor auth. I found that [using a `fastlane` API Key JSON file](https://docs.fastlane.tools/app-store-connect-api/) was the simplest approach for me. I save this on my machine at `~/Developer/AppStoreConnect/api_key.json`.

```json
{
  "key_id": "XXXXXXXXXX",
  "issuer_id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "key": "-----BEGIN PRIVATE KEY-----\nXXXXXXXXXX\n-----END PRIVATE KEY-----"
}
```

Again, not having to configure all of this on a CI machine is a joy. I don't have to worry about accidentally leaking secrets because I misconfigured something. I also don't have to worry about data breaches on a CI service.

### Codesigning

When working on a team, using Xcode's "automatic codesigning" feature is usually a nightmare. This is why [`fastlane` has its own entire infrastructure for this](http://docs.fastlane.tools/codesigning/getting-started/). It is even more complicated and burdensome and tedious to get everything working on a CI/CD service, not to mention for everyone on a team. But, lucky for me, none of that applies to solo indie development!

When working alone, Xcode's automatic codesigning works fine. You can configure `fastlane` accordingly. Even better, you do not have to waste your time trying to get all of this working on a CI/CD service!

I initially had some trouble getting `fastlane` to work with automatic codesigning. First, you need to configure your Xcode project to use automatic codesigning for all relevant targets. Second, when building via `fastlane`, you need to pass `-allowProvisioningUpdates` to the `export_xcargs` parameter. See the configuration files below.

### Minimal configuration

Here's the minimal configuration you'll need for building and uploading your app.

[`Appfile`](https://docs.fastlane.tools/advanced/Appfile):

```ruby
app_identifier("com.example.MyApp")
apple_id("email@example.com")
itc_team_id("123456")
team_id("XXXXXXXXX")

# set other parameters as needed
```

[`Deliverfile`](https://docs.fastlane.tools/actions/deliver):

```ruby
api_key_path("/PATH/TO/YOUR/api_key.json")

# set other parameters as needed
```

[`Gymfile`](https://docs.fastlane.tools/actions/gym):

```ruby
output_directory("./build") # relative to your project

# Enable automatic code signing and provisioning
export_xcargs("-allowProvisioningUpdates")
```

### Screenshots

The App Store [screenshot requirements are unpleasant to deal with]({% post_url 2024-01-16-app-store-screenshot-requirements %}). Luckily, [`fastlane snapshot`](https://docs.fastlane.tools/getting-started/ios/screenshots/) can help with this for iOS. Unfortunately, it simply does not work for macOS. (See [#11092](https://github.com/fastlane/fastlane/issues/11092), [#11092-comment-349012721](https://github.com/fastlane/fastlane/issues/11092#issuecomment-349012721), [#11092-comment-349273411](https://github.com/fastlane/fastlane/issues/11092#issuecomment-349273411), [#19864](https://github.com/fastlane/fastlane/pull/19864)) The good news though is that you _can_ use fastlane to _upload_ your macOS screenshots to App Store Connect.

For iOS, you can configure a [`Snapfile`](http://docs.fastlane.tools/actions/snapshot/#snapfile) with all the parameters you need.

Here's my lane for generating iOS screenshots. Because `fastlane` makes it trivial, I generate screenshots for all devices. Although, I really [wish this weren't necessary]({% post_url 2024-01-16-app-store-screenshot-requirements %}).

```ruby
screenshots_path_ios = "./fastlane/screenshots/ios"

platform :ios do
  desc "Capture iOS screenshots"
  lane :screenshots do
    capture_screenshots(
      scheme: "SnapshotTests-iOS",
      output_directory: screenshots_path_ios,
      concurrent_simulators: true,
      devices: [
        "iPhone 15 Pro Max",
        "iPhone 14 Plus",
        "iPhone 15 Pro",
        "iPhone 14",
        "iPhone SE 3",
        "iPad Pro (12.9-inch) (6th generation)",
        "iPad Pro (12.9-inch) (2nd generation)",
        "iPad Pro (11-inch) (4th generation)",
        "iPad (9th generation)",
        "iPad mini (5th generation)"
      ]
    )
  end
end
```

### Putting it all together

With all of this configuration complete, you can now write your [`Fastfile`](http://docs.fastlane.tools/advanced/Fastfile).

Below is my `Fastfile` for [Taxatio](https://www.hexedbits.com/taxatio/), which runs on iOS and macOS. Like I mentioned, `fastlane` does not work for _generating_ macOS screenshots, but it does work for _uploading_ them. All you need to do is place your screenshots in `fastlane/screenshots/` for `fastlane` to find them.

```ruby
screenshots_path_ios = "./fastlane/screenshots/ios"
screenshots_path_macos = "./fastlane/screenshots/macos"

platform :ios do
  desc "Upload iOS app, metadata, and screenshots to the App Store"
  lane :appstore_upload do
    run_tests(scheme: "Taxatio-iOS")

    build_app(
      scheme: "Taxatio-iOS",
      output_name: "Taxatio-iOS"
    )

    upload_to_app_store(
      screenshots_path: screenshots_path_ios
    )
  end
end

platform :mac do
  desc "Upload macOS app, metadata, and screenshots to the App Store"
  lane :appstore_upload do
    run_tests(scheme: "Taxatio-macOS")

    build_app(
      scheme: "Taxatio-macOS",
      output_name: "Taxatio-macOS"
    )

    upload_to_app_store(
      screenshots_path: screenshots_path_macos
    )
  end
end
```

When ready to submit, I run the following commands:

```ruby
fastlane ios appstore_upload
fastlane mac appstore_upload
```

**Important Notes:**

- `fastlane` seems to get confused with screenshots for multiple platforms. If you provide explicit, distinct directories for each platform's screenshots like I have above, then everything works. To me, this is also a nicer method of organization. The `upload_to_app_store` action uses the API Key defined in the `Deliverfile`, so all you need to do is provide the `screenshots_path`.

- Even though I run tests frequently during development, I have `fastlane` run all unit tests first as a sanity check --- just in case I forget to run them.

- For building the app, I only need to provide the scheme because I'm using automatic codesigning and my `Gymfile` passes `-allowProvisioningUpdates`. I also provide unique names for the output binaries to differentiate between platforms.

### Complete workflow

With all of this in place, my overall workflow is the following:

1. I keep all of my projects in private repos on GitHub.
1. I write code, build, run, and test locally via Xcode.
1. When ready to release, I'll generate new screenshots if needed.
    1. For iOS: `fastlane ios screenshots`
    1. For macOS: there are a few options. I'll write about this in another post. Once I have my Mac app screenshots ready, I put them in `fastlane/screenshots/macos/`.
1. When ready to upload to App Store Connect, I run `fastlane [ios,macOS] appstore_upload`.
1. I login to App Store Connect for a quick sanity check and submit manually.

I am very happy with this lightweight setup. I have automated the tedious and error-prone aspects of dealing with the App Store, without the hassle of maintaining a CI/CD service. Even better, now that I have found a solution that works, I can bring this over to other apps in the future beginning with the 1.0 release.
