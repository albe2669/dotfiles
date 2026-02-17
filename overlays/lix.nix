{ pkgs, ... }:
{
  nixpkgs.overlays = [ (final: prev: {
    my-new-package = prev.my-new-package.override {
      nix = final.lixPackageSets.stable.lix;
    }; # Adapt to your specific use case.

    inherit (final.lixPackageSets.stable)
      nixpkgs-review
      # nix-direnv
      nix-eval-jobs
      nix-fast-build
      colmena;
  }) ];

  nix.package = pkgs.lixPackageSets.stable.lix;
}
