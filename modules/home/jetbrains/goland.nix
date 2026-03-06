{
  system,
  pkgs-unstable,
  inputs,
  ...
}: let
  lib = import ./lib.nix {inherit system pkgs-unstable inputs;};
in {
  home.packages = [
    (lib.createIde "goland" [])
  ];
}
