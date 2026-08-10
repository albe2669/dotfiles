{config, ...}: {
  flake.modules.homeManager.preflight = {
    inputs,
    config,
    system,
    ...
  }: let
    secrets = config.sops.secrets;
  in {
    imports = [
      inputs.preflight.homeManagerModules.preflight
    ];

    programs.preflight = {
      enable = true;
      package = inputs.preflight.packages.${system}.default;

      installService = true;

      settings = {
        clock.timezone = "Europe/Copenhagen";
        server = {
          host = "127.0.0.1";
          port = 3030;
        };

        sync = {
          githubTokenPath = secrets.gh_token.path;
          # linearTokenPath = secrets.linear_token.path;
          github.filters = [
            {
              repo = "corticph/agent-api";
              exclude_drafts = true;
            }
            {
              repo = "corticph/agent-memory";
              exclude_drafts = true;
            }
            {
              repo = "corticph/ml-service-llm-reasoning";
              author = "albe2669";
            }
            {
              repo = "corticph/api-specs";
              author = "albe2669";
              reviewing_team = "corticph/ai-agents";
              exclude_drafts = true;
            }
            {
              repo = "corticph/gocomo";
              author = "albe2669";
              reviewing_team = "corticph/ai-agents";
              exclude_drafts = true;
            }
          ];
        };
      };
    };
  };

  flake.modules.combined.preflight = _: {
    hm.imports = [config.flake.modules.homeManager.preflight];
  };
}
