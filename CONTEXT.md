# wt-zed CONTEXT

Architecture context for agents working on `wt-zed` itself. User-facing docs live in `README.md`; the plugin protocol lives in git-wt's `docs/plugin-contract.md`.

## Load-bearing invariants

1. **git-wt owns the contract**: this repo implements `git-wt.plugin.v0`; it does not define manifest schema, event vocabulary, or validation rules. See `wt-plugin.json` and `wt-zed` (`cmd_manifest`, `cmd_event`).
2. **Manifest and executable stay in lockstep**: `wt-plugin.json` names `zed`, executable `wt-zed`, and events `wt:worktree-created` plus `wt:worktree-removed`; the script must keep matching handlers.
3. **Open uses a new Zed window**: created worktrees run `zed -n <worktree-path>`, not `zed --add`, so worktrees do not attach to an existing window by surprise.
4. **Removal is explicitly best-effort no-op**: Zed's documented CLI does not expose non-interactive close-workspace. `wt:worktree-removed` must stay honest and return `zed-close-workspace-not-supported` until Zed adds a supported close surface.
5. **Missing Zed CLI is non-fatal for lifecycle events**: `wt-zed` should not break git-wt operations because editor CLI is unavailable; created events return `noop`.

## Module map

```
wt-zed                   bash executable: subcommands, JSON parsing, Zed launch, event handlers
wt-plugin.json           plugin manifest consumed by git-wt
tests/test_plugin.bats   bats coverage for manifest, health, created, removed
README.md                user-facing behavior, requirements, env vars, limitations
CHANGELOG.md             release notes
```

## Real seams

- Event handlers are the real seams: created opens a Zed window; removed documents/returns unsupported close behavior.
- JSON extraction is a practical seam because the plugin supports `python3` first and `yq` fallback for worktree path parsing.

## Hypothetical seams

- Do not add focus/list handlers until Zed exposes a supported non-interactive API worth calling.
- Do not extract a shared shell plugin framework. Three plugins duplicate a tiny subcommand shell; the contract is still settling and a shared runtime dependency would be heavier than the duplication.
- Do not move protocol documentation into this repo. git-wt is the host and contract authority.

## Public API stability

No library API. The public surface is the executable CLI (`manifest`, `health`, `event <name>`) plus `wt-plugin.json`. Breaking changes require a plugin release and matching git-wt compatibility note.

## ADRs

ADR-001 — use `zed -n`: new worktrees open in their own Zed window; `--add` is avoided because it can attach to the current window.

ADR-002 — no close-workspace emulation: removal stays a JSON no-op until Zed documents a non-interactive close command.
