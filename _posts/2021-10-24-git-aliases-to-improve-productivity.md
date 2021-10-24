---
layout: post
categories: [software-dev]
tags: [git, git-aliases]
date: 2021-10-24T11:10:05-07:00
title: Git aliases to improve productivity
---

Using [git aliases](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases) came up at work the other day. It's been awhile since [I've written about git]({% post_url 2017-08-08-customizing-git-log %}), so I thought it might be a good time to share all the aliases I've built up over the years.

<!--excerpt-->

### Creating git aliases

If you aren't familiar with [git aliases](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases), they are simply shortcuts or custom commands for git. I think it is pretty common for folks to write custom scripts for git to automate tedious tasks, and then store those scripts in their repo. A popular one is to delete old branches. The problem with this approach is that you then have to copy these scripts to every new repo you create. Aside from having to add extra files to your repo that are not related to your project, it is difficult to keep them up-to-date because they exist in so many places.

Another common approach is to add custom git scripts and aliases to your `~/.zprofile` or `~/.zshrc` (or `.bash_profile` and `.bashrc`). This is an improvement, but it is also undesirable as it will quickly clutter your `~/.zprofile` or `~/.zshrc` with a bunch of git-related aliases and commands.

Aliases let you extend git itself, exposing your custom commands everywhere you can invoke `git`.

Creating an alias is easy. The format is: `git config --global alias.NAME 'CONTENT'` where `NAME` is the name of the alias and `CONTENT` is the custom command. For example: `git config --global alias.co checkout`. This adds an alias named `co` that translates to `checkout`. After adding this, you can run `git co`, which will be the equivalent of `git checkout`. But aliases are not limited to simply shortening git's existing commands. Git aliases can be entire shell scripts. Aliases can even reference other aliases.

Note that creating an alias with the same name as an existing alias will overwrite the previous entry. You can remove an alias by running `git config --global --unset alias.NAME`.

### My git aliases

Below is a list of my current git aliases. That is, the output of `git config --global -l | grep alias` &mdash; for which I have created an alias, of course. I'll list each alias with a brief description of what it does and the command to add it your git config.

Some of these aliases are a bit complex. Rather than explaining each piece, I'll leave that as an exercise for the reader to figure out. I encourage you to experiment with these. Add them to your git config, run them, modify them as you see fit.

If you have any favorite aliases that are not listed here, [please let me know]({{ site.data.social.twitter }})!

{% include break.html %}

##### List all existing aliases, sorted alphabetically

```bash
# create
git config --global alias.aliases '!f() { git config --global -l | grep alias | sort; }; f'
# usage
git aliases
```

##### Common command shortcuts

These are all simple abbreviations of existing git commands. I find it much nicer to write `git st` than `git status`, for example.

```bash
# create
git config --global alias.st status
# usage
git st

# List of other shortcuts
alias.br=branch
alias.cm=commit
alias.co=checkout
alias.re=restore
alias.sw=switch
alias.dif=diff
alias.pus=push
alias.pu=push
alias.pick=cherry-pick
```

Note that some of these account for typos. After accidentally typing `git dif` or `git pus` too many times, I decided to make these resolve to `git diff` and `git push`. Much better than seeing `git: 'dif' is not a git command. See 'git --help'.`.

##### Amend the previous commit

```bash
# create
git config --global alias.amend 'commit --amend'
# usage
git amend
```

##### List authors and their total commit count, in order of number of commits

This will list all authors by unique email with their total number of commits. Admittedly, this does nothing for productivity, but don't act like you aren't curious about meaningless vanity metrics. Plus, this is excellent data for your annual performance review at BIG COMPANY.

```bash
# create
git config --global alias.authors-list 'shortlog -e -s -n'
# usage
git authors-list
```

A slight variation on the above: list all authors by unique name only. This is useful if some authors commit using multiple emails. This can happen, for example, when you modify files via GitHub's web UI or turn on the setting to hide your email, in which case it will appear as `USERNAME@users.noreply.github.com` instead of your real email. In this scenario, using `authors-list` above would have multiple entries for one person. Typically, author names are the same even when used with various emails, resulting in `authors-count` being more accurate. I also find it easier to read.

```bash
# create
git config --global alias.authors-count 'shortlog -s -n'
# usage
git authors-count
```

##### Create and checkout a new branch

```bash
# create
git config --global alias.cob 'checkout -b'
# usage
git cob my-new-feature
```

