---
layout: post
categories: [software-dev]
tags: [xcode, ios, macos]
date: 2020-07-07T20:16:16-07:00
title: Quickly switching between Xcodes
---

I try to have only one Xcode installed at a time for simplicity and tidiness. But such a setup is rare as we often must manage stable releases and beta versions simultaneously.

<!--excerpt-->

I know some folks often have _multiple stable_ versions of Xcode installed at any given time. Ain't nobody got time for that. I keep two Xcode installs **at most** &mdash; the latest stable release and the latest beta (if any). During and after WWDC, when we have a new major (beta) version of Xcode, I find I need to switch more frequently as the betas break in different ways or I otherwise need to use the latest stable release.

Using plain `xcode-select` is slow because you have to provide the path to the Xcode you want to select each time. I wrote a custom shell command to switch between Xcodes more quickly.

```zsh
# switch between release and beta xcodes
function xcswitch() {
    RELEASE="Xcode.app"
    BETA="Xcode-beta.app"

    CURRENT=$(xcode-select -p)
    NEXT=""

    if [[ "$CURRENT" =~ "$RELEASE" ]]
    then
        NEXT="$BETA"
    else
        NEXT="$RELEASE"
    fi

    sudo xcode-select -s "/Applications/$NEXT"
    echo "Switched to $NEXT"
}
```

It checks your current Xcode selection, then switches to the other one. This makes some assumptions, namely that you only ever have two Xcodes installed like me &mdash; `Xcode.app` and `Xcode-beta.app`. It also assumes they are installed in `/Applications`. This should work as-is for most folks, but you can tweak it for your needs.

If you find this useful, you can copy it to your `.bash_profile` or `.zprofile` and invoke it by calling `xcswitch`.
