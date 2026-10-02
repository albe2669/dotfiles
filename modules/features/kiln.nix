{
  category = "Tools";
  name = "kiln";

  homeManager = {
    inputs,
    lib,
    system,
    config,
    pkgs,
    ...
  }: let
    apiKeyEnvName = "CORTI_API_KEY";
    pkg =
      (inputs.kiln.packages.${system}.default.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.makeWrapper];
        postFixup =
          (old.postFixup or "")
          + ''
            wrapProgram $out/bin/kiln \
              --run 'if [ -f "${config.sops.secrets.corti_bearer.path}" ]; then export ${apiKeyEnvName}=$(cat "${config.sops.secrets.corti_bearer.path}"); fi'
          '';
      }))
      // {
        meta = inputs.kiln.packages.${system}.default.meta or {};
      };
    roles = {
      default = "corti/corti-s1-beta:auto";
      smol = "corti/corti-s1-mini:auto";
      slow = "corti/corti-s1-beta:auto";
      plan = "corti/corti-s1-beta:auto";
      task = "corti/corti-s1-beta:auto";
      commit = "corti/corti-s1-mini-instant:auto";
      tiny = "corti/corti-s1-tiny:auto";
      advisor = "corti/corti-s1-mini:auto";
      vision = "corti/corti-s1-mini:auto";
      search = "corti/corti-s1-mini:auto";
      reviewer = "corti/corti-s1-beta:auto";
    };
    roleLines = lib.mapAttrsToList (role: spec: "${role} = \"${spec}\"") roles;
  in {
    home.packages = [pkg];

    # The whole config renders through sops so the provider base URL and
    # key name stay out of the flake. One template owns config.toml;
    # programs.kiln's typed settings file would clash with it, so the
    # settings tables live here instead.
    sops.templates."kiln-config.toml" = {
      content = ''
        [roles]
        ${lib.concatStringsSep "\n" roleLines}

        [providers.corti]
        wire = "openai-completions"
        base_url = "${config.sops.placeholder.corti_base_url}"
        api_key_env = "${apiKeyEnvName}"

        [tui]
        theme = "everforest"
        symbols = "nerd"

        [capabilities]
        secret_files = true
        redact_secrets = true

        [checks]
        test = "cargo test --workspace"
        lint = "cargo clippy --all-targets --all-features -- -D warnings"
      '';
      path = "${config.xdg.configHome}/kiln/config.toml";
    };
  };
}
