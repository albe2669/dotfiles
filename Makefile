vm:
	nix --extra-experimental-features "nix-command flakes" build --show-trace --option eval-cache false .#skein.vm
