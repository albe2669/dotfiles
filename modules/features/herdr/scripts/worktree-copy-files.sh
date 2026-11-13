# worktrunk post-start hook: copy dotfiles from the source checkout into
# the new worktree. Args: $1 = source checkout, $2 = destination worktree,
# $3... = files (relative paths, may name directories).

set -eu
src=$1
dest=$2
shift 2

for f in "$@"; do
  [ -e "$src/$f" ] || continue
  mkdir -p "$dest/$(dirname "$f")"
  cp -R "$src/$f" "$dest/$f"
done
