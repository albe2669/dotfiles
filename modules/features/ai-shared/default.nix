{config, ...}: {
  flake.modules.homeManager.ai = {
    inputs,
    system,
    ...
  }: {
    home.packages = [
      inputs.llm-agents.packages.${system}.openspec
      inputs.llm-agents.packages.${system}.openspecui
    ];
  };

  flake.modules.combined.ai = _: {
    hm.imports = [
      config.flake.modules.homeManager.ai
    ];
  };
}
