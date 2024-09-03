{
  nixpkgs,
  nixpkgs-unstable,
  nixos-generators,
  home-manager,
  disko,
  variables,
  theme,
  self,
  ...
}: let
  x64System = "x86_64-linux";

  x64SpecialArgs = {
    inherit variables theme;

    username = variables.username;

    pkgs-unstable = import nixpkgs-unstable {
      system = x64System;

      # Necessary for installing paid or non-free software
      config.allowUnfree = true;

      config.permittedInsecurePackages = [
        "electron-29.4.6"
      ];
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
      info = (import ./skein/info.nix) {};
      nixosModules = ./skein/os.nix;
      homeModules = ./skein/home.nix;
    };
    gosling = {
      info = (import ./gosling/info.nix) {};
      nixosModules = ./gosling/os.nix;
      homeModules = ./gosling/home.nix;
    };
  };

  hosts =
    builtins.mapAttrs (host: hostConf: {
      name = hostConf.info.name;
      disko = hostConf.info.disko;
      diskPath = hostConf.info.diskPath;
      configuration = {
        inherit (hostConf) nixosModules homeModules;
      };
    })
    configurations;
in {
  nixosConfigurations =
    builtins.mapAttrs (
      _: hostConf:
        nixosSystem ({host = hostConf;} // baseArgs)
    )
    hosts;

  packages."${x64System}" =
    builtins.mapAttrs (
      _: hostConf:
        self.nixosConfigurations.${hostConf.name}.config.formats
    )
    hosts;

  hosts = hosts;

  allSystems = allSystems;
}
