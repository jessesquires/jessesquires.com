---
layout: post
categories: [software-dev]
tags: [fastlane, ci, release-process, xcode, ios, xcconfig, bitrise]
date: 2022-03-28T16:33:56-07:00
title: Using fastlane to increment version numbers in xcconfig files
---

If you are using [fastlane](https://docs.fastlane.tools) to automate your release process, you might be using the [`increment_version_number`](https://docs.fastlane.tools/actions/increment_version_number/) and [`increment_build_number`](https://docs.fastlane.tools/actions/increment_build_number/) actions to bump your version and build numbers, respectively. However, if your Xcode project is configured to use [`xcconfig` files](https://nshipster.com/xcconfig/), then you are out of luck. Shockingly, fastlane does not seem to support projects that use `xcconfig` files and there is a surprising dearth of information online about how to make fastlane work with Xcode build configuration files.

<!--excerpt-->

To workaround this limitation, I wrote some custom lanes similar to [`increment_version_number`](https://docs.fastlane.tools/actions/increment_version_number/) that work with `xcconfig` files. Thankfully, [Sergii Ovcharenko](https://github.com/sovcharenko) wrote a fastlane plugin, [fastlane-plugin-xcconfig](https://github.com/sovcharenko/fastlane-plugin-xcconfig), that makes reading and writing key-value pairs to `xcconfig` files easy. After adding this plugin to your project, you can add the following lanes to your `Fastfile`.

```ruby
desc 'Increments major app version'
lane :version_bump_major do
    version_bump("major")
end

desc 'Increments minor app version'
lane :version_bump_minor do
    version_bump("minor")
end

desc 'Increments patch app version'
lane :version_bump_patch do
    version_bump("patch")
end

def version_bump(type)
    file_path = 'Path/To/Your/App.xcconfig'
    version_key = 'MARKETING_VERSION'
    current_version = get_xcconfig_value(
      path: file_path,
      name: version_key
    )
    puts "Current Version: #{current_version}"
    puts "Version Bump: #{type}"

    components = current_version.split('.')
    major = components[0].to_i
    minor = components[1].to_i
    patch = components[2].to_i

    if type == "major"
      major += 1
      minor = 0
      patch = 0
    elsif type == "minor"
      minor += 1
      patch = 0
    elsif type == "patch"
      patch += 1
    else
      abort("Unknown version bump type: #{type}\nValid options: major, minor, patch.")
    end

    new_version = [major, minor, patch].join('.')
    puts "New Version: #{new_version}"

    update_xcconfig_value(
      path: file_path,
      name: version_key,
      value: new_version
    )
end
```

You can incorporate the code above into your existing lanes or workflows, or you can invoke the lanes directly. As an example, consider a current version number of `1.31.2`. These lanes will produce the following results.

```bash
[bundle exec] fastlane version_bump_major
# => 2.0.0

[bundle exec] fastlane version_bump_minor
# => 1.32.0

[bundle exec] fastlane version_bump_patch
# => 1.31.3
```

For the project I'm working on, we use our CI service (Bitrise) to set the build number for our app. (That is, we set it to `BITRISE_BUILD_NUMBER`.) However, if you would like to use fastlane for build numbers as well, you can write something very similar to the above but modify the value for `CURRENT_PROJECT_VERSION` instead. I'll leave that as an exercise for the reader.
