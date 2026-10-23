{config, ...}: let
  flakeConfig = config;
in {
  category = "Programming languages";
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

    shell.envVars = lib.mkIf config.opts.variables.isDarwin {
      LIBRARY_PATH = lib.makeLibraryPath [
        pkgs.darwin.libresolv
      ];
    };
  };
}
