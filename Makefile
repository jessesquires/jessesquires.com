
.DEFAULT: build

.PHONY: build
build:
	bundle exec jekyll build

.PHONY: watch
watch:
	bundle exec jekyll build --watch

.PHONY: incr
incr:
	bundle exec jekyll build --watch --incremental

.PHONY: future
future:
	bundle exec jekyll build --watch --future

.PHONY: pub
pub:
	./scripts/publish.sh

.PHONY: tags
tags:
	./scripts/tags_publish.sh

.PHONY: new
new:
	./scripts/new-post.swift
