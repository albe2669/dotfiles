#!/usr/bin/env bash
set -uo pipefail

dotfiles="$(git rev-parse --show-toplevel)"

case "$(uname -s)-$(uname -m)" in
  Linux-x86_64) sys=x86_64-linux;;
  Darwin-arm64) sys=aarch64-darwin;;
  Darwin-x86_64) sys=x86_64-darwin;;
  *) echo "Unsupported system" >&2; exit 1;;
esac

mapfile -t lines < <(nix eval --raw ".#readmeSystems" --apply '
  s: builtins.concatStringsSep "\n" (map (name: "${builtins.getAttr name s} ${name}") (builtins.attrNames s))' \
  --extra-experimental-features 'nix-command flakes' 2>/dev/null) || {
  echo "Failed to eval readmeSystems" >&2
  exit 1
}

hosts=()
for line in "${lines[@]}"; do
  set -- $line
  [ "$1" = "$sys" ] && hosts+=("$2")
done
[ ${#hosts[@]} -eq 0 ] && { echo "No hosts for $sys" >&2; exit 1; }

failed=0
for host in "${hosts[@]}"; do
  readme="$dotfiles/hosts/$host/README.md"
  path=$(nix build ".#hostReadmes.$host" --no-link --print-out-paths --extra-experimental-features 'nix-command flakes' 2>/dev/null) || {
    echo "Skipped $host (build failed)" >&2
    failed=1
    continue
  }
  if [ -f "$path/README.md" ]; then
    cp "$path/README.md" "$readme"
    echo "Generated $readme"
  else
    echo "No README.md in build output for $host" >&2
    failed=1
  fi
done

exit $failed