##### Smartlog

This produces a very pretty log, similar to `hg smartlog`, which [I wrote about in-depth here]({% post_url 2017-08-08-customizing-git-log %}). It display the commit hash, date, author, and title in a beautiful, easy to read format. This is probably my favorite and most-used alias.

```bash
# create
git config --global alias.smartlog "log --graph --pretty=format:'commit: %C(bold red)%h%Creset %C(red)<%H>%Creset %C(bold magenta)%d %Creset%ndate: %C(bold yellow)%cd %Creset%C(yellow)%cr%Creset%nauthor: %C(bold blue)%an%Creset %C(blue)<%ae>%Creset%n%C(cyan)%s%n%Creset'"
# usage
git smartlog
```

It will list all commits by default, or you can specify the `N` most recent.

```bash
git smartlog -3
```

This creates a shortcut for `smartlog`.

```bash
# create
git config --global alias.sl '!git smartlog'
# usage
git sl
git sl -2
```

This produces a modified `smartlog` filtered by the specified author. In this case, it will display all of my commits only. You'll want to use your name here, instead.

```bash
# create
git config --global alias.me "!git smartlog --author='Jesse Squires'"
# usage
git me
git me -5
```

##### Smartlog for one commit with the full commit message

This is similar to `smartlog`. It differs in that it will only display a single commit as well as the full commit message instead of only the title. By default it will display the last commit, otherwise you can provide a commit sha.

```bash
# create
git config --global alias.log-commit "log -1 --pretty=format:'commit: %C(bold red)%h%Creset %C(red)<%H>%Creset %C(bold magenta)%d %Creset%ndate: %C(bold yellow)%cd %Creset%C(yellow)%cr%Creset%nauthor: %C(bold blue)%an%Creset %C(blue)<%ae>%Creset%n%n%C(bold cyan)%s%n%n%C(cyan)%b%n%Creset'"
# usage
git log-commit
git log-commit 61067ae
```

And a shortcut:

```bash
# create
git config --global alias.logcm '!git log-commit'
# usage
git logcm
git logcm 61067ae
```

This works nicely in conjunction with `smartlog`. You can find the commit you are looking for, then use `git logcm` to display the full commit message.

##### List a succinct one-line log of all commits

```bash
# create
git config --global alias.ls 'log --oneline'
# usage
git ls
```

##### Discard all changes in working directory

```bash
# create
git config --global alias.nuke 'reset --hard'
# usage
git nuke
```

##### Remove all unreferenced files and directories

This one also comes from `hg`.

```bash
# create
git config --global alias.purge 'clean -fd'
# usage
git purge
```

##### Revert a specific file in your working directory

```bash
# create
git config --global alias.revertfile 'checkout --'
# usage
git revertfile name.txt
```

##### Unstage a specific file in your working directory

```bash
# create
git config --global alias.unstage 'reset HEAD --'
# usage
git unstage file.txt
```

##### Delete all branches (except for main and current)

This will delete all your local branches, except for `main` (or `master`) and the branch you are currently on. It will also `prune origin` afterward. You'll want to edit this if there are other branches that you never want to delete, perhaps a `dev` branch.

```bash
# create
git config --global alias.trim '!f() { git branch | grep -v "main" | grep -v "master" | grep -v "^*" | xargs git branch -D; git remote prune origin; }; f'
# usage
git trim
```

##### Undo your last commit

This will undo your last commit, but it will not discard the changes, which will be left staged. If you'd like to discard changes, you can run `git nuke` after. Otherwise, you can edit and re-commit. Note that if you have already pushed your branch to your remote, you'll need to force push after undoing the last commit.

```bash
# create
git config --global alias.uncommit 'reset --soft HEAD^'
# usage
git uncommit
```

Extra tip: I personally find git's interactive rebase and squash interface to be quite obtuse. If I need to quickly squash the last 2-3 commits, I will often run `git uncommit` a few times in a row, then simply create a new commit with all the changes. It's a bit of a hack, but it's fast and easy. I would not recommend this for more complex rebasing and squashing, however.

### Backup and restore

Lastly, whenever you get a new machine you'll have to re-add all these aliases to git. Luckily, it is easy to backup and restore your entire git configuration. It lives in `~/.gitconfig`, so you'll need to back that up somewhere and restore it on your new machine. Hopefully, you are already backing up your `.zprofile`, `.zshrc`, and other dotfiles. If not, now is a good time to start!
