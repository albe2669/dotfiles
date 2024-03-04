{
  description = "A NixOS configuration made by a silly goose way over their head";

  # TODO: Move to it's own file
  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
  };

  # FIXME: Different file?
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11"; # Use stable for now
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
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
    hosts = import ./hosts inputs;
  in {
    nixosConfigurations = hosts.nixosConfigurations;
    packages = hosts.packages;
    
    # TODO: This might be wrong
    formatter = nixpkgs.lib.genAttrs hosts.allSystems (
      system: nixpkgs.legacyPackages.${system}.alejandra
    );
  };
}
