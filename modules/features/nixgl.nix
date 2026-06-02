{
  config,
  inputs,
  ...
}: {
  flake.modules.homeManager.nixgl = {inputs, ...}: {
    nixGL.packages = inputs.nixgl.packages;
    nixGL.defaultWrapper = "nvidia";
    nixGL.offloadWrapper = "nvidiaPrime";
    nixGL.installScripts = ["mesa" "nvidiaPrime"];
  };

  flake.modules.combined.nixgl = {...}: {
    hm.imports = [config.flake.modules.homeManager.nixgl];
  };
}
