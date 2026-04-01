# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and this project adheres
to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] - 2026-04-01

### Added

- Added `RFC5962_VERSION` and `RFC5962_VARIANT` constants to `IntToUuid`
- Added tests covering the Test Vectors from
  the [IntToUuid](https://github.com/wickedbyte/int-to-uuid-spec) specification

### Changed

- Widened `ramsey/uuid` constraint from `^4.7` to `^4.6`, allowing older minor
  versions that support V8 UUIDs
- Updated validation/error messages to reference RFC 9562 instead of RFC 4122
- Updated README.md to adopt RFC 9562 terminology and reflect the new test vectors
- Added `keywords` to composer.json for improved Packagist discoverability

### Deprecated

- `IntToUuid::RFC4122_VERSION` — use `IntToUuid::RFC5962_VERSION` instead
- `IntToUuid::RFC4122_VARIANT` — use `IntToUuid::RFC5962_VARIANT` instead

## [1.0.1] - 2026-03-20

### Added

- Added CONTRIBUTING.md with development setup and contribution guidelines
- Added SECURITY.md with vulnerability disclosure policy
- Added CODE_OF_CONDUCT.md (Contributor Covenant 3.0)
- Added CHANGELOG.md
- **Dev:** Added `.prettierignore` and `.env.dist`
- **Dev:** Added `homepage` and `prefer-stable` to composer.json

### Changed

- Updated LICENSE.md copyright year to 2025-2026
- **Dev:** Replaced Dockerfile, compose.yml, and Makefile with standardized
  WickedByte project infrastructure
- **Dev:** Standardized composer.json scripts to match other WickedByte projects
- **Dev:** Simplified phpstan.dist.neon to match standard configuration
- **Dev:** Aligned rector.php, phpcs.xml, .gitignore, and .editorconfig with
  project conventions

## [1.0.0] - 2025-07-29

### Added

- Initial release

[Unreleased]: https://github.com/wickedbyte/int-to-uuid/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/wickedbyte/int-to-uuid/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/wickedbyte/int-to-uuid/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/wickedbyte/int-to-uuid/releases/tag/v1.0.0
