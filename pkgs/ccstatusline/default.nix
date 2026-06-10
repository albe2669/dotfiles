{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  nodejs,
}:
# ccstatusline is a Bun-built CLI that ships a single, self-contained bundle
# (dist/ccstatusline.js) with zero runtime dependencies, so we can package the
# published npm tarball directly instead of building from source.
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ccstatusline";
  version = "2.2.19";

  src = fetchurl {
    url = "https://registry.npmjs.org/ccstatusline/-/ccstatusline-${finalAttrs.version}.tgz";
    hash = "sha256-ZECyfJStzolhs1EQrrbq6svXCtvcpj6YJRPjFIazLSw=";
  };

  nativeBuildInputs = [makeBinaryWrapper];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/ccstatusline
    cp -r dist package.json $out/lib/ccstatusline/

    makeWrapper ${lib.getExe nodejs} $out/bin/ccstatusline \
      --inherit-argv0 \
      --add-flags $out/lib/ccstatusline/dist/ccstatusline.js

    runHook postInstall
  '';

  meta = {
    description = "Configurable, powerful status line formatter for Claude Code";
    homepage = "https://github.com/sirmalloc/ccstatusline";
    changelog = "https://github.com/sirmalloc/ccstatusline/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "ccstatusline";
  };
})
