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
              excludeOthersDrafts = true;
            }
            {
              repo = "corticph/agent-memory";
              excludeOthersDrafts = true;
            }
            {
              repo = "corticph/ml-service-llm-reasoning";
              author = "@me";
            }
            {
              repo = "corticph/ml-service-llm-reasoning";
              reviewer = "@me";
            }
            {
              repo = "corticph/api-specs";
              author = "@me";
            }
            {
              repo = "corticph/api-specs";
              reviewingTeam = "corticph/ai-agents";
              excludeOthersDrafts = true;
            }
            {
              repo = "corticph/gocomo";
              author = "@me";
            }
            {
              repo = "corticph/gocomo";
              reviewer = "@me";
              excludeOthersDrafts = true;
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
