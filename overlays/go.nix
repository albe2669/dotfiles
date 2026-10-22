_final: prev: let
  version = "1.27.3";
in {
  go_1_27 = prev.go_1_27.overrideAttrs (_old: {
    inherit version;

    src = prev.fetchurl {
      url = "https://go.dev/dl/go${version}.src.tar.gz";
      hash = "sha256-bndJA1zzYPBrJXXRYup535/ajvZxiJ5cN1+OUHd/Jrs=";
    };

    vendorHash = "";
  });
}
