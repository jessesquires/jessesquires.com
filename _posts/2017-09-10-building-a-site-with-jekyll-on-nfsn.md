---
layout: post
categories: [software-dev]
tags: [web, jekyll, ruby, git, nearlyfreespeech, nfsn, website-infra]
date: 2017-09-10T10:00:00-07:00
date-updated: 2020-10-07T10:03:48-07:00
title: Building a site with Jekyll on NearlyFreeSpeech
subtitle: My blog infrastructure, and migrating off of GitHub pages
---

This site used to be hosted via [GitHub Pages](https://pages.github.com), but I decided to move to a dedicated host to have more control over how I develop and deploy the site, and how it's configured. A number of limitations and quirks eventually drove me to migrate away from GitHub pages to my excellent and inexpensive bare-bones host, [NearlyFreeSpeech.net](https://www.nearlyfreespeech.net). I was also interested in learning to do all of this on my own, rather than relying on GitHub Pages "magic". If you're looking to setup your own Jekyll-powered site, or if you're looking to migrate off of GitHub Pages, hopefully this is helpful.

<!--excerpt-->

{% include updated_notice.html
    update_message="This post has been updated to reflect recent changes with NearlyFreeSpeech, as well as changes in my setup."
%}

### Overview of this site

* This site hosted on [NearlyFreeSpeech.net](https://www.nearlyfreespeech.net).
* It is built using [Jekyll](https://jekyllrb.com) via the [github-pages gem](https://github.com/github/pages-gem).
* It uses the [Bootstrap](https://getbootstrap.com) front-end library for HTML, CSS, and JS. (And thus [jQuery](https://jquery.com/).) I've created my own layouts and styling via Bootstrap, rather than using [Bootstrap's themes](https://themes.getbootstrap.com), or [JekyllThemes](http://jekyllthemes.org), or [Octopress](http://octopress.org/docs/theme/).
* It uses [Font Awesome](https://fortawesome.github.io/Font-Awesome/) for icons, like what you see in the site footer.
* I deploy via Git. I simply commit changes, then `git push`. A post-receive hook builds the site via Jekyll and dumps the output in the public www directory.
* This site is open source. Additional details in the [README](https://github.com/jessesquires/jessesquires.com/blob/master/README.md).

### Limitations of GitHub Pages

Firstly, I think GitHub Pages is awesome &mdash; especially for open source project pages and [documentation]({% post_url 2016-05-20-swift-documentation %}). If you are just getting started with a blog and unsure if you're committed to it, or you merely want to experiment, it's great. You can completely remove your site in seconds by deleting the repo on GitHub if you decide it's not for you. It's **free** (as in beer) and easy to get setup and publishing in a few hours, or even a few minutes if you use one of their themes. And, as you'll see, it's relatively easy to migrate away from GitHub Pages once you've decided you've outgrown it.

The main problem I have with GitHub Pages is the lack of control. There's some "magic" involved with it. All you do is create a repository with the name `<username>.github.io`, add and commit your files, then the site gets built with [Jekyll](https://jekyllrb.com) each time you push a commit. GitHub publishes a [pages-gem](https://github.com/github/pages-gem), which you can install to replicate their environment and build your site locally for testing. The issue is that the `pages-gem` gets updated and deployed without any notifications to users. My site has broken a handful of times because of breaking changes in gem dependencies. When this happens, it is incredibly difficult to debug. You have to view the errors on the repo settings page, and if the error is something generic and unactionable, you're stuck navigating through [this help doc](https://help.github.com/articles/troubleshooting-github-pages-builds/). It turns out that it's difficult to debug problems when you have no server to which you can login. What makes this worse is that you discover these problems when you are trying to publish a new post. Thus, your simple "`git push` to publish" turns into a few hours of trying to figure out what went wrong until you realize that the GitHub Pages server environment does not match your local environment.

To add to this, the GitHub Pages server will not build any site with unsupported "plugins" (i.e., gems) or certain configurations (specified in `_config.yml`).  You have no access to `.htaccess` or `.conf`. [Custom domain configuration](https://help.github.com/articles/using-a-custom-domain-with-github-pages/) is a bit awkward and cumbersome with a `CNAME` file at the root. There's a 1 GB soft limit on size &mdash; this is probably nothing to worry about for a site like this, but still. What if this becomes a hard limit? What if that limit is decreased in the future? And in general, what if... what if... what if...

Another odd (and "magical") aspect of GitHub Pages is how project pages work when you have a custom GitHub Pages user site with a custom domain. Normally, a project site is hosted at `<username>.github.io/<project>`, for example [jessesquires.github.io/JSQDataSourcesKit](https://jessesquires.github.io/JSQDataSourcesKit/). With a custom domain, this becomes `<mysite>.com/<project>`. For example, if my pages repo is `jessesquires.github.io` and my custom domain is `jessesquires.com`, then my project site would be `jessesquires.com/JSQDataSourcesKit`. Furthermore, navigating to `jessesquires.github.io/JSQDataSourcesKit` will *redirect* to `jessesquires.com/JSQDataSourcesKit`.

And finally, HTTPS is not available by default for GitHub Pages sites with a custom domain. For non-custom domains (i.e., the default `<username>.github.io`) enabling/enforcing HTTPS is a simple checkbox in your repo settings. Apparently there are [ways to enable HTTPS](https://vickylai.io/verbose/free-custom-domain-website-https/) via Cloudflare, but that seems cumbersome and involves yet another service. This is what really pushed me over the edge, because [YES, your site needs HTTPS](https://doesmysiteneedhttps.com).

So, if I have already registered my domain through [NearlyFreeSpeech](https://www.nearlyfreespeech.net) (NFSN), why go through all this trouble? Why not also *host* on NFSN and get a painless HTTPS setup as well?

(Another plus is that the other sites that I manage are hosted on NFSN, so this move would consolidate everything for me.)

### About NearlyFreeSpeech.net and why

Hopefully you've noticed the amazing double-entendre &mdash; "nearly free" as in [incredibly inexpensive](https://www.nearlyfreespeech.net/services/pricing), and "free speech" as in promoting freedom of speech via your own website on the open web. NFSN is a [simple, bare-bones, DIY](https://www.nearlyfreespeech.net/services/hosting) host and domain registrar. They provide every thing you need for most sites, especially simple Jekyll blogs like this one. All of their services are pay-as-you-go or "pay for what you use". My currently monthly charges are about $0.17 per month. Yes, **17 cents**. However, any kind of support is extra, sometimes the forums are cryptic, and there's some additional manual setup/configuration that you need to do sometimes. For me, that trade-off simply means I get to learn more. It is definitely [not for everyone](https://www.reddit.com/r/Wordpress/comments/18e5n9/anyone_use_nearlyfreespeech_as_a_webdev_babynoob/). The other great thing about using an indie host/registrar like NFSN is that it's **not** Amazon or GoDaddy. You are free from the shackles and despair of sleazy, giant corporations and their bullshit.

{% include updated_notice.html
    update_message="My costs are now around <b>$1.66</b> USD per month, due to some small pricing changes at NFSN and my increased usage. All things considered, this is still incredibly cheap."
%}

### Setting up your site

What I'll walk through in this post is installing Jekyll (using the [`github-pages`](https://rubygems.org/gems/github-pages) gem) on NFSN, setting up a bare Git repo, and configuring everything so that you can `git push` to publish new posts or other site updates. The end result will be a workflow similar to using GitHub Pages, only you will have setup everything on your own and will have total control. We'll go through these steps as if this is a fresh setup. Then we'll discuss the different steps needed if you are migrating from GitHub Pages.

Regarding your actual site and content, I'll assume you've already got those basics complete. There are already good [tutorials and docs](https://jekyllrb.com/docs/home/) on using and configuring Jekyll. If you've used GitHub Pages, it should be familiar. There's only one thing to point out here and that is to create a `Gemfile` and use [Bundler](http://bundler.io). For any other gaps, you can [view the source](https://github.com/jessesquires/jessesquires.com) for this site.

The easiest setup is to use the `github-pages` gem, which should have everything you need.

```ruby
source 'https://rubygems.org'

gem 'github-pages', group: :jekyll_plugins
```

This makes the transition from hosting on GitHub Pages to hosting elsewhere smoother, depending on your setup. Alternatively, you can simply use Jekyll directly, which is what I would recommend. My [current Gemfile looks like this](https://github.com/jessesquires/jessesquires.com/blob/master/Gemfile):

```ruby
source 'https://rubygems.org'

gem 'jekyll', '~> 4.0'
gem 'jekyll-sitemap'

gem 'danger'
gem 'danger-prose'
```

#### SSH

Once you have an account with NFSN, it's straightforward to setup a site and domain, so I won't go over that. Once this is setup, you'll be provided with SSH access. I'd recommend generating and adding an SSH key to NFSN. GitHub has a good guide on [generating SSH keys](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/). You can add the key from the profile page on NFSN. After this is setup, you can `ssh username@ssh.phx.nearlyfreespeech.net` to login to your server.

#### NFSN Directories

For any NearlyFreeSpeech site, [there are several subdirectories](https://faq.nearlyfreespeech.net/section/ourservice/directories) in the root `/home` directory. The most relevant ones are the following:

* `/home/public` &mdash; This is your website's Document root. (Sometimes named `www`.)
> This directory is the heart of your site. All of the content in this directory is directly accessible via the web. You can put all your static HTML files, images, .htaccess files, and most scripts in this directory.
* `/home/protected/` &mdash; This is reserved for content that should be *indirectly* accessible, and other things like custom Ruby gem installs.
> This directory is available for data files and other content that should be indirectly accessible via the web. For example, putting included source files, libraries, configuration and permanent data files that are used by PHP or CGI scripts into this directory makes them accessible to the script, but prevents them from being directly downloaded over the web.
* `/home/private/` &mdash; Equivalent to `~`. For anything that should not be accessible via the web, like Git repos, or privately used gems for a Jekyll site.
> This directory is yours to use for personal files that you do not want accessible via the web at all. For example, if you're building a custom C++ CGI script, it would be appropriate to put the source code in this directory. This directory is also your "home" directory for Unix shell purposes.

Additional notes on `/home/protected/` from NFSN:

> To install software locally on your site, use the protected directory, not the private directory, or the web server may have permissions problems reading it.

#### Setting up Ruby Gems

First you need to do some setup for Ruby and install [Bundler](http://bundler.io). After ssh'ing into NFSN, you'll need to add the following to your `.bash_profile` or `.bashrc`, depending on your setup. ([Explanation of the difference.](http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html))

```bash
export GEM_HOME=/home/private/.gem
```

This tells NFSN where to find the gems you've installed. Then:

```bash
cd /home/private
gem install bundler
```

(Actually installing Jekyll will come later.)

#### Creating a bare Git repository

You'll need to create a bare Git repository. This will contain your code and markdown files, and will be your `remote` when you clone the repo to your machine.

```bash
cd /home/private
mkdir site.git
cd site.git
git init --bare
```

You can clone this repo locally.

```bash
# replace "<username>" with your login
git clone ssh://<username>@ssh.phx.nearlyfreespeech.net/home/private/site.git
```

You also want to create a checkout directory, which is where you'll locally clone your site and build it before publishing.

```bash
cd /home/private
mkdir site_checkout
cd site_checkout
git clone /home/private/site.git/
```

#### Setting up Git hooks

Next you need to setup a [post-receive hook](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) in git. This script will run on your server each time you `git push` to the remote repo on your NFSN server. In the bare repo you created (`site.git`), there will be a `hooks/` directory with sample scripts. You can rename and edit `post-receive.sample` or create a new, empty `post-receive` file. It should contain the following:

```bash
#!/bin/bash

export GEM_HOME=/home/private/.gem

SITE_CHECKOUT=$HOME/site_checkout
GIT_DIR=$SITE_CHECKOUT/.git
PUBLIC_WWW=/home/public

cd $SITE_CHECKOUT

git --git-dir=$GIT_DIR status
git --git-dir=$GIT_DIR pull -f
git --git-dir=$GIT_DIR status

bundle install
bundle exec jekyll build --destination $PUBLIC_WWW

exit
```

This will `cd` into `/private/site_checkout` then run `git pull` to pull the latest changes from the bare repo. Because this runs from the bare repo `hooks/` directory, we need to specify the git checkout directory using `--git-dir`. Then it runs `bundle install` to update or install any gems. (Remember you skipped installing `jekyll` earlier? This takes care of that.) Using Bundler allows you to easily keep gems updated without having to ssh into your server. Finally, it runs `jekyll build` and publishes your generated site (by putting the files in `/home/public`).

Don't forget to make the file executable.

```bash
chmod ug+x /home/private/site.git/hooks/post-receive
```

#### Setting up HTTPS

To setup HTTPS on NFSN, ssh into your server and run `tls-setup.sh` from within `/home/public/`.

#### Updating and publishing

With all of that setup complete, all that's left is publishing your site and new blog posts. In your local clone of the repo, `git commit` your changes and `git push` to publish. Everything is automated. It's a super simple workflow. You can run `bundle install` to install everything locally and run `bundle exec jekyll serve` to view your site locally.

### Migrating off of GitHub Pages

The setup described above basically replicates GitHub Pages on your own server, which makes migrating straightforward. Or as mentioned above, you can switch over to using the `jekyll` gem directly, which is a bit lighter than `github-pages`.

#### Configuring Git

You'll want to follow the steps above, except for when it comes to your local git repo. With GitHub Pages, you'll already have a repo setup on GitHub and cloned locally. You need to set your `remote.origin` to NFSN (to the bare repo you created there), and add a new remote for GitHub.

```bash
# replace username with your usernames
git remote set-url origin ssh://<username>@ssh.phx.nearlyfreespeech.net/home/private/site.git
git remote add github git@github.com:<username>/<username>.github.io.git
```

After this change, `git push origin master` will push your master branch to NFSN and `git push github master` will push to GitHub. If you don't want your site to be open source, then don't add the github remote. Push to NFSN and your entire site (and entire git history) should now be copied over to NFSN.

#### Configuring DNS

Now you need to get your custom domain to point to your site on NFSN, not GitHub Pages.

1. Remove the `CNAME` file from your repo. Push to NFSN (`origin`) and GitHub (`github`).
2. Rename your `<username>.github.io` repo. I renamed mine to `jessesquires.com`. This can be anything, like `myblog`, as long as it is not the GitHub Pages reserved name. If you added a `remote.github` to your local repo, don't forget to reset the url to the new repo name.
3. On NFSN, remove the `CNAME` records [that you setup for GitHub Pages](https://help.github.com/articles/setting-up-a-www-subdomain/) originally.
4. On NFSN, configure DNS for your site and your domain.

These changes take some time to propagate, a few hours or so. Don't panic while GitHub 404's your site. It will resolve itself soon.

#### Managing GitHub project sites

As mentioned above, any project sites you had hosted on GitHub Pages will now only be accessible via `<username>.github.io/<project>` &mdash; not `<mysite>.com/<project>`. You will need to update anything that links to the later, or make those pages part of your new NFSN site.

After migrating to NFSN, I decided to make a new [jessesquires.github.io](https://github.com/jessesquires/jessesquires.github.io) GitHub Pages site repo. This is simply a landing page and introduction for my GitHub projects, using GitHub's built-in themes. You can view the [site here](https://jessesquires.github.io). Without this, `jessesquires.github.io` would show a 404 error, which is awkward considering my project sites are now only available at `jessesquires.github.io/<project>`. Creating this new GitHub Pages user site avoids that awkwardness and gives a better separation between my personal site and what I'm doing on GitHub. By using a built-in theme, it's trivial to maintain &mdash; just a single `README.md`.

### Conclusion

I'm really happy with this setup and how simple it is to use. Everything is consolidated on NFSN. Enabling HTTPS was easy. I can eventually customize my site further. Most importantly, I can install and update gems on my own schedule. I don't have to worry about any of the limitations or quirks of GitHub Pages hosting. And while my site is no longer *free*, it is **nearly free**. &#x1F609;
