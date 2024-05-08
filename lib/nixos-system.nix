{
  nixpkgs,
  home-manager,
  nixos-generators,
  system,
  specialArgs,
  host,
  disko,
}: let
  username = specialArgs.username;
in
  nixpkgs.lib.nixosSystem {
    inherit system specialArgs;
    modules = [
      host.configuration.nixosModules
      disko.nixosModules.disko
      {
        # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
        nix.registry.nixpkgs.flake = nixpkgs;

        # make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
        environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";
        nix.nixPath = ["/etc/nix/inputs"];
      }

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.extraSpecialArgs = specialArgs;
        home-manager.users."${username}" = {
          imports = [
            host.configuration.homeModules
          ];

          _module.args = {
            # theme = import ../colors.nix;
          };
        };
      }

      nixos-generators.nixosModules.all-formats
      {
      }
    ];
  }
