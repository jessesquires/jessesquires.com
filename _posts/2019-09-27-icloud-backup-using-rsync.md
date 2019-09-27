---
layout: post
categories: [software-dev]
tags: [icloud, apple, ios, macos]
date: 2019-09-27 T10:00:00-07:00
title: Backing up your iCloud Drive files using rsync
---

Unfortunately, iCloud [does not have a good reputation](https://mjtsai.com/blog/2019/07/23/trusting-icloud-drive/) for being reliable, especially during [beta releases of iOS and macOS](https://mjtsai.com/blog/2019/07/11/icloud-data-loss-with-macos-10-15-and-ios-13-betas/). Yet a lot people still use it, often without any problems. *I still use it*, despite a few bad experiences in the past, because the best alternatives are [questionable](https://www.drop-dropbox.com) for [other reasons](https://www.theregister.co.uk/2016/05/26/dropbox_kernel_access/). I've had good luck with iCloud Drive for the past few years, but I am terrified and paranoid of getting caught in the middle of an [iCloud clusterfuck](https://furbo.org/2019/09/04/icloud-clusterfuck/), so I backup what I have in iCloud periodically using `rsync`.

<!--excerpt-->

#### Exploring iCloud Drive

The iCloud Drive folder on your Mac is tricky. [The files are not what they seem](https://www.youtube.com/watch?v=mbi7rq-TSk8&feature=youtu.be&t=110). iCloud Drive displays as a special directory in the sidebar of Finder. Its actual location on disk is at `~/Library/Mobile Documents/`. If you `cd` there and `ls`, you will see its entire contents, most of which is not viewable via Finder.

There appear to be three general types of directories present. After some digging around, I could not discern a difference between them. They have the following formats:

- Developer ID or "App ID Prefix" (I think?) followed by bundle identifier. Examples:
    - `8Z3V4F58RK~com~ustwo~monumentvalley/`
    - `F3LWYJ7GM7~com~apple~mobilegarageband/`
    - `F3LWYJ7GM7~com~apple~musicmemos~ideas/`
- Apple first-party apps with specific iCloud support, prefixed with `com~apple~`. These correspond to the "special" app-specific folders that you see in Finder's view of iCloud Drive. However, not all of these are present in Finder, like Notes and Mail. Examples:
    - `com~apple~Automator/`
    - `com~apple~Keynote/`
    - `com~apple~Preview/`
    - `com~apple~TextEdit/`
    - `com~apple~Notes/`
    - `com~apple~mail/`
- Bundle identifiers prefixed with `iCloud~com~`. Examples:
    - `iCloud~com~agilebits~onepassword-ios/`
    - `iCloud~com~apple~iBooks/`
    - `iCloud~com~ustwo~monumentvalley2/`
    - `iCloud~com~apple~mobilesafari/`

Aside from the `com~apple~`-prefixed directories, both first-party and third-party apps appear in both formats. My guess is that the difference is legacy vs modern naming conventions, especially considering [MomumentValley](https://apps.apple.com/us/app/monument-valley/id728293409) (2014) and [MonumentValley2](https://apps.apple.com/us/app/monument-valley-2/id1187265767) (2017).

#### Backing up your documents

Now that we sort of understand the layout of `~/Library/Mobile Documents/`, where the hell are **our** iCloud Drive documents stored? Those live in `com~apple~CloudDocs/`. If you `cd` there, you should see all of the "custom", non-app-specific files that you've stored in iCloud Drive. These should match what is viewable in Finder.

This is the directory that we want to backup. We can use `rsync` to do that. (Side note: the way that `rsync` handles paths is a bit odd. It doesn't like relative paths, or `~`, or escaping spaces in directory names. Thus, this script uses absolute paths with spaces.) You just need to fill-in the `USER` and `DEST` variables.

```bash
#!/bin/bash

USER="<user>"

DEST="<destination dir>"

SRC="/Users/$USER/Library/Mobile Documents/com~apple~CloudDocs/"

rsync --verbose --recursive --delete-before --whole-file --times --exclude=".DS_Store" --exclude=".Trash/" "$SRC" "$DEST"
```

Explanation of the options:

- `--verbose`: increase verbosity
- `--recursive`: recurse into directories
- `--delete-before`: receiver deletes before transfer
- `--whole-file`: copy files whole (without rsync algorithm)
- `--times`: transfer modification times along with the files and update them on the remote system
- `--exclude`: exclude files matching PATTERN

You can use the `--dry-run` option to preview what would be transfered without actually executing `rsync`.

This will backup **only your** iCloud Drive files. Any app-specific files (like Pages documents in `com~apple~Pages/`) will not be included. If you want to backup any of those files, you will need to write a similar script with those target directories as the source. If you want to backup *everything*, specify the root `~/Library/Mobile Documents/` directory &mdash; but beware, this might be *a lot* of data. For example, `iCloud~com~apple~iBooks/` contains *all* of your synced iBooks that were not purchased from the iBook Store. I have a lot of those.

That's it! You can read the `rsync` docs (`man rsync`) for more details and options, but this should get you started.
