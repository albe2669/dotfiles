{
  pkgs,
  lib,
  ...
}: {
  nix = {
    package = pkgs.nix;

    optimise = {
      automatic = lib.mkDefault true;
      dates = [
        "Mon *-*-* 00:00:00" # weekly
      ];
    };

    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
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
}
