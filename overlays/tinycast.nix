_final: prev: let
  version = "0.12.1";
in {
  tinycast = prev.tinycast.overrideAttrs (_old: {
    inherit version;

    src = prev.fetchurl {
      url = "https://github.com/abue-ammar/tinycast/releases/download/v${version}/Tinycast-${version}.dmg";
      hash = "sha256-6dPaLAobs7gTzkHM5Sk0+9B8BJQWic9Ojli6MoT3lsU=";
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
