final: prev: let
  version = "0.42.0";
in {
  rtk = prev.rtk.overrideAttrs (old: rec {
    inherit version;

    src = prev.fetchFromGitHub {
      owner = "rtk-ai";
      repo = "rtk";
      tag = "v${version}";
      hash = "sha256-ZCDVS/AFljljMac+cAzQztYPQgvQrcEhKIHHRhkMsv8=";
    };

    # Requires IFD
    cargoDeps = prev.rustPlatform.importCargoLock {
      lockFile = src + "/Cargo.lock";
      allowBuiltinFetchGit = true;
    };
    cargoHash = null;
  });
}
