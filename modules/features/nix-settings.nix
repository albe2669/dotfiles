{ config, ... }:
let
  flakeConfig = config;
in {
  flake.modules.nixos.nix-settings = { lib, ... }: {
    nix = {
      # optimise = {
      #   automatic = lib.mkDefault true;
      #   dates = [
      #     "Mon *-*-* 00:00:00" # weekly
      #   ];
      # };

      gc = {
        automatic = lib.mkDefault true;
        dates = lib.mkDefault "weekly";
        # frequency = lib.mkDefault "weekly";
        options = lib.mkDefault "--delete-older-than 7d";
      };

      settings = {
        # Manual optimise storage: nix-store --optimise
        # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
        auto-optimise-store = true;
        builders-use-substitutes = true;
        # enable flakes globally
        experimental-features = ["nix-command" "flakes"];
      };
    };

    nixpkgs.config.allowUnfree = true;
  };

  flake.modules.darwin.nix-settings = { pkgs, lib, ... }: {
    nix = {
      # package = pkgs.nix;

      gc = {
        automatic = lib.mkDefault true;
        interval = lib.mkDefault {
          Weekday = 0;
          Hour = 2;
          Minute = 0;
        };
        options = lib.mkDefault "--delete-older-than 7d";
      };

      settings = {
        auto-optimise-store = true;
        builders-use-substitutes = true;
        experimental-features = ["nix-command" "flakes"];
      };
    };

    nixpkgs.config.allowUnfree = true;
  };

  flake.modules.combined.nix-settings = { system, ... }: let
    isDarwin = builtins.match ".*-darwin" system != null;
  in {
    imports = [
      (if isDarwin
       then flakeConfig.flake.modules.darwin.nix-settings
       else flakeConfig.flake.modules.nixos.nix-settings)
    ];
  };
}
