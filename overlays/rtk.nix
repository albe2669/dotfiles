final: prev: let
  version = "0.37.2";
in {
  rtk = prev.rtk.overrideAttrs (old: rec {
    inherit version;

    src = prev.fetchFromGitHub {
      owner = "rtk-ai";
      repo = "rtk";
      tag = "v${version}";
      hash = "sha256-rNuu8B5TnKZHrbVSV8HkcTeTdcol26259GGJEPEMPZY=";
    };

    cargoDeps = prev.rustPlatform.importCargoLock {
      lockFile = src + "/Cargo.lock";
      allowBuiltinFetchGit = true;
    };
    cargoHash = null;
  });
}
