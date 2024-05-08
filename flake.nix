{
  description = "A NixOS configuration made by a silly goose way over their head";

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
  };

  # These urls should coincide with the stateVersion variable in the variables.nix file
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11"; # Use stable for now
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
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
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixos-generators,
    home-manager,
    ...
  }: let
    args =
      {
        variables = import ./variables.nix;
      }
      // inputs;

    hosts = import ./hosts args;
    installers = import ./hosts/installers.nix ({
        hosts = hosts.hosts;
        systems = hosts.allSystems;
      }
      // args);
  in {
    hosts = hosts;
    nixosConfigurations = hosts.nixosConfigurations;
    packages = hosts.packages;
    installers = installers;

    formatter = nixpkgs.lib.genAttrs hosts.allSystems (
      system: nixpkgs.legacyPackages.${system}.alejandra
    );
  };
}
