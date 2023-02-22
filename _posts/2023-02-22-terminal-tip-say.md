---
layout: post
categories: [software-dev]
tags: [terminal, macos, ios, productivity, automation]
date: 2023-02-22T09:33:22-08:00
title: Make your terminal tell you when it's done
---

When working on large iOS apps, all the tasks you need to perform _before_ you even get started writing code can begin to consume a lot of time. I'm talking about all the preparation that happens in your terminal --- pulling the latest changes, bootstrapping the project, etc. During this wait, I usually take a moment to follow-up on emails or Slack messages. But the problem with that is I inevitably end up getting pulled deeper into those tasks and forget to return to the terminal, open Xcode, and start working.

<!--excerpt-->

Often pulling the latest changes from `main` in git and bootstrapping the project can take a lot of time for large iOS apps --- multiple minutes, or longer. Git can start to slowdown not only as the repo grows, but especially as your team grows. If dozens or hundreds of pull requests merge daily, then every `git pull` from `main` will download a ton of changes. Another common setup for large iOS projects is to automate all the various project bootstrapping tasks using a `Makefile`. Running `make` will run `bundle install` (for CocoaPods, Fastlane, etc.), run `pod install`, generate the Xcode project, and more.

I usually run `git pull && make` to do everything in one go. I don't like to sit there doing nothing and stare at my terminal, but if I start checking emails and Slack I'll get sidetracked then forget to stop and return to writing code. What I want is for terminal to notify me after all the tasks are complete. Then I can open Xcode and get started.

Good news --- there is an easy way to make terminal tell you when it's done with a little known (and very underrated, in my opinion) command, `say`. Running `say` invokes the speech synthesis manager on macOS to convert text to audible speech. Just run `say hello` in your terminal right now to try it out. Neat!

So how can you use this? Instead of running `git pull && make`, you can run `git pull && make && say done`. You can pass any text you want to `say` and you don't even need to wrap it in quotes. You could run `say time to work!` or `say xcode time, baby!`. And then, you'll know when it's time to close email and Slack and open up Xcode.

Because `say` is like any other command, you can incorporate it into any scripts as well. Also, `say` is a great tool for pranking your friends and coworkers who leave their laptops unlocked and unattended. I'll leave that as an exercise for the reader.
