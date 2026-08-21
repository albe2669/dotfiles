_: {
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
      frontendPackage = inputs.preflight.packages.${system}.frontend;
      raycastPackage = inputs.preflight.packages.${system}.raycast;

      installService = true;
      installRaycast = true;

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
            {
              repo = "corticph/deployments";
              author = "@me";
            }
            {
              repo = "corticph/deployments";
              reviewer = "@me";
            }
            {
              repo = "corticph/charts";
              author = "@me";
            }
            {
              repo = "corticph/charts";
              reviewer = "@me";
            }
            {
              repo = "corticph/actions";
              author = "@me";
            }
            {
              repo = "corticph/actions";
              reviewer = "@me";
            }
          ];
        };
      };
    };
  };
}
