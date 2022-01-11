---
layout: post
categories: [software-dev]
tags: [macos, time-machine, macos-catalina]
date: 2020-01-10T12:26:27-08:00
title: Time Machine failing on macOS Catalina
image:
    file: time-machine-fail.png
    alt: "Time Machine backups failing"
    half_width: true
---

I was ready celebrate that my upgrade to macOS ~~Vista~~ Catalina was successful. Zero issues, zero data loss, only the expected barrage of [security](https://mjtsai.com/blog/2019/07/23/annoying-catalina-security-features/) [theater](https://mjtsai.com/blog/2019/10/16/catalina-vista/) dialogs. And then Time Machine backups started to fail.

<!--excerpt-->

{% include post_image.html %}

I have been using Time Machine with a Synology NAS to backup my mac for multiple macOS releases. I switched to this setup from an AirPort Time Capsule ([RIP](https://www.macrumors.com/2018/11/16/airport-extreme-time-capsule-removed-from-apple-online-store/)) years ago. I have never had any issues until now, and I have not changed any settings.

Before upgrading to Catalina, I followed Howard Oakley's [excellent recommendations](https://eclecticlight.co/2019/11/11/time-machine-and-backing-up-in-catalina/). I made one last backup on Mojave. I completely disabled Time Machine. I saved and archived my old Mojave backups. After upgrading to Catalina, I re-enabled Time Machine and started a fresh backup set. Everything worked for a few weeks.

Now, my backups have started failing. Sometimes it cannot find the disk, even when it is mounted in Finder. More recently, it says that my `.backupbundle` "could not be accessed (error 45)".

[This Apple Community forum post](https://discussions.apple.com/thread/2266364) from 2009 mentions "error 45" and users who replied said that Time Machine is not compatible with a NAS. That may have been true at the time, but it certainly is not true now. [This Apple Support document](https://support.apple.com/en-us/HT202784) from 2019 specifically mentions NAS support and links to the spec on [Time Machine over SMB](https://developer.apple.com/library/archive/releasenotes/NetworkingInternetWeb/Time_Machine_SMB_Spec/index.html). I know my NAS is compatible and it was working perfectly prior to Catalina.

So far, the only solution I have found is to disable Time Machine backups, remove the NAS as a backup disk, re-enable Time Machine, re-add the NAS as a backup, and select the option to keep the existing backups. After this backups will succeed for a few days, or maybe a week. Then they start failing again.
