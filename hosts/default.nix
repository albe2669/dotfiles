{
  self,
  inputs,
  config,
  ...
}: let
  createNixosConfiguration = machine: system: specialArgs:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = specialArgs;

      modules = [
        ../variables.nix
        ../theme.nix

        self.nixosModules.state
        (import ../modules/nixos/home.nix {inherit specialArgs;})

        inputs.disko.nixosModules.disko

        inputs.nixos-generators.nixosModules.all-formats
        {
        }

        {
          # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
          nix.registry.nixpkgs.flake = inputs.nixpkgs;

          # make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
          environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
          nix.nixPath = ["/etc/nix/inputs"];
        }

        ./${machine}
      ];
    };

  system = "x86_64-linux";

  specialArgs = rec {
    inherit self inputs system;

    username = config.opts.variables.username;

    pkgs-unstable = import inputs.nixpkgs-unstable {
      system = system;

      # Necessary for installing paid or non-free software
      config.allowUnfree = true;

      config.permittedInsecurePackages = [
        "electron-29.4.6"
      ];

      # Overlays are only applied to the unstable channel, since they probably are
      overlays = import ../overlays {};
    };
  };

  allHosts = [
    "gander"
    "gosling"
    "skein"
    "larry"
  ];

  nixosConfigurations = builtins.listToAttrs (builtins.map (host: {
      name = host;
      value = createNixosConfiguration host system specialArgs;
    })
    allHosts);
  installers =
    builtins.mapAttrs (
      hostName: nixosConfig:
        import ../lib/install/configure-installer.nix {
          host = nixosConfig.config.opts.info;
          inherit self system inputs;
          inherit (nixosConfig.config.opts) variables theme;
          lib = inputs.nixpkgs.lib;
          config = nixosConfig.config;
        }
    )
    nixosConfigurations;
in {
  flake.nixosConfigurations = nixosConfigurations;
  flake.installers.${system} = installers;
  flake.legacyPackages.${system} =
    builtins.mapAttrs (
      name: config: config.config.formats
    )
    nixosConfigurations;
}
