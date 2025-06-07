export JEKYLL_ENV=development

.DEFAULT: build

# ====== Build ====== #
.PHONY: build
build:
	bundle exec jekyll build

.PHONY: watch
watch:
	bundle exec jekyll build --watch

.PHONY: drafts
drafts:
	bundle exec jekyll build
	bundle exec jekyll build --drafts --watch --incremental

.PHONY: incr
incr:
	bundle exec jekyll build
	bundle exec jekyll build --watch --incremental

# ====== Install ====== #
.PHONY: install
install:
	bundle install
	npm install

.PHONY: update
update: update-bundle update-npm

.PHONY: update-bundle
update-bundle:
	bundle update --all
	bundle update --bundler

.PHONY: update-npm
update-npm:
	npm update

# ====== Publish ====== #
.PHONY: pub
pub:
	./scripts/publish.zsh

.PHONY: tags
tags:
	./scripts/tag_and_publish.zsh $(tag)

.PHONY: deploy-github
deploy-github:
	./scripts/deploy_github.zsh

# ====== Write ====== #
.PHONY: new
new:
	./scripts/new-post.swift

.PHONY: post-update
post-update:
	./scripts/update-post-date.swift $(p)

.PHONY: date
date:
	./scripts/current-date-time.swift

# ====== Utils ====== #
.PHONY: open
open:
	nova .

.PHONY: random
random:
	./scripts/random-post.swift

.PHONY: image-optim
image-optim:
	./scripts/imageoptim.zsh $(files)

# ====== Preview ====== #
.PHONY: safari
safari:
	open http://jessesquires.localhost

.PHONY: firefox
firefox:
	open -a Firefox http://jessesquires.localhost
