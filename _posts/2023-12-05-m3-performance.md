---
layout: post
categories: [software-dev]
tags: [apple-silicon, m3, xcode]
date: 2023-12-05T10:52:20-08:00
title: M3 Max Performance
---

After [setting up my new M3 MacBook Pro]({% post_url 2023-12-04-new-m3-mbp %}), I decided to do some quick performance comparisons with my old Intel machine. Anecdotally, I would have told you that it is insanely faster but seeing the data made my jaw drop.

<!--excerpt-->

First, here are the specs for the two machines:

- 2020 13" MacBook Pro, Intel 2.3 Ghz Quad-Core i7, 32GB RAM
- 2023 14" MacBook Pro, M3 Max (16‑core CPU, 40‑core GPU), 128GB memory

Do I really _need_ an M3 Max? Probably not, but I waited until the _third generation_ of M-series chips to upgrade, I wanted to make it count, and I want to keep this machine for years to come. Also, as [an indie dev]({% post_url 2023-04-10-going-indie %}) I get to write this off on my taxes as a business expense. :)

### Xcode Performance

Before erasing and resetting my old laptop, I wanted to see how Xcode performance compared between the Intel and the M3. I did not do an incredibly "scientific" comparison between these two machines, but more of a real world experiment. For example, I did not quit every single running application, etc. However, I was not actively using either machine during the test. I used Migration Assistant to setup the new M3 MacBook from the old Intel MacBook, so they were at least configured as similarly as possible.

I built and ran the same Xcode project on both. The project is massive, with over 100 monthly committers according to GitHub stats. It's an iOS app that has started to remind me of what it used to be like working on the Instagram iOS app. If you've ever worked on one of these extremely large apps, you know that Xcode _is painfully slow_ --- which is why these big companies implement alternative build systems like Buck and Bazel. This project contains around 1.5 million lines of code, including third-party dependencies --- based on a naive run of `wc -l`. It is Objective-C and Swift, but mostly Swift. The majority of Objective-C code comes from third-party dependencies.

Below are the results for various tasks. I have listed the build times as reported by Xcode's build logs in the sidebar.

A clean build of the project in Xcode:

- M3 Max: `2m 23s`
- Intel i7: `11m 32s`

That's about a 5.5x speed up! And, of course, the fans on the Intel were going full speed the entire time. The fans on the M3 turned on briefly and quietly for maybe 30-60 seconds, which I almost didn't notice because the fans on the Intel were so damn loud.

Next, I tried running an incremental build:

- M3 Max: `20s`
- Intel i7: `66s`

And finally, I did a build-and-run, measuring a cold launch of the iOS simulator:

- M3 Max: `51s`
- Intel i7: `2m 31s`

The performance improvement is simply unbelievable. Using this new M3 machine is an insanely different experience. The impact on my development workflow is **dramatic** and, honestly, unthinkable. I have never experienced such a profound hardware upgrade. My iteration cycles in Xcode are almost instant now. Previously, I dreaded having to do a clean build on the Intel machine --- nearly 12 minutes is enough time to do all sorts of other things! Now, a clean build is simply no issue. And for smaller projects, every action in Xcode feels nearly instantaneous on the M3.

### Other notes

Battery life is incredible. Even when using Xcode, the battery life is impressive. On the Intel machine, the battery would be nearly drained after only 1-2 hours of using Xcode. On the M3 machine, I've been able to go entire work days on a single charge.

I did not measure generally daily usage and tasks, but I can say with confidence that the M3 simply outperforms the Intel by orders of magnitude in every way imaginable. Everything is faster. Typically slow-to-launch apps like Photoshop launch almost instantly. Simply opening large Xcode projects on the Intel machine was usually a chore, but for the M3 it is effortless.

When using Xcode for large projects like the one I described above, my Intel machine would _crawl_ --- sometimes it would get so bogged down that it was almost unusable, preventing me from doing anything else. With the M3, I don't even notice that Xcode is running when I switch to other tasks in other applications. My Intel machine would often beach-ball on just a normal day with normal tasks. I have yet to see a loading spinner on this new M3.

I am very happy I finally upgraded to Apple Silicon. If, like me, you have been waiting "for the right moment" to upgrade from an Intel machine, now is the time.
