final: prev: let
  version = "1.26.1";
in {
  go_1_26 = prev.go_1_26.overrideAttrs (old: {
    inherit version;

    src = prev.fetchurl {
      url = "https://go.dev/dl/go${version}.src.tar.gz";
      hash = "sha256-MXIpPQSyCdwRRGmOe6E/BHf2uoxf/QvmbCD9vJeF37s=";
    };
  });
}
