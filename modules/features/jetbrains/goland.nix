{
  pkgs-unstable,
  inputs,
  config,
  ...
}: let
  lib = import ./lib.nix {
    inherit pkgs-unstable inputs;
    isDarwin = config.opts.variables.isDarwin;
  };
in {
  home.packages = [
    (lib.createIde "goland" [])
  ];
}
