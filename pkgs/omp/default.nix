{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  rustPlatform,
  bun,
  bunSrc,
  unzip,
  nodejs,
  pkg-config,
  openssl,
}: let
  version = "16.3.10";

  src = fetchFromGitHub {
    owner = "can1357";
    repo = "oh-my-pi";
    rev = "v${version}";
    hash = "sha256-fvCZxd0r7+s0DG/OvPxr2xnyRV69BqSiL/Xgez02tmg=";
  };

  platforms = {
    "x86_64-linux" = {
      node = "linux-x64-baseline";
      bunChecksum = "sha256-/c4UPGYLgBpluNputevnq0VxBIvq+wasQib/B4BsQUY=";
    };
    "aarch64-linux" = {
      node = "linux-arm64";
      bunChecksum = lib.fakeHash;
    };
    "x86_64-darwin" = {
      node = "darwin-x64-baseline";
      bunChecksum = lib.fakeHash;
    };
    "aarch64-darwin" = {
      node = "darwin-arm64";
      bunChecksum = "sha256-S+ptZXObcOlZ7rRDK3ro7ORrUWEzwYC8iDmGgLZQKJw=";
    };
  };

  platformSpecific = platforms.${stdenv.hostPlatform.system};

  # --------------------------------------------------------------------------
  # Stage 1 — Bun/npm dependency fetch (fixed-output derivation)
  # --------------------------------------------------------------------------
  bunDeps = stdenvNoCC.mkDerivation {
    name = "omp-bun-deps-${version}";
    inherit src;

    nativeBuildInputs = [bun];

    buildPhase = ''
      export HOME=$(mktemp -d)
      bun install --frozen-lockfile --no-progress
    '';

    installPhase = ''
      # bun workspaces links @oh-my-pi/* → ../../packages/* and robomp-web →
      # ../../python/robomp/web. These symlinks are valid in the build tree
      # but break in the Nix store (packages/ is absent there). Remove them
      # explicitly; the final build recreates them from the source tree.
      rm -rf node_modules/@oh-my-pi
      rm -f node_modules/robomp-web
      # .bin entries for workspace bins also become dangling; remove them.
      find node_modules/.bin -maxdepth 1 -type l ! -exec test -e {} \; -delete
      cp -r node_modules $out
    '';

    outputHash = platformSpecific.bunChecksum;
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
  };

  # --------------------------------------------------------------------------
  # Stage 2 — Rust NAPI addon
  # --------------------------------------------------------------------------
  nativesAddon = rustPlatform.buildRustPackage {
    pname = "pi-natives";
    inherit version src;

    cargoHash = "sha256-Oy4xCMX/MA8c1UoC63a7eLEHF1N9BZ75fFjRcuL+yNE=";

    # pi-natives uses #![feature(alloc_error_hook)] which requires nightly;
    # RUSTC_BOOTSTRAP=1 lets stable Rust compile nightly feature gates.
    env.RUSTC_BOOTSTRAP = "1";

    cargoBuildFlags = ["--package" "pi-natives" "--lib"];

    nativeBuildInputs = [nodejs pkg-config];
    buildInputs = [openssl];

    installPhase = let
      # nixpkgs's cargoBuildHook passes --target <rustcTarget>, so cargo puts
      # artifacts in target/<rustcTarget>/release/ rather than target/release/.
      rustTarget = stdenv.hostPlatform.rust.rustcTarget;
      ext =
        if stdenv.hostPlatform.isDarwin
        then "dylib"
        else "so";
    in ''
      runHook preInstall
      mkdir -p $out/lib
      install -m755 target/${rustTarget}/release/libpi_natives.${ext} \
        $out/lib/pi_natives.${platformSpecific.node}.node
      runHook postInstall
    '';

    doCheck = false;
  };
