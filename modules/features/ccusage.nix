{config, ...}: {
  flake.modules.homeManager.ccusage = {
    inputs,
    system,
    config,
    pkgs-unstable,
    ...
  }: let
    # Shared model definitions — same source as omp's models.yml.
    modelsData = import ./ai-shared/models.nix;

    # ccusage pricing overrides keyed by raw model name (as recorded in omp
    # session logs with the [pi] adapter prefix).  models.nix costs are
    # per-million-tokens; ccusage expects per-token, so divide by 1e6.
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

    # ccusage configuration: pricing overrides for Corti models (not in
    # LiteLLM) and calculate mode so overrides are used instead of the
    # display cost embedded in omp session logs.
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

  flake.modules.combined.ccusage = {...}: {
    hm.imports = [
      config.flake.modules.homeManager.ccusage
    ];
  };
}
