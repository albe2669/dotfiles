final: prev: let
  version = "2.0.76";
in {
  claude-code = prev.claude-code.overrideAttrs (old: {
    inherit version;

    src = prev.fetchzip {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
      hash = "sha256-wazALudqwwYVCm7qCYIuOkOVcFxRTzLjkDnRXaHLFIQ=";
    };
  });
}
