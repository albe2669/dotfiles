_final: prev: let
  version = "2.14.0";
in {
  golangci-lint = prev.golangci-lint.overrideAttrs (_old: {
    inherit version;

    src = prev.fetchFromGitHub {
      owner = "golangci";
      repo = "golangci-lint";
      tag = "v${version}";
      hash = "sha256-HATA7JKHwEouM+8jYZbQrkX7p4gut4IpyTvcBexu/4o=";
    };

    vendorHash = "sha256-ekP/zDhYMpMG+tYAyYHNfLOCt/JkxrXUw1jHUEfsM8k=";
  });
}
