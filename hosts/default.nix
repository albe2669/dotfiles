{
  self,
  inputs,
  config,
  lib,
  ...
}: let
  allHosts = [
    "gander"
    "gosling"
    "skein"
    "larry"
    "nene"
    "barnacle"
  ];

  hostInfos = builtins.listToAttrs (map (host: {
      name = host;
      value = import ./${host}/info.nix;
    })
    allHosts);

  isDarwinSystem = system: builtins.match ".*-darwin" system != null;

  linuxHosts = lib.filterAttrs (_: info: !(isDarwinSystem info.system)) hostInfos;
  darwinHosts = lib.filterAttrs (_: info: isDarwinSystem info.system) hostInfos;

  mkInfoModule = info: {lib, ...}: {
    options.opts.info = {
      name = lib.mkOption {
        type = lib.types.str;
        default = info.name;
        description = "System name";
      };
      system = lib.mkOption {
        type = lib.types.str;
        default = info.system;
        description = "System architecture";
      };
    };
  };

  mkSpecialArgs = system: rec {
    inherit self inputs system;

    username = config.opts.variables.username;

    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;

      config.allowUnfree = true;

      config.permittedInsecurePackages = [
        "electron-29.4.6"
      ];

      overlays = import ../overlays {};
    };

    pkgs-goland = import inputs.nixpkgs-goland {
      inherit system;
      config.allowUnfree = true;
    };
  };

  sharedModules = [
    ../variables.nix
    ../theme.nix
    ../overlays/lix.nix

    {
      nix.registry.nixpkgs.flake = inputs.nixpkgs;
    }
  ];

  createNixosConfiguration = name: info: let
    system = info.system;
    specialArgs = mkSpecialArgs system;
  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system specialArgs;

      modules =
        sharedModules
        ++ [
          (mkInfoModule info)

          self.nixosModules.state
          self.nixosModules.stylix
          self.nixosModules.sops
          (import ../modules/nixos/home.nix {inherit specialArgs;})

          inputs.disko.nixosModules.disko

          inputs.nixos-generators.nixosModules.all-formats

          {
            environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
            nix.nixPath = ["/etc/nix/inputs"];
          }

          ./${name}
        ];
    };

  createDarwinConfiguration = name: info: let
    system = info.system;
    specialArgs = mkSpecialArgs system;
  in
    inputs.nix-darwin.lib.darwinSystem {
      inherit system specialArgs;

      modules =
        sharedModules
        ++ [
          (mkInfoModule info)

          {
            opts.variables.isDarwin = true;
          }

          self.darwinModules.state
          self.darwinModules.stylix
          self.darwinModules.sops
          (import ../modules/darwin/home.nix {inherit specialArgs;})

          ./${name}
        ];
    };

  nixosConfigurations = builtins.mapAttrs createNixosConfiguration linuxHosts;
  darwinConfigurations = builtins.mapAttrs createDarwinConfiguration darwinHosts;

  installers =
    builtins.mapAttrs (
      hostName: nixosConfig:
        import ../lib/install/configure-installer.nix {
          host = nixosConfig.config.opts.info;
          inherit self inputs;
          system = nixosConfig.config.opts.info.system;
          inherit (nixosConfig.config.opts) variables theme;
          lib = inputs.nixpkgs.lib;
          config = nixosConfig.config;
        }
    )
    nixosConfigurations;
in {
  flake.nixosConfigurations = nixosConfigurations;
  flake.darwinConfigurations = darwinConfigurations;
  flake.installers.x86_64-linux = installers;
  flake.legacyPackages.x86_64-linux =
    builtins.mapAttrs (
      name: config: config.config.formats
    )
    nixosConfigurations;
}
