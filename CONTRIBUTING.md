# Contributing

Contributions are welcome. This project accepts pull requests on [GitHub][github].

## Communication Channels & Reporting Bugs

You can find help and discussion at the project's [GitHub Issues page][issues]. Please use the issue tracker to report
any bugs found with this project.

⚠️ _**ATTENTION!!!** DO NOT include passwords or other sensitive information in your bug report._

When submitting a bug report, please include enough information to reproduce the bug. A good bug report includes the
following sections:

- **Description**: Provide a short and clear description of the bug.

- **Steps to Reproduce**: Provide steps to reproduce the behavior you are experiencing. Please try to keep this as short
  as possible. If able, create a reproducible script outside any framework you are using. This will help us to
  quickly debug the issue.

- **Expected Behavior**: Provide a short and clear description of what you expect to happen.

- **Screenshots or Other Output**: If applicable, add screenshots or program output to help explain your problem.

- **Environment Details**: Provide details about the system where you're using this package, such as PHP version and
  operating system.

- **Additional Context**: Provide any additional context that may help us debug the problem.

## Fixing Bugs

This project welcomes pull requests to fix bugs!

If you see a bug report that you'd like to fix, please feel free to do so. Following the directions and guidelines
described in the "Adding New Features" section below, you may create bugfix branches and send pull requests.

## Adding New Features

If you have an idea for a new feature, it's a good idea to check out the [issues][] or active [pull requests][] first to
see if anyone is already working on the feature. If not, feel free to submit an issue first, asking whether the feature
is beneficial to the project. This will save you from doing a lot of development work only to have your feature
rejected. We don't enjoy rejecting your hard work, but some features don't fit with the goals of the project.

When you do begin working on your feature, here are some guidelines to consider:

- Your pull request description should clearly detail the changes you have made. We will use this description to update
  the CHANGELOG. If there is no description, or it does not adequately describe your feature, we may ask you to update
  the description.
- All pull requests must comply with the project coding standard (see below). Please ensure your code does, too. _Hint:
  run `make phpcs` to check._
- Please **write tests** for any new features you add.
- Please **ensure that tests pass** before submitting your pull request. `wickedbyte/int-to-uuid` automatically runs
  tests for pull requests. However, running the tests locally will help save time. _Hint: run `make phpunit`._
- **Use topic/feature branches.** Please do not ask to pull from your main branch. - For more information,
  see "[Understanding the GitHub flow][gh-flow]."
- **Submit one feature per pull request.** If you have multiple features you wish to submit, please break them into
  separate pull requests.

## Developing

To develop this project, you will need [PHP](https://www.php.net) 8.2 or greater
and [Composer](https://getcomposer.org). This project has a standardized Docker development environment that is
recommended for any one contributing to this project. Composer is used as a script-runner inside of the container, and
`make` is used externally from the host environment to run most of the common scripts.

After cloning this repository locally, execute the following commands:

```bash
cd /path/to/repository
make
```

> **Note:** A `GITHUB_TOKEN` in `.env` is optional. It increases the GitHub API rate limit for
> Composer but is not required for installing public packages. If you hit rate limits, generate
> a token at [github.com/settings/tokens](https://github.com/settings/tokens) (no scopes needed)
> and add it to your `.env` file.

The full suite of code quality tools can be run in one command:

```bash
make ci
```

### Static Analysis

This project uses [PHPStan](https://github.com/phpstan/phpstan) to provide static analysis of PHP code. You may run
static analysis manually across the whole codebase with the following command:

```bash
# Static analysis
make phpstan
```

### Coding Standards

This project follows a superset of [PER-CS][per-cs]
coding standards, enforced by [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer).
Rector is also used to enforce code quality and standards

```bash
# Run the code standards linter
make phpcs

# Attempt to auto-fix coding standards issues
make phpcbf

# Run Rector with project configuration
make rector
```

### Running Tests

The following must pass before we will accept a pull request. If this does not pass, it will result in a complete build
failure. Before you can run this, be sure to `composer install`.

To run all the tests and coding standards checks, execute the following from the command line, while in the project root
directory:

```
make phpunit
```

[github]: https://github.com/wickedbyte/int-to-uuid
[issues]: https://github.com/wickedbyte/int-to-uuid/issues
[pull requests]: https://github.com/wickedbyte/int-to-uuid/pulls
[per-cs]: https://www.php-fig.org/per/coding-style/
[gh-flow]: https://guides.github.com/introduction/flow/
