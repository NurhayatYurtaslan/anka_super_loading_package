---
name: repo-package-versions
description: >-
  Manages root pubspec version, semver bump choice, CHANGELOG sync, and pubspec
  dependency constraints for this Flutter/Dart package. Use when the user
  mentions version, semver, release, bump, pub publish, CHANGELOG, or pubspec
  version.
---

# Repo package versions

## Scope

- **Library version**: `version:` in the repo root `pubspec.yaml` (the example app version is a separate concern).
- **Principles**: Same as `.cursor/rules/package-versions.mdc`; if anything conflicts, follow root `pubspec.yaml` and `CHANGELOG.md`.

## Which bump when

| Change | Bump |
|--------|------|
| Breaking API, removed export, or narrower supported SDK | **MAJOR** |
| New feature, backward compatible | **MINOR** |
| Fixes only, or docs/example-only (API unchanged) | **PATCH** |

During `0.y.z` pre-releases with a fluid API, MINOR/PATCH is acceptable; after stable `1.0.0`, apply semver more strictly.

## Release / bump steps

1. Read `CHANGELOG.md`: add a `## x.y.z` section; list user-facing items since the last release (call out **Breaking** first if applicable).
2. Set root `pubspec.yaml` `version:` to the new `x.y.z` (must match CHANGELOG).
3. Adjust `environment` or dependency constraints only when required by the change; avoid unnecessary tightening of `^` ranges.
4. Run `dart pub get` at the root and in `example/` if needed.
5. Before publish: `dart pub publish --dry-run`.

## Dependency versions (summary)

- External packages: prefer `^major.minor.patch` when possible.
- If you pin or use a narrow range because only one version works, note the reason briefly in CHANGELOG or the PR description.

## Commit message

Version bumps follow this repo’s commit rules; type is often `chore` (meta/release housekeeping) or `update` (version and CHANGELOG update) from `commits.md`—read `commits.md` if unsure.
