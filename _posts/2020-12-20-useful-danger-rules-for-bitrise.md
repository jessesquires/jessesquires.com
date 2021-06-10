---
layout: post
categories: [software-dev]
tags: [ci, danger, bitrise]
date: 2020-12-20T20:28:41-08:00
title: Useful Danger rules for Bitrise
---

This is a quick follow-up to my [previous post]({% post_url 2020-12-15-running-multiple-dangers %}). The client project I'm working on is also using Bitrise for CI, which I must say is quite good. If you are looking for a hosted CI service I would highly recommend checking them out.

<!--excerpt-->

Anyway, if you are using Bitrise (and Danger), here are some convenient rules to add to your post-CI Danger run. These rules comment with the build number, a link to build logs, a link to Bitrise's "Test Reports" feature, and a link to the install page of the internal build that was created by your pull request.

```ruby
# Comment with build number
build_number = ENV['BITRISE_BUILD_NUMBER']
message("Build ##{build_number} completed.")

# Comment with link to build logs
build_url = ENV['BITRISE_BUILD_URL']
if build_url
    message("[Bitrise Build logs](#{build_url})")
end

# Comment with link to test reports
build_slug = ENV['BITRISE_BUILD_SLUG']
if build_slug
    message("[Bitrise Test Reports](https://addons-testing.bitrise.io/builds/#{build_slug}/summary)")
end

# Comment with link to public install page
public_install_page_url = ENV['BITRISE_PUBLIC_INSTALL_PAGE_URL']
if public_install_page_url
    message("[New app deployed to Bitrise](#{public_install_page_url})")
end
```

Altogether, this provides a nice summary for your pull request. It allows you to quickly find all of the various results for your build, and easily send a link to that build to product managers, QA testers, and designers who might wish to verify or test your changes. I've found this to be very convenient and helpful, especially on GitLab (also used by this client) which has a dramatically inferior web UI compared to GitHub.
