vm:
	nix --extra-experimental-features "nix-command flakes" build --option eval-cache false .#skein.vm
