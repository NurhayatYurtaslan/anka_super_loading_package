# Claude / agent rules (this repository)

Instructions for AI assistants (including Claude) working in this repo. **Authoritative lists** still live in `commits.md` and `.cursor/rules/`; if anything conflicts, prefer those files.

## Project

- **Type**: Flutter **package** (library), not only an app. Library code lives under `lib/`; the demo app is under `example/`.
- **SDK / tooling**: Dart / Flutter per root `pubspec.yaml` `environment`. Prefer `dart analyze` and `flutter test` from repo root; run example tests from `example/` when relevant.

## Scope and edits

- Change only what the task requires; avoid unrelated refactors or extra markdown unless asked.
- Match existing naming, imports, and style in touched files.

## Commit messages

- **Types** (do not invent others): see repo root **`commits.md`** for the full list and meanings (`feat`, `fix`, `chore`, `refactor`, `docs`, `style`, `test`, `perf`, `ci`, `build`, `revert`, `add`, `remove`, `update`, `rename`, `move`, `copy`, `security`, `hotfix`).
- **Subject**: `type: short description` or `type(scope): short description`. Lowercase English type; clear summary; **no trailing period** on the subject line.
- **Body**: Optional blank line, then context (what / why) if it helps reviewers.
- **Assistant footer** (when you propose the full message): add a blank line, then exactly **`signed by claude`** (this file is for Claude; do not use `signed by cursor` here). Human-written commits may omit this line. Do not use author-handle signatures.

**Good example:**

```
feat: add export for widget settings

signed by claude
```

**Bad examples:** `fixed stuff`, `WIP`, or any `type` not in `commits.md`.

## Package versions and `pubspec`

- Root **`pubspec.yaml`** `version` follows semver (`MAJOR.MINOR.PATCH`). Align the top section of **`CHANGELOG.md`** with the same version when releasing.
- **Bump guide**: breaking API or removed support → MAJOR; backward-compatible features → MINOR; fixes / non-behavioral tweaks → PATCH.
- Dependencies: prefer **`^x.y.z`** for published packages unless a pin is justified (note why in CHANGELOG or PR text).
- Before publish: `dart pub publish --dry-run`. Breaking changes need a clear **Breaking** note in `CHANGELOG.md`.

## Pull requests

- Use **`pull_request_template.md`** when opening a PR (fill sections as applicable).

## Cursor parity

- The same ideas are mirrored under **`.cursor/rules/`** (`commit-conventions.mdc`, `package-versions.mdc`) and **`.cursor/skills/`** for Cursor-specific workflows. Updating rules in one place should ideally be reflected in `CLAUDE.md` or the canonical file (`commits.md`, rules) so tools stay aligned.
