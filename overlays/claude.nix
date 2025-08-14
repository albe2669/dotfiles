final: prev: let
  version = "1.0.80";
in {
  claude-code = prev.claude-code.overrideAttrs (old: {
    inherit version;

    src = prev.fetchzip {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
      hash = "sha256-o7fG0LnTR7fGxq4VP5393tcQZi0JtPOF8Gb2cUAsevA=";
    };
  });
}
