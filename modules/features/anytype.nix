{
  category = "Software";
  name = "anytype";

  homeManager = {
    pkgs-unstable,
    lib,
    ...
  }: {
    home.packages = lib.optionals (!pkgs-unstable.stdenv.hostPlatform.isDarwin) [
      pkgs-unstable.anytype
    ];
  };
}
