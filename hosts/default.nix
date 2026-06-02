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
    "brant"
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
  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit self inputs system;
      };

      modules =
        sharedModules
        ++ [
          (mkInfoModule info)

          self.modules.nixos.home-manager-wiring
          self.modules.combined.stylix
          self.modules.combined.sops

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
  in
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;

      specialArgs = {
        inherit self inputs system;
      };

      modules =
        sharedModules
        ++ [
          (mkInfoModule info)

          {
            opts.variables.isDarwin = true;
          }

          self.modules.darwin.home-manager-wiring
          self.modules.combined.stylix
          self.modules.combined.sops

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
