---
layout: post
categories: [software-dev]
tags: [macos, bugs, mail, spotlight, onyx]
date: 2021-03-09T22:30:52-08:00
title: Fixing macOS Big Sur search bugs
subtitle: And maybe others
---

This post is mostly for posterity, for anyone currently experiencing these bugs on macOS, and to praise [Titanium Software's](https://titanium-software.fr/en/index.html) excellent Mac utility app [OnyX](https://titanium-software.fr/en/onyx.html).

<!--excerpt-->

[OnyX](https://titanium-software.fr/en/onyx.html) has been around for ages &mdash; since Mac OS X Jaguar 10.2! It is an indispensable utility and one of the first apps that I install on a new machine, or after a clean install of macOS.

> OnyX is a multifunction utility that you can use to verify the structure of the system files, to run miscellaneous maintenance and cleaning tasks, to configure parameters in the Finder, Dock, Safari, and some Apple applications, to delete caches, to remove certain problematic folders and files, to rebuild various databases and indexes, and more.
>
> OnyX is a reliable application which provides a clean interface to many tasks that would otherwise require complex commands to be typed using a command-line interface.

I always assumed it was a well-known app, but I'm not so sure anymore. In any case, I have used it to fix all sorts of issues over the years &mdash; just weird, inexplicable, random bugs. Two of my friends recently used OnyX to successfully fix bugs they were experiencing on macOS Big Sur, so I figured it's worth writing a brief post about.

#### Mail.app search not working

Search in the Mail.app on Big Sur stopped working for some users. In addition to the [workarounds mentioned here](https://piunikaweb.com/2020/12/28/apple-mail-search-function-in-macos-big-sur-not-working-for-some-users/), Ben used OnyX to [delete Mail's Mailboxes index](https://twitter.com/benasher44/status/1348084829787590656). After that, search in Mail.app started working for him again. 

I've occasionally had to use OnyX to rebuild the Mailboxes index for similar issues, like missing results.

#### Spotlight search not working

More recently, [Alexis tweeted about an issue with Spotlight Search](https://mobile.twitter.com/alexisgallagher/status/1368034513817718784) (and others replied with the same issue). Apparently, for some users, Spotlight was taking insanely long to search. For Alexis, it took almost 45 minutes to find a single file. I suggested using OnyX to rebuild the Spotlight index, [which fixed the issue](https://mobile.twitter.com/alexisgallagher/status/1368312327380996096) for him.

Similarly, I've experienced issues over the years with Spotlight returning garbage results &mdash; bizarre system files, files from git repos (random files from `.git/objects/`), or just not finding the correct files. Rebuilding the index with OnyX always resolved the issue.

#### Rebuilding and cleaning

OnyX can do quite a lot, especially in terms of rebuilding various indexes/databases and removing various system caches. You should use it with care, but the next time you run into an issue on macOS, it's worth taking a look to see if there's something OnyX can do that might help.
