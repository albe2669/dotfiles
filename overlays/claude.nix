final: prev: let
  version = "1.0.107";
in {
  claude-code = prev.claude-code.overrideAttrs (old: {
    inherit version;

    src = prev.fetchzip {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
      hash = "sha256-ht8MReur4K/QrEY9/MH6srQL3/8LHk8pCuSDld+LlEg=";
    };
  });
}
