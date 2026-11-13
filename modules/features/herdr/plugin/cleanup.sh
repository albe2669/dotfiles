#!/usr/bin/env bash
# herdr plugin event hook: when a workspace backed by a git worktree closes,
# remove the worktree directory if it has no uncommitted changes. Branches
# are never deleted.
set -uo pipefail

event_json="${HERDR_PLUGIN_EVENT_JSON:-}"
[ -n "$event_json" ] || exit 0

checkout=$(printf '%s' "$event_json" | jq -r '.data.workspace.worktree.checkout_path // empty')
[ -n "$checkout" ] || exit 0

# Only linked worktrees (herdr's grouped children), not primary checkouts.
is_linked=$(printf '%s' "$event_json" | jq -r '.data.workspace.worktree.is_linked_worktree')
[ "$is_linked" = "true" ] || exit 0

[ -d "$checkout/.git" ] || [ -f "$checkout/.git" ] || exit 0

if [ -n "$(git -C "$checkout" status --porcelain 2>/dev/null)" ]; then
  echo "worktree $checkout has uncommitted changes; leaving it in place" >&2
  exit 0
fi

wt_bin="${HERDR_WT_BIN:-wt}"
if ! command -v "$wt_bin" >/dev/null 2>&1; then
  echo "wt not found; leaving $checkout in place" >&2
  exit 0
fi

branch=$(git -C "$checkout" branch --show-current 2>/dev/null)
if [ -z "$branch" ]; then
  echo "$checkout is on a detached HEAD; leaving it in place" >&2
  exit 0
fi

# -C makes wt resolve the repo from the closing checkout, not the plugin dir.
"$wt_bin" -C "$checkout" remove "$branch" --no-delete-branch --foreground \
  || echo "wt remove failed for $checkout; remove it manually" >&2
exit 0
