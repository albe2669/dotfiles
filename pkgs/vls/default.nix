{
  lib,
  stdenvNoCC,
  vlang,
  fetchgit,
}:
# vls master imports core `json2`, which only exists in V master. V 0.5.2
# only ships `x.json2`, so pin the last commit before that migration.
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vls";
  version = "unstable-2026-07-26";

  src = fetchgit {
    url = "https://github.com/vlang/vls";
    rev = "6725d02f7fd3904896afb1cb425ab4c6d2ba9cf8";
    hash = "sha256-P8Fg59C7NTMmWJAdjeoLLVS91jLLtH5zqdX+4AUgJtA=";
  };

  # Backport of upstream a66c68 "fix: process streaming stdio requests":
  # V 0.5.2's os.stdin() reads with C fread, which blocks until the full
  # buffer is filled, so LSP clients holding stdin open never get a
  # response. Read the raw fd instead so each frame is processed as it
  # arrives.
  patches = [./stdio-streaming.patch];

  nativeBuildInputs = [vlang];

  buildPhase = ''
    runHook preBuild
    # The V compiler writes cache files to HOME; a dir inside the build tree
    # keeps the cc wrapper happy (it rejects impure paths like /tmp in
    # linked objects).
    export HOME="$PWD/v-home"
    mkdir -p "$HOME"
    v -o vls .
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp vls $out/bin/
    runHook postInstall
  '';

  meta = {
    description = "V language server";
    homepage = "https://github.com/vlang/vls";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    mainProgram = "vls";
  };
})
