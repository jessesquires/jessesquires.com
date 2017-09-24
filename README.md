# [jessesquires.com](https://www.jessesquires.com) [![Build Status](https://travis-ci.org/jessesquires/jessesquires.com.svg?branch=master)](https://travis-ci.org/jessesquires/jessesquires.com)

*Turing complete with a stack of `0xdeadbeef`*

![Logo](https://www.jessesquires.com/ico/apple-touch-icon.png)

## About

This is my personal site and blog. It mostly contains bits about Swift, iOS, Cocoa, Objective-C, and open source.

Lovingly built with [Jekyll](https://jekyllrb.com), [Bootstrap](https://getbootstrap.com), [jQuery](https://jquery.com), and [Font Awesome](https://fortawesome.github.io/Font-Awesome/). Hosted at [NearlyFreeSpeech](https://nearlyfreespeech.net/).


## Requirements

- [Bundler](https://bundler.io)
- [Bower](http://bower.io)

## Gems

- [jekyll](https://jekyllrb.com) ([Latest](https://github.com/jekyll/jekyll/releases/latest))
- [jekyll-paginate](https://github.com/jekyll/jekyll-paginate)
- [jekyll-sitemap](https://github.com/jekyll/jekyll-sitemap)

#### Updating gems

```bash
$ bundle update
```

## Dependencies

- [Bootstrap](https://getbootstrap.com)
- [jQuery](https://jquery.com)
- [Font Awesome](https://fortawesome.github.io/Font-Awesome/)
- [html5shiv](https://github.com/aFarkas/html5shiv)
- [respond](https://github.com/scottjehl/Respond)
- [Ubuntu Mono font](https://www.google.com/fonts/specimen/Ubuntu+Mono)

#### Updating dependencies

```bash
$ bower update
```

## Usage

#### Installation

```bash
$ git clone https://github.com/jessesquires/jessesquires.com.git
$ cd jessesquires.com/
$ bundle install
$ bower install
$ bower update
```

#### Building the site

```bash
$ bundle exec jekyll build
```

#### Previewing the site locally

```bash
$ bundle exec jekyll serve
# Now browse to http://localhost:4000
```

#### Writing a draft

```bash
$ bundle exec jekyll build --future --drafts --watch
```

## Verifying DNS setup

```bash
$ dig www.jessesquires.com +nostats +nocomments +nocmd
```

## License

> **Copyright &copy; 2014-present Jesse Squires.**

<a rel="license" href="https://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="https://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.

All code is licensed under an [MIT License](https://opensource.org/licenses/MIT).

The *Ubuntu Mono* font is licensed under the [Ubuntu Font License](http://font.ubuntu.com/ufl/).
