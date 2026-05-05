final: prev: let
  version = "2.12.1";
in {
  golangci-lint = prev.golangci-lint.overrideAttrs (old: {
    inherit version;

    src = prev.fetchFromGitHub {
      owner = "golangci";
      repo = "golangci-lint";
      tag = "v${version}";
      hash = "sha256-B19aLvfNRY9TOYw/71f2vpNUuSIz8OI4dL0ijGezsas=";
    };

    vendorHash = "sha256-xuoj4+U4tB5gpABKq4Dbp2cxnljxdYoBbO8A7DqPM5E=";
  });
}
