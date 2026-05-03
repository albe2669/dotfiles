final: prev: let
  version = "2.1.114";
  baseUrl = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
  platformKey = "${prev.stdenv.hostPlatform.node.platform}-${prev.stdenv.hostPlatform.node.arch}";

  checksums = {
    "darwin-arm64" = "bf1b4da368da7970f0d1d4a1675acea99b6f2ad94f24e9f8ccfcc7940ac67894";
    "darwin-x64" = "1a30360b6240056a58ba9187c8f9d2e88e949e0f970d5cf81f8d69bc65568f6a";
    "linux-arm64" = "9556b74e2c912e7dcaef90c91fd0dd5095364f8a9d71398de3c5c669612b828a";
    "linux-x64" = "12bd4b0916deb06be17ffc7b2f0485e140bf00b2db3dcb78469d66723d73c27f";
    "linux-arm64-musl" = "20c68c312e76fb81f52cd2006b1461a0eedd470798f44b9b4a833ad583ccc05b";
    "linux-x64-musl" = "fbbcfa225e948d9263c39f8be29a956ea4bd3a445f79aa9396cdc3263ea05690";
  };

  src = prev.fetchurl {
    url = "${baseUrl}/${version}/${platformKey}/claude";
    sha256 = checksums.${platformKey};
  };
in {
  claude-code = prev.claude-code-bin.overrideAttrs (_: {
    pname = "claude-code";
    inherit version src;
  });
}
