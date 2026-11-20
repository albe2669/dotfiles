# herdr popup: pick a branch/worktree with wt, open it as a herdr workspace.

set -eu
wt_bin="${HERDR_WT_BIN:?HERDR_WT_BIN not set}"
tmp=$(mktemp)
err=$(mktemp)
err_fifo=$(mktemp -u)
mkfifo "$err_fifo"
trap 'rm -f "$tmp" "$err" "$err_fifo"' EXIT

# -C keeps the picker scoped to this repo; --branches/--remotes list
# reviewable origin branches too; --no-cd + -x writes the resolved path
# without hijacking the popup's directory. wt paints its TUI on stderr;
# tee copies it to the terminal while keeping a capture for the fallback.
tee "$err" < "$err_fifo" >&2 &
tee_pid=$!
"$wt_bin" switch --branches --remotes --no-cd \
  -x sh -- -c 'printf %s "$1" > "$2"' sh '{{ worktree_path }}' "$tmp" 2> "$err_fifo" || true
wait "$tee_pid"

# Enter on a filter that matches nothing exits with a hint naming the query;
# fall back to creating a worktree for that branch so Enter works everywhere.
if [ ! -s "$tmp" ] && query=$(sed -n "s/.*No worktree matches '\([^']*\)' — use alt-c.*/\1/p" "$err") \
  && [ -n "$query" ]; then
  "$wt_bin" switch --create "$query" --no-cd \
    -x sh -- -c 'printf %s "$1" > "$2"' sh '{{ worktree_path }}' "$tmp"
fi

repo=$("$HERDR_BIN_PATH" worktree list --workspace "$HERDR_ACTIVE_WORKSPACE_ID" \
  | jq -r '.result.source.repo_root')

if [ -n "$repo" ] && [ "$repo" != "null" ]; then
  "$HERDR_BIN_PATH" worktree open --cwd "$repo" --path "$(cat "$tmp")" --focus --trust-repository
fi
