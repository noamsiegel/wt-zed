# wt-zed

Zed editor integration for [`git-wt`](https://github.com/noamsiegel/git-wt).

`wt-zed` does one thing: open new git-wt worktrees in a new Zed window. It implements `git-wt.plugin.v0`; the protocol source of truth is git-wt's [`docs/plugin-contract.md`](https://github.com/noamsiegel/git-wt/blob/main/docs/plugin-contract.md). Plugin-family comparison lives in git-wt's [`docs/plugins.md`](https://github.com/noamsiegel/git-wt/blob/main/docs/plugins.md).

## Install

From the git-wt registry:

```sh
wt plugin install zed
```

Explicit install from GitHub:

```sh
wt plugin install noamsiegel/wt-zed
```

Local development:

```sh
wt plugin link /path/to/wt-zed
```

## Behavior

| git-wt event | Zed action |
|---|---|
| `wt:worktree-created` | Run `zed -n <worktree-path>` to open the worktree in a new Zed window. |
| `wt:worktree-removed` | Return best-effort `noop`; Zed's documented CLI does not expose non-interactive close-workspace. |

`-n` asks Zed to open the project in a new window. The plugin intentionally does not use `zed --add`, which may add the worktree to the current window instead.

## Requirements

- `git-wt` with `git-wt.plugin.v0` support.
- Zed CLI on `PATH` as `zed`.
- `python3` or `yq` for parsing event payload JSON.

`wt-zed health` reports whether `zed` is currently available.

## Commands

```sh
wt-zed manifest
wt-zed health
wt-zed event wt:worktree-created < payload.json
wt-zed event wt:worktree-removed < payload.json
```

## Environment

No plugin-specific environment variables today. Configure Zed through Zed's own CLI/settings surface.

## What it doesn't do

- Does not define the git-wt plugin API; git-wt owns `git-wt.plugin.v0`.
- Does not install, update, or configure Zed.
- Does not close Zed windows on worktree removal; Zed has no documented non-interactive close command.
- Does not focus existing Zed windows or answer `wt:list`.
- Does not manage git worktree naming, branch policy, or cleanup policy.

## Development

```sh
bats tests/test_plugin.bats
bash -n wt-zed
```

## License

MIT. See [LICENSE](./LICENSE).
