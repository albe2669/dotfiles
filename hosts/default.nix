{
  nixpkgs,
  nixpkgs-unstable,
  nixos-generators,
  home-manager,
  disko,
  variables,
  self,
  ...
}: let
  x64System = "x86_64-linux";

  x64SpecialArgs = {
    inherit variables;

    username = variables.username;

    pkgs-unstable = import nixpkgs-unstable {
      system = x64System;

      # Necessary for installing paid or non-free software
      config.allowUnfree = true;
    };
  };

  allSystems = [x64System];

  nixosSystem = import ../lib/nixos-system.nix;

  baseArgs = {
    inherit home-manager nixpkgs nixos-generators disko;
    system = x64System;
    specialArgs = x64SpecialArgs;
  };

  configurations = {
    skein = {
      nixosModules = ./skein/os.nix;
      homeModules = ./skein/home.nix;
    };
  };

  hosts = builtins.attrNames configurations;
in {
  nixosConfigurations = nixpkgs.lib.genAttrs hosts (
    host: nixosSystem (configurations.${host} // baseArgs)
  );

  packages."${x64System}" = nixpkgs.lib.genAttrs hosts (
    host: self.nixosConfigurations.${host}.config.formats
  );

  hosts = hosts;

  allSystems = allSystems;
}
