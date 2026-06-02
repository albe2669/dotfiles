final: prev: let
  version = "2.1.126";
  baseUrl = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
  platformKey = "${prev.stdenv.hostPlatform.node.platform}-${prev.stdenv.hostPlatform.node.arch}";

  checksums = {
    "darwin-arm64" = "87a1d05018ceadfc1fe616bfc10262b0503f51986f4af2dc42d1ed856ed3f7bb";
    "darwin-x64" = "49a90c474383a9eda11310bd71f7ea6bb91361ec99443b733cb5003f6e703ccb";
    "linux-arm64" = "88a6dca613a40559f3bac8a946a2ec6e60a870b91938d3df93dcac1dec4848cb";
    "linux-x64" = "fce96968d275161ff65a4c19fc6434efc6973d9f6d35dc3992a2ba0553cac18e";
  };

  src = prev.fetchurl {
    url = "${baseUrl}/${version}/${platformKey}/claude";
    sha256 = checksums.${platformKey};
  };
in {
  # claude-code-bin was aliased to claude-code in nixpkgs (2026-04-18).
  # Using prev.claude-code avoids the cycle that prev.claude-code-bin creates.
  claude-code = prev.claude-code.overrideAttrs (_: {
    inherit version src;
  });
}
