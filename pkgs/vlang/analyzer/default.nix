{
  lib,
  stdenv,
  fetchgit,
  vlang,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "v-analyzer";
  version = "unstable-2026-11-02";

  src = fetchgit {
    url = "https://github.com/vlang/v-analyzer";
    rev = "7801a67d0583371265c2b50258ee3641c14dfdaf";
    hash = "sha256-PMSrR5NsK1O3Yf92lUAHyK9yqHhYy7rnUi+X2aL4Pkw=";
  };

  # The pinned commit predates the current V master module resolution:
  # single-segment imports prefer the vlib module, so the vendored
  # src/bytes module is shadowed by the new stdlib bytes module. Move it
  # under src/analyzer and import it with its dotted path, which resolves
  # inside the project first.
  postPatch = ''
    mv src/bytes src/analyzer/bytes
    substituteInPlace src/analyzer/index/IndexSerializer.v src/analyzer/index/IndexDeserializer.v \
      --replace-fail "import bytes" "import analyzer.bytes"
    # V master keeps `u8 << n` in u8, so the big-endian reconstruction in
    # read_int/read_i64 silently drops every shifted byte. Widen first.
    substituteInPlace src/analyzer/bytes/deserialize.v \
      --replace-fail "res |= datum << (8 * (3 - index))" "res |= int(datum) << (8 * (3 - index))" \
      --replace-fail "res |= datum << (8 * (7 - index))" "res |= int(datum) << (8 * (7 - index))"
  '';

  nativeBuildInputs = [vlang];
  # The V compiler writes cache files to HOME; a dir inside the build tree
  # keeps the cc wrapper happy (it rejects impure paths like /tmp in
  # linked objects).
  buildPhase = ''
    runHook preBuild
    export HOME="$PWD/v-home"
    mkdir -p "$HOME"
    v -o v-analyzer src -no-parallel -cflags "-Wno-misleading-indentation -Wno-jump-misses-init -Wno-error=jump-misses-init -Wno-typedef-redefinition"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D v-analyzer $out/bin/v-analyzer
    install -D tree_sitter_v/queries/highlights.scm $out/queries/v/highlights.scm

    runHook postInstall
  '';

  # Deterministic version metadata; upstream embeds the commit at build
  # time through git, which the sandbox does not have.
  env.BUILD_COMMIT = finalAttrs.src.rev;

  meta = {
    description = "V language server";
    homepage = "https://github.com/vlang/v-analyzer";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "v-analyzer";
  };
})
