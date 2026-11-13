# herdr popup: pick a branch/worktree with wt, open it as a herdr workspace.

set -eu
wt_bin="${HERDR_WT_BIN:?HERDR_WT_BIN not set}"
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

# -C keeps the picker scoped to this repo; --branches/--remotes list
# reviewable origin branches too; --no-cd + -x writes the resolved path
# without hijacking the popup's directory.
"$wt_bin" switch --branches --remotes --no-cd \
  -x sh -- -c 'printf %s "$1" > "$2"' sh '{{ worktree_path }}' "$tmp"

# the picker was cancelled or the switch failed before producing a path
[ -s "$tmp" ] || exit 0

repo=$("$HERDR_BIN_PATH" worktree list --workspace "$HERDR_ACTIVE_WORKSPACE_ID" \
  | jq -r '.result.source.repo_root')

if [ -n "$repo" ] && [ "$repo" != "null" ]; then
  "$HERDR_BIN_PATH" worktree open --cwd "$repo" --path "$(cat "$tmp")" --focus --trust-repository
fi
