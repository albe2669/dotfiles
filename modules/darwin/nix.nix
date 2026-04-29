{
  config,
  pkgs,
  lib,
  ...
}: {
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
      netrc-file = config.sops.secrets.nix_netrc.path;
    };
  };

  nixpkgs.config.allowUnfree = true;
}
