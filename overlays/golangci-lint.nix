final: prev: let
  version = "2.11.3";
in {
  golangci-lint = prev.golangci-lint.overrideAttrs (old: {
    inherit version;

    src = prev.fetchFromGitHub {
      owner = "golangci";
      repo = "golangci-lint";
      tag = "v${version}";
      hash = "sha256-VD46VOSBzVeeJ86FYLEPTsy23MUQapDPPYiO3/Ki8Mw=";
    };

    vendorHash = "sha256-k/lsDC6thW3B1zcn+OXjSmwmiW8pm0HM+g/z+N3AQek=";
  });
}
