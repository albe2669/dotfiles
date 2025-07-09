final: prev: let
  version = "1.0.33";
in {
  claude-code = prev.claude-code.overrideAttrs (old: {
    inherit version;

    src = prev.fetchzip {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
      hash = "sha256-AH/ZokL0Ktsx18DrpUKgYrZKdBnKo29jntwXUWspH8w=";
    };
  });
}
