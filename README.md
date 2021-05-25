# [jessesquires.com](https://www.jessesquires.com) ![CI](https://github.com/jessesquires/jessesquires.com/workflows/CI/badge.svg)

*Turing complete with a stack of `0xdeadbeef`*

![Logo](https://www.jessesquires.com/ico/favicon-180-precomposed.png)

## About

This is my personal site and blog.

Built with [Jekyll](https://jekyllrb.com), [Bootstrap](https://getbootstrap.com), and [Font Awesome](https://fontawesome.com). Hosted at [NearlyFreeSpeech](https://nearlyfreespeech.net).

## Requirements

- [Bundler](https://bundler.io)
- [NPM](https://www.npmjs.com)

## Dependencies

### Gems

- [jekyll](https://jekyllrb.com) ([Latest](https://github.com/jekyll/jekyll/releases/latest)) ([Cheat Sheet](https://learn.cloudcannon.com/jekyll-cheat-sheet/))
- [jekyll-sitemap](https://github.com/jekyll/jekyll-sitemap)
- [jekyll-paginate](https://github.com/jekyll/jekyll-paginate)

#### Updating Gems

```bash
$ make update-bundle
```

### NPM packages

- [Bootstrap](https://getbootstrap.com) ([package](https://www.npmjs.com/package/bootstrap))
- [Font Awesome](https://fortawesome.github.io/Font-Awesome/) ([pkg](https://yarnpkg.com/en/package/font-awesome))

#### Updating packages

```bash
$ make update-deps
```

### Other

- [GoatCounter Analytics](https://www.goatcounter.com)
- [Ubuntu Mono font](https://www.google.com/fonts/specimen/Ubuntu+Mono)

## Usage

### Installation

```bash
$ git clone https://github.com/jessesquires/jessesquires.com.git
$ cd jessesquires.com/
$ make install
```

### Building the site

```bash
$ make build
```

### Previewing the site locally

```bash
$ bundle exec jekyll serve # browse to http://localhost:4000
```

### Handling Links

- To other blog posts: `[link]({{ site.url }}{% post_url 2000-01-01-my-blog-post-title %})`
- To images: `{{ site.url }}{{ site.img_url}}/path-to/image.png`

### Verifying DNS setup

```bash
$ dig www.jessesquires.com +nostats +nocomments +nocmd
```

### Install software on NFSN

```bash
$ cd home/protected/      # preferred directory for installing
$ wget <URL-to-some-file> # download
$ tar -zxvf file.tar.gz   # extract
$ mkdir bin               # if needed

# follow any install instructions
# put binary in protected/bin/
# add `export PATH=$PATH:/home/protected/bin/` to your `.bash_profile`
```

## License

> **Copyright &copy; 2014-present Jesse Squires.**

<a rel="license" href="https://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="https://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.

All code is licensed under an [MIT License](https://opensource.org/licenses/MIT).

The *Ubuntu Mono* font is licensed under the [Ubuntu Font License](http://font.ubuntu.com/ufl/).
