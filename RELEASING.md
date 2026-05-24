# Releasing wt-zed

Use this checklist from a clean `main` checkout.

1. Pick `X.Y.Z` and verify the tree is ready:
   ```sh
   bats tests/
   bash -n wt-zed
   git status --short
   ```
2. Bump version in both release-bearing files:
   - `VERSION="X.Y.Z"` in `wt-zed`
   - `"version": "X.Y.Z"` in `wt-plugin.json`
3. Re-run `bats tests/`; the version-match test must prove those values match.
4. Prepend a flat `## X.Y.Z` entry to `CHANGELOG.md`; do not use `## [X.Y.Z]` or keepachangelog subheadings.
5. Review the final diff and confirm `git status --short` only shows intended release files.
6. Commit, tag, and push in this order:
   ```sh
   git add -A
   git commit -m "Release wt-zed vX.Y.Z"
   git tag -a vX.Y.Z -m "wt-zed vX.Y.Z"
   git push origin main
   git push origin vX.Y.Z
   ```
7. Create the GitHub release after both pushes succeed:
   ```sh
   gh release create vX.Y.Z --notes "..."
   ```
8. Smoke the released manifest locally:
   ```sh
   ~/Documents/GitHub/wt-zed/wt-zed manifest | yq -p json '.version'
   ```
   It must print `X.Y.Z`.

## Recovery

- If a stale `guardrails` shim breaks push, inspect `.git/hooks/pre-push`, remove the stale shim stanza, reinstall the current hooks if needed, then re-run the failed push.
- If tag push fails or the remote tag points at the wrong commit, stop before `gh release create`; delete the bad local/remote tag, recreate it on the release commit, then push `main` and `vX.Y.Z` again.
- If `gh release create` ran against a bad tag, delete or correct the GitHub release, fix the tag alignment first, then recreate the release notes.
- If the version-match test catches drift, bump whichever file you forgot, then re-run `bats tests/` and `bash -n wt-zed`.
