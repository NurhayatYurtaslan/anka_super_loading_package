The commit type can include the following:

- [ ] feat – a new feature is introduced with the changes
- [ ] fix – a bug fix has occurred
- [ ] chore – changes that do not relate to a fix or feature and don't modify src or test files (for example updating dependencies)
- [ ] refactor – refactored code that neither fixes a bug nor adds a feature
- [ ] docs – updates to documentation such as a the README or other markdown files
- [ ] style – changes that do not affect the meaning of the code, likely related to code formatting such as white-space, missing semi-colons, and so on.
- [ ] test – including new or correcting previous tests
- [ ] perf – performance improvements
- [ ] ci – continuous integration related
- [ ] build – changes that affect the build system or external dependencies
- [ ] revert – reverts a previous commit
- [ ] add – when adding a new file, function, method, variable, and so on
- [ ] remove – when removing a file, function, method, variable, and so on
- [ ] update – when updating a file, function, method, variable, and so on
- [ ] rename – when renaming a file, function, method, variable, and so on
- [ ] move – when moving a file, function, method, variable, and so on
- [ ] copy – when copying a file, function, method, variable, and so on
- [ ] security – in case of vulnerabilities
- [ ] hotfix – a bug hot fix has occurred

## Assistant commit footer (AI-generated commits only)

When an assistant proposes the **full** commit message, add one final line after a blank line (exact wording, lowercase):

- **Cursor**: `signed by cursor`
- **Claude** (including Claude Code): `signed by claude`

Do not add other signature lines (for example author social handles) to commits. Human-authored commits may omit this footer.