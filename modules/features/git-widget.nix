_: {
  flake.modules.homeManager.git-widget = {
    inputs,
    config,
    ...
  }: {
    imports = [inputs.git-widget.homeManagerModules.default];

    programs.git-widget = {
      enable = true;

      github = {
        tokenFile = config.sops.secrets.gh_token.path;
      };

      repositories = [
        {
          owner = "corticph";
          name = "agent-api";
          filter = ["all"];
          notifications = {
            newPR = true;
            assigned = true;
            reviewRequested = true;
            ciFailed = true;
          };
        }

        {
          owner = "corticph";
          name = "agent-memory";
          filter = ["all"];
          notifications = {
            newPR = true;
            assigned = true;
            reviewRequested = true;
            ciFailed = true;
          };
        }

        {
          owner = "corticph";
          name = "ml-service-llm-reasoning";
          filter = ["opened" "assigned"];
          notifications = {
            newPR = false;
            assigned = true;
            reviewRequested = true;
            ciFailed = false;
          };
        }

        {
          owner = "corticph";
          name = "api-specs";
          filter = ["opened" "assigned-direct" "assigned-group"];
          assignedGroup = "corticph/ai-agents";
          notifications = {
            newPR = false;
            assigned = true;
            reviewRequested = true;
            ciFailed = false;
          };
        }

        {
          owner = "corticph";
          name = "gocomo";
          filter = ["opened" "assigned-direct" "assigned-group"];
          assignedGroup = "corticph/ai-agents";
          notifications = {
            newPR = false;
            assigned = true;
            reviewRequested = true;
            ciFailed = false;
          };
        }
      ];
    };
  };
}
