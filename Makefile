SHELL := bash
.DEFAULT_GOAL := vendor

app = docker compose run --rm php

# The build target dependencies must be set as "order-only" prerequisites to prevent
# the target from being rebuilt everytime the dependencies are updated.
build:
	@docker compose build --pull
	@$(app) composer install
	@$(app) mkdir --parents build
	@touch build

.PHONY: vendor
vendor: build
	@$(app) composer install

.PHONY: clean
clean:
	$(app) rm -rf ./build ./vendor

.PHONY: up
up:
	docker compose up --detach

.PHONY: down
down:
	docker compose down --remove-orphans

.PHONY: bash
bash: build
	@$(app) bash

# Generate HTML PHPUnit test coverage report, aliased to "phpunit-coverage" for consistency with other tooling targets.
.PHONY: phpunit-coverage
phpunit-coverage: build
	@$(app) composer run-script test-coverage

# Run the PHP development server to serve the HTML test coverage report on port 8000.
.PHONY: serve-coverage
serve-coverage:
	@docker compose run --rm --publish 8000:80 php php -S 0.0.0.0:80 -t /app/build/phpunit

.PHONY: lint phpcbf phpcs phpstan phpunit rector rector-dry-run
lint phpcbf phpcs phpstan phpunit rector rector-dry-run:
	docker compose run --rm --user=$$(id -u):$$(id -g) php composer run-script "$@"


# Runs all the code quality checks: lint, phpstan, phpcs, and rector-dry-run".
.NOTPARALLEL: ci
.PHONY: ci
ci: lint phpcs phpstan rector-dry-run phpunit

# Runs the automated fixer tools, then run the code quality checks in one go, aliased to "preci".
.PHONY: pre-ci preci
preci: pre-ci
pre-ci: build phpcbf rector ci
