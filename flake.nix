{
  description = "A NixOS configuration made by a silly goose way over their head";

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # These urls should coincide with the stateVersion variable in the variables.nix file
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11"; # Use stable for now
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
      inputs.hyprland.follows = "hyprland";
    };

    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.astal.follows = "astal";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-jetbrains-plugins = {
      url = "github:theCapypara/nix-jetbrains-plugins";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    elephant = {
      url = "github:albe2669/elephant";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.elephant.follows = "elephant";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      debug = true;
      imports = [
        ./variables.nix
        ./theme.nix

        ./modules

        ./hosts
      ];

      systems = [
        "x86_64-linux"
      ];

      perSystem = {
        config,
        pkgs,
        lib,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs-unstable {
          inherit system;

          # Necessary for installing paid or non-free software
          config.allowUnfree = true;
        };

        formatter = pkgs.alejandra;
        packages = import ./pkgs {inherit pkgs;};
      };
    };
}
#
#
#   let
#     specialArgs = import ./lib/special-args.nix {
#       inherit inputs nixpkgs-unstable nixos-hardware zen-browser hyprland hyprland-plugins;
#
#       theme = import ./theme.nix;
#     };
#
#     configurations =
#       builtins.mapAttrs (_: hostConf: {
#         inherit (hostConf) info nixosModules homeModules;
#         homeManager = import ./lib/home-manager.nix {
#           inherit nixpkgs home-manager;
#           specialArgs = specialArgs.x64SpecialArgs;
#           host = hostConf;
#         };
#       }) {
#         gander = import ./hosts/gander {};
#         gosling = import ./hosts/gosling {};
#         skein = import ./hosts/skein {};
#         larry = import ./hosts/larry {};
#       };
#
#     osConfigurations =
#       nixpkgs.lib.filterAttrs (_: hostConf: builtins.hasAttr "nixosModules" hostConf) configurations;
#
#     args =
#       {
#         inherit specialArgs home-manager;
#
#         configurations = osConfigurations;
#       }
#       // inputs;
#
#     hosts = import ./hosts args;
#     installers = import ./hosts/installers.nix ({
#         hosts = hosts.hosts;
#         systems = hosts.allSystems;
#       }
#       // args);
#   in {
#     confs = configurations;
#     homeConfigurations =
#       builtins.mapAttrs (
#         _: hostConf:
#           hostConf.homeManager.configuration
#       )
#       configurations;
#     hosts = hosts;
#     nixosConfigurations = hosts.nixosConfigurations;
#     packages = hosts.packages;
#     installers = installers;
#
#   };
# }

