SHELL := bash
.SHELLFLAGS = -ec
.DEFAULT_GOAL := build/.install
.WAIT:

_WARN := "\033[33m%s\033[0m %s\n"  # Yellow text template for "printf"
_INFO := "\033[32m%s\033[0m %s\n" # Green text template for "printf"
_ERROR := "\033[31m%s\033[0m %s\n" # Red text template for "printf"

##------------------------------------------------------------------------------
# Command Aliases & Function/Variable Definitions
##------------------------------------------------------------------------------

# Set COMPOSER_AUTH only when GITHUB_TOKEN is non-empty (avoids confusing 401 errors with empty tokens)
export COMPOSER_AUTH ?= $(shell TOKEN=$$(grep '^GITHUB_TOKEN=' .env 2>/dev/null | cut -d= -f2); \
	if [ -n "$$TOKEN" ]; then echo '{"github-oauth": {"github.com":"'$$TOKEN'"}}'; fi)

docker-php = docker compose run --rm php
docker-run = docker run --rm --env-file "$${PWD}/.env" --user=$$(id -u):$$(id -g)

# Define behavior to safely source file (1) to dist file (2), without overwriting
# if the dist file already exists. This is more portable than using `cp --no-clobber`.
define copy-safe
	if [ ! -f "$(2)" ]; then \
		echo "Copying $(1) to $(2)"; \
		cp "$(1)" "$(2)"; \
	else \
		echo "$(2) already exists, not overwriting."; \
	fi
endef

# Check if a token (1) is set in .env and print a helpful message if not. The token is
# optional for public packages — it only increases the GitHub API rate limit for Composer.
define check-token
	@TOKEN_VALUE=$$(grep "^$(1)=" ".env" 2>/dev/null | cut -d'=' -f2); \
	if [ -z "$$TOKEN_VALUE" ]; then \
		printf $(_WARN) "[optional]" "$(1) is not set in .env. Composer may hit GitHub API rate limits."; \
		printf $(_INFO) "" "To set it: echo '$(1)=<your-token>' >> .env"; \
	fi
endef

BUILD_DIRS = build/.phpunit.cache \
	build/composer \
	build/docker \
	build/phpstan \
	build/phpunit \
	build/rector \
	build/xdebug

##------------------------------------------------------------------------------
# Docker Targets
##------------------------------------------------------------------------------

build/docker/docker-compose.json: Dockerfile compose.yml | build/docker
	docker compose pull --quiet --policy="always"
	COMPOSE_BAKE=true docker compose build \
		--pull \
		--build-arg USER_UID=$$(id -u) \
		--build-arg USER_GID=$$(id -g)
	touch "$@" # required to consistently update the file mtime

build/docker/int-to-uuid-%.json: Dockerfile | build/docker
	docker buildx build --target="$*" --pull --load --tag="int-to-uuid-$*" --file Dockerfile .
	docker image inspect "int-to-uuid-$*" > "$@"

##------------------------------------------------------------------------------
# Build/Setup/Teardown Targets
##------------------------------------------------------------------------------

.env:
	@$(call copy-safe,.env.dist,.env)

$(BUILD_DIRS): | .env
	mkdir -p "$@"

vendor: build/composer build/docker/docker-compose.json composer.json $(wildcard composer.lock) | .env
	mkdir -p "$@"
	@$(call check-token,GITHUB_TOKEN)
	$(docker-php) composer install
	@touch vendor

build/.install : vendor build/docker/int-to-uuid-prettier.json | $(BUILD_DIRS)
	@echo "Application Build Complete."
	@touch build/.install

.PHONY: clean
clean:
	$(docker-php) rm -rf ./build ./vendor

##------------------------------------------------------------------------------
# Code Quality, Testing & Utility Targets
##------------------------------------------------------------------------------

.PHONY: up
up:
	docker compose up --detach

.PHONY: down
down:
	docker compose down --remove-orphans

.PHONY: bash
bash: build/docker/docker-compose.json
	$(docker-php) bash

.PHONY: test
test: phpunit

.PHONY: lint phpcbf phpcs phpstan phpunit phpunit-coverage rector rector-dry-run
lint phpcbf phpcs phpstan phpunit phpunit-coverage rector rector-dry-run: build/.install
	$(docker-php) composer run-script "$@"

.NOTPARALLEL: ci pre-ci preci
.PHONY: ci pre-ci preci
ci: lint phpcs phpstan phpunit prettier-check rector-dry-run

pre-ci preci: prettier-write rector phpcbf ci

# Run the PHP development server to serve the HTML test coverage report on port 8000.
.PHONY: serve-coverage
serve-coverage:
	@docker compose run --rm --publish 8000:80 php php -S 0.0.0.0:80 -t /app/build/phpunit

##------------------------------------------------------------------------------
# Prettier Code Formatter for JSON, YAML, HTML, Markdown, and CSS Files
# Example Usage: `make prettier-check`, `make prettier-write`
##------------------------------------------------------------------------------

.PHONY: prettier-%
prettier-%: | build/docker/int-to-uuid-prettier.json
	$(docker-run) --volume $${PWD}:/app int-to-uuid-prettier --$* .

##------------------------------------------------------------------------------
# Enable Makefile Overrides
#
# If a "build/Makefile" exists, it can define additional targets/behavior and/or
# override the targets of this Makefile. Note that this declaration has to occur
# at the end of the file in order to effect the override behavior.
##------------------------------------------------------------------------------

-include build/Makefile
-include .local/Makefile
