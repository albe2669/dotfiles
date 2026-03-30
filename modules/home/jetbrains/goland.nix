{
  system,
  pkgs-unstable,
  pkgs-goland,
  inputs,
  config,
  ...
}: let
  lib = import ./lib.nix {
    inherit system pkgs-unstable inputs;
    pkgs-ide = pkgs-goland;
    isDarwin = config.opts.variables.isDarwin;
  };
in {
  home.packages = [
    (lib.createIde "goland" [])
  ];
}
