# oh-my-pi (omp) — TypeScript+Rust hybrid built with bun build --compile.
#
# Build architecture:
#   1. bunDeps  — fixed-output derivation: runs `bun install` with network to
#                 vendor all JS/TS workspace dependencies; the outputHash locks
#                 the result so subsequent builds are fully sandboxed.
#   2. nativesAddon — rustPlatform.buildRustPackage: compiles the NAPI Rust
#                 addon (packages/natives) that provides grep, PTY, clipboard,
#                 syntax highlighting, and shell operations to the TypeScript layer.
#   3. final    — sandboxed: symlinks vendored deps, places the .node addon, then
#                 runs `bun build --compile` to produce a self-contained binary
#                 that embeds the Bun runtime.
#
# Hash update workflow:
#   nix build .#omp 2>&1 | grep "got:"   (repeat for each placeholder that fires)
#
# Alternatively, use `nix store prefetch-file <url>` for fetchFromGitHub hashes.
{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  rustPlatform,
  bun,
  nodejs,
  pkg-config,
  openssl,
}: let
  version = "16.0.5";

  src = fetchFromGitHub {
    owner = "can1357";
    repo = "oh-my-pi";
    rev = "v${version}";
    # Run: nix-prefetch-github can1357 oh-my-pi --rev v16.0.5
    hash = lib.fakeHash;
  };

  # --------------------------------------------------------------------------
  # Stage 1 — Bun/npm dependency vendoring (fixed-output derivation)
  # --------------------------------------------------------------------------
  # Fixed-output derivations may access the network; their outputHash pins the
  # result so the build is reproducible after the hash is filled in.
  #
  # To compute: rm the placeholder, run `nix build .#omp`, copy the "got:" hash.
  bunDeps = stdenvNoCC.mkDerivation {
    name = "omp-bun-deps-${version}";
    inherit src;

    nativeBuildInputs = [bun];

    buildPhase = ''
      export HOME=$(mktemp -d)
      # --frozen-lockfile: aborts if bun.lock is out of date (ensures reproducibility)
      bun install --frozen-lockfile --no-progress
    '';

    installPhase = ''
      cp -r node_modules $out
    '';

    outputHash = lib.fakeHash;
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
  };

  # --------------------------------------------------------------------------
  # Stage 2 — Rust NAPI native addon
  # --------------------------------------------------------------------------
  # packages/natives provides pi_natives.<platform>.node — a shared library
  # loaded by the TypeScript layer for native ops (grep, PTY, clipboard, etc.).
  #
  # The natives package is part of the root Cargo workspace (crates/* + any
  # package.json-declared workspaces that also have Cargo.toml members).
  # We build only the pi-natives crate and skip the test suite (it needs a
  # running Node host to load the .node file).
  nativesAddon = rustPlatform.buildRustPackage {
    pname = "pi-natives";
    inherit version src;

    # To compute: nix hash path --type sha256 --base64 \
    #   $(nix-prefetch-github can1357 oh-my-pi --rev v16.0.5 | jq -r .outPath)
    cargoHash = lib.fakeHash;

    # Build only the native addon crate; skip the rest of the workspace.
    cargoBuildFlags = ["--package" "pi-natives" "--lib"];

    nativeBuildInputs = [nodejs pkg-config];
    buildInputs = [openssl];

    # NAPI-RS outputs a shared library; rename to the .node convention that the
    # TypeScript loader discovers by platform suffix.
    installPhase = let
      nodeTriple = {
        "x86_64-linux" = "linux-x64-gnu";
        "aarch64-linux" = "linux-arm64-gnu";
        "x86_64-darwin" = "darwin-x64";
        "aarch64-darwin" = "darwin-arm64";
      }.${stdenv.hostPlatform.system};
      ext =
        if stdenv.hostPlatform.isDarwin
        then "dylib"
        else "so";
    in ''
      runHook preInstall
      mkdir -p $out/lib
      install -m755 target/release/libpi_natives.${ext} \
        $out/lib/pi_natives.${nodeTriple}.node
      runHook postInstall
    '';

    doCheck = false;
  };

  # The naming convention used by packages/natives/native/index.js when loading
  # the .node file on the current platform.
  nodeTriple = {
    "x86_64-linux" = "linux-x64-gnu";
    "aarch64-linux" = "linux-arm64-gnu";
    "x86_64-darwin" = "darwin-x64";
    "aarch64-darwin" = "darwin-arm64";
  }.${stdenv.hostPlatform.system};
in
  stdenvNoCC.mkDerivation {
    pname = "omp";
    inherit version src;

    nativeBuildInputs = [bun];

    buildPhase = ''
      runHook preBuild
      export HOME=$(mktemp -d)

      # Use the vendored node_modules (bun resolves from the symlink at cwd)
      ln -sfn ${bunDeps} node_modules

      # Place the compiled native addon where packages/natives/native/index.js
      # expects to find it on this platform.
      mkdir -p packages/natives/native
      cp ${nativesAddon}/lib/pi_natives.${nodeTriple}.node \
         packages/natives/native/

      # Produce a standalone self-contained binary (embeds the Bun runtime +
      # all TypeScript source; no external Bun required at runtime).
      bun build --compile \
        --no-compile-autoload-bunfig \
        --no-compile-autoload-dotenv \
        --no-compile-autoload-tsconfig \
        --no-compile-autoload-package-json \
        --keep-names \
        --define 'process.env.PI_COMPILED="true"' \
        --external mupdf \
        ./packages/coding-agent/src/cli.ts \
        --outfile $TMPDIR/omp

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 $TMPDIR/omp $out/bin/omp
      runHook postInstall
    '';

    meta = {
      description = "oh-my-pi (omp) — AI coding agent for the terminal (hash-anchored edits, LSP, subagents, 40+ providers)";
      homepage = "https://github.com/can1357/oh-my-pi";
      changelog = "https://github.com/can1357/oh-my-pi/releases/tag/v${version}";
      license = lib.licenses.mit;
      platforms = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
      mainProgram = "omp";
    };
  }
