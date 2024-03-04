{
  nixpkgs,
  nixpkgs-unstable,
  nixos-generators,
  home-manager,
  self,
  ...
}: let 
  inherit (self) inputs;

  consts = import ../consts.nix;
  
  x64System = "x86_64-linux";

  x64SpecialArgs = {
    username = consts.username;

    pkgs-unstable = import nixpkgs-unstable {
      system = x64System;

      # Necessary for installing paid or non-free software
      config.allowUnfree = true;
    };
  };

  allSystems = [x64System];

  nixosSystem = import ../lib/nixos-system.nix;
  skein = {
    nixosModules = ./skein/os.nix;
    homeModules = ./skein/home.nix;
  };
in {
  nixosConfigurations = let
    baseArgs = {
      inherit home-manager nixos-generators;
      nixpkgs = nixpkgs;
      system = x64System;
      specialArgs = x64SpecialArgs;
    };
  in {
    skein = nixosSystem (skein // baseArgs);
  };

  packages."${x64System}" =
    nixpkgs.lib.genAttrs [
      "skein"
      # gosling
    ] (
      host: self.nixosConfigurations.${host}.config.formats
    );

  allSystems = allSystems;
}
