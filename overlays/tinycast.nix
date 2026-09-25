_final: prev: let
  version = "0.11.3";
in {
  tinycast = prev.tinycast.overrideAttrs (_old: {
    inherit version;

    src = prev.fetchurl {
      url = "https://github.com/abue-ammar/tinycast/releases/download/v${version}/Tinycast-${version}.dmg";
      hash = "sha256-yfAME5ZIrZme4qW0lT8EDKy5h1wZkWdJDdg/HR1zqXc=";
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
