#!/usr/bin/env bash
set -uo pipefail

dotfiles="$(git rev-parse --show-toplevel)"

# Only attempt hosts that match the current system.
case "$(uname -s)-$(uname -m)" in
  Linux-x86_64) hosts=(gander gosling skein larry);;
  Darwin-arm64) hosts=(nene brant);;
  Darwin-x86_64) hosts=(nene barnacle brant);;
  *) hosts=();;
esac

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
