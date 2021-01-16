.DEFAULT: build

.PHONY: build
build:
	bundle exec jekyll build

.PHONY: install
install:
	bundle install
	yarn install

.PHONY: update
update:
	bundle update --all
	bundle update --bundler
	yarn upgrade --latest

.PHONY: watch
watch:
	bundle exec jekyll build --watch

.PHONY: incr
incr:
	bundle exec jekyll build --watch --incremental

.PHONY: pub
pub:
	./scripts/publish.zsh

.PHONY: tags
tags:
	./scripts/tag_and_publish.zsh $(tag)

.PHONY: new
new:
	./scripts/new-post.swift

.PHONY: date
date:
	./scripts/current-date-time.swift

.PHONY: deploy-github
deploy-github:
	./scripts/deploy_github.zsh

.PHONY: image-optim
image-optim:
	./scripts/imageoptim.zsh $(files)
