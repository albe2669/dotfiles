# Detect OS
os != uname -s

# Make the host the one in /etc/hostname (Linux) or scutil (macOS)
ifeq ($(os),Darwin)
host != scutil --get LocalHostName 2>/dev/null || hostname -s
else
host != cat /etc/hostname
endif
# If not found, use skein
# Detect nom for pretty build output. Falls back to empty so nix keeps TTY colors.
nom != command -v nom 2>/dev/null || true
nom_pipe = $(if $(nom),--log-format internal-json -v |& nom --json,)

repl:
	nix --extra-experimental-features "nix-command flakes repl-flake" --show-trace repl

show:
	nix --extra-experimental-features "nix-command flakes" flake show

fmt:
	nix --extra-experimental-features "nix-command flakes" fmt *

update:
	nix --extra-experimental-features "nix-command flakes" flake update --option access-token "github.com=$(gh auth token)"

build:
ifeq ($(os),Darwin)
	sudo darwin-rebuild build --show-trace --flake .#$(host) $(nom_pipe)
else
	sudo nixos-rebuild build --show-trace --flake .#$(host) $(nom_pipe)
endif

rebuild:
ifeq ($(os),Darwin)
	sudo darwin-rebuild switch --show-trace --flake .#$(host) $(nom_pipe)
else
	sudo nixos-rebuild switch --show-trace --flake .#$(host) $(nom_pipe)
endif

darwin-rebuild:
	darwin-rebuild switch --show-trace --flake .#$(host) $(nom_pipe)

upgrade: update rebuild

vm:
	rm -rf result
	rm -f $(host).qcow2
	nix --extra-experimental-features "nix-command flakes" build --show-trace --option eval-cache false .#$(host).vm $(nom_pipe)

iso:
	nix --extra-experimental-features "nix-command flakes" build --show-trace --option eval-cache false .#$(host).install-iso $(nom_pipe)

installer:
	nix --extra-experimental-features "nix-command flakes" build --show-trace --option eval-cache false .#installers.x86_64-linux.$(host) $(nom_pipe)

hms:
	NIXPKGS_ALLOW_UNFREE=1 home-manager switch -b backup --extra-experimental-features "nix-command flakes repl-flake" --show-trace --impure --flake .#$(host)

nixprofiles != ls -dv /nix/var/nix/profiles/system-*-link/|tail -2
homeprofiles != ls -dv ~/.local/state/nix/profiles/home-manager-*-link/|tail -2
show-diff:
	# ======== System diff ======== ";
	nix store diff-closures $(nixprofiles);

	# ======== home-manager diff ======== ";
	nix store diff-closures $(homeprofiles)
