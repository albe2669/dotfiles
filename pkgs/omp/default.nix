{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
}: let
  version = "16.0.5";

  platformMap = {
    "x86_64-linux" = "linux-x64";
    "aarch64-linux" = "linux-arm64";
    "x86_64-darwin" = "darwin-x64";
    "aarch64-darwin" = "darwin-arm64";
  };

  checksums = {
    "linux-x64" = "sha256-gamoR9iIK6wahclhOe0kXZYryxkJ8v8Tq65xIu3Z320=";
    "linux-arm64" = "sha256-We/8CASGZxQv5rgCjoI2bVRdR83qqGsoZQ2BU0xOKTo=";
    "darwin-x64" = "sha256-iw6km89VfgVl4L5cKxaukZ6FbSyFShrVfkm7COTDgsc=";
    "darwin-arm64" = "sha256-R0vGASa3oKSOTyiSHPOajx2mzJi7ThhOS+MjqgudfYE=";
  };

  platformKey = platformMap.${stdenv.hostPlatform.system};
in
  stdenvNoCC.mkDerivation {
    pname = "omp";
    inherit version;

    src = fetchurl {
      url = "https://github.com/can1357/oh-my-pi/releases/download/v${version}/omp-${platformKey}";
      hash = checksums.${platformKey};
    };

    # Single pre-built binary — nothing to unpack or build
    dontUnpack = true;
    dontBuild = true;

    nativeBuildInputs =
      lib.optionals stdenv.hostPlatform.isLinux [autoPatchelfHook];

    # Provide common Rust runtime libs for dynamic Linux builds.
    # autoPatchelfHook is a no-op when the binary is statically linked (musl).
    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [stdenv.cc.cc.lib];

    installPhase = ''
      runHook preInstall
      install -Dm755 $src $out/bin/omp
      runHook postInstall
    '';

    meta = {
      description = "oh-my-pi — AI coding agent for the terminal (hash-anchored edits, LSP, subagents, 40+ providers)";
      homepage = "https://github.com/can1357/oh-my-pi";
      changelog = "https://github.com/can1357/oh-my-pi/releases/tag/v${version}";
      license = lib.licenses.mit;
      platforms = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
      mainProgram = "omp";
    };
  }
