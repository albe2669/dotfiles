_: {
  flake.modules.homeManager.anytype = {
    pkgs-unstable,
    lib,
    ...
  }: {
    home.packages = lib.optionals (!pkgs-unstable.stdenv.isDarwin) [
      pkgs-unstable.anytype
    ];
  };
}
