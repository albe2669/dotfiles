# Make the host the one in /etc/hostname
host != cat /etc/hostname
# If not found, use skein
host ?= skein

repl:
	nix --extra-experimental-features "nix-command flakes repl-flake" --show-trace repl

show:
	nix --extra-experimental-features "nix-command flakes" flake show

fmt:
	nix --extra-experimental-features "nix-command flakes" fmt *

update:
	nix --extra-experimental-features "nix-command flakes" flake update

build:
	sudo nixos-rebuild build --show-trace --flake .#$(host)

rebuild:
	sudo nixos-rebuild switch --show-trace --flake .#$(host)

upgrade: update rebuild

vm:
	rm -rf result
	rm -f $(host).qcow2
	nix --extra-experimental-features "nix-command flakes" build --show-trace --option eval-cache false .#$(host).vm

iso:
	nix --extra-experimental-features "nix-command flakes" build --show-trace --option eval-cache false .#$(host).install-iso

installer:
	nix --extra-experimental-features "nix-command flakes" build --show-trace --option eval-cache false .#installers.x86_64-linux.$(host)

hms:
	NIXPKGS_ALLOW_UNFREE=1 home-manager switch -b backup --extra-experimental-features "nix-command flakes repl-flake" --show-trace --impure --flake .#$(host)

nixprofiles != ls -dv /nix/var/nix/profiles/system-*-link/|tail -2
homeprofiles != ls -dv ~/.local/state/nix/profiles/home-manager-*-link/|tail -2
show-diff:
	# ======== System diff ======== ";
	nix store diff-closures $(nixprofiles);

	# ======== home-manager diff ======== ";
	nix store diff-closures $(homeprofiles)
