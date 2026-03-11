final: prev: let
  version = "2.11.1";
in {
  golangci-lint = prev.golangci-lint.overrideAttrs (old: {
    inherit version;

    src = prev.fetchFromGitHub {
      owner = "golangci";
      repo = "golangci-lint";
      tag = "v${version}";
      hash = "sha256-psdZmQFvcZJZm9cOZXXuq2A2XULy1ippIGmyHnxk/oM=";
    };

    vendorHash = "sha256-RTdHfQRg/MLt+VJ4mcbOui6L7T4c1kFT66ROnjs6nKU=";
  });
}
