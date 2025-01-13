{
  description = "A NixOS configuration made by a silly goose way over their head";

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
  };

  # These urls should coincide with the stateVersion variable in the variables.nix file
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11"; # Use stable for now
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixos-generators,
    nixos-hardware,
    home-manager,
    zen-browser,
    ...
  }: let
    extraArgs = {
      variables = import ./variables.nix;
      theme = import ./theme.nix;
    };

    specialArgs = import ./lib/special-args.nix ({
        inherit nixpkgs-unstable nixos-hardware zen-browser;
      }
      // extraArgs);

    configurations =
      builtins.mapAttrs (_: hostConf: {
        inherit (hostConf) info nixosModules homeModules;
        homeManager = import ./lib/home-manager.nix {
          inherit nixpkgs home-manager;
          specialArgs = specialArgs.x64SpecialArgs;
          host = hostConf;
        };
      }) {
        gander = import ./hosts/gander {};
        gosling = import ./hosts/gosling {};
        skein = import ./hosts/skein {};
      };

    osConfigurations =
      nixpkgs.lib.filterAttrs (_: hostConf: builtins.hasAttr "nixosModules" hostConf) configurations;

    args =
      {
        inherit specialArgs home-manager;

        configurations = osConfigurations;
      }
      // inputs;

    hosts = import ./hosts args;
    installers = import ./hosts/installers.nix ({
        hosts = hosts.hosts;
        systems = hosts.allSystems;
      }
      // args);
  in {
    confs = configurations;
    homeConfigurations =
      builtins.mapAttrs (
        _: hostConf:
          hostConf.homeManager.configuration
      )
      configurations;
    hosts = hosts;
    nixosConfigurations = hosts.nixosConfigurations;
    packages = hosts.packages;
    installers = installers;

    formatter = nixpkgs.lib.genAttrs hosts.allSystems (
      system: nixpkgs.legacyPackages.${system}.alejandra
    );
  };
}
