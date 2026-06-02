{
  system,
  pkgs-unstable,
  inputs,
  config,
  ...
}: let
  lib = import ./lib.nix {
    inherit system pkgs-unstable inputs;
    isDarwin = config.opts.variables.isDarwin;
  };
in {
  home.packages = [
    (lib.createIde "phpstorm" [
      "com.laravel_idea.plugin"
      "com.kalessil.phpStorm.phpInspectionsEA"
    ])
  ];
}
