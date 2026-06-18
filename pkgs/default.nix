{pkgs, ...}: let
  # omp requires bun >= 1.3.14; nixpkgs ships 1.3.13.
  bun-1-3-14 = pkgs.bun.overrideAttrs (finalAttrs: _old: {
    version = "1.3.14";
    src =
      {
        "aarch64-darwin" = pkgs.fetchurl {
          url = "https://github.com/oven-sh/bun/releases/download/bun-v${finalAttrs.version}/bun-darwin-aarch64.zip";
          hash = "sha256-2LliIYKK1vl6x6wKt+lYcjQa92MAHogD6CZ2UsJlJiA=";
        };
        "x86_64-darwin" = pkgs.fetchurl {
          url = "https://github.com/oven-sh/bun/releases/download/bun-v${finalAttrs.version}/bun-darwin-x64-baseline.zip";
          hash = pkgs.lib.fakeHash;
        };
        "aarch64-linux" = pkgs.fetchurl {
          url = "https://github.com/oven-sh/bun/releases/download/bun-v${finalAttrs.version}/bun-linux-aarch64.zip";
          hash = pkgs.lib.fakeHash;
        };
        "x86_64-linux" = pkgs.fetchurl {
          url = "https://github.com/oven-sh/bun/releases/download/bun-v${finalAttrs.version}/bun-linux-x64.zip";
          hash = pkgs.lib.fakeHash;
        };
      }
      .${pkgs.stdenv.hostPlatform.system};
  });
in {
  kittykat = pkgs.callPackage ./kittykat {};
  # anytype = pkgs.callPackage ./anytype {};
  yuckls = pkgs.callPackage ./yuckls {};
  ccusage = pkgs.callPackage ./ccusage {};
  ccstatusline = pkgs.callPackage ./ccstatusline {};
  pup = pkgs.callPackage ./pup {};
  omp = pkgs.callPackage ./omp {bun = bun-1-3-14;};
}
