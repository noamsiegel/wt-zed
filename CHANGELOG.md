# Changelog

## 0.1.3 - 2026-05-24

- Changed manifest/health version assertions to read the expected version from `wt-plugin.json` instead of hardcoded literals.
- Future version bumps no longer require touching `tests/test_plugin.bats`.
- Bumped manifest + script version to 0.1.3.

## 0.1.2 - 2026-05-24

- Added `RELEASING.md`: release checklist with version-site reminders and recovery notes.
- Added `tests/test_version.bats`: asserts script `VERSION` matches `wt-plugin.json` version.
- Updated existing manifest/health test assertions from `0.1.0` to current version (drift fix).
- Bumped to 0.1.2.

## 0.1.1 - 2026-05-24

- Added `CONTEXT.md` and `AGENTS.md` for plugin-specific invariants and agent orientation.
- Slimmed `README.md` to plugin-specific behavior; links to `git-wt/docs/plugin-contract.md` for the protocol spec and to `git-wt/docs/plugins.md` for the family-wide comparison.
- Bumped manifest + script version to 0.1.1.

## 0.1.0 - 2026-05-24

- Initial `git-wt` plugin release.
- Open newly created worktrees in Zed with `zed -n <path>`.
- Return best-effort no-op for worktree removal because Zed has no documented close-workspace CLI command.
- Add manifest and health commands for `git-wt.plugin.v0`.
