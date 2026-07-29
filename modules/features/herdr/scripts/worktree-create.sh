# herdr popup command: create a project-local git worktree and copy
# dotfiles into it, then let herdr register the checkout as a workspace.

set -eu

printf 'branch: '
read -r branch

if [ -z "$branch" ]; then
  echo 'no branch name given' >&2
  exit 1
fi

# Reject names that could escape the worktree path.
case "$branch" in
  *..*|"") echo "invalid branch name: $branch" >&2; exit 1 ;;
esac

src="${HERDR_ACTIVE_PANE_CWD:-$(pwd)}"
wtroot="$src/.worktrees"
checkout="$wtroot/$branch"

if [ -e "$checkout" ]; then
  echo "already exists: $checkout" >&2
  exit 1
fi

mkdir -p "$wtroot"

# Create the worktree through herdr's API so it shows up in the workspace
# list. --path must be absolute; --base comes from HERDR_WORKTREE_BASE.
base="${HERDR_WORKTREE_BASE:-main}"
if ! "$HERDR_BIN_PATH" worktree create \
    --branch "$branch" \
    --base "$base" \
    --path "$checkout" \
    >/dev/null; then
  # herdr prints the error JSON to stderr already.
  rmdir "$wtroot" 2>/dev/null || true
  exit 1
fi

# Copy dotfiles/dirs from the source checkout into the new worktree.
for f in ${HERDR_WORKTREE_COPY_FILES:-}; do
  src_path="$src/$f"
  [ -e "$src_path" ] || continue
  dest_dir="$checkout/$(dirname "$f")"
  mkdir -p "$dest_dir"
  cp -R "$src_path" "$dest_dir/"
done

echo "worktree ready: $checkout"
