{
  lib,
  stdenv,
  fetchFromGitHub,
  glfw,
  freetype,
  openssl,
  makeWrapper,
  pkg-config,
  sqlite,
  upx,
  boehmgc,
  libxdmcp,
  libxau,
  libx11,
  xorgproto,
  binaryen,
  callPackage,
}:
# Pinned to a commit between the 0.5.2 release in nixpkgs and the next
# release: v-analyzer and `v ls` need APIs that only exist in V master.
# Keep the vc and markdown pins in sync with the same V master.
let
  # macOS SDKs deprecate sys/ptrace.h; swap the directive for
  # sys/proc_info.h. The ptrace constants are redefined per platform in
  # the bootstrap C, so nothing is lost.
  ptraceSubstitution = "#include <sys/proc_info.h>";
  # vc is the V compiler's source translated to C (needed for bootstrap).
  vc = stdenv.mkDerivation {
    pname = "v.c";
    version = "unstable-2026-11-11";
    src = fetchFromGitHub {
      owner = "vlang";
      repo = "vc";
      rev = "8c91abe5600f4c2d6c0b417ca4f21e0ac7e22fed";
      hash = "sha256-uP0D9YTItCWzfNqmUVAsp2OkFGXnliXXB1fGm6H4dfk=";
    };

    # patch the ptrace reference for darwin
    installPhase =
      lib.optionalString stdenv.hostPlatform.isDarwin ''
        substituteInPlace v.c \
          --replace "#include <sys/ptrace.h>" "${ptraceSubstitution}"
      ''
      + ''
        mkdir -p $out
        cp v.c $out/
      '';
  };
  # Required for vdoc.
  markdown = fetchFromGitHub {
    owner = "vlang";
    repo = "markdown";
    rev = "55292d1aa5dc2ba79d53e3430306755a56d91b6b";
    hash = "sha256-P6LOKkjWU3Xjk/AzTp11uwb1eOpNBAoQIU5WUQ0mtsQ=";
  };
  boehmgcStatic = boehmgc.override {
    enableStatic = true;
  };
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "vlang";
    version = "unstable-2026-11-11";

    src = fetchFromGitHub {
      owner = "vlang";
      repo = "v";
      rev = "7e42a7364048eb8de6bfb4225311463aed366847";
      hash = "sha256-1PxA8LTHF2s/UHh7qLa9opcsw1fDMdxNcrVtHkZLKSE=";
    };

    propagatedBuildInputs =
      [
        glfw
        freetype
        openssl
        sqlite
      ]
      ++ lib.optional stdenv.hostPlatform.isUnix upx;

    nativeBuildInputs = [
      makeWrapper
      pkg-config
    ];

    buildInputs =
      [
        binaryen
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        libx11
        libxau
        libxdmcp
        xorgproto
      ];

    makeFlags = [
      "local=1"
    ];

    env.VC = vc;

    preBuild = ''
      export HOME=$(mktemp -d)
      mkdir -p ./thirdparty/tcc/lib
      cp -r ${boehmgcStatic}/lib/* ./thirdparty/tcc/lib
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,lib,share}
      cp -r examples $out/share
      cp -r {cmd,vlib,thirdparty} $out/lib
        cp v GNUmakefile v.mod $out/lib
      ln -s $out/lib/v $out/bin/v
      wrapProgram $out/bin/v \
        --prefix PATH : ${
        lib.makeBinPath [
          stdenv.cc
          pkg-config
        ]
      } \
        --prefix PKG_CONFIG_PATH : ${lib.getDev sqlite}/lib/pkgconfig

      # Skip vpm module fetches for tools; the build sandbox has no network.
      export VTEST_SANDBOXED_PACKAGING=1

      mkdir -p $HOME/.vmodules;
      ln -sf ${markdown} $HOME/.vmodules/markdown
      $out/lib/v -v build-tools
      $out/lib/v -v $out/lib/cmd/tools/vdoc
      $out/lib/v -v $out/lib/cmd/tools/vast
      $out/lib/v -v $out/lib/cmd/tools/vvet
      $out/lib/v -v $out/lib/cmd/tools/vcreate

      runHook postInstall
    '';

    passthru.vTools.analyzer = callPackage ./analyzer {vlang = finalAttrs.finalPackage;};

    meta = {
      homepage = "https://vlang.io/";
      changelog = "https://github.com/vlang/v/commits/master";
      description = "Simple, fast, safe, compiled language for developing maintainable software";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      mainProgram = "v";
    };
  })
