{
	hosts,
	systems,
	disko,
	nixpkgs,
	nixos-generators,
  ...
}: let
	configureInstaller = import ../lib/install/configure-installer.nix;

	args = {
    inherit (nixpkgs) lib;
		inherit disko nixos-generators nixpkgs;
	};
in 
	nixpkgs.lib.genAttrs systems (
    system: nixpkgs.lib.genAttrs hosts (
      host: configureInstaller ({ host = host; system = system; } // args)
    )
  )
