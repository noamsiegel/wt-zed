#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  export PATH="$BATS_TEST_TMPDIR/bin:/usr/bin:/bin"
  mkdir -p "$BATS_TEST_TMPDIR/bin"
  cat > "$BATS_TEST_TMPDIR/bin/python3" <<'SH'
#!/usr/bin/env bash
exec /opt/homebrew/bin/python3 "$@"
SH
  chmod +x "$BATS_TEST_TMPDIR/bin/python3"
  rm -f "$BATS_TEST_TMPDIR/bin/zed" "$BATS_TEST_TMPDIR/zed.args"
}

@test "manifest outputs valid plugin metadata" {
  run "$REPO_ROOT/wt-zed" manifest
  [ "$status" -eq 0 ]

  manifest="$output" python3 - <<'PY'
import json
import os

data = json.loads(os.environ["manifest"])
assert data["name"] == "zed"
assert data["executable"] == "wt-zed"
assert data["api_versions"] == ["git-wt.plugin.v0"]
assert data["events"] == ["wt:worktree-created", "wt:worktree-removed"]
assert data["capabilities"] == []
assert data["version"] == "0.1.2"
PY
}

@test "health reports ok and zed availability" {
  run "$REPO_ROOT/wt-zed" health
  [ "$status" -eq 0 ]

  health="$output" python3 - <<'PY'
import json
import os

data = json.loads(os.environ["health"])
assert data["ok"] is True
assert data["version"] == "0.1.2"
assert isinstance(data["zed_available"], bool)
PY
}

@test "created event opens worktree with zed -n and exits zero" {
  zed_args="$BATS_TEST_TMPDIR/zed.args"
  cat > "$BATS_TEST_TMPDIR/bin/zed" <<SH
#!/usr/bin/env bash
printf '%s\\n' "\$@" > "$zed_args"
SH
  chmod +x "$BATS_TEST_TMPDIR/bin/zed"

  run bash -c '"$1" event wt:worktree-created <<JSON
{"api_version":"git-wt.plugin.v0","event":"wt:worktree-created","repo":"repo","worktree":{"id":"feature","path":"/tmp/wt-zed-test","branch":"feature/test"},"timestamp":"2026-05-24T00:00:00Z"}
JSON' _ "$REPO_ROOT/wt-zed"
  for _ in 1 2 3 4 5; do
    [[ -f "$BATS_TEST_TMPDIR/zed.args" ]] && break
    sleep 0.1
  done
  [ "$status" -eq 0 ]

  run python3 - <<'PY'
from pathlib import Path
args = Path(__import__("os").environ["BATS_TEST_TMPDIR"], "zed.args").read_text().splitlines()
assert args == ["-n", "/tmp/wt-zed-test"]
PY
  [ "$status" -eq 0 ]
}

@test "created event is noop without zed and exits zero" {
  run bash -c '"$1" event wt:worktree-created <<JSON
{"worktree":{"path":"/tmp/wt-zed-test"}}
JSON' _ "$REPO_ROOT/wt-zed"
  [ "$status" -eq 0 ]
  [[ "$output" == *'"reason":"zed-not-found"'* ]]
}

@test "removed event is best-effort noop" {
  run bash -c '"$1" event wt:worktree-removed <<JSON
{"worktree":{"path":"/tmp/wt-zed-test"}}
JSON' _ "$REPO_ROOT/wt-zed"
  [ "$status" -eq 0 ]
  [[ "$output" == *'"reason":"zed-close-workspace-not-supported"'* ]]
}
