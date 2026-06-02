final: prev: let
  version = "2.12.2";
in {
  golangci-lint = prev.golangci-lint.overrideAttrs (old: {
    inherit version;

    src = prev.fetchFromGitHub {
      owner = "golangci";
      repo = "golangci-lint";
      tag = "v${version}";
      hash = "sha256-qR7fp1x2S+EwEAcplRHTvA3jWwLr/XSiYKSZtAwkrNU=";
    };

    vendorHash = "sha256-AG5wtLwWLz55bdp1oi3cW+9O3yj1W1P7MV9zxym7Pb4=";
  });
}
