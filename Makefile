
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

.PHONY: pub
pub:
	./scripts/publish.sh
