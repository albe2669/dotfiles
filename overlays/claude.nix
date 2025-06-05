final: prev: let version = "1.0.11"; in {
  claude-code = prev.claude-code.overrideAttrs (old: {
    inherit version;

    src = prev.fetchzip {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
      hash = "sha256-IXNBNjt4Sh5pR+Cz2uEZcCop9reAmQ7hObohtN0f3Ww=";
    };
  });
}
