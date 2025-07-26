{
  description = "A NixOS configuration made by a silly goose way over their head";

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
  };

  # These urls should coincide with the stateVersion variable in the variables.nix file
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05"; # Use stable for now
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprland = {
      url = "github:hyprwm/hyprland";
      # inputs.nixpkgs.follows = "nixpkgs-unstable"; # Commented so it uses the cache
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      # inputs.hyprland.follows = "hyprland"; # Commented so it uses the cache
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixos-generators,
    nixos-hardware,
    nixos-wsl,
    nixgl,
    home-manager,
    zen-browser,
    hyprland,
    hyprland-plugins,
    ...
  }: let
    specialArgs = import ./lib/special-args.nix {
      inherit inputs nixpkgs-unstable nixos-hardware zen-browser hyprland hyprland-plugins;

      variables = import ./variables.nix;
      theme = import ./theme.nix;
    };

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
        larry = import ./hosts/larry {};
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
