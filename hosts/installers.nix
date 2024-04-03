{
	hosts,
	systems,
	disko,
	nixpkgs,
	nixos-generators,
  ...
}: let
	consts = import ../consts.nix;
	configureInstaller = import ../lib/install/configure-installer.nix;

	args = {
    inherit (nixpkgs) lib;
		inherit (consts) dotfilesLocation;
		inherit disko nixos-generators nixpkgs;
	};
in 
	nixpkgs.lib.genAttrs systems (
    system: nixpkgs.lib.genAttrs hosts (
      host: configureInstaller ({ host = host; system = system; } // args)
    )
  )
