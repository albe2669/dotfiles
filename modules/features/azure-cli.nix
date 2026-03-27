{ config, ... }: {
  flake.modules.homeManager.azure-cli = {pkgs, ...}: {
    home.packages = with pkgs; [
      (azure-cli.withExtensions [])
      kubelogin
    ];
  };

  flake.modules.combined.azure-cli = { ... }: {
    hm.imports = [ config.flake.modules.homeManager.azure-cli ];
  };
}
