{
  hosts,
  systems,
  disko,
  nixpkgs,
  nixos-generators,
  variables,
  ...
}: let
  configureInstaller = import ../lib/install/configure-installer.nix;

  args = {
    inherit (nixpkgs) lib;
    inherit disko nixos-generators nixpkgs variables;
  };
in
  nixpkgs.lib.genAttrs systems (
    system:
      nixpkgs.lib.genAttrs hosts (
        host:
          configureInstaller ({
              host = host;
              system = system;
            }
            // args)
      )
  )
