---
name: repo-commit-messages
description: >-
  Aligns git commit messages in this repo with `commits.md`: allowed type list,
  message shape, and assistant footer `signed by cursor`. Use when the user mentions commit, git
  commit, conventional commit, staging, pre-PR summary, or `commits.md`.
---

# Repo commit messages

## Source

All commit **type** values and meanings are listed in `commits.md`. Summary below (if the list changes, read the file):

`feat`, `fix`, `chore`, `refactor`, `docs`, `style`, `test`, `perf`, `ci`, `build`, `revert`, `add`, `remove`, `update`, `rename`, `move`, `copy`, `security`, `hotfix`

## Steps

1. Classify the change: pick **one** of the types above; if there are multiple themes, split sensibly or use the dominant type.
2. Subject line: `type: imperative or subject-style summary under ~50 chars` (optionally `type(scope): ...`).
3. Body: add only if needed for breaking changes, migrations, or review context.
4. When proposing the full commit message from Cursor, end with a blank line then exactly: `signed by cursor` (per `commits.md`; do not use author handles or `signed by claude` here).

5. Before suggesting a message to the user, verify the type matches `commits.md`.

## Examples

**fix**

```
fix: null guard when loading cached preferences

signed by cursor
```

**chore**

```
chore: bump example app iOS deployment target

signed by cursor
```

**refactor**

```
refactor: extract session refresh into service

signed by cursor
```

## Multi-file / mixed changes

Reflect the highest-impact theme in the subject; list other areas briefly in the body. Suggest two separate commits when that is clearer.
