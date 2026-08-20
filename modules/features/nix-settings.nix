{lib, ...}: let
  mkCommon = gc: {config, ...}: {
    nix = {
      inherit gc;

      settings = {
        auto-optimise-store = true;
        builders-use-substitutes = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [
          "https://cache.nixos.org"
          "https://cache.numtide.com"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        ];
        netrc-file = config.sops.secrets.nix_netrc.path;
      };
    };

    nixpkgs.config.allowUnfree = true;
  };
in {
  flake.modules.nixos.nix-settings = mkCommon {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  flake.modules.darwin.nix-settings = mkCommon {
    automatic = lib.mkDefault true;
    interval = lib.mkDefault {
      Weekday = 0;
      Hour = 2;
      Minute = 0;
    };
    options = lib.mkDefault "--delete-older-than 7d";
  };
}
