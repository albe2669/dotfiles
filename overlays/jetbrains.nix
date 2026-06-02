final: prev: {
  jetbrains =
    (import (builtins.fetchTarball {
        url = "https://github.com/nixos/nixpkgs/archive/42a1c966be226125b48c384171c44c651c236c22.tar.gz";
        sha256 = "sha256:082dpl311xlspwm5l3h2hf10ww6l59m7k2g2hdrqs4kwwsj9x6mf";
      }) {
        inherit (final.pkgs) system;
        config.allowUnfree = true;
      }).jetbrains;
}