in
  stdenvNoCC.mkDerivation {
    pname = "omp";
    inherit version src;

    nativeBuildInputs = [bun unzip];

    # bun build --compile appends a payload past the ELF section table.
    # The default fixup phase's strip/patchelf rewrites section headers
    # and breaks the embedded payload — the resulting binary segfaults in
    # ld-linux's dl_main on launch.
    dontStrip = true;
    dontPatchELF = true;

    buildPhase = ''
      runHook preBuild
      export HOME=$(mktemp -d)

      # Copy vendored deps to a mutable node_modules (a symlink to the
      # read-only store path cannot have workspace links added to it).
      cp -r ${bunDeps} node_modules
      chmod -R u+w node_modules

      # Recreate workspace package symlinks that bun install created but that
      # were stripped from bunDeps. Read each packages/*/package.json for the
      # canonical name, then link node_modules/@scope/name → ../../packages/x.
      for pkg_json in packages/*/package.json; do
        [ -f "$pkg_json" ] || continue
        pkg_dir="$(dirname "$pkg_json")"
        pkg_name="$(grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' "$pkg_json" \
                    | head -1 | grep -o '"[^"]*"$' | tr -d '"')"
        [ -n "$pkg_name" ] || continue
        case "$pkg_name" in
          @*/*)
            scope="''${pkg_name%%/*}"
            bare="''${pkg_name#*/}"
            mkdir -p "node_modules/$scope"
            ln -sfn "../../$pkg_dir" "node_modules/$scope/$bare"
            ;;
        esac
      done

      # Place the compiled native addon where packages/natives/native/index.js
      # expects to find it on this platform.
      mkdir -p packages/natives/native
      cp ${nativesAddon}/lib/pi_natives.${platformSpecific.node}.node \
         packages/natives/native/

      # Generate build-time artefacts required by bun build --compile.
      # 1. Embed native .node into a tar.gz + generate embedded-addon.js shim.
      (cd packages/natives && bun scripts/embed-native.ts)
      # 2. docs-index.generated.ts — embeds docs/ Markdown into the binary.
      (cd packages/coding-agent && bun scripts/generate-docs-index.ts)
      # 3. tool-views.generated.js — React tool-view bundle for HTML exports.
      (cd packages/collab-web && bun scripts/build-tool-views.ts)
      # 4. legacy-pi-bundled-registry.ts — static-import registry for legacy
      #    pi-* extension compat surfaces. Bun 1.3.14+ made bunfs filesystem
      #    APIs unreachable at runtime (upstream issue #3423), so these
      #    surfaces can no longer be reached as extra --compile entrypoints
      #    landed at computed /$bunfs/root/... paths; they must instead be
      #    statically imported through this generated registry.
      (cd packages/coding-agent && bun scripts/generate-legacy-pi-bundled-registry.ts --generate)

      # Extract the upstream bun ZIP unmodified to embed in the output. The
      # bun binary in $PATH is patchelf'd by nixpkgs to run on NixOS, but
      # patchelf rewrites bun's ELF section table — and bun --compile
      # appends a payload past that table. Embedding the patched binary
      # produces an output that segfaults in ld.so dl_main. Pass the raw
      # binary via --compile-executable-path instead.
      mkdir -p $TMPDIR/bun-raw
      unzip -q ${bunSrc} -d $TMPDIR/bun-raw
      bunRawBin=$(find $TMPDIR/bun-raw -maxdepth 2 -name bun -type f -executable | head -1)
      if [ -z "$bunRawBin" ]; then
        echo "could not locate unpacked bun binary" >&2; exit 1
      fi

      # Compile the self-contained binary. Entrypoints mirror build-binary.ts
      # so that legacy pi-* extension shims land in bunfs.
      # Legacy pi-* extension compat surfaces are no longer listed as extra
      # --compile entrypoints (see the registry generation step above) — the
      # bundler now includes them via the main module graph instead.
      bun build --compile \
        --compile-executable-path="$bunRawBin" \
        --no-compile-autoload-bunfig \
        --no-compile-autoload-dotenv \
        --no-compile-autoload-tsconfig \
        --no-compile-autoload-package-json \
        --keep-names \
        --define 'process.env.PI_COMPILED="true"' \
        --external mupdf \
        --external fastembed \
        --external onnxruntime-node \
        --root . \
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
