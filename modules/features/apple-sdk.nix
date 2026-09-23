{config, ...}: let
  flakeConfig = config;
in {
  category = "Programming Languages";
  name = "apple-sdk";
  software = [
    "apple-sdk"
  ];

  homeManager = {
    pkgs,
    lib,
    config,
    ...
  }: {
    home.packages = lib.optionals config.opts.variables.isDarwin [
      pkgs.apple-sdk
    ];

    home.sessionVariables = lib.mkIf config.opts.variables.isDarwin {
      LIBRARY_PATH = lib.makeLibraryPath [
        pkgs.darwin.libresolv
      ];
    };
  };
}
