{pkgs, ...}: let
  bunVersion = "1.3.14";

  # omp requires bun >= 1.3.14; nixpkgs ships 1.3.13.
  bun-1-3-14 = pkgs.bun.overrideAttrs (_finalAttrs: _old: {
    version = bunVersion;
    src = bunSrcs.${pkgs.stdenv.hostPlatform.system};
  });

  # Per-platform raw upstream ZIPs of bun. The ZIPs are referenced twice:
  # 1. As `src` for `bun-1-3-14` — gets unpacked and (auto-)patchelf'd into a
  #    sandbox-runnable bun. This is the binary that drives the omp build.
  # 2. Passed unmodified to omp's `bun build --compile` via
  #    `--compile-executable-path` — the OUTPUT binary needs an UNPATCHED
  #    bun runtime as its template, because patchelf rewriting bun's ELF
  #    section table corrupts the payload bun's --compile appends past it
  #    (otherwise the resulting self-contained binary segfaults in ld.so
  #    dl_main on launch).
  bunSrcs = {
    "aarch64-darwin" = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${bunVersion}/bun-darwin-aarch64.zip";
      hash = "sha256-2LliIYKK1vl6x6wKt+lYcjQa92MAHogD6CZ2UsJlJiA=";
    };
    "x86_64-darwin" = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${bunVersion}/bun-darwin-x64-baseline.zip";
      hash = pkgs.lib.fakeHash;
    };
    "aarch64-linux" = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${bunVersion}/bun-linux-aarch64.zip";
      hash = pkgs.lib.fakeHash;
    };
    "x86_64-linux" = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${bunVersion}/bun-linux-x64.zip";
      hash = "sha256-lR7iruhV8IWVruxiJSJqKY0/6oOj3NZGXAnLzN9+hI8=";
    };
  };
in {
  kittykat = pkgs.callPackage ./kittykat {};
  # anytype = pkgs.callPackage ./anytype {};
  yuckls = pkgs.callPackage ./yuckls {};
  ccusage = pkgs.callPackage ./ccusage {};
  ccstatusline = pkgs.callPackage ./ccstatusline {};
  pup = pkgs.callPackage ./pup {};
  omp = pkgs.callPackage ./omp {
    bun = bun-1-3-14;
    bunSrc = bunSrcs.${pkgs.stdenv.hostPlatform.system};
  };
}
