#!/usr/bin/env bash

set -euo pipefail

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Find the newest build
newest_build=$(sqlite3 /nix/var/nix/db/db.sqlite "SELECT path FROM ValidPaths WHERE path LIKE '%goland-with-plugins-%' ORDER BY id DESC LIMIT 1;")
if [[ -z "$newest_build" ]]; then
    echo "No valid build found"
    exit 1
fi

execs=$(find -L $newest_build/* -name "*copilot-language-server*")
if [[ -z "$execs" ]]; then
    echo "No copilot-language-server executable found in the newest build"
    exit 1
fi

for exec in $execs; do
    if [[ $exec != *"darwin"* ]]; then
        echo "Skipping non-Darwin executable: $exec"
        continue
    fi

    echo "Fixing executable: $exec"
    sudo xattr -dr com.apple.quarantine "$exec"
    sudo chmod +x "$exec"
done

echo "Successfully fixed the newest build: $newest_build"
