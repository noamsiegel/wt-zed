# AGENTS.md

This file orients agents working on **wt-zed** itself. Read `CONTEXT.md` for plugin-specific invariants. Read git-wt's `docs/plugin-contract.md` for the host protocol; do not redefine it here.

## How to work here

- Keep code edits in `wt-zed`; it is intentionally one Bash executable.
- Keep plugin metadata in `wt-plugin.json` in sync with implemented events.
- Add or update bats tests in `tests/test_plugin.bats` for behavior changes.
- Run `bats tests/test_plugin.bats` and `bash -n wt-zed` before yielding.
- Never invent unsupported Zed close/focus behavior; document no-op until Zed CLI supports it.
- Never move plugin-contract details from git-wt into this repo.

## Docs index

- `README.md` — user-facing install, behavior, requirements, limitations.
- `CONTEXT.md` — maintainer invariants, module map, seams, ADRs.
- `CHANGELOG.md` — release history.
- `tests/test_plugin.bats` — plugin behavior tests.
- `wt-plugin.json` — manifest consumed by git-wt.
- git-wt `docs/plugin-contract.md` — source of truth for `git-wt.plugin.v0`.
- git-wt `docs/plugins.md` — plugin family comparison.

<!-- INDEX:START -->
<!-- Optional future agents-toc-managed index. -->
<!-- INDEX:END -->
