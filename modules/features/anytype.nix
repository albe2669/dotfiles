_: {
  flake.modules.homeManager.anytype = {
    pkgs-unstable,
    lib,
    ...
  }: {
    home.packages = lib.optionals (!pkgs-unstable.stdenv.hostPlatform.isDarwin) [
      pkgs-unstable.anytype
    ];
  };
}
