---
layout: post
categories: [software-dev]
tags: [git, open-source]
date: 2017-08-08T10:00:00-07:00
title: Customizing git-log
subtitle: Creating a 'smartlog' alias in git
image:
    file: git-smartlog.jpg
    alt: git-smartlog
    caption: git-smartlog before and after
    source_link: null
    half_width: false
---

[Git](https://www.git-scm.com) is sometimes rough around the edges, but fortunately it's not too difficult to customize and make more user-friendly. The other day I spent some time experimenting with `git log` and crafting a new `git smartlog` alias.

<!--excerpt-->

As much as [Greg Heo](https://gregheo.com) would [like you to believe](https://twitter.com/gregheo/status/891819310808580096) that I miss using [Mercurial](https://www.mercurial-scm.org), I don't. 😉 I used `hg` for two years while working at Instagram/Facebook and was happy to return to `git` as my primary source control management tool. I prefer Git's model and workflow, but that's a discussion for another post. Anyway, there is one thing *I do miss* about `hg` &mdash; the [smartlog](https://www.mercurial-scm.org/wiki/SmartlogExtension) extension. You can find this an other Mercurial extensions by Facebook [here](https://bitbucket.org/facebook/hg-experimental).

> `hg smartlog` displays the graph of commits that are relevant to you, and highlights your current commit in purple.

I wanted this (or something similar) in Git. The closest thing out-of-the-box is `git log`, but it's rather unusable on its own. By default, it lists all commits with the full commit message, along with metadata like date and author. If you want the *full* history, this works. But rarely does one want this level of verbosity when needing to quickly check recent history or when trying find a specific commit. Give it a try. Run `git log` in one of your repos.

### Creating an alias

Creating [Git aliases](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases) (or shortcuts) is easy. For example, `git config --global alias.co checkout` sets `co` as an alias for `checkout`. After setting this, running `git co` is the same as the more verbose `git checkout`. Note that even with an alias set, both commands will still work.

### Customizing `git log`

As you can read in [the docs for git-log](https://www.git-scm.com/docs/git-log), there are **a ton** of options to pass to `log`, including an overwhelming amount of ["pretty format"](https://www.git-scm.com/docs/git-log#_pretty_formats) options. There's a more digestible, high-level overview in [section 2.3 of the Git book](https://git-scm.com/book/en/v2/Git-Basics-Viewing-the-Commit-History). After experimenting with these various options, here's what I came up with:

```bash
$ git log --graph --pretty=format:'commit: %C(bold red)%h%Creset %C(red)<%H>%Creset %C(bold magenta)%d %Creset%ndate: %C(bold yellow)%cd %Creset%C(yellow)%cr%Creset%nauthor: %C(bold blue)%an%Creset %C(blue)<%ae>%Creset%n%C(cyan)%s%n%Creset'
```

Obviously, it is impossible to type this every time you want to run `log`. So you can set an alias called "smartlog". You can also find a [gist here](https://gist.github.com/jessesquires/d0f3fc99be8208394a450ce86443ce7d).

```bash
$ git config --global alias.smartlog "log --graph --pretty=format:'commit: %C(bold red)%h%Creset %C(red)<%H>%Creset %C(bold magenta)%d %Creset%ndate: %C(bold yellow)%cd %Creset%C(yellow)%cr%Creset%nauthor: %C(bold blue)%an%Creset %C(blue)<%ae>%Creset%n%C(cyan)%s%n%Creset'"
```

Here's a comparison (using [IGListKit](https://github.com/Instagram/IGListKit/commits/master)) between the default `git log` (left) and this new `git smartlog` (right):

{% include post_image.html %}

The default log displays the commit hash, author, date, and *full* commit message. The result is barely seeing just two commits. By contrast, `smartlog` displays the 10 most recent commits. Let's breakdown what's happening how it corresponds to the options passed to `--pretty=format:`. The first line contains the abbreviated commit hash (`%h`) in bold, followed by the full commit hash (`%H`). If available, ref names (e.g. branches, tags, etc.) (`%d`) come after the commit. The second line displays the RFC2822 style date (`%cd`) followed by a relative date (e.g. "2 days ago") (`%cr`). Next is the author name (`%an`) and email (`%ae`). Finally, there's the commit subject (`%s`). Interspersed in `--pretty=format:` are color settings, for example `%C(red)` sets the color to red and `%Creset` resets to the default terminal color. And `%n` inserts a newline.

You've probably noticed that this doesn't exactly match the behavior of `hg smartlog`, which shows only **your** commits. You can fix that by specifying an author, `git smartlog --author='Jesse Squires'`. You can specify anyone on your team, which could also be useful. That command is rather long, so you can set another alias.

```bash
$ git config --global alias.me '!git smartlog --author=Jesse Squires'
# usage: git me
```

Notice that you can reference your previous alias (`smartlog`) within this one. You can use the same technique to abbreviate `smartlog` to `sl`. Yes, you can set aliases for your aliases.

```bash
$ git config --global alias.sl '!git smartlog'
# usage: git sl
```

### Other useful aliases for Git

Here are a few more aliases that I find useful. Some are simply "shortcuts" for existing commands (like `st` for `status`) while others provide more a user-friendly interface for somewhat obscure commands (like `uncommit`).

```bash
alias.co=checkout
alias.br=branch
alias.cm=commit
alias.st=status
alias.unstage=reset HEAD --
alias.uncommit=reset --soft HEAD^
alias.purge=clean -fd
alias.dif=diff
alias.pick=cherry-pick
```

Git aliases are pretty powerful and super useful to increase your productivity. Not to mention, they help smooth out Git's rough edges.
