vm:
	nix --extra-experimental-features "nix-command flakes" build --show-trace --option eval-cache false .#skein.vm

iso:
	nix --extra-experimental-features "nix-command flakes" build --show-trace --option eval-cache false .#skein.install-iso

iso-gosling:
	nix --extra-experimental-features "nix-command flakes" build --show-trace --option eval-cache false .#gosling.install-iso

show:
	nix --extra-experimental-features "nix-command flakes" flake show

installer-skein:
	nix --extra-experimental-features "nix-command flakes" build --show-trace --option eval-cache false .#installers.x86_64-linux.skein

repl:
	nix --extra-experimental-features "nix-command flakes repl-flake" repl

fmt:
	nix --extra-experimental-features "nix-command flakes" fmt
