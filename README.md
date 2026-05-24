# wt-zed

Zed editor integration for [`git-wt`](https://github.com/noamsiegel/git-wt).

`wt-zed` is a `git-wt.plugin.v0` plugin. When `git-wt` creates a new worktree, the plugin opens that worktree in Zed with:

```sh
zed -n <worktree-path>
```

`-n` asks Zed to open the project in a new window. The plugin intentionally does not use `zed --add`, which may add the worktree to the current window instead.

When a worktree is removed, `wt-zed` returns a best-effort no-op because Zed's documented CLI supports opening projects but does not expose a non-interactive close-workspace command.

## Install

Once `wt-zed` is in the `git-wt` plugin registry:

```sh
wt plugin install zed
```

Explicit install from GitHub:

```sh
wt plugin install noamsiegel/wt-zed
```

## Requirements

- `git-wt` with plugin support
- Zed CLI on `PATH` for opening worktrees (`zed`)
- `python3` or `yq` for parsing event payload JSON

`wt-zed health` reports whether `zed` is currently available.

## Commands

```sh
wt-zed manifest
wt-zed health
wt-zed event wt:worktree-created < payload.json
wt-zed event wt:worktree-removed < payload.json
```

## Manifest

The plugin manifest is `wt-plugin.json` next to the executable:

```json
{
  "name": "zed",
  "executable": "wt-zed",
  "api_versions": ["git-wt.plugin.v0"],
  "events": ["wt:worktree-created", "wt:worktree-removed"],
  "capabilities": [],
  "version": "0.1.0",
  "source": "https://github.com/noamsiegel/wt-zed",
  "description": "Zed editor integration for git-wt"
}
```
