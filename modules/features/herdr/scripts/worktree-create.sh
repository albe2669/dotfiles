# herdr popup command: create a project-local git worktree and copy
# dotfiles into it, then let herdr register the checkout as a workspace.

set -eu

function branch_exists() {
  git rev-parse --verify "$1" > /dev/null 2>&1
}

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

workspace_info=$("$HERDR_BIN_PATH" worktree list --workspace "$HERDR_WORKSPACE_ID")
workspace_id=$(echo $workspace_info | jq -r '.result.source.source_workspace_id')

src=$(echo $workspace_info | jq -r '.result.source.repo_root')
wtroot="$src/.worktrees"
checkout="$wtroot/$branch"

if [ -e "$checkout" ]; then
  echo "already exists: $checkout" >&2
  exit 1
fi

mkdir -p "$wtroot"

# Create the worktree through herdr's API so it shows up in the workspace
# list. --path must be absolute; --base comes from HERDR_WORKTREE_BASE.
base="origin/main"
if ! branch_exists "$base"; then
  echo "base branch does not exist: $base" >&2
  base="origin/master"
  echo "trying $base instead"
fi
if ! branch_exists "$base"; then
  echo "base branch does not exist: $base" >&2
  exit 1
fi

result=$("$HERDR_BIN_PATH" worktree create --workspace $workspace_id --branch "$branch" --base "$base" --path "$checkout" --focus)

if [ $? -ne 0 ]; then
  # herdr prints the error JSON to stderr already.
  rmdir "$wtroot" 2>/dev/null || true
  exit 1
fi

workspace_id=$(echo "$result" | jq -r '.result.workspace.workspace_id')
pane_id=$(echo "$result" | jq -r '.result.root_pane.pane_id')
result_dir=$(echo "$result" | jq -r '.result.worktree.path')

# herdr creates the new branch tracking origin/main. Drop the tracking so the first push sets up origin/$branch.
git -C "$result_dir" branch --unset-upstream

# Copy dotfiles/dirs from the source checkout into the new worktree.
for f in ${HERDR_WORKTREE_COPY_FILES:-}; do
  src_path="$src/$f"
  [ -e "$src_path" ] || continue
  dest_dir="$result_dir/$(dirname "$f")"
  mkdir -p "$dest_dir"
  cp -R "$src_path" "$dest_dir/"
done

"$HERDR_BIN_PATH" pane run "$pane_id" "nvim"
result=$("$HERDR_BIN_PATH" pane split "$pane_id" --direction right)
pane_id=$(echo "$result" | jq -r '.result.pane.pane_id')
"$HERDR_BIN_PATH" pane run "$pane_id" "omp"


echo "worktree ready: $checkout"
