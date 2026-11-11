_final: prev: let
  version = "0.12.11";
in {
  tinycast = prev.tinycast.overrideAttrs (_old: {
    inherit version;

    src = prev.fetchurl {
      url = "https://github.com/abue-ammar/tinycast/releases/download/v${version}/Tinycast-${version}.dmg";
      hash = "sha256-fdxekolncM2RROF17rhwDaLLSDLBw84YpR9lB0d4AUg=";
    };

    sourceRoot = "Tinycast.app";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications/Tinycast.app"
      cp -R . "$out/Applications/Tinycast.app"

      runHook postInstall
    '';
  });
}
