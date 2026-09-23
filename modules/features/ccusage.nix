{
  category = "Tools";
  name = "ccusage";

  homeManager = {
    inputs,
    system,
    pkgs-unstable,
    ...
  }: let
    modelsData = import ./ai-shared/models.nix;

    # ccusage expects per-token costs; models.nix stores per-million-tokens.
    ccusagePricingOverrides = builtins.listToAttrs (
      map (m: {
        name = "[pi] ${m.id}";
        value = {
          inputCostPerToken = m.cost.input / 1000000.0;
          outputCostPerToken = m.cost.output / 1000000.0;
          cacheReadInputTokenCost = m.cost.cacheRead / 1000000.0;
        };
      })
      modelsData.models
    );
  in {
    home.packages = [
      inputs.llm-agents.packages.${system}.ccusage
    ];

    # Calculate mode uses these overrides instead of display costs in omp logs.
    xdg.configFile."claude/ccusage.json".source =
      (pkgs-unstable.formats.json {}).generate "ccusage.json"
      {
        "$schema" = "https://ccusage.com/config-schema.json";
        defaults = {
          mode = "calculate";
          pricingOverrides = ccusagePricingOverrides;
        };
      };
  };
}
