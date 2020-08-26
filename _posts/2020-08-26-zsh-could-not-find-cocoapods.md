---
layout: post
categories: [software-dev]
tags: [cocoapods, zsh, ios, macos]
date: 2020-08-26T16:03:48-07:00
title: zsh could not find CocoaPods
---

Out of nowhere today, when I tried to run `pod install` on my machine, it could not be found. Uh... what?

<!--excerpt-->

```bash
zsh: command not found: pod
```

The only thing that changed recently was installing [the most recent supplemental update](https://www.macrumors.com/2020/08/12/apple-releases-macos-10-16-5-supplemental-update/). Otherwise, nothing with my configuration or environment has changed. Even more strange is that other Ruby gems seemed to work fine, like `jekyll`. Running `gem list` produced the expected output, and I even verified that the `pod` binary existed in `~/.gem/bin/` via Finder.

I use [`rbenv`](https://github.com/rbenv/rbenv) to manage Ruby versions (installed via `brew`). And my `.zprofile` contains the following:

```bash
export GEM_HOME="$HOME/.gem"
export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then
    eval "$(rbenv init -)";
fi
```

After searching around and finding terrible advice (see below) on Stack Overflow, I decided to add the following to my `.zprofile`:

```bash
export PATH="$HOME/.gem/bin/:$PATH"
```

This was the sanest solution I could think of, but I do not know if it is the "most correct". Now everything works as expected. But I honestly have no idea why this change was required *now*, and why it was not required *before*. (Or if I should do something else?) *\*shrugs\** Computers, I guess?

I am not a Ruby expert, so if I should be doing something differently, please let me know.

{% include break.html %}

The [bad advice on Stack Overflow](https://stackoverflow.com/questions/2119064/sudo-gem-install-or-gem-install-and-gem-locations) that I saw on numerous posts was to use `sudo`, which is considered [bad practice](https://github.com/calabash/calabash-ios/wiki/Best-Practice%3A--Never-install-gems-with-sudo) for various reasons. Another bad suggestion was [specifying the bindir](https://guides.rubygems.org/command-reference/#gem-install) to `/usr/local/bin` when installing the gem, which is not typically where you would want gems installed.

```bash
# yeah... do NOT do this
sudo gem install -n /usr/local/bin cocoapods
```
