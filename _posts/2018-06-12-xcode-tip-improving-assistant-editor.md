---
layout: post
title: ! 'Xcode tip: Improving the assistant editor'
image:
    file: xcode-assistant-editor.png
    alt: Xcode navigation settings
    caption: Xcode Navigation settings
    half_width: false
---

I recently discovered a preference in Xcode's Navigation settings that makes the 'Assistant Editor' much more useful, especially when writing Swift.

<!--excerpt-->

{% include post_image.html %}

You can open the 'Assistant Editor' in Xcode by clicking the button with two circles in the top right, or via View > Assistant Editor > Show Assistant Editor. This brings up a second pane on the right with another file. In Objective-C, the behavior defaults to displaying your pair of `.h` and `.m` files, though sometimes this isn't the case.

In general, I find the behavior of the editor confusing and frustrating. Sometimes it gets stuck in "manual mode", or it changes on its own. In Swift it usually defaults to showing you the generated interface for the types in the file opened on the left, which usually isn't what you want because it's not very useful.

By default, when you 'Quick Open' a file via `cmd-shift-O`, it opens in the 'Primary Editor' on the **left** &mdash; even if the **right** editor pane is currently focused. Annoying. All I want to do is open two files side-by-side, switch between them easily, and have 'Quick Open' target whichever side is currently focused.

All these issues are remedied by selecting "Uses Focused Editor" from Xcode's Navigation preferences. This setting combined with using the "Move Focus To Editor..." shortcut (`cmd-J`) is perfect. You can quickly switch between editor panes or open new ones, and 'Quick Open' will open the file you select in whichever pane is currently focused.

{% include image.html
    file="xcode-cmd-j.png"
    alt="Xcode Move Focus To Editor..."
    caption="cmd-J: Move Focus To Editor..."
%}

To recap:

1. Set "Uses Focused Editor" in the Navigation preferences
2. `cmd-J` to switch between panes or open new ones
3. `cmd-shift-O` to open files in the currently focused pane

This is a much better dev experience.

**Update:** As a few readers [have noted](https://github.com/jessesquires/jessesquires.com/issues/79), if you `option-enter` when doing 'Quick Open', then the selected file will open in the 'Assistant Editor' immediately. Another good tip!
