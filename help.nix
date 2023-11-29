{
  description = "A NixOS configuration made by a silly goose way over their head";

  # TODO: Move to it's own file
  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
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
    username = "goose";
    
    x64System = "x86_64-linux";
    x64SpecialArgs = {
      inherit username;

      pkgs-unstable = import nixpkgs-unstable {
        system = x64System;

        # Necessary for installing paid or non-free software
        config.allowUnfree = true;
      };
    };

    allSystems = [ x64System ];

    nixosSystem = import ./lib/nixos-system.nix;

    skein = {
      nixosModules = ./hosts/skein/os.nix;
      homeModules = ./hosts/skein/home.nix;
    };

    # gosling = {
    #   nixosModules = ./hosts/gosling/os.nix;
    #   homeModules = ./hosts/gosling/home.nix;
    # };

    # // inputs;
  in {
    nixosConfigurations = let
      baseArgs = {
        inherit home-manager nixos-generators;
        nixpkgs = nixpkgs; # TODO: nixpkgs-unstable?
        system = x64System;
        specialArgs = x64SpecialArgs;
      };
    in {
      skein = nixosSystem (skein // baseArgs);
      # gosling = nixosSystem (gosling // baseArgs);
    };

    packages."${x64System}" = nixpkgs.lib.genAttrs [
      "skein"
      # gosling
    ] (
      host: self.nixosConfigurations.${host}.config.formats.iso
    );

    # TODO: This might be wrong
    formatter = nixpkgs.lib.genAttrs allSystems (
      system: nixpkgs.legacyPackages.${system}.nixfmt
    );
  };
}
